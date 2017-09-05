//
//  MDRegularMealDataCell.h
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDRegularMealDataCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblMyRegularMealMenu;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *spiceLevelView;
@property (strong, nonatomic) IBOutlet UILabel *lblMyRegularMealData;

@end
