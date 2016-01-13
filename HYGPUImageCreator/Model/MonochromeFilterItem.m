//
//  MonochromeFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "MonochromeFilterItem.h"

@implementation MonochromeFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageMonochromeFilter *filter = [[GPUImageMonochromeFilter alloc]init];
  
  CGFloat red = 0.6;
  CGFloat green = 0.45;
  CGFloat blue = 0.3;
  CGFloat alpha = 1;
  for (FilterElement *element in self.elements) {
    if ([element.name isEqualToString:@"intensity"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.intensity = value;
    } else if ([element.name isEqualToString:@"red"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      red = value;
    } else if ([element.name isEqualToString:@"green"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      green = value;
    } else if ([element.name isEqualToString:@"blue"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      blue = value;
    } else if ([element.name isEqualToString:@"alpha"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      alpha = value;
    }
  }
  
  filter.color = (GPUVector4){red, green, blue, alpha};
  
  return filter;
}

+ (instancetype)create
{
  MonochromeFilterItem *item = [[MonochromeFilterItem alloc]init];
  item.name = @"Monochrome";
  
  //intensity
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"intensity";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  //red
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"red";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0.6);
  [item.elements addObject:element];
  
  //green
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"green";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0.45);
  [item.elements addObject:element];
  
  //blue
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"blue";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0.3);
  [item.elements addObject:element];
  
  //alpha
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"alpha";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  return item;
}

@end
