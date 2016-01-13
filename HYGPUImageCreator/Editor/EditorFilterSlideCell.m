//
//  EditorFilterSlideCell.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "EditorFilterSlideCell.h"
#import "AppConst.h"

@implementation EditorFilterSlideCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)sliderAction:(UISlider *)sender {
  [self setValueNumber:sender.value];
  self.element.currentValue = @(sender.value);
  [[NSNotificationCenter defaultCenter]postNotificationName:kFilterValueDidChangedNotification
                                                     object:nil];
}

- (void)configureWithElement:(FilterElement *)element
{
  self.element = element;
  self.nameLabel.text = element.name;
  self.slider.minimumValue = element.range.minValue;
  self.slider.maximumValue = element.range.maxValue;
  
  if (element.defaultValue) {
    self.slider.value = element.defaultValue.floatValue;
    [self setValueNumber:element.defaultValue.floatValue];
  }
  
  if (element.currentValue) {
    self.slider.value = element.currentValue.floatValue;
    [self setValueNumber:element.currentValue.floatValue];
  }
}

- (void)setValueNumber:(CGFloat)valueNumber
{
  NSString *numberString = [NSString stringWithFormat:@"%.3f", valueNumber];
  self.valueLabel.text = numberString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
