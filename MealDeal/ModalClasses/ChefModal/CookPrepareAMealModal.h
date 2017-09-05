//
//  CookPrepareAMealModal.h
//  MealDeal
//
//  Created by Mohit on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "Macro.h"

@interface CookPrepareAMealModal : NSObject

@property (strong, nonatomic) NSString *strMealCategory;
@property (strong, nonatomic) NSString *strCuisineName;
@property (strong, nonatomic) NSString *strCuisineType;
@property (strong, nonatomic) NSString *strIngredients;
@property (strong, nonatomic) NSString *strCaloriesPerServing;
@property (strong, nonatomic) NSString *strPricePerDate;
@property (strong, nonatomic) NSString *strAddOnCost;
@property (strong, nonatomic) NSString *strServings;
@property (strong, nonatomic) NSString *strSides;
@property (strong, nonatomic) NSString *strSpiceLevel;
@property (strong, nonatomic) NSString *strHealthMeter;
@property (strong, nonatomic) NSString *strTime;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strMealCount;
@property (strong, nonatomic) NSString *strCountry;
@property (strong, nonatomic) NSString *strState;
@property (strong, nonatomic) NSString *strCity;
@property (strong, nonatomic) NSString *strZipCode;
@property (strong, nonatomic) NSString *strStreetName;
@property (strong, nonatomic) NSString *strMinerals;
@property (strong, nonatomic) NSString *strQuantityToConsume;
@property (strong, nonatomic) NSString *strMealTime;
@property (strong, nonatomic) NSString *strNutrients;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *time;



// Parse Data For Chef My Regular Meals


@property (strong, nonatomic) NSString *strMyRegularMealDishName;
@property (strong, nonatomic) NSString *strMyRegularMealDishType;
@property (strong, nonatomic) NSString *strMyRegularMealDishImageUrl;
@property (strong, nonatomic) NSArray  *ingredientsArray;
@property (strong, nonatomic) NSString *strMyRegularMealIngredientes;
@property (strong, nonatomic) NSString *strMyRegularMealCaloriesPerServing;
@property (strong, nonatomic) NSString *strMyRegularMealCostPerPlate;
@property (strong, nonatomic) NSString *strMyRegularMealAdditionalCost;
@property (strong, nonatomic) NSString *strMyRegularMealServings;
@property (strong, nonatomic) NSString *strMyRegularMealSlides;
@property (strong, nonatomic) NSString *strMyRegularMealSpiceLevel;
@property (strong, nonatomic) NSString *strMyRegularMealHealthMeter;
@property (strong, nonatomic) NSString *strMyRegularMealPreparationTime;
@property (strong, nonatomic) NSString *strMyRegularMealDate;
@property (strong, nonatomic) NSString *strMyRegularMealCountry;
@property (strong, nonatomic) NSString *strMyRegularMealState;
@property (strong, nonatomic) NSString *strMyRegularMealCity;
@property (strong, nonatomic) NSString *strMyRegularMealZip;
@property (strong, nonatomic) NSString *strMyRegularMealStreetName;

+(NSMutableArray *)getDataFromArray:(NSArray *)array;


// Parse Data For Requested Meals Chef Section

@property (strong, nonatomic) NSString *strRequestedMealOrderId;
@property (strong, nonatomic) NSString *strRequestedMealImageUrl;
@property (strong, nonatomic) NSString *strRequestedMealDinerName;
@property (strong, nonatomic) NSString *strRequestedMealDinerId;
@property (strong, nonatomic) NSString *strRequestedMealZipForDiner;
@property (strong, nonatomic) NSString *strRequestedMealCuisineName;
@property (strong, nonatomic) NSString *strRequestedMealCuisineType;
@property (strong, nonatomic) NSString *strRequestedMealPickUpDate;
@property (strong, nonatomic) NSString *strRequestedMealPickUpTime;
@property (strong, nonatomic) NSString *strRequestedMealStatus;
@property (strong, nonatomic) NSString *strRequestedMealId;

+(NSMutableArray*)getDataFromRequestedMealArray:(NSArray *)array;


// Parse Data For Requested Meal Details Chef Section

@property (strong, nonatomic) NSArray  *requestDetailMealImages;
@property (strong, nonatomic) NSString *strRequestDetailMealCategroy;
@property (strong, nonatomic) NSString *strRequestDetailMealId;
@property (strong, nonatomic) NSString *strRequestDetailDinerId;
@property (strong, nonatomic) NSString *strRequestDetailDinerName;
@property (strong, nonatomic) NSString *strRequestDetailDinerZip;
@property (strong, nonatomic) NSString *strRequestDetailCuisineName;
@property (strong, nonatomic) NSString *strRequestDetailCuisineType;
@property (strong, nonatomic) NSString *strRequestDetailAllergies;
@property (strong, nonatomic) NSString *strRequestDetailStoreAround;
@property (strong, nonatomic) NSString *strRequestDetailSpecialRequirements;
@property (strong, nonatomic) NSString *strRequestDetailSteps;
@property (strong, nonatomic) NSString *strRequestDetailIngredientesReq;
@property (strong, nonatomic) NSString *strRequestDetailSpiceLevel;
@property (strong, nonatomic) NSString *strRequestDetailPriceOffering;
@property (strong, nonatomic) NSString *strRequestDetailPickUpDate;
@property (strong, nonatomic) NSString *strRequestDetailPickUpTime;


+(CookPrepareAMealModal*)getDataFromDictionary:(NSDictionary *)dict;












































































































































































































































































































































@end
