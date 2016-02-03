//
//  ShareManager.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/2/3.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "ShareManager.h"
#import <DropboxSDK/DropboxSDK.h>
#import "SVProgressHUD.h"

@interface ShareManager () <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *dbClient;

@end

@implementation ShareManager

- (void)shareToDropboxWithName:(NSString *)name data:(NSData *)data fromController:(UIViewController *)viewController
{
  if (!data) {
    return;
  }
  
  if (![DBSession sharedSession].isLinked) {
    [[DBSession sharedSession]linkFromController:viewController];
    return;
  }
  
  if (![self saveFileWithName:name data:data]) {
    [SVProgressHUD showErrorWithStatus:@"save file error!"];
    return;
  }
  
  if (!self.dbClient) {
    self.dbClient = [[DBRestClient alloc]initWithSession:[DBSession sharedSession]];
    self.dbClient.delegate = self;
  }
  
  NSString *fullName = [NSString stringWithFormat:@"%@%@", name, @".json"];
  NSString *path = [[self tempPath]stringByAppendingPathComponent:fullName];
  NSString *destDir = @"/";
  [self.dbClient uploadFile:fullName toPath:destDir withParentRev:nil fromPath:path];
  [SVProgressHUD showWithStatus:@"Uploading..."];
}

- (BOOL)saveFileWithName:(NSString *)name data:(NSData *)data
{
  NSString *fullName = [NSString stringWithFormat:@"%@%@", name, @".json"];
  NSString *path = [[self tempPath]stringByAppendingPathComponent:fullName];
  return [data writeToFile:path atomically:YES];
}

- (NSString *)tempPath
{
  static NSString *tempPath = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachePath = [cachePath stringByAppendingPathComponent:@"saved_filters"];
    tempPath = cachePath;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:tempPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  });
  
  return tempPath;
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
  [SVProgressHUD showSuccessWithStatus:@"Upload success."];
  NSLog(@"File uploaded successfully to path: /HYGPUImageCreator%@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
  [SVProgressHUD showErrorWithStatus:@"Upload failed."];
  NSLog(@"File upload failed with error: %@", error);
}

+ (instancetype)sharedInstance
{
  static ShareManager *kShareManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    kShareManager = [[ShareManager alloc]init];
  });
  
  return kShareManager;
}

@end
