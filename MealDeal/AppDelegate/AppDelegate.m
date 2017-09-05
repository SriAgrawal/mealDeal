//
//  AppDelegate.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()  <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self checkReachability];
    
    /*--------------- Facebook ---------------------*/
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  
    
    /*--------------- Goohle signIn ---------------------*/

    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    [self currentLocationIdentifier];
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MDLocationVC *locationVC = [storyBoard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:locationVC];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    
    //Register for remote notification
    
    [self setUpNotification];
    [self methodToRegisterDeviceForPushNotification:application];
    
    [self paypalMethod];

    return YES;
}

- (void)currentLocationIdentifier
{
    //---- For getting current gps location
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
{
    self.currentLocation = [locations objectAtIndex:0];
    [APPDELEGATE setLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude]];
    [APPDELEGATE setLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCurrentLocation" object:nil];
}

#pragma mark - Public Methods

- (void)setUpNotification {
    
    //-- Set Notification
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound);
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

// Register device for push notification

-(void)methodToRegisterDeviceForPushNotification:(UIApplication *)application {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [application registerForRemoteNotifications];
    application.applicationIconBadgeNumber = 0;
    
}

- (void)paypalMethod {
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"ARrP_dPH0qPJu1WVDo-GLniX-kScOdFtDySDxKux0NfJkPiMqO2xGr7IZEXC4q4HAsNIH20sCP5c1y__"}];
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    
    //    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @""}];
    //    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    
}

- (JASidePanelController *)getSlidePanel {
    
    self.slidePanelController = [[JASidePanelController alloc] init];
    self.slidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.slidePanelController.leftPanel = [mainStoryboard instantiateViewControllerWithIdentifier:@"MDSlideMenuVC"];
    //self.slidePanelController.leftFixedWidth = WIN_WIDTH-70;
    
    MDSpecial_Surprise_NutritionVC *special_Surprise_NutritionVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MDSpecial_Surprise_NutritionVC"];
    special_Surprise_NutritionVC.contentType = Todays_Special;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:special_Surprise_NutritionVC];
    [navigationController setNavigationBarHidden:YES];
    self.slidePanelController.centerPanel = navigationController;
    
    return self.slidePanelController;
}

- (JASidePanelController *)getSlidePanelChef {
    
    self.slidePanelController = [[JASidePanelController alloc] init];
    self.slidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    self.slidePanelController.leftPanel = [mainStoryboard instantiateViewControllerWithIdentifier:@"MDMenuVC"];
    //self.slidePanelController.leftFixedWidth = WIN_WIDTH-70;
    
    MDRequestsVC *requestsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MDRequestsVC"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:requestsVC];
    [navigationController setNavigationBarHidden:YES];
    self.slidePanelController.centerPanel = navigationController;
    
    return self.slidePanelController;
}

- (void)logOut {
    
    [NSUSERDEFAULT removeObjectForKey:p_id];
    [NSUSERDEFAULT removeObjectForKey:pEmail];
    [NSUSERDEFAULT removeObjectForKey:pPassword];
    [NSUSERDEFAULT removeObjectForKey:pRole];
    
    [FacebookLogin logOut];
    [[GIDSignIn sharedInstance] signOut];

    //[[GooglePlusLogin sharedManager] logOut];
}

- (void)progressHud:(BOOL)status {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
    });
    
}

