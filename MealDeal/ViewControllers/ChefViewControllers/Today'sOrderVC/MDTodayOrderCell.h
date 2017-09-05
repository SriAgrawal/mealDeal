//
//  MDTodayOrderCell.h
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDTodayOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *placeholderLbl;
@property (strong, nonatomic) IBOutlet UILabel *dataLbl;

@property (strong, nonatomic) IBOutlet HCSStarRatingView *spiceLevelView;
@property (strong, nonatomic) IBOutlet UITextView *txtViewCell;
@end
