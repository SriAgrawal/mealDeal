//
//  MDCustomOrderVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 25/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface MDCustomOrderVC : UIViewController

@property (nonatomic) BOOL                              isDealAccepted;

@property (strong, nonatomic) MealDetails               *cusomMealObj;

@end
