//
//  MDCartViewCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPathButton.h"

@interface MDCartViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishCountLabel;

@property (weak, nonatomic) IBOutlet IndexPathButton *minusButton;
@property (weak, nonatomic) IBOutlet IndexPathButton *plusButton;
@property (weak, nonatomic) IBOutlet IndexPathButton *deleteButton;


@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookNameLabel;
@property (weak, nonatomic) IBOutlet IndexPathButton *pickUpTimeButton;

@end
