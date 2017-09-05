//
//  GooglePlusLogin.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^GooglePlusDidSignCompletionBlock) (NSDictionary *infoDict, NSError *error);
typedef void (^GooglePlusDidDisconnectWithUserCompletionBlock) (NSDictionary *infoDict, NSError *error);

@interface GooglePlusLogin : NSObject

+ (GooglePlusLogin *)sharedManager;

- (void)getGooglePlusInfoWithCompletionHandler:(UIViewController *)controller didSignIn:(GooglePlusDidSignCompletionBlock)didSignCompletionBlock didDisconnect:(GooglePlusDidDisconnectWithUserCompletionBlock)didDisconnectWithUserCompletionBlock;
- (void)logOut;


@end
