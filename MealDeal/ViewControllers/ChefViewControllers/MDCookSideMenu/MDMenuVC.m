//
//  MDMenuVC.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDMenuVC.h"

@interface MDMenuVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrMenuItems,*arrMenuItemImages;
}

@end

@implementation MDMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrMenuItems = [[NSMutableArray alloc] initWithObjects:@"Requests",@"Regular Mealers",@"Today's Order",@"Prepare a Meal",@"Notifications",@"Settings and Preferences",@"Orders",@"My Regular Meals",@"Healthy Meals",@"Logout", nil];
    arrMenuItemImages = [[NSMutableArray alloc] initWithObjects:@"special_icon",@"eater_icon",@"eater_icon",@"prepare_icon",@"notification_icon",@"setting_icon",@"order_icon",@"order_icon",@"meal_icon",@"logout_icon", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [arrMenuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDMenuCell";
    
    MDMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           cellIdentifier];
    if (cell == nil) {
        cell = [[MDMenuCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblMenu.text = [arrMenuItems objectAtIndex:indexPath.row];
    cell.imgMenu.image = [UIImage imageNamed:[arrMenuItemImages objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *centralNav = (UINavigationController *)self.sidePanelController.centerPanel;
    
    if (indexPath.row == 0 ){
        
        MDRequestsVC *requestsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRequestsVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:requestsVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
    } else if (indexPath.row == 1) {
        
        MDRegularMealersVC *regularMealers = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRegularMealersVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:regularMealers animated:NO];
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 2) {
        
        ViewController *todayOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:todayOrder animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 3) {
        MDPrepareAMealVC *prepareAMeal = [self.storyboard instantiateViewControllerWithIdentifier:@"MDPrepareAMealVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:prepareAMeal animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 4) {
        MDNotificationsVC *notifications = [self.storyboard instantiateViewControllerWithIdentifier:@"MDNotificationsVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:notifications animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 5) {
        MDSettingsVC *settings = [self.storyboard instantiateViewControllerWithIdentifier:@"MDSettingsVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:settings animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
    } else if (indexPath.row == 6) {
        MDCookOrderHistoryVC *orderHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCookOrderHistoryVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:orderHistory animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 7) {
        MDMyRegularMealVC *myRegularMealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDMyRegularMealVC"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:myRegularMealVC animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 8) {
        MDCookHealthyMealVc *healthyMeal = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCookHealthyMealVc"];
        [centralNav popToRootViewControllerAnimated:NO];
        [centralNav pushViewController:healthyMeal animated:NO];
        
        [self.sidePanelController toggleLeftPanel:nil];
        
    } else if (indexPath.row == 9) {
        
        [AlertController title:@"Logout" message:@"Are you sure you want to Logout?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                
                [self callApiForLogout];
            }
        }];
    }
}

- (void)callApiForLogout {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
