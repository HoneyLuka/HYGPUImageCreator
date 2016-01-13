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

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FilterSelectViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initData];
}

- (void)initData
{
  BrightnessFilterItem *brightness = [BrightnessFilterItem create];
  ContrastFilterItem *contrast = [ContrastFilterItem create];
  RGBFilterItem *rgb = [RGBFilterItem create];
  WhiteBalanceFilterItem *whiteBalance = [WhiteBalanceFilterItem create];
  SaturationFilterItem *saturation = [SaturationFilterItem create];
  HueFilterItem *hue = [HueFilterItem create];
  SharpenFilterItem *sharpen = [SharpenFilterItem create];
  ExposureFilterItem *exposure = [ExposureFilterItem create];
  GammaFilterItem *gamma = [GammaFilterItem create];
  HighlightShadowFilterItem *highlightShadow = [HighlightShadowFilterItem create];
//  LookupFilterItem *lookup = [LookupFilterItem create];
  ColorInvertFilterItem *colorInvert = [ColorInvertFilterItem create];
  GrayscaleFilterItem *gray = [GrayscaleFilterItem create];
  MonochromeFilterItem *mono = [MonochromeFilterItem create];
  FalseColorFilterItem *falseColor = [FalseColorFilterItem create];
  
  self.dataArray = @[brightness, contrast, rgb, whiteBalance, saturation, hue, sharpen, exposure, gamma, highlightShadow, colorInvert, gray, mono, falseColor];
  [self.tableView reloadData];
}

- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"nameCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
  }
  
  FilterItem *item = self.dataArray[indexPath.row];
  cell.textLabel.text = item.name;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  FilterItem *item = self.dataArray[indexPath.row];
  
  if ([self.delegate respondsToSelector:@selector(viewController:didSelectFilter:)]) {
    [self.delegate viewController:self didSelectFilter:item];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
