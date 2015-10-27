//
//  ViewController.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "DCCReactiveViewController.h"
#import "DCCObjectToObserveUsedForTesting.h"
#import "DCCReactiveExamplePresentationControl.h"

@interface DCCReactiveViewController ()

@property (nonatomic, strong) IBOutlet DCCObjectToObserveUsedForTesting *objectToReactToOnPropertyChanges;
@property (nonatomic, strong) IBOutlet DCCReactiveExamplePresentationControl *presentationControl;

@end

@implementation DCCReactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.presentationControl presentWithViewModel:self.objectToReactToOnPropertyChanges];
    NSArray* toolbarItems = @[
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                            target:self
                                                                            action:@selector(didTapToSetItems:)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:@selector(didTapToAddNewItem:)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                           target:self
                                                                           action:@selector(didTapToDeleteAnItem:)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                           target:self
                                                                           action:@selector(didTapToUpdateAnItem:)]];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update title" style:UIBarButtonItemStylePlain target:self action:@selector(didTapToUpdateTitle:)];
}

-(void)didTapToAddNewItem:(id)sender {
    [self.objectToReactToOnPropertyChanges addNewItem];
}

-(void)didTapToUpdateAnItem:(id)sender {
    [self.objectToReactToOnPropertyChanges updateAnItem];
}

-(void)didTapToDeleteAnItem:(id)sender {
    [self.objectToReactToOnPropertyChanges removeAnItem];
}

-(void)didTapToSetItems:(id)sender {
    [self.objectToReactToOnPropertyChanges setItems];
}

-(void)didTapToUpdateTitle:(id)sender {
    [self.objectToReactToOnPropertyChanges updateStringToObserve];
}

@end
