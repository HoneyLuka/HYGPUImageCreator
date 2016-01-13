//
//  LookupFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "LookupFilterItem.h"

@implementation LookupFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageLookupFilter *filter = [[GPUImageLookupFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.intensity = value;
  
  return filter;
}

+ (instancetype)create
{
  LookupFilterItem *item = [[LookupFilterItem alloc]init];
  item.name = @"Lookup";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"intensity";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(1);
  
  [item.elements addObject:element];
  
  return item;
}

@end
