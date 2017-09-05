//
//  CookSettingsModal.h
//  MealDeal
//
//  Created by Mohit on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "Macro.h"

@interface CookSettingsModal : NSObject

@property(strong, nonatomic)NSString *strUsername;
@property(strong, nonatomic)NSString *strName;
@property(strong, nonatomic)NSString *strPassword;
@property(strong, nonatomic)NSString *strPhoneNo;
@property(strong, nonatomic)NSString *strEmail;
@property(strong, nonatomic)NSString *strZipcode;
@property(strong, nonatomic)NSString *strReviews;
@property(strong, nonatomic)NSString *strTotalRating;
@property(strong, nonatomic)NSString *strImageUrl;
@property(assign, nonatomic)BOOL pushNotificationStatus;


@property(strong, nonatomic)NSString *strCountry;
@property(strong, nonatomic)NSString *strState;
@property(strong, nonatomic)NSString *strCity;
@property(strong, nonatomic)NSString *strZipCodeAddress;
@property(strong, nonatomic)NSString *strStreetName;
@property(strong, nonatomic)NSString *strAccountNumber;


+(CookSettingsModal *)gettingDataFromResponse:(NSDictionary *)dict;



// Data Parsing For Chef Order History
@property(strong, nonatomic)NSString *strOrderHistoryDate;
@property(strong, nonatomic)NSString *strOrderHistoryImageUrl;


+(NSMutableArray *)gettingDataFromArray:(NSArray *)array;


// Parse Data For My Regular Mealers Chef Section

@property(strong, nonatomic)NSString *strRegularMealersDate;
@property(strong, nonatomic)NSString *strRegularMealersDinerName;
@property(strong, nonatomic)NSString *strRegularMealersDishOrdered;
@property(strong, nonatomic)NSString *strRegularMealersOrderAmount;
@property(strong, nonatomic)NSMutableArray *arrMealName;


+(NSMutableArray *)gettingDataFromRegularMealersArray:(NSArray *)array;


// Parse Data For Chef Today,s Order List

@property(strong, nonatomic)NSString *strTodaysOrderAllergies;
@property(strong, nonatomic)NSString *strTodaysOrderUsername;
@property(strong, nonatomic)NSString *strTodaysOrderDinerImage;
@property(strong, nonatomic)NSString *strTodaysOrderDinerId;
@property(strong, nonatomic)NSString *strTodaysOrderDinerName;
@property(strong, nonatomic)NSString *strTodaysOrderZip;
@property(strong, nonatomic)NSString *strTodaysOrderCuisineName;
@property(strong, nonatomic)NSString *strTodaysOrderCuisineType;
@property(strong, nonatomic)NSString *strTodaysOrderStoreAround;
@property(strong, nonatomic)NSString *strTodaysOrderSpecialRequirements;
@property(strong, nonatomic)NSString *strTodaysOrderSteps;
@property(strong, nonatomic)NSString *strTodaysOrderIngredientsReq;
@property(strong, nonatomic)NSString *strTodaysOrderSpiceLevel;
@property(strong, nonatomic)NSString *strTodaysOrderTimeRequested;
@property(strong, nonatomic)NSString *strTodaysOrderPickUpDate;
@property(strong, nonatomic)NSString *strTodaysOrderMealImage;


+(NSMutableArray *)parseDataFromTodaysOrdersList:(NSArray*)array;


// Parse Data For Cher Future Orders List

@property(strong, nonatomic)NSString *strFutureOrderUsername;
@property(strong, nonatomic)NSString *strFutureOrderSpecialWraps;
@property(strong, nonatomic)NSString *strFutureOrderPrice;
@property(strong, nonatomic)NSString *strFutureOrderPaymentType;
@property(strong, nonatomic)NSString *strFutureOrderId;
@property(strong, nonatomic)NSString *strFutureOrderImage;
@property(strong, nonatomic)NSString *strFutureOrderStatus;
@property(strong, nonatomic)NSString *strFutureOrderMealId;


+(NSMutableArray *)getDataFromFutureOrdersArray:(NSArray*)array;











@end
