//
//  ViewController.m
//  PropertyReact
//
//  Created by Corneliu on 24/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "DCCReactiveViewController.h"
#import "DCCViewModelToReactTo.h"
#import "DCCReactiveExamplePresentationControl.h"

@interface DCCReactiveViewController ()

@property (nonatomic, strong) IBOutlet DCCViewModelToReactTo *viewModel;
@property (nonatomic, strong) IBOutlet DCCReactiveExamplePresentationControl *presentationControl;

@end

@implementation DCCReactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.presentationControl presentWithViewModel:self.viewModel];
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
    [self.viewModel addNewItem];
}

-(void)didTapToUpdateAnItem:(id)sender {
    [self.viewModel updateAnItem];
}

-(void)didTapToDeleteAnItem:(id)sender {
    [self.viewModel removeAnItem];
}

-(void)didTapToSetItems:(id)sender {
    [self.viewModel setItems];
}

-(void)didTapToUpdateTitle:(id)sender {
    [self.viewModel updateStringToObserve];
}

@end
