//
//  MealDetails.m
//  MealDeal
//
//  Created by Krati Agarwal on 15/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MealDetails.h"
#include "Macro.h"

@implementation MealDetails

// ***** Diner Today's special/Surprise me/ Personal Nutrition screen parsing ******

+ (NSArray *)meals:(NSDictionary *)dataDict {
    
    NSMutableArray *list = [NSMutableArray new];
    
    NSArray *arr = [dataDict objectForKeyNotNull:pDetails expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in arr) {
        
        MealDetails *mealObj = [[MealDetails alloc] init];
        
        mealObj.mealIdString = [dict objectForKeyNotNull:p_id expectedObj:@""];
        mealObj.chefIdString = [dict objectForKeyNotNull:pChefId expectedObj:@""];
        mealObj.priceString = [dict objectForKeyNotNull:pPrice expectedObj:@""];
        
        NSArray *imageArray = [dict objectForKeyNotNull:pImages expectedObj:[NSArray array]];
        NSString *urlString = [imageArray firstObject];
        
        mealObj.photoURL = [NSURL URLWithString:urlString];
        
        NSDictionary *cuisineDetaildict = [dict objectForKeyNotNull:pCuisineDetail expectedObj:[NSDictionary dictionary]];
        mealObj.cuisineNameString = [cuisineDetaildict objectForKeyNotNull:pName expectedObj:@""];
        
        [list addObject: mealObj];
    }
    
    return [list mutableCopy];
}

// ***************** Diner detail list parsing **********************

+ (MealDetails *)mealDetails:(NSDictionary *)resultDict {
    
    MealDetails *mealObj = [[MealDetails alloc] init];
    
    NSDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
    
    ////////////////////// parsing Chef's speciality ///////////////////////
    NSDictionary *specialityDict = [dataDict objectForKeyNotNull:pPrefResult expectedObj:[NSDictionary dictionary]];
    mealObj.specialityString = [specialityDict objectForKeyNotNull:pSpeciality expectedObj:@""];
    
    ////////////////////// parsing Chef's review details ///////////////////////
    NSDictionary *reviewDict = [dataDict objectForKeyNotNull:pReview expectedObj:[NSDictionary dictionary]];
    mealObj.totalReviewString = [reviewDict objectForKeyNotNull:pTotalreview expectedObj:@""];
    mealObj.totalRatingString = [reviewDict objectForKeyNotNull:pTotalRating expectedObj:@""];
    
    ////////////////////// parsing Chef's name and id ///////////////////////
    NSDictionary *chefDict1 = [dataDict objectForKeyNotNull:pResult expectedObj:[NSDictionary dictionary]];
    
    ////////////////////// parsing Chef's  details ///////////////////////
    NSDictionary *chefDict2 = [chefDict1 objectForKeyNotNull:pChefId expectedObj:[NSDictionary dictionary]];
    mealObj.chefIdString = [chefDict2 objectForKeyNotNull:p_id expectedObj:@""];
    mealObj.chefNameString = [chefDict2 objectForKeyNotNull:pFullName expectedObj:@""];
    
    mealObj.mealTypeString = [chefDict1 objectForKeyNotNull:pMealType expectedObj:@""];
    mealObj.caloriesString = [chefDict1 objectForKeyNotNull:pCalories expectedObj:@""];
    mealObj.priceString = [chefDict1 objectForKeyNotNull:pPrice expectedObj:@""];
    mealObj.additionalCostString = [chefDict1 objectForKeyNotNull:pAdditionalCost expectedObj:@""];
    mealObj.servingsString = [chefDict1 objectForKeyNotNull:pServings expectedObj:@""];
    mealObj.spiceLevelString = [chefDict1 objectForKeyNotNull:pSpiceLevel expectedObj:@""];
    
    mealObj.date = [AppUtility getDateFromString:[chefDict1 objectForKeyNotNull:pData expectedObj:@""]];
    mealObj.dateString = [mealObj.date getDateString];
    
    mealObj.healthMeterString = [chefDict1 objectForKeyNotNull:pHealthMeter expectedObj:@""];
    
    mealObj.time = [AppUtility getDateFromString:[chefDict1 objectForKeyNotNull:pTimeRequired expectedObj:@""]];
    mealObj.timeRequiredString = [mealObj.time getTimeString];
    
    NSMutableDictionary *cuisineDict = [chefDict1 objectForKeyNotNull:pCuisineDetail expectedObj:@""];
    mealObj.cuisineNameString = [cuisineDict objectForKeyNotNull:pName expectedObj:@""];
    mealObj.cuisineTypeString = [cuisineDict objectForKeyNotNull:pType expectedObj:@""];
    
    NSArray *imageArray = [chefDict1 objectForKeyNotNull:pImages expectedObj:[NSArray array]];
    mealObj.imageUrlArray = [NSMutableArray new];
    
    for (NSString * str in imageArray) {
        
        [mealObj.imageUrlArray addObject: [NSURL URLWithString:str]];
    }
    
    mealObj.ingredientsArray = [chefDict1 objectForKeyNotNull:pIngredients expectedObj:[NSArray array]];
    mealObj.ingredientsString = @"";
    for (NSString * str in mealObj.ingredientsArray) {
        
        NSString * tempString = [mealObj.ingredientsString stringByAppendingString:str];
        mealObj.ingredientsString = [tempString stringByAppendingString:@","];
    }
    
    mealObj.ingredientsString = [mealObj.ingredientsString stringByReplacingCharactersInRange:NSMakeRange(mealObj.ingredientsString.length - 1,1) withString:@""];
    
    return mealObj;
}

