//
//  ContrastFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "ContrastFilterItem.h"

@implementation ContrastFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.contrast = value;
  
  return filter;
}

+ (instancetype)create
{
  ContrastFilterItem *item = [[ContrastFilterItem alloc]init];
  item.name = @"Contrast";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"contrast";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 4;
  element.range = range;
  element.defaultValue = @(1);
  
  [item.elements addObject:element];
  
  return item;
}

@end
