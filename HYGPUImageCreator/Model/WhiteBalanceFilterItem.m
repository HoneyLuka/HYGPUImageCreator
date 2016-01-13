//
//  WhiteBalanceFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "WhiteBalanceFilterItem.h"

@implementation WhiteBalanceFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.temperature = value;
  
  return filter;
}

+ (instancetype)create
{
  WhiteBalanceFilterItem *item = [[WhiteBalanceFilterItem alloc]init];
  item.name = @"WhiteBalance";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"temperature";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 10000;
  element.range = range;
  element.defaultValue = @(5000);
  
  [item.elements addObject:element];
  
  return item;
}

@end
