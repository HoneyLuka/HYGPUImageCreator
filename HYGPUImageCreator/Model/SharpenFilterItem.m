//
//  SharpenFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "SharpenFilterItem.h"

@implementation SharpenFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageSharpenFilter *filter = [[GPUImageSharpenFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.sharpness = value;
  
  return filter;
}

+ (instancetype)create
{
  SharpenFilterItem *item = [[SharpenFilterItem alloc]init];
  item.name = @"Sharpen";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"sharpness";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = -4;
  range.maxValue = 4;
  element.range = range;
  element.defaultValue = @(0);
  
  [item.elements addObject:element];
  
  return item;
}

@end
