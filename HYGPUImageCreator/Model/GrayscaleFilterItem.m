//
//  GrayscaleFilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "GrayscaleFilterItem.h"

@implementation GrayscaleFilterItem

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  if (!self.enabled) {
    return nil;
  }
  GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc]init];
  
  return filter;
}

+ (instancetype)create
{
  GrayscaleFilterItem *item = [[GrayscaleFilterItem alloc]init];
  item.name = @"Grayscale";
  
  return item;
}

@end
