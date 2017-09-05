//
//  AppDelegate.h
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//
#import <Google/SignIn.h>
#import <UIKit/UIKit.h>
#import "Macro.h"
#import <MapKit/MapKit.h>

@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate,CLLocationManagerDelegate> 


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController     *navigationController;
@property (strong, nonatomic) JASidePanelController      *slidePanelController;
@property (nonatomic, assign) BOOL                       isReachable,isFromCook;

@property (strong, nonatomic) NSString                   *latitude;
@property (strong, nonatomic) NSString                   *longitude;

@property (strong, nonatomic) NSString                   *chefId,*strLastMsgId;

@property (strong, nonatomic) CLLocation                 * currentLocation;
@property (strong, nonatomic) CLLocationManager          * locationManager;

@property (nonatomic) NSInteger                          cartCount;

- (void)logOut;
- (JASidePanelController *)getSlidePanel;
- (JASidePanelController *)getSlidePanelChef;

- (void)progressHud:(BOOL)statu;

@end

