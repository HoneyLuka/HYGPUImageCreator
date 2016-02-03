//
//  FilterElement.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FilterElement.h"

@implementation FilterElement

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    self.name = [coder decodeObjectForKey:@"name"];
    self.showType = [coder decodeIntegerForKey:@"showType"];
    self.range = [coder decodeObjectForKey:@"range"];
    
    NSNumber *defaultValue = [coder decodeObjectForKey:@"defaultValue"];
    if (defaultValue) {
      self.defaultValue = defaultValue;
    }
    
    NSNumber *currentValue = [coder decodeObjectForKey:@"currentValue"];
    if (currentValue) {
      self.currentValue = currentValue;
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.name forKey:@"name"];
  [coder encodeInteger:self.showType forKey:@"showType"];
  [coder encodeObject:self.range forKey:@"range"];
  if (self.defaultValue) {
    [coder encodeObject:self.defaultValue forKey:@"defaultValue"];
  }
  
  if (self.currentValue) {
    [coder encodeObject:self.currentValue forKey:@"currentValue"];
  }
}

- (NSDictionary *)dictionaryForJSON
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  
  [dict setObject:self.name forKey:@"name"];
  
  if (self.currentValue) {
    [dict setObject:self.currentValue forKey:@"currentValue"];
  } else {
    [dict setObject:[NSNull null] forKey:@"currentValue"];
  }
  
  return dict;
}

@end
