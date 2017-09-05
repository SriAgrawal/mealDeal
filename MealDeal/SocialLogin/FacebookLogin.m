//
//  FacebookLogin.m
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "FacebookLogin.h"
#import "Macro.h"

//@@@@@@@@@@@@@@@ Version v3 @@@@@@@@@@@@@@@@@@@@@@@

@implementation FacebookLogin

#pragma mark - Facebook methods

// This method will handle ALL the session state changes in the app

+ (void)getFacebookInfoWithCompletionHandler:(UIViewController *)controller completionBlock:(void (^)(NSDictionary *infoDict, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        handler(nil,error);
        return ;
    }
    
    [self callFacebookLoginWithCompletionBlock:controller completionBlock:^(NSDictionary *infoDict, NSError *error) {
        handler(infoDict, error);
    }];
    
}

+ (void)callFacebookLoginWithCompletionBlock:(UIViewController *)controller completionBlock:(void (^)(NSDictionary *infoDict, NSError *error))handler {
    //  picture.type(large)
    NSMutableDictionary *requsetDict = [NSMutableDictionary dictionary];
    [requsetDict setValue:@"id,name,first_name,last_name,gender,email,birthday,picture.type(large)" forKey:@"fields"];
    //[requsetDict setValue:@"locale" forKey:@"en_US"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self progressHud:YES];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requsetDict]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             [self progressHud:NO];
             handler(result,error);
         }];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        
        [loginManager logInWithReadPermissions:[NSArray arrayWithObjects:@"email", @"public_profile", @"user_photos", nil] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                [errorDetails setValue:@"Processing Error. Please try again!" forKey:NSLocalizedDescriptionKey];
                
                NSError *errorCustom = [NSError errorWithDomain:@"Processing Error!" code:error.code userInfo:errorDetails];
                handler(nil,errorCustom);
                
                [self logOut];
            } else if (result.isCancelled) {
                
                NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                [errorDetails setValue:@"Request cancelled!" forKey:NSLocalizedDescriptionKey];
                NSError *errorCustom = [NSError errorWithDomain:@"Request cancelled!" code:2009 userInfo:errorDetails];
                handler(nil,errorCustom);
                
                [self logOut];
                
            } else {
                
                [self progressHud:YES];
                //Getting Basic data from facebook
                [FBSDKAccessToken setCurrentAccessToken:result.token];
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requsetDict]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         [self progressHud:NO];
                         handler(result,error);
                     }];
                }
            }
            
        }];
    }
}

+ (void)logOut {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}
#pragma mark -

#pragma mark - Private Methods
+ (void)progressHud:(BOOL)status {
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[APPDELEGATE window]];
    if (status) {
        if (hud == nil) {
            hud = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
        }
        [hud setCornerRadius:8.0];
        [hud.bezelView setColor:RGBCOLOR(0, 0, 0, 0.8)];
        [hud setMargin:12];
        [hud setActivityIndicatorColor:[UIColor whiteColor]];
        
    } else {
        [hud hideAnimated:true afterDelay:0.1];
    }
}
#pragma mark -

@end
