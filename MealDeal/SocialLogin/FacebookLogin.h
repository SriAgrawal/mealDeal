//
//  FacebookLogin.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

//@@@@@@@@@@@@@@@ Version v3 @@@@@@@@@@@@@@@@@@@@@@@

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FacebookLogin : NSObject

// facebook login
+ (void)getFacebookInfoWithCompletionHandler:(UIViewController *)controller completionBlock:(void (^)(NSDictionary *infoDict, NSError *error))handler;
+ (void)logOut;

@end
