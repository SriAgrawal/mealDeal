//
//  MDSettingsBaseVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDSettingsBaseVC.h"

#import "Macro.h"

@interface MDSettingsBaseVC () <CarbonTabSwipeNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView             *containerView;

@property (strong, nonatomic) NSArray                   *arrayItems;
@property (strong, nonatomic) CarbonTabSwipeNavigation  *pageVC;

@end

@implementation MDSettingsBaseVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Private Methods

- (void)initialSetup {
    [self setUpPages];
}

- (void)setUpPages {
    
    self.arrayItems = @[@"Account Details", @"Preference"];
    
    // add more items if you wants to make scrollable segments is self.arrayItems. Also you can add ([UIImage imageNamed:@"hourglass"]) abject i arry. If it is image object than segment tab will be image & if it is only string than it is Sgment tab will show text.
    
    self.pageVC = [[CarbonTabSwipeNavigation alloc] initWithItems:self.arrayItems delegate:self];
    
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    
    UIColor *color = RGBCOLOR(80, 255, 41, 1);
    [self.pageVC setIndicatorColor:color];
    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:50];
    [self.pageVC setIndicatorHeight:5];
    
    [self.pageVC.carbonSegmentedControl setWidth:windowWidth/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:windowWidth/self.arrayItems.count forSegmentAtIndex:1];
 
    //    [self.pageVC.carbonTabSwipeScrollView setBackgroundColor:[UIColor clearColor]];
    //    [self.pageVC.carbonSegmentedControl setBackgroundColor:[UIColor clearColor]];
    //    [self.pageVC.toolbar setBackgroundColor:[UIColor clearColor]];
    [self.pageVC.toolbar setBarStyle:UIBarStyleBlack];
    
    //RGBCOLOR(0, 0, 0, 0.3)
    // Custimize segmented control
    [self.pageVC setNormalColor:[UIColor grayColor]
                           font:[AppUtility rockwellBoldFontWithSize:16]];
    [self.pageVC setSelectedColor:color
                             font:[AppUtility rockwellBoldFontWithSize:16]];
    
}

#pragma mark - UIButton Actions

- (IBAction)locationButtonAction:(id)sender {
    
    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    locationVC.isAfterLogin = YES;
    locationVC.isBack = YES;

    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)onMenu:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    
    switch (index) {
        case 0: {
            MDAccountDetailsVC *accountDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDAccountDetailsVC"];
            return accountDetailsVC;
        }
        default:{
            MDPreferenceVC *preferenceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDPreferenceVC"];
            return preferenceVC;
        }
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    
    self.title = self.arrayItems[index];
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    LogInfo(@"Did move at index: %ld", index);
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
      didFinishTransitionToIndex:(NSUInteger)index {
    LogInfo(@"Did move at index: %ld", index);
    
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
