//
//  MDOrderHistoryCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPathButton.h"

@interface MDOrderHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;

@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet IndexPathButton *addToCartButtonAction;
@property (weak, nonatomic) IBOutlet IndexPathButton *needHelpButton;

@end
