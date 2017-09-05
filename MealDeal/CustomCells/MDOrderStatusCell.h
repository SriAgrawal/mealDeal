//
//  MDOrderStatusCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPathButton.h"

@interface MDOrderStatusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView        *mealImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *bottomImageView;

@property (weak, nonatomic) IBOutlet UILabel            *chefNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel            *pickUpTimeLabel;

@property (weak, nonatomic) IBOutlet IndexPathButton    *chatButton;
@property (weak, nonatomic) IBOutlet UIButton           *orderStatusButton;
@property (strong, nonatomic) IBOutlet UILabel *paymentTypeLabel;

@end
