//
//  DCCReactiveExamplePresentationControl.m
//  PropertyReact
//
//  Created by Corneliu on 27/10/15.
//  Copyright © 2015 Dolfn. All rights reserved.
//

#import "DCCReactiveExamplePresentationControl.h"
#import "DCCPropertyReactor.h"
#import "DCCExampleViewModel.h"
@import UIKit;

@interface DCCReactiveExamplePresentationControl()<UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *itemsTableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) DCCPropertyReactor *propertyReactor;
@property (nonatomic, strong) id<DCCExampleViewModel> viewModel;

@end

@implementation DCCReactiveExamplePresentationControl

-(void)presentWithViewModel:(id<DCCExampleViewModel>)viewModel {
    self.propertyReactor = [[DCCPropertyReactor alloc] init];
    self.viewModel = viewModel;
    __weak typeof(self) weakSelf = self;
    
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(stringToObserve)) ofObject:viewModel withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexPaths) {
        weakSelf.titleLabel.text = [viewModel stringToObserve];
    }];
    
    [self.propertyReactor reactToSettingValueToPropertyWithName:NSStringFromSelector(@selector(itemsToObserve)) ofObject:viewModel withBlock:^(NSKeyValueChange changeKind, NSArray *changedIndexPaths) {
        switch (changeKind) {
            case NSKeyValueChangeSetting:
            {
                [weakSelf.itemsTableView reloadData];
            }
                break;
            case NSKeyValueChangeInsertion:{
                if (changedIndexPaths) {
                    [weakSelf.itemsTableView insertRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
                break;
            case NSKeyValueChangeReplacement:{
                if (changedIndexPaths) {
                    [weakSelf.itemsTableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
                break;
            case NSKeyValueChangeRemoval:{
                if (changedIndexPaths) {
                    [weakSelf.itemsTableView deleteRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel itemsToObserve].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const kItemCellIdentifier = @"itemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.viewModel itemsToObserve][indexPath.row];
    return cell;
}

@end
