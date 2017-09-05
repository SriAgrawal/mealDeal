//
//  MDTitleDetailLabelCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 21/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTitleDetailLabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField    *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton       *dateButton;
@property (weak, nonatomic) IBOutlet UIImageView    *dropImageView;
@end
