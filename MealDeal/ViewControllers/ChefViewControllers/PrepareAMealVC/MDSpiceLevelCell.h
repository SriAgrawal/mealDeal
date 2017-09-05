//
//  MDSpiceLevelCell.h
//  MealDealApp
//
//  Created by Mohit on 08/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDSpiceLevelCell : UITableViewCell
@property (strong, nonatomic) IBOutlet HCSStarRatingView *spiceLevelView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *healthMeterView;

@end
