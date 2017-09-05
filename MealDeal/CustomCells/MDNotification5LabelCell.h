//
//  MDNotification5LabelCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDNotification5LabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificationStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
