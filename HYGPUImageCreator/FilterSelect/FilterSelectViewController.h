//
//  FilterSelectViewController.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterItem.h"

@class FilterSelectViewController;
@protocol FilterSelectViewControllerDelegate <NSObject>

- (void)viewController:(FilterSelectViewController *)sender didSelectFilter:(FilterItem *)item;

@end

@interface FilterSelectViewController : BaseViewController

@property (nonatomic, weak) id<FilterSelectViewControllerDelegate> delegate;

@end
