//
//  FileManager.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/2/2.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterListModel.h"

@interface FileManager : NSObject

- (BOOL)saveFilterList:(FilterListModel *)model;
- (BOOL)deleteFilterList:(FilterListModel *)model;
- (BOOL)filterIsExist:(NSString *)name;
- (NSMutableArray *)loadAllFilters;

+ (instancetype)sharedInstance;

@end
