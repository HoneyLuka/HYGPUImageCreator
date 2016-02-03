//
//  FilterListModel.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterItem.h"
#import "ContrastFilterItem.h"

@interface FilterListModel : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<FilterItem> *filterList;

- (NSArray *)generateFilterArray;

@end