- (void)checkReachability {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
            
        });
    };
    
    [reach startNotifier];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    BOOL isFacebook = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    if (isFacebook) {
        return YES;
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL isFacebook = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    if (isFacebook) {
        return YES;
    } else{
        
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([LISDKCallbackHandler shouldHandleUrl:url])
//    {
//        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
//    return YES;
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NSUSERDEFAULT setValue:token forKey:pDevice_token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [NSUSERDEFAULT setValue:kDummyDeviceToken forKey:pDevice_token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =  [UIApplication sharedApplication].applicationIconBadgeNumber +1;
    
    [AlertController title:[NSString stringWithFormat:@"%@",userInfo]];

    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        
        if ([userInfo[@"type"] isEqualToString:@"Custom Meal"]) {
            [self handleNotificationForCustomMealRequest:userInfo andIsActiveOrInactive:NO andController:[APPDELEGATE navigationController] isFromDidReceiveRemote:YES];
        }
//        else if ([userInfo[@"type"] isEqualToString:@"Request"]) {
//            [self handleNotificationForApproved:userInfo andIsActiveOrInactive:NO andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@"Chat"]) {
//            [self handleNotificationForAccept:userInfo andIsActiveOrInactive:NO andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@"New Quoted Price"]) {
//            [self handleNotificationForComplete:userInfo andIsActiveOrInactive:NO andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@""]) {
//            [self handleNotificationForCancel:userInfo andIsActiveOrInactive:NO andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }
        
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        if ([userInfo[@"type"] isEqualToString:@"Custom Meal"]) {
            [self handleNotificationForCustomMealRequest:userInfo andIsActiveOrInactive:YES andController:[APPDELEGATE navigationController] isFromDidReceiveRemote:YES];
        }
//        else if ([userInfo[@"type"] isEqualToString:@"approved"]) {
//            [self handleNotificationForApproved:notificationDict andIsActiveOrInactive:YES andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@"accept"]) {
//            [self handleNotificationForAccept:notificationDict andIsActiveOrInactive:YES andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@"complete"]) {
//            [self handleNotificationForComplete:notificationDict andIsActiveOrInactive:YES andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }else if ([userInfo[@"type"] isEqualToString:@"cancel"]) {
//            [self handleNotificationForCancel:notificationDict andIsActiveOrInactive:YES andController:[APPDELEGATE navController] isFromDidReceiveRemote:YES];
//        }
    }
}

#pragma mark - UNUserNotificationCenterDelegate method

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {

    [AlertController title:[NSString stringWithFormat:@"%@", response.notification.request.content.userInfo]];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    NSDictionary *notificationDict;
    notificationDict = response.notification.request.content.userInfo;
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        if ([notificationDict[@"type"] isEqualToString:@"Custom Meal"]) {
            [self handleNotificationForCustomMealRequest:notificationDict andIsActiveOrInactive:NO andController:[APPDELEGATE navigationController] isFromDidReceiveRemote:NO];
        }
    } else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        if ([notificationDict[@"type"] isEqualToString:@"Custom Meal"]) {
            [self handleNotificationForCustomMealRequest:notificationDict andIsActiveOrInactive:YES andController:[APPDELEGATE navigationController] isFromDidReceiveRemote:NO];
        }
    }
    
}

/////////////////////////////// Notification Management /////////////////////


//************************ Custom Meal ************************//

-(void)handleNotificationForCustomMealRequest:(NSDictionary *)dict andIsActiveOrInactive:(BOOL)isActive andController:(UINavigationController *)controller isFromDidReceiveRemote: (BOOL)isFromDidReceive {
    
    if (isActive) {
            if ([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[MDRequestVC class]]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName: @"refreshProviderDetails" object:nil userInfo:dict];
                
            } else {
                if(isFromDidReceive) {
                    //Asking user before Navigate
                    NSDictionary *notificationDict = dict[@"aps"];

                    [AlertController title:@"" message:[NSString stringWithFormat:@"%@", notificationDict[@"alert"]] andButtonsWithTitle:@[@"View", @"Cancel"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                        if (index) {

                            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            MDRequestVC *requestVC = [storyBoard instantiateViewControllerWithIdentifier:@"MDRequestVC"];
                            requestVC.isNotification = YES;
                            requestVC.notificationDict = dict;
                            [self.navigationController pushViewController: requestVC animated:YES];
                        }
                    }];
                } else {
                    // You are in different controller and now you push to request detail controller
                   
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MDRequestVC *requestVC = [storyBoard instantiateViewControllerWithIdentifier:@"MDRequestVC"];
                    requestVC.isNotification = YES;
                    requestVC.notificationDict = dict;
                    [self.navigationController pushViewController: requestVC animated:YES];

                }
            }
    }
    else {
        if ([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[MDRequestVC class]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName: @"refreshProviderDetails" object:nil userInfo:dict];
            }
            else {
                
                // You are in different controller and now you push to request detail controller
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MDRequestVC *requestVC = [storyBoard instantiateViewControllerWithIdentifier:@"MDRequestVC"];
                requestVC.isNotification = YES;
                requestVC.notificationDict = dict;
                [self.navigationController pushViewController: requestVC animated:YES];
            }
    }

}


@end
