//
//  MDOrderStatusBaseVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 25/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDOrderStatusBaseVC.h"
#import "Macro.h"

@interface MDOrderStatusBaseVC () <CarbonTabSwipeNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView             *containerView;

@property (weak, nonatomic) IBOutlet UIButton           *navigationBarButton;
@property (strong, nonatomic) NSArray                   *arrayItems;
@property (strong, nonatomic) CarbonTabSwipeNavigation  *pageVC;

@end

@implementation MDOrderStatusBaseVC

#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}
#pragma mark -

#pragma mark - Private Methods

- (void)initialSetup {
    if (self.isBack) {
        [self.navigationBarButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [self.navigationBarButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateHighlighted];
    }
    [self setUpPages];
}

- (void)setUpPages {
    
    self.arrayItems = @[@"Order Status", @"Order History", @"Future Orders"];
    
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
    [self.pageVC.carbonSegmentedControl setWidth:windowWidth/self.arrayItems.count forSegmentAtIndex:2];
//    [self.pageVC.carbonTabSwipeScrollView setBackgroundColor:[UIColor clearColor]];
//    [self.pageVC.carbonSegmentedControl setBackgroundColor:[UIColor clearColor]];
//    [self.pageVC.toolbar setBackgroundColor:[UIColor clearColor]];
    [self.pageVC.toolbar setBarStyle:UIBarStyleBlack];
    
    //RGBCOLOR(0, 0, 0, 0.3)
    // Custimize segmented control
    [self.pageVC setNormalColor:[UIColor darkGrayColor]
                           font:[AppUtility rockwellBoldFontWithSize:16]];
    [self.pageVC setSelectedColor:color
                             font:[AppUtility rockwellBoldFontWithSize:16]];
    
}

#pragma mark -

#pragma mark - UIButton Actions

- (IBAction)onMenu:(id)sender {
    
    (self.isBack) ? [self.navigationController popViewControllerAnimated:YES] : [self.sidePanelController showLeftPanelAnimated:YES];
    
}

#pragma mark -

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            MDOrderStatusVC *orderStatusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderStatusVC"];
            return orderStatusVC;
        }
        case 1:{
            MDOrderHistoryVC *orderHistoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderHistoryVC"];
            return orderHistoryVC;
        }
            
        default:{
            MDFutureOrderVC *mealDealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDFutureOrderVC"];
            return mealDealVC;
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
    LogInfo(@"Did move at index: %ld", (unsigned long)index);
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
      didFinishTransitionToIndex:(NSUInteger)index {
    LogInfo(@"Did move at index: %ld", (unsigned long)index);
    
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark -

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
