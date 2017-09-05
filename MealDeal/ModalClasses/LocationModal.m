//
//  LocationModal.m
//  MealDeal
//
//  Created by Krati Agarwal on 21/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "LocationModal.h"
#include "Macro.h"

@implementation LocationModal

+ (NSArray *)location:(NSDictionary *)dataDict {

    NSMutableArray *list = [NSMutableArray new];

    NSArray *locationArray = [dataDict objectForKeyNotNull:pResult expectedObj:[NSArray array]];
    
    for (NSDictionary *mealDict in locationArray) {
        
        LocationModal *locationObj = [[LocationModal alloc] init];

        NSDictionary *chefDetailDict = [mealDict objectForKeyNotNull:pChefId expectedObj:[NSDictionary dictionary]];
        locationObj.chefId = [chefDetailDict objectForKeyNotNull:p_id expectedObj:@""];
        locationObj.isVerified = [chefDetailDict objectForKeyNotNull:pIsVarified expectedObj:@""];
        
        NSDictionary *latLongDict = [chefDetailDict objectForKeyNotNull:pAddress expectedObj:[NSDictionary dictionary]];
        NSArray *latLongArray = [latLongDict objectForKeyNotNull:pLoc expectedObj:[NSArray array]];
        locationObj.chefLongitude = [latLongArray firstObject];
        locationObj.chefLatitude = [latLongArray lastObject];

        locationObj.mealType = [mealDict objectForKeyNotNull:pMealType expectedObj:@""];
    
        NSDictionary *cuisineDetailDict = [mealDict objectForKeyNotNull:pCuisineDetail expectedObj:[NSDictionary dictionary]];
        locationObj.mealName = [cuisineDetailDict objectForKeyNotNull:pName expectedObj:@""];

        [list addObject: locationObj];

    }
    return [list mutableCopy];
}

@end
