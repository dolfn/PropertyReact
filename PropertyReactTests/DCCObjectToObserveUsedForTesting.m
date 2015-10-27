//
//  DCCObjectToObserveUsedForTesting.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "DCCObjectToObserveUsedForTesting.h"

@interface DCCObjectToObserveUsedForTesting() {
    NSMutableArray *_itemsToObserve;
}

#pragma mark - DCCObjectToObserveUsedForTestingProtocol
@property (nonatomic, strong, readwrite) NSString *stringToObserve;

@end

@implementation DCCObjectToObserveUsedForTesting

-(instancetype)init {
    self = [super init];
    if (self) {
        _itemsToObserve = [NSMutableArray array];
    }
    return self;
}

-(NSArray *)itemsToObserve {
    return [_itemsToObserve copy];
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return ![key isEqualToString:NSStringFromSelector(@selector(itemsToObserve))];
}

-(void)setItems {
    NSIndexSet *itemsToSetIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)];
    [self willChange:NSKeyValueChangeSetting valuesAtIndexes:itemsToSetIndexSet forKey:NSStringFromSelector(@selector(itemsToObserve))];
    _itemsToObserve = [NSMutableArray arrayWithObjects:@"0", @"1", @"2", @"3", nil];
    [self didChange:NSKeyValueChangeSetting valuesAtIndexes:itemsToSetIndexSet forKey:NSStringFromSelector(@selector(itemsToObserve))];
}

-(void)addNewItem {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:_itemsToObserve.count] forKey:NSStringFromSelector(@selector(itemsToObserve))];
    NSString *newItemToAdd = [NSString stringWithFormat:@"%lu", _itemsToObserve.count];
    [_itemsToObserve insertObject:newItemToAdd atIndex:_itemsToObserve.count];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:_itemsToObserve.count] forKey:NSStringFromSelector(@selector(itemsToObserve))];
}

-(void)removeAnItem {
    if (_itemsToObserve.count) {
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:_itemsToObserve.count - 1] forKey:NSStringFromSelector(@selector(itemsToObserve))];
        [_itemsToObserve removeObjectAtIndex:(_itemsToObserve.count - 1)];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:_itemsToObserve.count] forKey:NSStringFromSelector(@selector(itemsToObserve))];
    }
}

-(void)updateAnItem {
    if (_itemsToObserve.count) {
        [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:NSStringFromSelector(@selector(itemsToObserve))];
        NSString *itemToUseAsReplacement = [NSString stringWithFormat:@"%lu", [_itemsToObserve[0] integerValue] + 1];
        [_itemsToObserve replaceObjectAtIndex:0 withObject:itemToUseAsReplacement];
        [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:NSStringFromSelector(@selector(itemsToObserve))];
    }
}

-(void)updateStringToObserve {
    self.stringToObserve = [self randomStringWithLength:30];
}

-(NSString *) randomStringWithLength: (int) len {
    
    int max = 9999999;
    int min = 1000000;
    int randNum = rand() % (max - min) + min; //create the random number.
    
    NSString *randomString = [NSString stringWithFormat:@"%d", randNum];
    return randomString;
}

@end
