//
//  FalseColorFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FalseColorFilterItem.h"

#define firstColorRed @"FirstColor - red"
#define firstColorGreen @"FirstColor - green"
#define firstColorBlue @"FirstColor - blue"
#define secondColorRed @"SecondColor - red"
#define secondColorGreen @"SecondColor - green"
#define secondColorBlue @"SecondColor - blue"

@implementation FalseColorFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageFalseColorFilter *filter = [[GPUImageFalseColorFilter alloc]init];
  
  CGFloat firstRed = 0;
  CGFloat firstGreen = 0;
  CGFloat firstBlue = 0.5;
  CGFloat secondRed = 1;
  CGFloat secondGreen = 0;
  CGFloat secondBlue = 0;
  
  for (FilterElement *element in self.elements) {
    if ([element.name isEqualToString:firstColorRed]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      firstRed = value;
    } else if ([element.name isEqualToString:firstColorGreen]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      firstGreen = value;
    } else if ([element.name isEqualToString:firstColorBlue]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      firstBlue = value;
    } else if ([element.name isEqualToString:secondColorRed]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      secondRed = value;
    } else if ([element.name isEqualToString:secondColorGreen]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      secondGreen = value;
    } else if ([element.name isEqualToString:secondColorBlue]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      secondBlue = value;
    }
  }
  
  filter.firstColor = (GPUVector4){firstRed, firstGreen, firstBlue, 1};
  filter.secondColor = (GPUVector4){secondRed, secondGreen, secondBlue, 1};
  
  return filter;
}

+ (instancetype)create
{
  FalseColorFilterItem *item = [[FalseColorFilterItem alloc]init];
  item.name = @"FalseColor";
  
  //first color red
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = firstColorRed;
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  [item.elements addObject:element];
  
  //first color green
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = firstColorGreen;
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  [item.elements addObject:element];
  
  //first color blue
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = firstColorBlue;
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0.5);
  [item.elements addObject:element];
  
  //second color red
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = secondColorRed;
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  //second color green
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = secondColorGreen;
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  [item.elements addObject:element];
  
  //second color blue
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = secondColorBlue;
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  [item.elements addObject:element];
  
  return item;
}

@end
