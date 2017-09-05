//
//  MDTextViewCell.h
//  MealDealApp
//
//  Created by Mohit on 08/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDTextViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnAddAsHealthyMeal;

@property (strong, nonatomic) IBOutlet AHTextView *txtViewData;
@property (strong, nonatomic) IBOutlet UILabel *lblHeathyMeal;
@property (strong, nonatomic) IBOutlet UILabel *lblTxtViewPlaceholder;
@end
