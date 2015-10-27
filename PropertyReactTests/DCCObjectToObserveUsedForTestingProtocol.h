//
//  DCCObjectToObserveUsedForTestingProtocol.h
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCCObservableObject.h"

@protocol DCCObjectToObserveUsedForTestingProtocol <DCCObservableObject>

@property (nonatomic, strong, readonly) NSArray *itemsToObserve;
@property (nonatomic, strong, readonly) NSString *stringToObserve;

-(void)setItems;
-(void)addNewItem;
-(void)removeAnItem;
-(void)updateAnItem;

-(void)updateStringToObserve;

@end
