//
//  FilterRange.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FilterRange.h"

@implementation FilterRange

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    self.minValue = [coder decodeFloatForKey:@"minValue"];
    self.maxValue = [coder decodeFloatForKey:@"maxValue"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeFloat:self.minValue forKey:@"minValue"];
  [coder encodeFloat:self.maxValue forKey:@"maxValue"];
}

@end
