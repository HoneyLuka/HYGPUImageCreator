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
- (BOOL)deleteFile:(NSString *)name;
- (BOOL)renameFile:(NSString *)newName oldName:(NSString *)oldName;
- (void)removeAllFile;
- (BOOL)filterIsExist:(NSString *)name;
- (NSMutableArray *)loadAllFilters;

+ (instancetype)sharedInstance;

@end
