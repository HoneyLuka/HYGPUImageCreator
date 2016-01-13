//
//  EditorFilterSectionHeaderView.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "EditorFilterSectionHeaderView.h"
#import "AppConst.h"

@implementation EditorFilterSectionHeaderView

- (void)configureWithFilterItem:(FilterItem *)item
{
  self.item = item;
  self.nameLabel.text = item.name;
  self.switcher.on = item.enabled;
}

- (IBAction)switchAction:(UISwitch *)sender {
  self.item.enabled = sender.on;
  [[NSNotificationCenter defaultCenter]postNotificationName:kFilterValueDidChangedNotification
                                                     object:nil];
}

+ (instancetype)createView
{
  EditorFilterSectionHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"EditorFilterSectionHeaderView" owner:self options:nil]lastObject];
  return view;
}

@end
