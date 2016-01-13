//
//  EditorFilterSlideCell.h
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterElement.h"

@interface EditorFilterSlideCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, strong) FilterElement *element;

- (void)configureWithElement:(FilterElement *)element;

@end
