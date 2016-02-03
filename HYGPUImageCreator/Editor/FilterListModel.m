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
    self.filterList = [NSMutableArray array];
    self.name = @"Unnamed Filter";
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.filterList = [aDecoder decodeObjectForKey:@"filterList"];
    if (!self.filterList) {
      self.filterList = [NSMutableArray array];
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.filterList forKey:@"filterList"];
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

- (NSDictionary *)dictionaryForJSON
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict setObject:self.name forKey:@"name"];
  
  NSMutableArray *filterArray = [NSMutableArray array];
  for (FilterItem *item in self.filterList) {
    NSDictionary *itemDict = [item dictionaryForJSON];
    if (itemDict) {
      [filterArray addObject:itemDict];
    }
  }
  
  [dict setObject:filterArray forKey:@"filterList"];
  
  return dict;
}

@end
