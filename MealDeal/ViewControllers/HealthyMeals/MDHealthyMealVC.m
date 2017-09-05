//
//  MDHealthyMealVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 24/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDHealthyMealVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDHealthyMealCell";

@interface MDHealthyMealVC ()

@property (strong, nonatomic) NSArray               *dataSourceArray;

@property (weak, nonatomic) IBOutlet UITableView    *tableView;

@end

@implementation MDHealthyMealVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;
    
    [self callApiForHealthyMeal];
}

#pragma mark - UIButton Actions

- (IBAction)locationButtonAction:(id)sender {
    
    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    locationVC.isAfterLogin = YES;
    locationVC.isBack = YES;

    [self.navigationController pushViewController:locationVC animated:YES];
    
}

- (IBAction)menuButtonAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count; // Return the number of rows in the section.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 105.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDHealthyMealCell *cell = (MDHealthyMealCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    MealDetails *healthyMealObj = self.dataSourceArray[indexPath.row];
    cell.mealNameLabel.text = healthyMealObj.cuisineNameString;
    [cell.mealImageView sd_setImageWithURL:healthyMealObj.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MealDetails *meal = self.dataSourceArray[indexPath.row];
    MDHealthyMealDetailVC *healthyMealDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDHealthyMealDetailVC"];
    
    healthyMealDetailVC.mealDetail = meal;
    healthyMealDetailVC.mealName = meal.cuisineNameString;
    
    [self.navigationController pushViewController: healthyMealDetailVC animated:YES];
}


#pragma mark - Web Api Section

- (void)callApiForHealthyMeal {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[APPDELEGATE chefId] forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPIHealthyMeal method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                self.dataSourceArray = [MealDetails healthyMeal:[resultDict objectForKeyNotNull:pData expectedObj:[NSArray array]]];
                
                [self.tableView reloadData];
                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
