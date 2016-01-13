//
//  HueFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "HueFilterItem.h"

@implementation HueFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageHueFilter *filter = [[GPUImageHueFilter alloc]init];
  FilterElement *element = self.elements.lastObject;
  CGFloat value = element.currentValue ?
  element.currentValue.floatValue : element.defaultValue.floatValue;
  filter.hue = value;
  
  return filter;
}

+ (instancetype)create
{
  HueFilterItem *item = [[HueFilterItem alloc]init];
  item.name = @"Hue";
  
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"hue";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 360;
  element.range = range;
  element.defaultValue = @(90);
  
  [item.elements addObject:element];
  
  return item;
}

@end
