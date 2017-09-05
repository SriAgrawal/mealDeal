//
//  MDCartVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum contentName {
    Todays_Special_Detail,
    Surprise_Me_Detail,
    Personal_Nutrition_Detail
} ContentType1;

@interface MDCartVC : UIViewController

@property (nonatomic) BOOL            isBack;
@property (nonatomic) ContentType1 contentType1;

@end
