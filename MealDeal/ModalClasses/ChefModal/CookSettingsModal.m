//
//  CookSettingsModal.m
//  MealDeal
//
//  Created by Mohit on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "CookSettingsModal.h"

@implementation CookSettingsModal

+(CookSettingsModal *)gettingDataFromResponse:(NSDictionary *)dict {
    
    CookSettingsModal *cookSettings = [[CookSettingsModal alloc]init];
    
    cookSettings.strImageUrl =  [dict objectForKeyNotNull:@"image" expectedObj:@""];
    cookSettings.strUsername =  [dict objectForKeyNotNull:@"userName" expectedObj:@""];
    cookSettings.pushNotificationStatus =  [dict objectForKeyNotNull:@"pushNotification" expectedObj:@""];
    cookSettings.strTotalRating =  [dict objectForKeyNotNull:@"totalRating" expectedObj:@""];
    cookSettings.strReviews =  [dict objectForKeyNotNull:@"totalreview" expectedObj:@""];

  //cookSettings.strAccountNumber =  [dict objectForKeyNotNull:@"paypalDetail" expectedObj:@""];
    
    cookSettings.strName =  [dict objectForKeyNotNull:@"fullName" expectedObj:@""];
    cookSettings.strEmail =  [dict objectForKeyNotNull:@"email" expectedObj:@""];
    cookSettings.strPhoneNo =  [dict objectForKeyNotNull:@"phoneNumber" expectedObj:@""];
    cookSettings.strPassword =  [dict objectForKeyNotNull:@"password" expectedObj:@""];

    NSDictionary *addressDict = [dict objectForKey:@"address"];
    cookSettings.strCountry =  [addressDict objectForKeyNotNull:@"country" expectedObj:@""];
    cookSettings.strState =  [addressDict objectForKeyNotNull:@"state" expectedObj:@""];
    cookSettings.strCity =  [addressDict objectForKeyNotNull:@"city" expectedObj:@""];
    cookSettings.strZipcode =  [addressDict objectForKeyNotNull:@"zipCode" expectedObj:@""];
    cookSettings.strStreetName =  [addressDict objectForKeyNotNull:@"streetName" expectedObj:@""];



    return cookSettings;
}



// Parse Data for Chef Order History

+(NSMutableArray *)gettingDataFromArray:(NSArray *)array{
    NSMutableArray *orderHistoryListArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookSettingsModal *orderHistoryInfo = [[CookSettingsModal alloc]init];
        orderHistoryInfo.strOrderHistoryDate = [dict objectForKey:@"PickUpDate"];
        NSArray *mealArray = [dict objectForKey:@"meal"];
        for(NSDictionary *mealDict in mealArray){
            NSDictionary *mealImage = [mealDict objectForKey:@"mealId"];
            NSArray *arr = [mealImage objectForKey:@"images"];
            orderHistoryInfo.strOrderHistoryImageUrl = [arr objectAtIndex:0];
        }
        
        [orderHistoryListArray addObject:orderHistoryInfo];
    }
    return orderHistoryListArray;

}

// Parse Data For Chef Regular Mealers

+(NSMutableArray *)gettingDataFromRegularMealersArray:(NSArray *)array{
    NSMutableArray *regularMealersArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookSettingsModal *regularMealersInfo = [[CookSettingsModal alloc]init];
        regularMealersInfo.arrMealName = [[NSMutableArray alloc] init];
        regularMealersInfo.strRegularMealersDate = [dict objectForKey:@"PickUpTime"];
        regularMealersInfo.strRegularMealersOrderAmount = [dict objectForKey:@"totalPrice"];
        NSDictionary *dinerDetails = [dict objectForKey:@"dinerId"];
        regularMealersInfo.strRegularMealersDinerName = [dinerDetails objectForKey:@"fullName"];
        NSArray *mealDetailsArray = [dict objectForKey:@"meal"];
        //NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        for(NSDictionary *mealDict in mealDetailsArray){
            NSDictionary *mealIdDict = [mealDict objectForKey:@"mealId"];
            NSDictionary *cuisineDetailDict = [mealIdDict objectForKey:@"cuisineDetail"];
            regularMealersInfo.strRegularMealersDishOrdered = [cuisineDetailDict objectForKey:@"name"];
           // [nameArray addObject:regularMealersInfo.strRegularMealersDishOrdered];
          //  regularMealersInfo.arrMealName = nameArray;
        }
        [regularMealersArray addObject:regularMealersInfo];
    }
    return regularMealersArray;
    
}

// Parse Data For Today's order List Chef Section

