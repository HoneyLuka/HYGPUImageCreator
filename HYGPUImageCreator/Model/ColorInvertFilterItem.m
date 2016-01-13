//
//  ColorInvertFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "ColorInvertFilterItem.h"

@implementation ColorInvertFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc]init];
  
  return filter;
}

+ (instancetype)create
{
  ColorInvertFilterItem *item = [[ColorInvertFilterItem alloc]init];
  item.name = @"ColorInvert";
  
  return item;
}

@end
