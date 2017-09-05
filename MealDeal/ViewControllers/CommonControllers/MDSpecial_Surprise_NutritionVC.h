//
//  MDSpecial_Surprice_NutritionVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "Macro.h"

typedef enum content {
    Todays_Special,
    Surprise_Me,
    Personal_Nutrition
} ContentType;

@interface MDSpecial_Surprise_NutritionVC : UIViewController

@property (nonatomic) ContentType contentType;

@end
