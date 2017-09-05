//
//  UserInfo.m
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "UserInfo.h"
#import "Macro.h"

@implementation UserInfo

+ (UserInfo *)getDefaultInfo {
    
    UserInfo *info = [[UserInfo alloc] init];
    
    info.userNameString = @"";
    info.fullNameString = @"";
    info.emailString = @"";
    info.phoneString = @"";
    info.passwordString = @"";
    info.confirmPasswordString = @"";
    info.countryString = @"";
    info.stateString = @"";
    info.cityString = @"";
    info.zipCodeString = @"";
    info.descriptionString = @"";
    
    info.roleType = None;
    
    info.rangeString = @"5 Miles";
    info.cuisinePreferenceString = @"";
    info.mealType = @"";
    info.chefType = @"";
    info.spiceLevelString = @"0";

    return info;
}


+ (UserInfo *)userDetail:(NSDictionary *)datadict {
    
    UserInfo *infoObj = [[UserInfo alloc] init];

    NSDictionary *uaerDict = [datadict objectForKeyNotNull:pChefdetails expectedObj:[NSDictionary dictionary]];

    infoObj.photoURL = [uaerDict objectForKeyNotNull:pPhoto expectedObj:@""];
    infoObj.phoneString = [uaerDict objectForKeyNotNull:pPhone expectedObj:@""];
    infoObj.passwordString = [uaerDict objectForKeyNotNull:pPassword expectedObj:@""];
    infoObj.emailString = [uaerDict objectForKeyNotNull:pEmail expectedObj:@""];
    infoObj.userNameString = [uaerDict objectForKeyNotNull:pUserName expectedObj:@""];
    infoObj.fullNameString = [uaerDict objectForKeyNotNull:pFullName expectedObj:@""];
    
    NSDictionary * addressDict = [uaerDict objectForKeyNotNull:pAddress expectedObj:[NSDictionary dictionary]];
    infoObj.zipCodeString = [addressDict objectForKeyNotNull:pZipCode expectedObj:@""];
    
    infoObj.pushNotification = [uaerDict objectForKeyNotNull:pPushNotification expectedObj:@""];
    
    infoObj.notificationStatus = NO;
    if ([infoObj.pushNotification isEqualToString:@"1"]) {
        infoObj.notificationStatus = YES;
    }
    
    return infoObj;
}

@end
