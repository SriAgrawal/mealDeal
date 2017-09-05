//
//  CanceledOrderDetail.m
//  MealDeal
//
//  Created by Ashish Shukla on 01/12/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "CanceledOrderDetail.h"
#import "Macro.h"
@implementation CanceledOrderDetail

+(NSMutableArray*)getCancelOrderdetailFromdict:(NSDictionary*)dict{
    NSMutableArray *arrayNotification = [NSMutableArray array];
    if ([[dict objectForKeyNotNull:@"notificationsData"] isKindOfClass:[NSArray class]]) {
        NSArray *arrayNotificationDetail = [dict objectForKeyNotNull:@"notificationsData"];
        for (id itemDict in arrayNotificationDetail) {
            if ([itemDict isKindOfClass:[NSDictionary class]]) {
                CanceledOrderDetail *cancelOrderObj = [[CanceledOrderDetail alloc]init];
                cancelOrderObj.mealID = [itemDict objectForKey:@"mealId"];
                cancelOrderObj.orderID = [itemDict objectForKey:@"orderId"];
                [arrayNotification addObject:cancelOrderObj];
            }
        }
    }
    return arrayNotification;
}




@end
