//
//  UserInfo.h
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : NSObject

typedef enum Role {
    None,
    Cook,
    Eat
} RoleType;

@property (strong, nonatomic) NSString *userNameString;
@property (strong, nonatomic) NSString *fullNameString;
@property (strong, nonatomic) NSString *emailString;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *passwordString;
@property (strong, nonatomic) NSString *confirmPasswordString;

@property (strong, nonatomic) NSString *countryString;
@property (strong, nonatomic) NSString *stateString;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *zipCodeString;
@property (strong, nonatomic) UIImage  *profileImage;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) NSString *pushNotification;
@property (nonatomic, assign) BOOL     notificationStatus;

@property (nonatomic, strong) NSURL    *photoURL;
@property (nonatomic, strong) NSString *socialIdString;

@property (strong, nonatomic) NSString *rangeString;
@property (strong, nonatomic) NSString *cuisinePreferenceString;
@property (nonatomic, strong) NSArray  *allergiesArray;
@property (strong, nonatomic) NSString *allergiesString;

@property (strong, nonatomic) NSString *mealType;
@property (strong, nonatomic) NSString *spiceLevelString;
@property (strong, nonatomic) NSString *chefType;

@property (nonatomic) RoleType roleType;


+ (UserInfo *)getDefaultInfo;

+ (UserInfo *)userDetail:(NSDictionary *)datadict;

@end
