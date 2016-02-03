//
//  ShareManager.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/2/3.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareManager : NSObject

- (void)shareToDropboxWithName:(NSString *)name data:(NSData *)data fromController:(UIViewController *)viewController;

+ (instancetype)sharedInstance;

@end
