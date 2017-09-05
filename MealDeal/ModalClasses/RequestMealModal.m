//
//  RequestMealModal.m
//  MealDeal
//
//  Created by Krati Agarwal on 12/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "RequestMealModal.h"
#import "Macro.h"

@implementation RequestMealModal

//Parse Order Status Data For Diner
+ (NSMutableArray *)getOrderStatusDataFromArray:(NSArray *)arr{
  
    NSMutableArray *orderStatusListArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in arr){
       
        RequestMealModal *orderStatusInfo = [[RequestMealModal alloc]init];
       
        orderStatusInfo.date = [AppUtility getDateFromString:[dict valueForKey:@"PickUpTime"]];
        orderStatusInfo.strOrderStatusPickUptime = [orderStatusInfo.date getTimeString];

        orderStatusInfo.pickupDate = [AppUtility getDateFromString:[dict objectForKey:@"PickUpDate"]];
        orderStatusInfo.strOrderStatusPickUpDate = [orderStatusInfo.pickupDate getDateString];

        orderStatusInfo.createdDate = [AppUtility getDateFromString:[dict objectForKey:@"createdAt"]];
        orderStatusInfo.strOrderStatusOrderTime = [orderStatusInfo.createdDate getTimeDateString];
        
        NSArray *mealArray = [dict objectForKey:@"meal"];
        
        for (NSDictionary *mealDict in mealArray) {
            
            RequestMealModal *orderStatusInfo2 = [[RequestMealModal alloc]init];

            orderStatusInfo2.date = orderStatusInfo.date;
            orderStatusInfo2.strOrderStatusPickUptime = orderStatusInfo.strOrderStatusPickUptime;
            
            orderStatusInfo2.pickupDate = orderStatusInfo.pickupDate;
            orderStatusInfo2.strOrderStatusPickUpDate = orderStatusInfo.strOrderStatusPickUpDate;

            orderStatusInfo2.createdDate = orderStatusInfo.createdDate;
            orderStatusInfo2.strOrderStatusOrderTime = orderStatusInfo.strOrderStatusOrderTime;
            
            orderStatusInfo2.strOrderStatusMealStatus = [mealDict valueForKey:@"status"];
            
            NSDictionary *mealId = [mealDict objectForKey:@"mealId"];
            orderStatusInfo2.strCustomMealStatus = [mealId valueForKey:@"customMeal"];
            
            if ([orderStatusInfo2.strOrderStatusMealStatus isEqualToString:@"Pending"] && [[NSString stringWithFormat:@"%@", orderStatusInfo2.strCustomMealStatus] isEqualToString:@"1"]) {
                
                orderStatusInfo2.strOrderStatusChefId = @"";
                orderStatusInfo2.strOrderStatusChefName = @"";
                
            } else {
                
                NSDictionary *chefDetails = [mealId objectForKey:@"chefId"];
                orderStatusInfo2.strOrderStatusChefId = [chefDetails objectForKey:p_id];
                orderStatusInfo2.strOrderStatusChefName = [chefDetails objectForKey:@"fullName"];

            }
            
            NSArray *imageArray = [mealId objectForKeyNotNull:pImages expectedObj:[NSArray array]];
            NSString *urlString = [imageArray firstObject];
            orderStatusInfo2.photoURL = [NSURL URLWithString:urlString];
           
            NSDictionary *cuisineDetails = [mealId objectForKey:@"cuisineDetail"];
            orderStatusInfo2.strOrderStatusDishName = [cuisineDetails objectForKey:@"name"];
            [orderStatusListArray addObject:orderStatusInfo2];
            
        }
    }
    return orderStatusListArray;
}

+ (NSArray *)getLastTwoDaysOrders:(NSArray *)dataArray {
    
    NSMutableArray *list = [NSMutableArray new];
    
    for (NSDictionary *dataDict in dataArray) {
        
        RequestMealModal *orderObj = [[RequestMealModal alloc] init];
        
        NSArray *chefDetailArray = [dataDict objectForKeyNotNull:pChefId expectedObj:[NSArray array]];
        orderObj.chefIdString = [chefDetailArray firstObject];
        
        orderObj.pickupDate = [AppUtility getDateFromString:[dataDict objectForKeyNotNull:@"PickUpDate" expectedObj:@""]];
        orderObj.dateString = [orderObj.pickupDate getDateString];

        orderObj.orderMealArray = [MealDetails particularChefMeal:[dataDict objectForKeyNotNull:pMeal expectedObj:[NSArray array]]];
        
        [list addObject:orderObj];
    }
    
    return [list mutableCopy];
}

@end
