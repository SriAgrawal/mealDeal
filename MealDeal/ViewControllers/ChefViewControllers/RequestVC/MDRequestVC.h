//
//  MDRequestVC.h
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDRequestVC : UIViewController

@property (strong, nonatomic) NSString                 *strOrderId,*strMealId,*strDinerId;

@property (nonatomic, assign) BOOL                     isNotification;
@property (strong, nonatomic) NSDictionary             *notificationDict;

@end
