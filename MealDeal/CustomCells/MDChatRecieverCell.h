//
//  MDChatRecieverCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDChatRecieverCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recieverImageView;

@property (strong, nonatomic) IBOutlet UILabel *reciverTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *reciverTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recievedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgMessaeReadStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnReceiveImageShowBtn;

@end
