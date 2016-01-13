//
//  EditorFilterSectionHeaderView.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItem.h"

@interface EditorFilterSectionHeaderView : UIView

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UISwitch *switcher;

@property (nonatomic, strong) FilterItem *item;

@property (nonatomic, assign) CGFloat section;

- (void)configureWithFilterItem:(FilterItem *)item;

+ (instancetype)createView;

@end
