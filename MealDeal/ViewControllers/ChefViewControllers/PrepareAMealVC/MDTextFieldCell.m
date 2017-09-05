//
//  MDTextFieldCell.m
//  MealDealApp
//
//  Created by Mohit on 08/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDTextFieldCell.h"

@implementation MDTextFieldCell

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
