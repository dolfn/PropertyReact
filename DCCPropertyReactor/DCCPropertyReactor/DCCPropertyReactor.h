//
//  DCCPropertyReactor.h
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCCObservableObject.h"

typedef void(^DCCBlockToRunWhenPropertyValueChange)(NSKeyValueChange changeKind, NSArray *changedIndexPaths);

@interface DCCPropertyReactor : NSObject

/*
 * The object that has the property to react to is not retained. The block is retained so please be careful about retain cycles.
 */
-(void)reactToSettingValueToPropertyWithName:(NSString *)propertyName
                                    ofObject:(id<DCCObservableObject>)objectWithProperty
                                   withBlock:(DCCBlockToRunWhenPropertyValueChange)blockToRunWhenPropertyIsSet;

-(void)stopReactingToSettingValueToPropertyWithName:(NSString *)propertyName
                                           ofObject:(id<DCCObservableObject>)objectWithProperty;

@end
