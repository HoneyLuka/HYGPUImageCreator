//
//  HighlightShadowFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "HighlightShadowFilterItem.h"

@implementation HighlightShadowFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc]init];
  
  for (FilterElement *element in self.elements) {
    if ([element.name isEqualToString:@"shadows"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.shadows = value;
    } else if ([element.name isEqualToString:@"highlights"]) {
      CGFloat value = element.currentValue ?
      element.currentValue.floatValue : element.defaultValue.floatValue;
      filter.highlights = value;
    }
  }
  
  return filter;
}

+ (instancetype)create
{
  HighlightShadowFilterItem *item = [[HighlightShadowFilterItem alloc]init];
  item.name = @"HighlightShadow";
  
  //shadow
  FilterElement *element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"shadows";
  FilterRange *range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(0);
  [item.elements addObject:element];
  
  //highlight
  element = [[FilterElement alloc]init];
  element.showType = FilterElementShowTypeSlider;
  element.name = @"highlights";
  range = [[FilterRange alloc]init];
  range.minValue = 0;
  range.maxValue = 1;
  element.range = range;
  element.defaultValue = @(1);
  [item.elements addObject:element];
  
  return item;
}

@end
