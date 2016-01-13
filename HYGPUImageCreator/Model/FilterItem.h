//
//  FilterItem.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterElement.h"
#import "GPUImage.h"

@protocol FilterItem <NSObject>
@end

@interface FilterItem : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSMutableArray<FilterElement> *elements;

- (GPUImageOutput<GPUImageInput> *)generateFilter;

+ (instancetype)create;

@end
