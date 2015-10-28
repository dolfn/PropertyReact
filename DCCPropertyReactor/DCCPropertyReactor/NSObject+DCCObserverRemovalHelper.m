//
//  NSObject+DCCObserverRemovalHelper.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "NSObject+DCCObserverRemovalHelper.h"

@implementation NSObject (DCCObserverRemovalHelper)

-(void)DCC_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    
    @try {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
    @catch (NSException *exception) {}
}

@end
