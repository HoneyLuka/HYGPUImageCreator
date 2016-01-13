//
//  AppDelegate+AppConfig.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/12.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "AppDelegate+AppConfig.h"
#import <SVProgressHUD.h>

@implementation AppDelegate (AppConfig)

- (void)configureApp
{
  [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
  [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
