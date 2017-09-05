//
//  MDSlideMenuVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDSlideMenuVC.h"
#import "Macro.h"
#import "MDHealthyMealVC.h"

static NSString *cellIdentifier = @"MDSlideMenuCell";

static NSString *pTitle = @"title";
static NSString *pIcon = @"icon";

@interface MDSlideMenuVC ()

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (strong, nonatomic) NSArray                       *dataSourceArray;

@end

@implementation MDSlideMenuVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private Methods

- (void)initialSetup {
    
    self.dataSourceArray = @[
                             @{pTitle : @"Today's Special", pIcon: @"special_icon"},
                             @{pTitle : @"Surprise Me", pIcon: @"surpise_me"},
                             @{pTitle : @"Healthy Meals", pIcon: @"meal_icon"},
                                @{pTitle : @"Personal Nutrition", pIcon: @"personal_icon"},
                             @{pTitle : @"Orders", pIcon: @"order_icon"},
                             @{pTitle : @"Request Meal", pIcon: @"request_meal_icon"},
                             @{pTitle : @"Cart", pIcon: @"cart_icon_mennu"},
                             @{pTitle : @"Notifications", pIcon: @"notification_icon"},
                             @{pTitle : @"Settings and Preferences", pIcon: @"setting_icon"},
                             @{pTitle : @"Contact Meal Deal", pIcon: @"contact_icon"},
                             @{pTitle : @"Log Out", pIcon: @"logout_icon"}
                             ];

}

#pragma mark -

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray count];// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDSlideMenuCell *cell = (MDSlideMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dataDict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    [cell.iconImageView setImage:[UIImage imageNamed:[dataDict valueForKey:pIcon]]];
    cell.titleLabel.text = [dataDict valueForKey:pTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *centralNav = (UINavigationController *)self.sidePanelController.centerPanel;
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
        
        MDSpecial_Surprise_NutritionVC *special_Surprice_NutritionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDSpecial_Surprise_NutritionVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:special_Surprice_NutritionVC animated:NO];
        
        switch (indexPath.row) {
            case 0:
                special_Surprice_NutritionVC.contentType = Todays_Special;
                break;
            case 1:
                special_Surprice_NutritionVC.contentType = Surprise_Me;
                break;
            default:
                special_Surprice_NutritionVC.contentType = Personal_Nutrition;
                break;
        }
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 2) {
        MDHealthyMealVC *healthyMealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDHealthyMealVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:healthyMealVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 4) {
        MDOrderStatusBaseVC *orderStatusBaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderStatusBaseVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:orderStatusBaseVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 5) {
        MDCustomMealVC *customMealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCustomMealVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:customMealVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
    } else if (indexPath.row == 6) {
        MDCartVC *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCartVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:cartVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 7) {
        MDNotificationsVC *notificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDNotificationsVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:notificationsVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
    
    } else if (indexPath.row == 8) {
        MDSettingsBaseVC *settingsBaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDSettingsBaseVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:settingsBaseVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 9) {
        
        MDNeedHelpVC *needHelpVC = [[MDNeedHelpVC  alloc]initWithNibName:@"MDNeedHelpVC" bundle:nil];
        needHelpVC.isPopUp = NO;
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:needHelpVC animated:NO];
        [self.sidePanelController toggleLeftPanel:nil];

        
       // needHelpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
       // [self presentViewController:needHelpVC animated:YES completion:nil];

    } else if (indexPath.row == 10) {
        
        [AlertController title:@"Logout" message:@"Are you sure you want to Logout?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                
                [self callApiForLogout];
            }
        }];
    }
}

- (void)callApiForLogout {
    
    [APPDELEGATE logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
