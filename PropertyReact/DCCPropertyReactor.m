//
//  DCCPropertyReactor.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "DCCPropertyReactor.h"
@import UIKit; // used to create the indexPath with row & section

@interface DCCPropertyReactor()

@property (nonatomic, strong) NSHashTable<id<DCCObservableObject>> *objectsToObserveHashTable;
@property (nonatomic, strong) NSMutableDictionary *propertiesToReactToByObjectHash;
@property (nonatomic, strong) NSMutableDictionary *blockToRunByObjectAndPropertyHashCombination;

@end

@implementation DCCPropertyReactor

-(NSHashTable *)objectsToObserveHashTable {
    if (!_objectsToObserveHashTable) {
        _objectsToObserveHashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _objectsToObserveHashTable;
}

-(NSMutableDictionary *)propertiesToReactToByObjectHash {
    if (!_propertiesToReactToByObjectHash) {
        _propertiesToReactToByObjectHash = [NSMutableDictionary dictionary];
    }
    return _propertiesToReactToByObjectHash;
}

-(NSMutableDictionary *)blockToRunByObjectAndPropertyHashCombination {
    if (!_blockToRunByObjectAndPropertyHashCombination) {
        _blockToRunByObjectAndPropertyHashCombination = [NSMutableDictionary dictionary];
    }
    return _blockToRunByObjectAndPropertyHashCombination;
}

-(void)reactToSettingValueToPropertyWithName:(NSString *)propertyName
                                    ofObject:(id<DCCObservableObject>)objectWithProperty
                                   withBlock:(DCCBlockToRunWhenPropertyValueChange)blockToRunWhenPropertyIsSet {
    if (!objectWithProperty || !propertyName) {
        return;
    }
    if (!blockToRunWhenPropertyIsSet) {
        [self stopReactingToSettingValueToPropertyWithName:propertyName ofObject:objectWithProperty];
        return;
    }
    
    //record object to observe
    [self.objectsToObserveHashTable addObject:objectWithProperty];
    
    //record observed property, if not already observing
    NSNumber *objectHashNumber = [NSNumber numberWithInteger:[objectWithProperty hash]];
    NSArray *propertiesToObserveForObject;
    if (![self.propertiesToReactToByObjectHash.allKeys containsObject:objectHashNumber]) {
        propertiesToObserveForObject = [NSArray array];
    }
    else {
        propertiesToObserveForObject = [self.propertiesToReactToByObjectHash objectForKey:objectHashNumber];
    }
    if (![propertiesToObserveForObject containsObject:propertyName]) {
        propertiesToObserveForObject = [propertiesToObserveForObject arrayByAddingObject:propertyName];
    }
    [self.propertiesToReactToByObjectHash setObject:propertiesToObserveForObject forKey:objectHashNumber];
    
    //record block to execute when observing a change in the property
    id blockKey = [self blockKeyForObservedObject:objectWithProperty andPropertyName:propertyName];
    [self.blockToRunByObjectAndPropertyHashCombination setObject:blockToRunWhenPropertyIsSet forKey:blockKey];
    
    //add observer
    [objectWithProperty addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)stopReactingToSettingValueToPropertyWithName:(NSString *)propertyName ofObject:(id<DCCObservableObject>)objectWithProperty {
    
    NSNumber *propertiesKey = [NSNumber numberWithInteger:[objectWithProperty hash]];
    if (![self.propertiesToReactToByObjectHash.allKeys containsObject:propertiesKey]) {
        return;
    }
    
    NSArray *propertiesObserverForObject = [self.propertiesToReactToByObjectHash objectForKey:propertiesKey];
    if (![propertiesObserverForObject containsObject:propertyName]) {
        return;
    }
    
    //remove property from records and, if necessary, remove object to observe from records
    NSMutableArray *mutablePropertiesForObject = [propertiesObserverForObject mutableCopy];
    [mutablePropertiesForObject removeObject:propertyName];
    if (mutablePropertiesForObject.count) {
        [self.propertiesToReactToByObjectHash setObject:[mutablePropertiesForObject copy] forKey:propertiesKey];
    }
    else {
        [self.propertiesToReactToByObjectHash removeObjectForKey:propertiesKey];
        [self.objectsToObserveHashTable removeObject:objectWithProperty];
    }
    
    //remove block to execute when property is set
    id blockKey = [self blockKeyForObservedObject:objectWithProperty andPropertyName:propertyName];
    if ([self.blockToRunByObjectAndPropertyHashCombination.allKeys containsObject:blockKey]) {
        [self.blockToRunByObjectAndPropertyHashCombination removeObjectForKey:blockKey];
    }
    
    //remove observer
    [objectWithProperty DCC_removeObserver:self forKeyPath:propertyName context:NULL];
    
}

-(id)blockKeyForObservedObject:(id<DCCObservableObject>)observedObject andPropertyName:(NSString *)propertyName {
    NSNumber *objectHashNumber = [NSNumber numberWithInteger:[observedObject hash]];
    NSString *blockKey = [NSString stringWithFormat:@"%@_%@", objectHashNumber, propertyName];
    return blockKey;
}

-(void)dealloc {
    //remove all observers
    for (id<DCCObservableObject> observedObject in self.objectsToObserveHashTable) {
        NSNumber *propertiesKey = [NSNumber numberWithInteger:[observedObject hash]];
        NSArray *propertiesObserverForObject = [self.propertiesToReactToByObjectHash objectForKey:propertiesKey];
        for (NSString *observedProperty in propertiesObserverForObject) {
            [observedObject DCC_removeObserver:self forKeyPath:observedProperty context:NULL];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    NSIndexSet *changedIndexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
    NSMutableArray *changedIndexes = [NSMutableArray array];
    [changedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPathToAdd = [NSIndexPath indexPathForRow:idx inSection:0];
        [changedIndexes addObject:indexPathToAdd];
    }];
    id blockKey = [self blockKeyForObservedObject:object andPropertyName:keyPath];
    DCCBlockToRunWhenPropertyValueChange blockToExecute = [self.blockToRunByObjectAndPropertyHashCombination objectForKey:blockKey];
    blockToExecute(changeKind, [changedIndexes copy]);
}

@end
