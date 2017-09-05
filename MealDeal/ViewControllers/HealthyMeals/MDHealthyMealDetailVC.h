//
//  MDHealthyMealDetailVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 24/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface MDHealthyMealDetailVC : UIViewController

@property (nonatomic) NSString                              *mealName;
@property (strong, nonatomic) MealDetails                   *mealDetail;

@end
