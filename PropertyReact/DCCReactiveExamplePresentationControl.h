//
//  DCCReactiveExamplePresentationControl.h
//  PropertyReact
//
//  Created by Corneliu on 27/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCCObjectToObserveUsedForTestingProtocol;

@interface DCCReactiveExamplePresentationControl : NSObject

-(void)presentWithViewModel:(id<DCCObjectToObserveUsedForTestingProtocol>)viewModel;

@end
