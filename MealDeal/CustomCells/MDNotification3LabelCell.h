//
//  MDNotification3LabelCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDNotification3LabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notificationStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
