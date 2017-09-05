//
//  MDSettingsCell.m
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDSettingsCell.h"

@implementation MDSettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtFieldData.leftView = paddingView2;
    self.txtFieldData.leftViewMode = UITextFieldViewModeAlways;

    // Configure the view for the selected state
}

@end
