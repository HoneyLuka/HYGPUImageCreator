//
//  ExposureFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "ExposureFilterItem.h"

@implementation ExposureFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.exposure = value;
  
  return filter;
}

+ (instancetype)create
{
  ExposureFilterItem *item = [[ExposureFilterItem alloc]init];
  item.name = @"Exposure";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"exposure";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = -10;
  range.maxValue = 10;
  element.range = range;
  element.defaultValue = @(0);
  
  [item.elements addObject:element];
  
  return item;
}

@end
