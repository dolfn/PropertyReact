//
//  DCCPropertyReactingTestCase.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCCObjectToObserveUsedForTesting.h"
#import "DCCPropertyReactor.h"

@interface DCCPropertyReactingTestCase : XCTestCase

@property (nonatomic, strong) DCCObjectToObserveUsedForTesting *objectToObserve;
@property (nonatomic, strong) DCCPropertyReactor *propertyReactor;

@end

@implementation DCCPropertyReactingTestCase

- (void)setUp {
    [super setUp];
    self.objectToObserve = [[DCCObjectToObserveUsedForTesting alloc] init];
    self.propertyReactor = [[DCCPropertyReactor alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSystemDefaultPropertySetting {
    __block NSUInteger numberOfReactions = 0;
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        numberOfReactions++;
    }];
    
    [self.objectToObserve updateStringToObserve];
    XCTAssertEqual(numberOfReactions, 1, @"Should have reacted 1 time when setting a new value for a property");
    [self.objectToObserve updateStringToObserve];
    XCTAssertEqual(numberOfReactions, 2, @"Should have reacted 2 time when setting a new value for a property");
    [self.objectToObserve updateStringToObserve];
    XCTAssertEqual(numberOfReactions, 3, @"Should have reacted 3 time when setting a new value for a property");
}

-(void)testArrayPropertySettingValues {
    __block NSUInteger numberOfReactions = 0;
    __block NSKeyValueChange recordedChangeKind;
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        numberOfReactions++;
        recordedChangeKind = changeKind;
    }];
    [self.objectToObserve setItems];
    XCTAssertEqual(numberOfReactions, 1, @"Should have reacted 1 time when setting a new value for an array property.");
    XCTAssertEqual(recordedChangeKind, NSKeyValueChangeSetting, @"Should have the 'NSKeyValueChangeSetting' change kind when setting a new value for an array property.");
}

-(void)testArrayPropertyUpdateValues {
    __block NSUInteger numberOfReactions = 0;
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        if (changeKind == NSKeyValueChangeReplacement) {
            numberOfReactions++;
        }
    }];
    [self.objectToObserve setItems];
    [self.objectToObserve updateAnItem];
    XCTAssertEqual(numberOfReactions, 1, @"Should have reacted 1 time when updating values for an array property.");
}

-(void)testArrayPropertyValueRemoval {
    __block NSUInteger numberOfReactions = 0;
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        if (changeKind == NSKeyValueChangeRemoval) {
            numberOfReactions++;
        }
    }];
    [self.objectToObserve setItems];
    [self.objectToObserve removeAnItem];
    XCTAssertEqual(numberOfReactions, 1, @"Should have reacted 1 time when removing values from an array property.");
}

-(void)testArrayPropertyValueInserting {
    __block NSUInteger numberOfReactions = 0;
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        if (changeKind == NSKeyValueChangeInsertion) {
            numberOfReactions++;
        }
    }];
    [self.objectToObserve addNewItem];
    XCTAssertEqual(numberOfReactions, 1, @"Should have reacted 1 time when inserting values in an array property.");
}

-(void)testStoppingToReactToPropertyChange {
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        XCTFail(@"Should not react to a property change, if we stop the reactor from observing the change.");
    }];
    [self.propertyReactor stopReactingToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:self.objectToObserve];
    [self.objectToObserve updateStringToObserve];
}


-(void)testAutomaticallyRemovingReactionsWhenTheReactorIsDealloced {
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        XCTFail(@"Should not react to a property change, if the reactor is nilled/dealloced.");
    }];
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        XCTFail(@"Should not react to a property change, if the reactor is nilled/dealloced.");
    }];
    self.propertyReactor = nil;
    [self.objectToObserve updateStringToObserve];
    [self.objectToObserve setItems];
}

-(void)testRemovingReactionsWhenTheReactorIsDealloced {
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        XCTFail(@"Should not react to a property change, if the reactor is nilled/dealloced.");
    }];
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:self.objectToObserve withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexes) {
        XCTFail(@"Should not react to a property change, if the reactor is nilled/dealloced.");
    }];
    self.propertyReactor = nil;
    [self.objectToObserve updateStringToObserve];
}

@end
