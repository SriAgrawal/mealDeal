//
//  MDChatSenderCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDChatSenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *senderImageView;

@property (strong, nonatomic) IBOutlet UILabel *senderTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sendedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgSendMessageReadStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnSendImageShow;
@property (strong, nonatomic) IBOutlet UIImageView *sendedImageReadStatusImg;

@end
