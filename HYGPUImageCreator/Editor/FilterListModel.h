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

@interface FilterListModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *filterList;

- (NSArray *)generateFilterArray;

- (NSDictionary *)dictionaryForJSON;

@end