+(NSMutableArray *)parseDataFromTodaysOrdersList:(NSArray *)array{
    NSMutableArray *todaysOrderArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookSettingsModal *todaysOrderInfo = [[CookSettingsModal alloc]init];
        todaysOrderInfo.strTodaysOrderPickUpDate = [dict objectForKey:@"PickUpDate"];
        NSDictionary *dinerDetails = [dict objectForKey:@"dinerId"];
        todaysOrderInfo.strTodaysOrderUsername = [dinerDetails objectForKey:@"fullName"];
        todaysOrderInfo.strTodaysOrderDinerImage = [dinerDetails objectForKey:@"image"];
        todaysOrderInfo.strTodaysOrderDinerId = [dinerDetails objectForKey:@"_id"];
        NSArray *mealArray = [dict objectForKey:@"meal"];
        NSDictionary *mealDict = [mealArray objectAtIndex:0];
        NSDictionary *mealIdDict = [mealDict objectForKey:@"mealId"];
        todaysOrderInfo.strTodaysOrderSpiceLevel = [mealIdDict objectForKey:@"spiceLevel"];
        todaysOrderInfo.strTodaysOrderSteps = [mealIdDict objectForKey:@"steps"];
        todaysOrderInfo.strTodaysOrderSpecialRequirements = [mealIdDict objectForKey:@"specialRequirements"];
        
        //todaysOrderInfo.strTodaysOrderIngredientsReq = [mealIdDict objectForKey:@"ingredients"];
        NSArray *ingredientsArray = [mealIdDict objectForKey:@"ingredients"];
        todaysOrderInfo.strTodaysOrderIngredientsReq = @"";
        for (NSString * str in ingredientsArray) {
            
            NSString * tempString = [todaysOrderInfo.strTodaysOrderIngredientsReq stringByAppendingString:str];
            todaysOrderInfo.strTodaysOrderIngredientsReq = [tempString stringByAppendingString:@","];
        }
        todaysOrderInfo.strTodaysOrderIngredientsReq = [todaysOrderInfo.strTodaysOrderIngredientsReq stringByReplacingCharactersInRange:NSMakeRange(todaysOrderInfo.strTodaysOrderIngredientsReq.length - 1,1) withString:@""];
        
        NSArray *allergiesArray = [mealIdDict objectForKey:@"allergies"];
        todaysOrderInfo.strTodaysOrderAllergies = @"";
        for (NSString * str in allergiesArray) {
            
            NSString * tempString = [todaysOrderInfo.strTodaysOrderAllergies stringByAppendingString:str];
            todaysOrderInfo.strTodaysOrderAllergies = [tempString stringByAppendingString:@","];
        }
        todaysOrderInfo.strTodaysOrderAllergies = [todaysOrderInfo.strTodaysOrderAllergies stringByReplacingCharactersInRange:NSMakeRange(todaysOrderInfo.strTodaysOrderAllergies.length - 1,1) withString:@""];

        
        todaysOrderInfo.strTodaysOrderStoreAround = [[mealIdDict objectForKey:@"storesArounds"] componentsJoinedByString:@","];
        NSArray *mealImageArray = [mealIdDict objectForKey:@"images"];
        todaysOrderInfo.strTodaysOrderMealImage = [mealImageArray objectAtIndex:0];
        NSDictionary *addressDict = [mealIdDict valueForKey:@"PickUpAddress"];
        todaysOrderInfo.strTodaysOrderZip = [addressDict valueForKey:@"zipCode"];
        NSDictionary *cuisineDetails = [mealIdDict objectForKey:@"cuisineDetail"];
        todaysOrderInfo.strTodaysOrderCuisineName = [cuisineDetails objectForKey:@"name"];
        todaysOrderInfo.strTodaysOrderCuisineType = [cuisineDetails objectForKey:@"type"];
        [todaysOrderArray addObject:todaysOrderInfo];
    }
    return todaysOrderArray;
    
}

// Parse Data For Chef Future Orders List

+(NSMutableArray *)getDataFromFutureOrdersArray:(NSArray*)array{
    NSMutableArray *futureOrdersArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookSettingsModal *futureOrdersInfo = [[CookSettingsModal alloc]init];
        futureOrdersInfo.strFutureOrderId = [dict objectForKey:@"_id"];
        NSDictionary *dinerDict = [dict objectForKey:@"dinerId"];
        futureOrdersInfo.strFutureOrderUsername = [dinerDict objectForKey:@"fullName"];
        futureOrdersInfo.strFutureOrderPrice = [dict objectForKey:@"totalPrice"];
        NSArray *mealArray = [dict objectForKey:@"meal"];
        NSDictionary *mealDict = [mealArray objectAtIndex:0];
        NSDictionary *mealIdDict = [mealDict objectForKey:@"mealId"];
        futureOrdersInfo.strFutureOrderMealId = [mealIdDict objectForKey:@"_id"];
        NSArray *mealImages = [mealIdDict objectForKey:@"images"];
        futureOrdersInfo.strFutureOrderImage = [mealImages objectAtIndex:0];
        [futureOrdersArray addObject:futureOrdersInfo];
    }
    return futureOrdersArray;

}




@end
