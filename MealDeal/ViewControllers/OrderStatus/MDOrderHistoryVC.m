//
//  MDOrderHistoryVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 25/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDOrderHistoryVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDOrderHistoryCell";

@interface MDOrderHistoryVC ()

@property (weak, nonatomic) IBOutlet UITableView        *tableView;

@property (weak, nonatomic) IBOutlet UILabel            *spendingLabel;
@property (weak, nonatomic) IBOutlet UILabel            *outstandingLabel;
@property (weak, nonatomic) IBOutlet UILabel            *currentDateLabel;

@property (strong, nonatomic) MealDetails               *mealObj;

@property (strong, nonatomic) NSArray                   *dataSourceArray;

@end

@implementation MDOrderHistoryVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
   
    self.tableView.alwaysBounceVertical = NO;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    self.currentDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
   [self callApiForOrderHistory];
}

#pragma mark - UIButton Selector Methods

- (void)needHelpSelector:(IndexPathButton *)button {
    
    MDNeedHelpVC *needHelpVC = [[MDNeedHelpVC  alloc]initWithNibName:@"MDNeedHelpVC" bundle:nil];
    needHelpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    needHelpVC.isPopUp = YES;
    [self presentViewController:needHelpVC animated:YES completion:nil];
    
}

- (void)addToCartButtonSelector:(IndexPathButton *)button {
    
    RequestMealModal *orderObj = self.dataSourceArray[button.indexPath.section];
    MealDetails *mealObj = orderObj.orderMealArray[button.indexPath.row];

    [self callApiForAddMealToCart:mealObj andChefId:orderObj.chefIdString];
    
}

#pragma mark - UITableView Datasource/Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 110;
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    RequestMealModal *orderObj = self.dataSourceArray[section];
    return [orderObj.orderMealArray count];
    
    //return 1; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDOrderHistoryCell *cell = (MDOrderHistoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RequestMealModal *orderObj = self.dataSourceArray[indexPath.section];

    MealDetails *mealObj = orderObj.orderMealArray[indexPath.row];
    cell.dishNameLabel.text = mealObj.cuisineNameString;
    cell.dishPriceLabel.text = [@"$" stringByAppendingString:mealObj.priceString];
    
    [cell.dishImageView sd_setImageWithURL:mealObj.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [cell.dishImageView setContentMode:UIViewContentModeScaleToFill];
    
    [cell.addToCartButtonAction setIndexPath:indexPath];
    
    [cell.needHelpButton addTarget:self action:@selector(needHelpSelector:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addToCartButtonAction addTarget:self action:@selector(addToCartButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Web Api Section

- (void)callApiForOrderHistory {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"dinerId"];
    
    [ServiceHelper request:dict apiName:kAPIDinerOrderHistory method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *orderHistoryDict = [resultDict objectForKeyNotNull:@"data" expectedObj:[NSDictionary dictionary]];
                
                self.outstandingLabel.text = [orderHistoryDict objectForKeyNotNull:pOutstanding expectedObj:@""];
                self.spendingLabel.text = [@"$" stringByAppendingString:[orderHistoryDict objectForKeyNotNull:pSpending expectedObj:@""]];

                self.dataSourceArray = [RequestMealModal getLastTwoDaysOrders:[orderHistoryDict objectForKeyNotNull:pLastTwoOrders expectedObj:[NSArray array]]];
                
                [self.tableView reloadData];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForAddMealToCart : (MealDetails *)mealObj andChefId: (NSString *)chefId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:chefId forKey:pChefId];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:pDinerId];
    
    NSMutableDictionary *mealDetail = [NSMutableDictionary dictionary];
    [mealDetail setValue:mealObj.mealIdString forKey:pMealId];
    [mealDetail setValue:@"1" forKey:pQuantity];
    [mealDetail setValue:@"false" forKey:pAddons];
    [mealDetail setValue:@"" forKey:pAddonsDetails];
    
    [dict setValue:mealDetail forKey:pMeal];
    
    [ServiceHelper request:dict apiName:kAPIAddToCart method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
               
                MDCartVC *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCartVC"];
                cartVC.isBack = YES;
                [self.navigationController pushViewController: cartVC animated:YES];
                
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
