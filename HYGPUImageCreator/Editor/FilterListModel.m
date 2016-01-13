//
//  FilterListModel.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FilterListModel.h"

@implementation FilterListModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.filterList = [NSMutableArray<FilterItem> array];
    self.name = @"Unnamed Filter";
  }
  return self;
}

- (NSArray *)generateFilterArray
{
  NSMutableArray *array = [NSMutableArray array];
  for (FilterItem *item in self.filterList) {
    if (!item.enabled) {
      continue;
    }
    
    GPUImageOutput<GPUImageInput> *filter = [item generateFilter];
    if (filter) {
      [array addObject:filter];
    }
  }
  
  return array;
}

@end
