//
//  RGBFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "RGBFilterItem.h"

@implementation RGBFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc]init];
  for (FilterElement *element in self.elements) {
    if ([element.name isEqualToString:@"red"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.red = value;
    } else if ([element.name isEqualToString:@"green"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.green = value;
    } else if ([element.name isEqualToString:@"blue"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.blue = value;
    }
  }
  
  return filter;
}

+ (instancetype)create
{
  RGBFilterItem *item = [[RGBFilterItem alloc]init];
  item.name = @"RGB";
  
  //R
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"red";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 2;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  //G
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"green";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 2;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];

  //B
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"blue";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 2;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  return item;
}

@end
