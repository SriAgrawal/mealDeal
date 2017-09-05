//
//  CookPrepareAMealModal.m
//  MealDeal
//
//  Created by Mohit on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "CookPrepareAMealModal.h"

@implementation CookPrepareAMealModal

// Parse Data for Chef Order History

+(NSMutableArray *)getDataFromArray:(NSArray *)array{
    NSMutableArray *myRegularMealArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookPrepareAMealModal *myRegularMealInfo = [[CookPrepareAMealModal alloc]init];
        NSDictionary *cuisineDict = [dict objectForKey:@"cuisineDetail"];
        myRegularMealInfo.strMyRegularMealDishName = [cuisineDict objectForKey:@"name"];
        myRegularMealInfo.strMyRegularMealDishType = [cuisineDict objectForKey:@"type"];
        
        myRegularMealInfo.ingredientsArray = [dict objectForKeyNotNull:pIngredients expectedObj:[NSArray array]];
        myRegularMealInfo.strMyRegularMealIngredientes = @"";
        for (NSString * str in myRegularMealInfo.ingredientsArray) {
            
            NSString * tempString = [myRegularMealInfo.strMyRegularMealIngredientes stringByAppendingString:str];
            myRegularMealInfo.strMyRegularMealIngredientes = [tempString stringByAppendingString:@","];
        }
        myRegularMealInfo.strMyRegularMealIngredientes = [myRegularMealInfo.strMyRegularMealIngredientes stringByReplacingCharactersInRange:NSMakeRange(myRegularMealInfo.strMyRegularMealIngredientes.length - 1,1) withString:@""];
        
        
        //myRegularMealInfo.strMyRegularMealIngredientes = [dict valueForKey:@"ingredients"];
       
        myRegularMealInfo.strMyRegularMealCaloriesPerServing = [dict objectForKey:@"calories"];
        myRegularMealInfo.strMyRegularMealCostPerPlate = [dict objectForKey:@"price"];
        myRegularMealInfo.strMyRegularMealAdditionalCost = [dict objectForKey:@"additionalCost"];
        myRegularMealInfo.strMyRegularMealServings = [dict objectForKey:@"servings"];
        myRegularMealInfo.strMyRegularMealSlides = [dict objectForKey:@"slides"];
        myRegularMealInfo.strMyRegularMealSpiceLevel = [dict objectForKey:@"spiceLevel"];
        myRegularMealInfo.strMyRegularMealHealthMeter = [dict objectForKey:@"healthMeter"];
        myRegularMealInfo.strMyRegularMealDate = [dict objectForKey:@"date"];
        
        myRegularMealInfo.time = [AppUtility getDateFromString:[dict valueForKey:@"timeRequired"]];
        myRegularMealInfo.strMyRegularMealPreparationTime = [myRegularMealInfo.time getTimeString];
        
        //myRegularMealInfo.strMyRegularMealPreparationTime = [dict valueForKey:@"timeRequired"];
       
        NSDictionary *addressDict = [dict objectForKey:@"PickUpAddress"];
        myRegularMealInfo.strMyRegularMealCountry = [addressDict objectForKey:@"country"];
        myRegularMealInfo.strMyRegularMealState = [addressDict objectForKey:@"state"];
        myRegularMealInfo.strMyRegularMealCity = [addressDict objectForKey:@"city"];
        myRegularMealInfo.strMyRegularMealZip = [addressDict objectForKey:@"zipCode"];
        myRegularMealInfo.strMyRegularMealStreetName = [addressDict objectForKey:@"streetName"];

        NSArray *imagesArray = [dict objectForKey:@"images"];
        myRegularMealInfo.strMyRegularMealDishImageUrl = [imagesArray objectAtIndex:0];
         [myRegularMealArray addObject:myRegularMealInfo];
    }
    return myRegularMealArray;
    
}

// Parse Data For Requested Meal Chef

