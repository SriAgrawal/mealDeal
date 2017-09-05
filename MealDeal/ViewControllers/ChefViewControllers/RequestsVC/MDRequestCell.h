//
//  MDRequestCell.h
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDRequestCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPickUpTime;
@property (strong, nonatomic) IBOutlet UILabel *lblPickUpDate;
@property (strong, nonatomic) IBOutlet UIImageView *mealStatusImg;
@property (strong, nonatomic) IBOutlet UILabel *lblDinerName;
@property (strong, nonatomic) IBOutlet UIImageView *mealInProcessImg;
@property (strong, nonatomic) IBOutlet UILabel *lblZipForDiner;
@property (strong, nonatomic) IBOutlet UIImageView *imgMeal;
@property (strong, nonatomic) IBOutlet UILabel *lblCuisineName;
@property (strong, nonatomic) IBOutlet UILabel *lblCuisineType;
@end
