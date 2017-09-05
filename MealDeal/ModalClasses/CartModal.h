//
//  CartModal.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModal : NSObject

@property (nonatomic, strong) NSString      *chefIdString;

@property (nonatomic, strong) NSString      *chefNameString;

@property (nonatomic, strong) NSString      *chefAddressString;

@property (nonatomic, assign) NSInteger     totalPrice;

@property (nonatomic, strong) NSArray       *cartMealArray;

@property (strong, nonatomic) NSString      *timeString;

@property (nonatomic, strong) NSDate        *time;

+ (NSArray *)cartDetail:(NSArray *)dataArray;

@end
