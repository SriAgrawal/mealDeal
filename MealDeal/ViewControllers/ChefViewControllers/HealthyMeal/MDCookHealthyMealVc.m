//
//  MDHealthyMealVc.m
//  MealDealApp
//
//  Created by Mohit on 05/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDCookHealthyMealVc.h"

@interface MDCookHealthyMealVc ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *healthyMealArray;
    MealDetails *healthyMealDetails;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation MDCookHealthyMealVc

- (void)viewDidLoad {
    [super viewDidLoad];
    healthyMealArray = [[NSMutableArray alloc] init];
    healthyMealDetails = [[MealDetails alloc] init];
    [self callApiForHealthyMealList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [healthyMealArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDCookHealthyMealCell";
    healthyMealDetails = [healthyMealArray objectAtIndex:indexPath.row];
    MDCookHealthyMealCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           cellIdentifier];
    if (cell == nil) {
        cell = [[MDCookHealthyMealCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.lblHealthyMeal.text = healthyMealDetails.strHealthyMealName;
    [cell.healthyMealImg sd_setImageWithURL:[NSURL URLWithString:healthyMealDetails.strHealthyMealImgeUrl]];
    cell.btnAddToTodayMenu.tag = indexPath.row;
    [cell.btnAddToTodayMenu addTarget:self action:@selector(btnAddToTodayMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.healthyMealImg.layer.cornerRadius  = 7.0;
        cell.healthyMealImg.clipsToBounds = YES;
    });
    
    return cell;
}

#pragma mark Button Action Methods

- (IBAction)menuBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

-(void)btnAddToTodayMenuAction:(UIButton*)sender{
    [self callApiForAddToTodaysMenu:sender.tag];
}

#pragma mark Web API Methods

- (void)callApiForHealthyMealList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    [dict setValue:@"true" forKey:@"healthyMeal"];


    [ServiceHelper request:dict apiName:kAPIChefHealthyMealList method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {

        if (!error) {

            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];

            if ([statusCode integerValue] == 200) {
                healthyMealArray = [MealDetails getDataFromArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
                
            } else {
                [AlertController title:responseMessage];
            }

        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForAddToTodaysMenu:(NSInteger)rowIndex {
    healthyMealDetails = [healthyMealArray objectAtIndex:rowIndex];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:healthyMealDetails.strHealthyMealId forKey:@"mealId"];
    
    [ServiceHelper request:dict apiName:kAPIChefHealthyMealList method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                [AlertController title:@"Added successfully."];

            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}



@end
