//
//  FilterItem.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FilterItem.h"
#import "ContrastFilterItem.h"

@implementation FilterItem

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.elements = [NSMutableArray<FilterElement> array];
  }
  return self;
}

- (GPUImageOutput<GPUImageInput> *)generateFilter
{
  NSAssert(NO, @"can't call base item");
  return nil;
}

- (BOOL)isEqual:(id)object
{
  if (!object || ![object isKindOfClass:[FilterItem class]]) {
    return NO;
  }
  
  FilterItem *other = object;
  if ([self.name isEqualToString:other.name]) {
    return YES;
  }
  
  return NO;
}

+ (instancetype)create
{
  NSAssert(NO, @"can't call base item");
  return nil;
}

@end
