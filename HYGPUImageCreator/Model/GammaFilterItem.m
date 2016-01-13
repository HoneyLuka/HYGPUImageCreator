//
//  GammaFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "GammaFilterItem.h"

@implementation GammaFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.gamma = value;
  
  return filter;
}

+ (instancetype)create
{
  GammaFilterItem *item = [[GammaFilterItem alloc]init];
  item.name = @"Gamma";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"gamma";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 3;
  element.range = range;
  element.defaultValue = @(1);
  
  [item.elements addObject:element];
  
  return item;
}

@end
