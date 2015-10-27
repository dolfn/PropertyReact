//
//  DCCObjectToObserveUsedForTesting.h
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCCObjectToObserveUsedForTestingProtocol.h"
#import "DCCObservableObject.h"

@interface DCCObjectToObserveUsedForTesting : NSObject <DCCObjectToObserveUsedForTestingProtocol, DCCObservableObject>

@end
