//
//  GooglePlusLogin.m
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "GooglePlusLogin.h"
#import "Macro.h"

static NSInteger imageDimension = 375;

@interface GooglePlusLogin () <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) GooglePlusDidSignCompletionBlock didSignCompletionBlock;
@property (nonatomic, strong) GooglePlusDidDisconnectWithUserCompletionBlock didDisconnectCompletionBlock;
@property (nonatomic, strong) UIViewController *parentController;

@end

@implementation GooglePlusLogin

+ (GooglePlusLogin *)sharedManager {
    
    static GooglePlusLogin *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[GooglePlusLogin alloc] init];
        
        //>>>>>>>>>>>>>>> Google Plus setup start <<<<<<<<<<<<<<<<<
        NSError* configureError;
        [[GGLContext sharedInstance] configureWithError: &configureError];
        NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
        
#warning SET kClientID if YOU ARE USING MANUAL SDK. If YOU ARE USING Google/SignIn USING POD THAN NO NEED TO SET kClientID
        
        //[GIDSignIn sharedInstance].clientID = kClientID;
        
        //>>>>>>>>>>>>>>> Google Plus setup end <<<<<<<<<<<<<<<<<<<<<<<
        
    });
    return _sharedManager;
}

#pragma mark - Facebook methods

// This method will handle ALL the session state changes in the app

- (void)getGooglePlusInfoWithCompletionHandler:(UIViewController *)controller didSignIn:(GooglePlusDidSignCompletionBlock)didSignCompletionBlock didDisconnect:(GooglePlusDidDisconnectWithUserCompletionBlock)didDisconnectWithUserCompletionBlock {
    
    self.didSignCompletionBlock = didSignCompletionBlock;
    self.didDisconnectCompletionBlock = didDisconnectWithUserCompletionBlock;
    self.parentController = controller;
    
    if (![APPDELEGATE isReachable]){
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        self.didSignCompletionBlock(nil, error);
        
        if (self.didDisconnectCompletionBlock) {
            self.didDisconnectCompletionBlock(nil, error);
        }
        
        return;
    }
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    [[GIDSignIn sharedInstance] signIn];
    [self progressHud:YES];
}

- (void)logOut {
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //update UI in main thread.
        [self progressHud:NO];
    });
    
    if (!error) {
        NSDictionary *infoDict = [self getInfoDictionaryFromUser:user];
        self.didSignCompletionBlock(infoDict, nil);

    } else {
        self.didSignCompletionBlock(nil, error);
        [self logOut];

    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    [self progressHud:NO];
    
    if (self.didDisconnectCompletionBlock) {
        if (!error) {
            NSDictionary *infoDict = [self getInfoDictionaryFromUser:user];
            self.didDisconnectCompletionBlock(infoDict, nil);
        } else {
            self.didDisconnectCompletionBlock(nil, error);
        }
    }
    
}

#pragma mark -

#pragma mark - GIDSignInUIDelegate
// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self.parentController presentViewController:viewController animated:YES completion:nil];
    [self progressHud:NO];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    [self progressHud:YES];
}
#pragma mark -

#pragma mark - Private Methods
- (void)progressHud:(BOOL)status {
    
    if (status) {
        [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
        [progressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [progressHUD setColor:RGBCOLOR(0, 0, 0, 0.7)];
        
        // remove this line if you are getting error in your code
        //progressHUD.MBProgressHUDModeIndeterminateColor = [UIColor whiteColor];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
    } else {
        [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    }
}

- (NSDictionary *)getInfoDictionaryFromUser:(GIDGoogleUser *)user {
    
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [infoDict setValue:userId forKey:@"userId"];
    [infoDict setValue:idToken forKey:@"idToken"];
    [infoDict setValue:user.profile.givenName forKey:@"firstName"];
    [infoDict setValue:user.profile.familyName forKey:@"lastName"];
    [infoDict setValue:user.profile.email forKey:@"email"];
    [infoDict setValue:user.profile.name forKey:@"fullName"];
    
    [infoDict setValue:user.profile.hasImage ? [[user.profile imageURLWithDimension:imageDimension] absoluteString]:@"" forKey:@"profileImageURL"];
    
    return [infoDict mutableCopy];
}

#pragma mark -

@end
