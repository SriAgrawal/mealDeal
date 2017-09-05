//
//  MDReviewsCell.h
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDReviewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *rateView;
@property (strong, nonatomic) IBOutlet UITextView *txtViewReview;
@end
