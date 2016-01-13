//
//  SaturationFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "SaturationFilterItem.h"

@implementation SaturationFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.saturation = value;
  
  return filter;
}

+ (instancetype)create
{
  SaturationFilterItem *item = [[SaturationFilterItem alloc]init];
  item.name = @"Saturation";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"saturation";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 2;
  element.range = range;
  element.defaultValue = @(1);
  
  [item.elements addObject:element];
  
  return item;
}

@end
