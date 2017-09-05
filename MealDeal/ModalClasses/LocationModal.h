//
//  LocationModal.h
//  MealDeal
//
//  Created by Krati Agarwal on 21/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModal : NSObject

@property (strong, nonatomic) NSString      *chefId;

@property (strong, nonatomic) NSString      *mealType;

@property (strong, nonatomic) NSString      *mealName;

@property (strong, nonatomic) NSString      *dinerName;

@property (strong, nonatomic) NSString      *isVerified;

@property (strong, nonatomic) NSString      *chefLatitude;

@property (strong, nonatomic) NSString      *chefLongitude;

+ (NSArray *)location:(NSArray *)dataArray;

@end
