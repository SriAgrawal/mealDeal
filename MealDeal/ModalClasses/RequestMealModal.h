//
//  RequestMealModal.h
//  MealDeal
//
//  Created by Krati Agarwal on 12/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RequestMealModal : NSObject

@property (strong, nonatomic) NSString                  *cuisineNameString;
@property (strong, nonatomic) NSString                  *cuisineTypeString;

@property (strong, nonatomic) UIImage                   *attachedImage;

@property (strong, nonatomic) NSString                  *allergiesString;
@property (strong, nonatomic) NSString                  *storeAroundString;
@property (strong, nonatomic) NSString                  *splRequirementsString;
@property (strong, nonatomic) NSString                  *stepsString;
@property (strong, nonatomic) NSString                  *ingredientsReqString;

@property (strong, nonatomic) NSString                  *spiceRating;

@property (strong, nonatomic) NSString                  *countryString;
@property (strong, nonatomic) NSString                  *stateString;
@property (strong, nonatomic) NSString                  *cityString;
@property (strong, nonatomic) NSString                  *zipCodeString;
@property (strong, nonatomic) NSString                  *addressCodeString;
@property (strong, nonatomic) NSString                  *priceString;
@property (strong, nonatomic) NSString                  *quantityString;
@property (strong, nonatomic) NSString                  *dateString;
@property (nonatomic, strong) NSDate                    *date;

@property (strong, nonatomic) NSString                  *timeString;
@property (nonatomic, strong) NSDate                    *time;

@property (nonatomic, strong) NSDate                    *pickupDate;



// Diner Order Status Data Parsing

@property(strong, nonatomic) NSString *strOrderStatusChefId;
@property(strong, nonatomic) NSString *strOrderStatusChefName;
@property(strong, nonatomic) NSString *strOrderStatusDishName;
@property(strong, nonatomic) NSString *strOrderStatusOrderTime;
@property(strong, nonatomic) NSString *strOrderStatusPickUpDate;
@property(strong, nonatomic) NSString *strOrderStatusPickUptime;
@property(strong, nonatomic) NSString *strOrderStatusPaymentType;
@property(strong, nonatomic) NSString *strOrderStatusMealImageUrl;
@property(strong, nonatomic) NSString *strOrderStatusMealStatus;
@property(strong, nonatomic) NSString *strOrderStatusOrderId;
@property(strong, nonatomic) NSString *strOrderStatusMealId;
@property(strong, nonatomic) NSString *strCustomMealStatus;
@property (nonatomic, strong) NSURL   *photoURL;
@property (nonatomic, strong) NSDate  *createdDate;

@property (nonatomic, strong) NSString      *chefIdString;
@property (nonatomic, strong) NSArray       *orderMealArray;

+ (NSMutableArray *)getOrderStatusDataFromArray:(NSArray *)arr;

+ (NSMutableArray *)getLastTwoDaysOrders:(NSArray *)lastOrderArray;

@end


