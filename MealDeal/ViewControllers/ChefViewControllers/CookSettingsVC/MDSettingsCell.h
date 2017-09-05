//
//  MDSettingsCell.h
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDSettingsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtFieldData;
@property (strong, nonatomic) IBOutlet AHTextView *txtViewData;
@property (strong, nonatomic) IBOutlet UIButton *btnPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblTextViewPlaceholder;
@end
