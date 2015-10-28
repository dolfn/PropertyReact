//
//  NSObject+DCCObserverRemovalHelper.h
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DCCObserverRemovalHelper)

-(void)DCC_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context NS_AVAILABLE(10_7, 5_0);

@end
