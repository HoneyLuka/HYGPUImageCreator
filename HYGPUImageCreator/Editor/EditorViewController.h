//
//  EditorViewController.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/12.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterListModel.h"

@interface EditorViewController : BaseViewController

+ (instancetype)controllerWithEditImage:(UIImage *)image filter:(FilterListModel *)filter;

@end
