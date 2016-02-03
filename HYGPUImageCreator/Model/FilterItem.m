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
    self.elements = [NSMutableArray array];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    self.name = [coder decodeObjectForKey:@"name"];
    self.enabled = [coder decodeBoolForKey:@"enabled"];
    self.elements = [coder decodeObjectForKey:@"elements"];
    if (!self.elements) {
      self.elements = [NSMutableArray array];
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.name forKey:@"name"];
  [coder encodeBool:self.enabled forKey:@"enabled"];
  [coder encodeObject:self.elements forKey:@"elements"];
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

- (NSDictionary *)dictionaryForJSON
{
  if (!self.enabled) {
    return nil;
  }
  
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  
  [dict setObject:self.name forKey:@"name"];
  
  NSMutableArray *elementsArray = [NSMutableArray array];
  for (FilterElement *element in self.elements) {
    NSDictionary *elementDict = [element dictionaryForJSON];
    if (elementDict) {
      [elementsArray addObject:elementDict];
    }
  }
  
  [dict setObject:elementsArray forKey:@"elements"];
  
  return dict;
}

+ (instancetype)create
{
  NSAssert(NO, @"can't call base item");
  return nil;
}

@end
