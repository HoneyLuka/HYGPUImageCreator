//
//  FileManager.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/2/2.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "FileManager.h"
#import "AppConst.h"

@implementation FileManager

+ (instancetype)sharedInstance
{
  static FileManager *kFileManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    kFileManager = [[FileManager alloc]init];
  });
  
  return kFileManager;
}

- (NSString *)cacheFolder
{
  static NSString *path = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingString:@"/filter_list_cache_folder/"];
    BOOL succ = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:NULL];
  });
  return path;
}

- (BOOL)saveFilterList:(FilterListModel *)model
{
  NSString *url = [NSString stringWithFormat:@"%@%@.json", [self cacheFolder], model.name];
//  NSData *data = [model toJSONData];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
  NSError *error;
  if ([data writeToFile:url options:NSDataWritingAtomic error:&error]) {
    return YES;
  }
  
  return NO;
}

- (BOOL)deleteFilterList:(FilterListModel *)model
{
  if (![self filterIsExist:model.name]) {
    return NO;
  }
  
  NSString *url = [NSString stringWithFormat:@"%@%@.json", [self cacheFolder], model.name];
  return [[NSFileManager defaultManager]removeItemAtPath:url error:nil];
}

- (BOOL)filterIsExist:(NSString *)name
{
  NSString *fullyFileName = [NSString stringWithFormat:@"%@%@.json", [self cacheFolder], name];
  return [[NSFileManager defaultManager] fileExistsAtPath:fullyFileName];
}

- (NSMutableArray *)loadAllFilters
{
  NSMutableArray *filters = [NSMutableArray array];
  
  NSDirectoryEnumerator<NSString *> *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:[self cacheFolder]];
  NSString *fileName = enumerator.nextObject;
  
  while (fileName) {
    NSString *fullyFilePath = [NSString stringWithFormat:@"%@%@", [self cacheFolder], fileName];
    NSData *data = [NSData dataWithContentsOfFile:fullyFilePath];
//    FilterListModel *model = [[FilterListModel alloc]initWithData:data error:nil];
    FilterListModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (model) {
      [filters addObject:model];
    }
    
    fileName = enumerator.nextObject;
  }
  
  return filters;
}

@end
