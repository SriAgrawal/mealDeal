//
//  ErrorModal.h
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorModal : NSObject

@property (strong, nonatomic) NSString *userNameErrorString;
@property (strong, nonatomic) NSString *fullNameErrorString;
@property (strong, nonatomic) NSString *emailErrorString;
@property (strong, nonatomic) NSString *phoneErrorString;
@property (strong, nonatomic) NSString *passwordErrorString;
@property (strong, nonatomic) NSString *confirmPasswordErrorString;
@property (strong, nonatomic) NSString *countryErrorString;
@property (strong, nonatomic) NSString *stateErrorString;
@property (strong, nonatomic) NSString *cityErrorString;
@property (strong, nonatomic) NSString *roleErrorString;
@property (strong, nonatomic) NSString *zipCodeErrorString;
@property (strong, nonatomic) NSString *termConditionErrorString;


+ (ErrorModal *)getDefaultInfo;

@end
