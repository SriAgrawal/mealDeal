//
//  CartModal.m
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "CartModal.h"
#import "Macro.h"

@implementation CartModal

+ (NSArray *)cartDetail:(NSArray *)dataArray {
    
    NSMutableArray *list = [NSMutableArray new];
    
    for (NSDictionary *dataDict in dataArray) {
        
        CartModal *cartObj = [[CartModal alloc] init];

        NSDictionary *chefDetailDict = [dataDict objectForKeyNotNull:pChefId expectedObj:[NSDictionary dictionary]];
        cartObj.chefIdString =  [chefDetailDict objectForKeyNotNull:p_id expectedObj:@""];
        cartObj.chefNameString =  [chefDetailDict objectForKeyNotNull:pFullName expectedObj:@""];
       // cartObj.chefAddressString =  [chefDetailDict objectForKeyNotNull:pChefId expectedObj:@""];

        cartObj.cartMealArray = [MealDetails particularChefMeal:[dataDict objectForKeyNotNull:pMeal expectedObj:[NSArray array]]];
        
        cartObj.totalPrice = 0;
        cartObj.timeString = @"";

        for (MealDetails *obj in cartObj.cartMealArray) {
            cartObj.totalPrice =  cartObj.totalPrice + [obj.priceString integerValue];
        }
        
        [list addObject:cartObj];

        cartObj.timeString = @"";
        
    }
    
    return [list mutableCopy];
}

@end