+(NSMutableArray *)getDataFromRequestedMealArray:(NSArray *)array{
    NSMutableArray *myRequestedMealArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array){
        CookPrepareAMealModal *myRequestedMealInfo = [[CookPrepareAMealModal alloc]init];
        myRequestedMealInfo.strRequestedMealOrderId = [dict objectForKey:@"_id"];

        NSDictionary *dinerDict = [dict objectForKey:@"dinerId"];
        myRequestedMealInfo.strRequestedMealDinerId = [dinerDict objectForKey:@"_id"];
        myRequestedMealInfo.strRequestedMealDinerName = [dinerDict objectForKey:@"fullName"];
        NSDictionary *zipCode = [dinerDict objectForKey:@"address"];
        myRequestedMealInfo.strRequestedMealZipForDiner = [zipCode objectForKey:@"zipCode"];

        myRequestedMealInfo.date = [AppUtility getDateFromString:[dict valueForKey:@"pickUpDate"]];
        myRequestedMealInfo.strRequestedMealPickUpDate = [myRequestedMealInfo.date getDateString];
        
        myRequestedMealInfo.time = [AppUtility getDateFromString:[dict valueForKey:@"PickUpTime"]];
        myRequestedMealInfo.strRequestedMealPickUpTime = [myRequestedMealInfo.time getTimeString];
        
        NSArray *mealArray = [dict objectForKey:@"meal"];
        for(NSDictionary *mealDict in mealArray){
            myRequestedMealInfo.strRequestedMealStatus = [mealDict objectForKey:@"status"];
            NSDictionary *mealId = [mealDict objectForKey:@"mealId"];
            myRequestedMealInfo.strRequestedMealId = [mealId objectForKey:@"_id"];
            NSArray *imagesArray = [mealId objectForKey:@"images"];
            myRequestedMealInfo.strRequestedMealImageUrl = [imagesArray objectAtIndex:0];
            NSDictionary *cuisineDetailDict = [mealId objectForKey:@"cuisineDetail"];
            myRequestedMealInfo.strRequestedMealCuisineName = [cuisineDetailDict objectForKey:@"name"];
            myRequestedMealInfo.strRequestedMealCuisineType = [cuisineDetailDict objectForKey:@"type"];
            [myRequestedMealArray addObject:myRequestedMealInfo];
        }
        //NSDictionary *mealDict = [mealArray objectAtIndex:0];
    }
    return myRequestedMealArray;
}

// Parse Data For Request Details Chef Section

+(CookPrepareAMealModal *)getDataFromDictionary:(NSDictionary *)dict {
    
    CookPrepareAMealModal *requestDetails = [[CookPrepareAMealModal alloc]init];
   
    NSDictionary *ordersDict = [dict objectForKey:@"orders"];

    requestDetails.date = [AppUtility getDateFromString:[ordersDict objectForKey:@"PickUpDate"]];
    requestDetails.strRequestDetailPickUpDate = [requestDetails.date getDateString];

    requestDetails.time = [AppUtility getDateFromString:[ordersDict valueForKey:@"PickUpTime"]];
    requestDetails.strRequestDetailPickUpTime = [requestDetails.time getTimeString];
    
    NSDictionary *dinerDict = [ordersDict objectForKey:@"dinerId"];
    requestDetails.strRequestDetailDinerId = [dinerDict objectForKey:p_id];
    requestDetails.strRequestDetailDinerName = [dinerDict objectForKey:pFullName];
    NSDictionary *addressDict = [dinerDict objectForKey:pAddress];
    requestDetails.strRequestDetailDinerZip = [addressDict objectForKey:pZipCode];

    NSDictionary *reviewDict = [dict objectForKey:@"result"];
    requestDetails.strRequestDetailMealCategroy = [reviewDict objectForKey:@"mealType"];
    requestDetails.strRequestDetailSpecialRequirements = [reviewDict objectForKey:@"specialRequirements"];
    requestDetails.strRequestDetailSteps = [reviewDict objectForKey:@"steps"];

    requestDetails.ingredientsArray = [reviewDict objectForKeyNotNull:pIngredients expectedObj:[NSArray array]];
    requestDetails.strRequestDetailIngredientesReq = @"";
    for (NSString * str in requestDetails.ingredientsArray) {
        
        NSString * tempString = [requestDetails.strRequestDetailIngredientesReq stringByAppendingString:str];
        requestDetails.strRequestDetailIngredientesReq = [tempString stringByAppendingString:@","];
    }
    requestDetails.strRequestDetailIngredientesReq = [requestDetails.strRequestDetailIngredientesReq stringByReplacingCharactersInRange:NSMakeRange(requestDetails.strRequestDetailIngredientesReq.length - 1,1) withString:@""];
    
    requestDetails.strRequestDetailSpiceLevel = [reviewDict objectForKey:@"spiceLevel"];
    requestDetails.strRequestDetailPriceOffering = [reviewDict objectForKey:@"price"];
    
    
    NSArray *allergiesArray = [reviewDict objectForKey:@"allergies"];
    requestDetails.strRequestDetailAllergies = @"";
    for (NSString * str in allergiesArray) {
        
        NSString * tempString = [requestDetails.strRequestDetailAllergies stringByAppendingString:str];
        requestDetails.strRequestDetailAllergies = [tempString stringByAppendingString:@","];
    }
    requestDetails.strRequestDetailAllergies = [requestDetails.strRequestDetailAllergies stringByReplacingCharactersInRange:NSMakeRange(requestDetails.strRequestDetailAllergies.length - 1,1) withString:@""];
    
    requestDetails.requestDetailMealImages = [[NSArray alloc] init];
    requestDetails.requestDetailMealImages = [reviewDict objectForKey:@"images"];
    NSDictionary *cuisineDict = [reviewDict objectForKey:@"cuisineDetail"];
    requestDetails.strRequestDetailCuisineName = [cuisineDict objectForKey:@"name"];
    requestDetails.strRequestDetailCuisineType = [cuisineDict objectForKey:@"type"];
    NSArray *storesAround = [reviewDict objectForKey:@"storesArounds"];
    requestDetails.strRequestDetailStoreAround = [storesAround objectAtIndex:0];

    return requestDetails;
}


@end