// ***************** Diner Healthy meal parsing **********************

+ (NSArray *)healthyMeal:(NSArray *)dataArray{
    
    NSMutableArray *list = [NSMutableArray new];
    
    for (NSDictionary *dict in dataArray) {
        
        MealDetails *mealObj = [[MealDetails alloc] init];
        
        mealObj.mealIdString = [dict objectForKeyNotNull:p_id expectedObj:@""];
        mealObj.chefIdString = [dict objectForKeyNotNull:pChefId expectedObj:@""];
        mealObj.mealTypeString = [dict objectForKeyNotNull:pMealType expectedObj:@""];
        mealObj.caloriesString = [dict objectForKeyNotNull:pCalories expectedObj:@""];
        mealObj.priceString = [dict objectForKeyNotNull:pPrice expectedObj:@""];
        mealObj.additionalCostString = [dict objectForKeyNotNull:pAdditionalCost expectedObj:@""];
        mealObj.servingsString = [dict objectForKeyNotNull:pServings expectedObj:@""];
        mealObj.sidesString = [dict objectForKeyNotNull:pSides expectedObj:@""];
        mealObj.spiceLevelString = [dict objectForKeyNotNull:pSpiceLevel expectedObj:@""];
        mealObj.healthMeterString = [dict objectForKeyNotNull:pHealthMeter expectedObj:@""];
        mealObj.time = [AppUtility getDateFromString:[dict objectForKeyNotNull:pTimeRequired expectedObj:@""]];
        mealObj.timeRequiredString = [mealObj.time getTimeString];
        
        mealObj.date = [AppUtility getDateFromString:[dict objectForKeyNotNull:pData expectedObj:@""]];
        mealObj.dateString = [mealObj.date getDateString];
        
        mealObj.mealCountString = [dict objectForKeyNotNull:pMealCount expectedObj:@""];
        
        NSDictionary *addToHealthyMealdict = [dict objectForKeyNotNull:pAddToHealthyMeal expectedObj:[NSDictionary dictionary]];
        mealObj.mineralstString = [addToHealthyMealdict objectForKeyNotNull:pMinerals expectedObj:@""];
        mealObj.consumedQuantityString = [addToHealthyMealdict objectForKeyNotNull:pConsumedQuantity expectedObj:@""];
        mealObj.mealTimeString = [addToHealthyMealdict objectForKeyNotNull:pMealTime expectedObj:@""];
        mealObj.nutrientsString = [addToHealthyMealdict objectForKeyNotNull:pNutrients expectedObj:@""];
        
        NSArray *imageArray = [dict objectForKeyNotNull:pImages expectedObj:[NSArray array]];
        NSString *urlString = [imageArray firstObject];
        mealObj.photoURL = [NSURL URLWithString:urlString];
        
        mealObj.ingredientsArray = [dict objectForKeyNotNull:pIngredients expectedObj:[NSArray array]];
        mealObj.ingredientsString = @"";
        for (NSString * str in mealObj.ingredientsArray) {
            
            NSString * tempString = [mealObj.ingredientsString stringByAppendingString:str];
            mealObj.ingredientsString = [tempString stringByAppendingString:@","];
        }
        mealObj.ingredientsString = [mealObj.ingredientsString stringByReplacingCharactersInRange:NSMakeRange(mealObj.ingredientsString.length - 1,1) withString:@""];
        
        NSDictionary *cuisineDetaildict = [dict objectForKeyNotNull:pCuisineDetail expectedObj:[NSDictionary dictionary]];
        mealObj.cuisineNameString = [cuisineDetaildict objectForKeyNotNull:pName expectedObj:@""];
        mealObj.cuisineTypeString = [cuisineDetaildict objectForKeyNotNull:pType expectedObj:@""];
        
        [list addObject:mealObj];
    }
    
    return [list mutableCopy];
    
}

