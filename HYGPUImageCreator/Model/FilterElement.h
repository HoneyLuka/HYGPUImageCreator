//
//  FilterElement.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterRange.h"

typedef NS_ENUM(NSUInteger, FilterElementShowType) {
  FilterElementShowTypeSlider,
};

@interface FilterElement : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) FilterElementShowType showType;
@property (nonatomic, strong) FilterRange *range;
@property (nonatomic, strong) NSNumber *defaultValue;
@property (nonatomic, strong) NSNumber *currentValue;

- (NSDictionary *)dictionaryForJSON;

@end
