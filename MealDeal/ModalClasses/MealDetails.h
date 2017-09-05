//
//  MealDetails.h
//  MealDeal
//
//  Created by Krati Agarwal on 15/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealDetails : NSObject

@property (strong, nonatomic) NSString                  *totalReviewString;

@property (strong, nonatomic) NSString                  *chefNameString;

@property (nonatomic, strong) NSURL                     *photoURL;

@property (strong, nonatomic) NSString                  *totalRatingString;

@property (strong, nonatomic) NSString                  *mealIdString;

@property (strong, nonatomic) NSString                  *chefIdString;

@property (strong, nonatomic) NSString                  *priceString;

@property (strong, nonatomic) NSString                  *cuisineNameString;

@property (strong, nonatomic) NSString                  *cuisineTypeString;

@property (strong, nonatomic) NSString                  *cuisineIncludes;

@property (strong, nonatomic) NSString                  *mealTypeString;

@property (strong, nonatomic) NSArray                   *ingredientsArray;

@property (strong, nonatomic) NSString                  *ingredientsString;

@property (strong, nonatomic) NSString                  *caloriesString;

@property (strong, nonatomic) NSString                  *additionalCostString;

@property (strong, nonatomic) NSString                  *servingsString;

@property (strong, nonatomic) NSString                  *spiceLevelString;

@property (strong, nonatomic) NSString                  *healthMeterString;

@property (strong, nonatomic) NSString                  *timeRequiredString;

@property (strong, nonatomic) NSString                  *specialityString;

@property (nonatomic, strong) NSMutableArray            *imageUrlArray;

@property (strong, nonatomic) NSString                  *sidesString;

@property (strong, nonatomic) NSString                  *dateString;

@property (strong, nonatomic) NSString                  *mealCountString;

@property (strong, nonatomic) NSString                  *mineralstString;

@property (strong, nonatomic) NSString                  *consumedQuantityString;

@property (strong, nonatomic) NSString                  *mealTimeString;

@property (strong, nonatomic) NSString                  *nutrientsString;

@property (nonatomic, assign) NSInteger                 quantity;

@property (nonatomic, strong) NSDate                    *date;

@property (nonatomic, strong) NSDate                    *time;

@property (strong, nonatomic) NSString                  *editpriceString;

///////////////////////////// Address /////////////////////////////////
@property (strong, nonatomic) NSString                  *countryString;
@property (strong, nonatomic) NSString                  *stateString;
@property (strong, nonatomic) NSString                  *cityString;
@property (strong, nonatomic) NSString                  *streetString;
@property (strong, nonatomic) NSString                  *zipCodeString;
@property (strong, nonatomic) NSString                  *longitudeString;
@property (strong, nonatomic) NSString                  *latitudeString;

+ (NSArray *)meals:(NSDictionary *)dataDict;

+ (MealDetails *)mealDetails:(NSDictionary *)dataDict;

+ (NSArray *)particularChefMeal:(NSArray *)mealArray;

+ (MealDetails *)cartMeal:(NSDictionary *)dataDict;


// Chef Healthy Meal list data parsing

@property(strong,nonatomic) NSString  *strHealthyMealImgeUrl;
@property(strong, nonatomic) NSString *strHealthyMealName;
@property(strong, nonatomic) NSString *strStatus;
@property(strong, nonatomic) NSString *strHealthyMealId;


+(NSMutableArray *)getDataFromArray:(NSArray*)array;

+ (NSArray *)healthyMeal:(NSArray *)dataArray;
    
@end
