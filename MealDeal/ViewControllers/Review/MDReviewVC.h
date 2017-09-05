//
//  MDReviewVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDReviewVC : UIViewController

@property(strong, nonatomic) NSString *strChefId,*strDishName,*strCookImageUrl,*strCookName,*strReviews,*strComments,*strDishType;
@property(assign, nonatomic) BOOL isFromReviewsList;
@end
