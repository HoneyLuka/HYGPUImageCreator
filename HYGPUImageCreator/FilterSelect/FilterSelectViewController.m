//
//  FilterSelectViewController.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FilterSelectViewController.h"
#import "BrightnessFilterItem.h"
#import "ContrastFilterItem.h"
#import "RGBFilterItem.h"
#import "WhiteBalanceFilterItem.h"
#import "SaturationFilterItem.h"
#import "HueFilterItem.h"
#import "SharpenFilterItem.h"
#import "ExposureFilterItem.h"
#import "GammaFilterItem.h"
#import "HighlightShadowFilterItem.h"
#import "LookupFilterItem.h"
#import "ColorInvertFilterItem.h"
#import "GrayscaleFilterItem.h"
#import "MonochromeFilterItem.h"
#import "FalseColorFilterItem.h"

@interface FilterSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *unusedArray;

@end

@implementation FilterSelectViewController

+ (instancetype)controllerWithUsedFilters:(NSMutableArray *)usedArray
{
  FilterSelectViewController *vc = [[FilterSelectViewController alloc]init];
  if (usedArray.count) {
    vc.usedArray = usedArray;
  } else {
    vc.usedArray = [NSMutableArray array];
  }
  
  return vc;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initData];
}

- (void)initData
{
  self.unusedArray = [NSMutableArray array];
  NSArray *filtersName = @[@"BrightnessFilterItem",
                           @"ContrastFilterItem",
                           @"RGBFilterItem",
                           @"WhiteBalanceFilterItem",
                           @"SaturationFilterItem",
                           @"HueFilterItem",
                           @"SharpenFilterItem",
                           @"ExposureFilterItem",
                           @"GammaFilterItem",
                           @"HighlightShadowFilterItem",
                           @"ColorInvertFilterItem",
                           @"GrayscaleFilterItem",
                           @"MonochromeFilterItem",
                           @"FalseColorFilterItem"];
  filtersName = [filtersName sortedArrayUsingComparator:
                 ^NSComparisonResult(NSString *obj1, NSString *obj2) {
                   return [obj1 compare:obj2];
  }];
  
  for (NSString *className in filtersName) {
    FilterItem *filterItem = [NSClassFromString(className) create];
    if (![self.usedArray containsObject:filterItem]) {
      [self.unusedArray addObject:filterItem];
    }
  }
  [self.tableView reloadData];
  self.tableView.editing = YES;
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender {
  [self.delegate viewControllerDidFinishSelectingFilters:self];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return self.usedArray.count;
  }
  
  return self.unusedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"nameCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
  }
  
  FilterItem *item = indexPath.section == 0 ? self.usedArray[indexPath.row] : self.unusedArray[indexPath.row];
  cell.textLabel.text = item.name;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  FilterItem *item = indexPath.section == 0 ? self.usedArray[indexPath.row] : self.unusedArray[indexPath.row];
  
  if (indexPath.section == 0) {
    [self.usedArray removeObject:item];
    [self.unusedArray addObject:item];
    [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.unusedArray.count - 1 inSection:1]];
  } else {
    [self.unusedArray removeObject:item];
    [self.usedArray addObject:item];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.usedArray.count - 1 inSection:0]];
  }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return indexPath.section == 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return indexPath.section == 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
  if (proposedDestinationIndexPath.section == 1) {
    return sourceIndexPath;
  }
  return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  FilterItem *sourceItem = self.usedArray[sourceIndexPath.row];
  [self.usedArray removeObject:sourceItem];
  [self.usedArray insertObject:sourceItem atIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return section == 0 ? @"Used Filters" : @"Unused Filters";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleNone;
}

@end
