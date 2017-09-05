//
//  MDRegularMealTodaySpecialCell.m
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDRegularMealTodaySpecialCell.h"

@implementation MDRegularMealTodaySpecialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtFieldTodaySpecial.leftView = paddingView2;
    self.txtFieldTodaySpecial.leftViewMode = UITextFieldViewModeAlways;

    // Configure the view for the selected state
}

@end
