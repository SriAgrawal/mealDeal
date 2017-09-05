//
//  CanceledOrderDetail.h
//  MealDeal
//
//  Created by Ashish Shukla on 01/12/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CanceledOrderDetail : NSObject

@property (strong, nonatomic) NSString    *orderID;
@property (strong, nonatomic) NSString    *mealID;
@property (strong, nonatomic) NSString    *reason;

+(NSMutableArray*)getCancelOrderdetailFromdict:(NSDictionary*)dict;

@end
