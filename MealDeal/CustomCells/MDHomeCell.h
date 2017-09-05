//
//  MDHomeCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 21/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *dishImageView;

@property (weak, nonatomic) IBOutlet UILabel        *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *dishPriceLabel;


@end
