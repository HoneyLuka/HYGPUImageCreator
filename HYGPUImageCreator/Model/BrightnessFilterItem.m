//
//  BrightnessFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "BrightnessFilterItem.h"

@implementation BrightnessFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.brightness = value;
  
  return filter;
}

+ (instancetype)create
{
  BrightnessFilterItem *item = [[BrightnessFilterItem alloc]init];
  item.name = @"Brightness";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"brightness";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = -1;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  
  [item.elements addObject:element];
  
  return item;
}

@end