// ***************** Diner Cart screen parsing **********************

+ (NSArray *)particularChefMeal:(NSArray *)mealArray {
    
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSDictionary *mealDict in mealArray) {
        [list addObject:[MealDetails cartMeal:mealDict]];
    }
    
    return [list mutableCopy];
}

+ (MealDetails *)cartMeal:(NSDictionary *)dataDict {
    
    MealDetails *mealObj = [[MealDetails alloc] init];

    NSDictionary *mealDict = [dataDict objectForKeyNotNull:pMealId expectedObj:[NSDictionary dictionary]];
    mealObj.mealIdString = [mealDict objectForKeyNotNull:p_id expectedObj:@""];
    mealObj.priceString = [mealDict objectForKeyNotNull:pPrice expectedObj:@""];
    mealObj.additionalCostString = [mealDict objectForKeyNotNull:pAdditionalCost expectedObj:@""];
    
    NSArray *imageArray = [mealDict objectForKeyNotNull:pImages expectedObj:[NSArray array]];
    NSString *urlString = [imageArray firstObject];
    mealObj.photoURL = [NSURL URLWithString:urlString];
    
    NSDictionary *cuisineDetailDict = [mealDict objectForKeyNotNull:pCuisineDetail expectedObj:[NSDictionary dictionary]];
    mealObj.cuisineNameString = [cuisineDetailDict objectForKeyNotNull:pName expectedObj:@""];
    mealObj.cuisineTypeString = [cuisineDetailDict objectForKeyNotNull:pType expectedObj:@""];

    NSDictionary *addressDict = [mealDict objectForKeyNotNull:@"PickUpAddress" expectedObj:[NSDictionary dictionary]];
    mealObj.countryString = [addressDict objectForKeyNotNull:pCountry expectedObj:@""];
    mealObj.stateString = [addressDict objectForKeyNotNull:pState expectedObj:@""];
    mealObj.cityString = [addressDict objectForKeyNotNull:pCity expectedObj:@""];
    mealObj.zipCodeString = [addressDict objectForKeyNotNull:pZipCode expectedObj:@""];
    mealObj.streetString = [addressDict objectForKeyNotNull:pStreetName expectedObj:@""];

    NSArray *locationArray = [addressDict objectForKeyNotNull:pLoc expectedObj:[NSArray array]];
    mealObj.longitudeString = [locationArray firstObject];
    mealObj.latitudeString = [locationArray lastObject];

    mealObj.quantity = 1;
    
    return mealObj;

}

// ***************** Chef Healthy Meal List Data Parsing **********************

+(NSMutableArray *)getDataFromArray:(NSArray *)array{
    NSMutableArray *healthyMealArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        MealDetails *healthyMeal = [[MealDetails alloc]init];
        NSArray *imageArray = [dict valueForKey:@"images"];
        healthyMeal.strHealthyMealImgeUrl = [imageArray objectAtIndex:0];
        NSDictionary *mealDict = [dict valueForKey:@"cuisineDetail"];
        healthyMeal.strHealthyMealName = [mealDict valueForKey:@"name"];
        healthyMeal.strHealthyMealId = [mealDict valueForKey:@"_id"];
        [healthyMealArray addObject:healthyMeal];
    }
    return healthyMealArray;
}


@end
