//
//  MDDealRequestCell.h
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDDealRequestCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblRequestMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblRequestMenuData;
@property (strong, nonatomic) IBOutlet UITextView *txtViewRequest;
@property (strong, nonatomic) IBOutlet UIButton *btnSpiceLevel;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *spiceViewRequest;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveSpiceLevel;
@end
