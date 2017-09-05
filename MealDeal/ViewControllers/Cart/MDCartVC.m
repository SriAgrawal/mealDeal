//
//  MDCartVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDCartVC.h"
#import "Macro.h"

@interface MDCartVC ()

@property (weak, nonatomic) IBOutlet UIButton                  *navigationBarButton;
@property (weak, nonatomic) IBOutlet UIButton                  *sendRequestButton;

@property (weak, nonatomic) IBOutlet UITableView               *tableView;
@property (weak, nonatomic) IBOutlet UIView                    *sendRequestButtonView;

@property (strong, nonatomic) NSArray                          *dataSourceArray;

@property (strong, nonatomic) NSMutableArray                   *dummyDataArray;

@end

@implementation MDCartVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];

    [self callApiForCartDetail];

}

#pragma mark - Private Methods

-(void)initialSetup {
    self.tableView.alwaysBounceVertical = NO;

    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.sendRequestButtonView.hidden = YES;
    if (self.isBack) {
        [self.navigationBarButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [self.navigationBarButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateHighlighted];
    }
    
    //dummy Array initialization
    self.dummyDataArray = [[NSMutableArray alloc] init];

    [self.dummyDataArray addObjectsFromArray:@[@"Dish Name 1", @"Dish Name 2", @"Dish Name 3"]];

   // self.dummyDataArray = @[@"Dish Name 1", @"Dish Name 2", @"Dish Name 3"];
    
}

- (BOOL)isAllFieldsVerified {
    
    BOOL isAllValid = YES;
    
    for (CartModal *cartObj in self.dataSourceArray) {

        if ([cartObj.timeString isEqualToString:@""]) {

            isAllValid = NO;
            break;
        
    }
  }
    return isAllValid;

}

#pragma mark - UIButton Selector Methods

- (void)plusButtonSelector:(IndexPathButton *)sender {
    
    LogInfo(@"%ld",(long)sender.indexPath.row);
    
    CartModal *cartObj = self.dataSourceArray[sender.indexPath.section];
    MealDetails *mealObj = cartObj.cartMealArray[sender.indexPath.row - 1];
    
    mealObj.quantity = mealObj.quantity + 1;
    [self.tableView reloadData];
    
    //[AlertController title:@"Work in progress..."];
}

- (void)minusButtonSelector:(IndexPathButton *)sender {
    LogInfo(@"%ld",(long)sender.indexPath.row);
    
    CartModal *cartObj = self.dataSourceArray[sender.indexPath.section];
    MealDetails *mealObj = cartObj.cartMealArray[sender.indexPath.row - 1];
    
    if (mealObj.quantity > 1) {
        mealObj.quantity = mealObj.quantity - 1;
        [self.tableView reloadData];
    }
        
    //[AlertController title:@"Work in progress..."];
}

- (void)deleteButtonSelector:(IndexPathButton *)sender {
    LogInfo(@"%ld",(long)sender.indexPath.row);
    
    [AlertController title:@"Are you sure you want to delete this dish from cart?" message:@"" andButtonsWithTitle:@[@"CANCEL", @"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if (index) {
            
            CartModal *cartObj = self.dataSourceArray[sender.indexPath.section];
            MealDetails *mealObj = cartObj.cartMealArray[sender.indexPath.row - 1];

            [self callApiForRemoveMeal : mealObj.mealIdString];
            //[self.dummyDataArray removeObjectAtIndex:sender.indexPath.row - 1];

        }
    }];
}

- (void)pickUpTimeButtonSelector:(IndexPathButton *)sender {
    LogInfo(@"%ld",(long)sender.indexPath.row);
   
    CartModal *cartObj = self.dataSourceArray[sender.indexPath.section];

    [self.view endEditing:YES];
    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"time" completionBlock:^(NSDate *date) {
      
        cartObj.timeString = [AppUtility getStringFromFullTime:date];
        cartObj.time = date;
        
        [sender setTitle:[AppUtility getStringFromFullTime:date] forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UIButton Action

- (IBAction)sendRequestButtonAction:(id)sender {
    
    if ([self isAllFieldsVerified])
        [self callApiForSendRequest];
    else
        [AlertController title: @"Please select pick up time."];


//    MDOrderStatusBaseVC *orderStatusBaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderStatusBaseVC"];
//    orderStatusBaseVC.isBack = YES;
//    [self.navigationController pushViewController: orderStatusBaseVC animated:YES];

}

- (IBAction)backButtonAction:(id)sender {
    
    (self.isBack) ? [self.navigationController popViewControllerAnimated:YES] : [self.sidePanelController showLeftPanelAnimated:YES];
    
}

#pragma mark - UITableView Datasource/Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    CartModal *cartObj = self.dataSourceArray[section];
        return [cartObj.cartMealArray count] + 2;
    
    //return self.dummyDataArray.count + 2;
   }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartModal *cartObj = self.dataSourceArray[indexPath.section];
    
    if (indexPath.row == 0)
        return 40.0f;
    else if (indexPath.row == [cartObj.cartMealArray count] + 1)
        return UITableViewAutomaticDimension;
    else
        return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartModal *cartObj = self.dataSourceArray[indexPath.section];

    NSString *cellID;
    if (indexPath.row == 0)
         cellID = @"MDCookNameID";
    else if (indexPath.row == [cartObj.cartMealArray count] + 1)
        cellID = @"MDCartpickUpAddressId";
    else
        cellID = @"MDCartViewCell";

    MDCartViewCell *cell = (MDCartViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    if(indexPath.row == 0)
        cell.cookNameLabel.text = cartObj.chefNameString;
 
    if (indexPath.row > 0 && indexPath.row < cartObj.cartMealArray.count + 1) {
       
        MealDetails *mealObj = cartObj.cartMealArray[indexPath.row - 1];
        cell.dishNameLabel.text = mealObj.cuisineNameString;
        cell.dishPriceLabel.text = [@"$" stringByAppendingString:mealObj.priceString];
        cell.dishCountLabel.text = [NSString stringWithFormat:@"%ld",(long)mealObj.quantity];
        
        [cell.dishImageView sd_setImageWithURL:mealObj.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
        [cell.dishImageView setContentMode:UIViewContentModeScaleToFill];
        
        [cell.plusButton setIndexPath:indexPath];
        [cell.minusButton setIndexPath:indexPath];
        [cell.deleteButton setIndexPath:indexPath];
    }
    [cell.pickUpTimeButton setIndexPath:indexPath];

    cell.totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: $%ld", (long)cartObj.totalPrice];
    [cell.pickUpTimeButton setTitle: cartObj.timeString forState:UIControlStateNormal];

    //Increment
    [cell.plusButton addTarget:self action:@selector(plusButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    //Decrement
    [cell.minusButton addTarget:self action:@selector(minusButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    //Delete
    [cell.deleteButton addTarget:self action:@selector(deleteButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    // pick up time
    [cell.pickUpTimeButton addTarget:self action:@selector(pickUpTimeButtonSelector:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - Web Api Section

- (void)callApiForCartDetail {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];

    [ServiceHelper request:dict apiName:kAPICartDetail method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        self.dataSourceArray = [[NSArray alloc]init];

        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                self.dataSourceArray = [CartModal cartDetail:[resultDict objectForKeyNotNull:pData expectedObj:[NSArray array]]];
                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
        
        if(self.dataSourceArray.count)
            self.sendRequestButtonView.hidden = NO;
        else
            self.sendRequestButtonView.hidden = YES;

        [self.tableView reloadData];

    }];
}

- (void)callApiForRemoveMeal:(NSString * )mealId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    [dict setValue:mealId forKey:pMealId];

    [ServiceHelper request:dict apiName:kAPIRemoveMealsFromCart method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];

        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
               
                [AlertController title:responseMessage message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callApiForCartDetail];
                }];
                
            } else {
                [AlertController title:responseMessage];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForSendRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    
    NSMutableArray * chefArray = [NSMutableArray new];

    for (CartModal *cartObj in self.dataSourceArray) {
        
        NSMutableDictionary *chefDict = [NSMutableDictionary dictionary];

        [chefDict setValue:cartObj.chefIdString forKey:pChefId];
        [chefDict setValue:[NSString stringWithFormat:@"%ld",(long)cartObj.totalPrice] forKey:@"totalPrice"];
        [chefDict setValue:[cartObj.time UTCDateFormat] forKey:@"PickUpTime"];
       
        NSMutableArray * mealArray = [NSMutableArray new];

        for (MealDetails *obj in cartObj.cartMealArray) {
           
            NSMutableDictionary *mealDict = [NSMutableDictionary dictionary];

            [mealDict setValue:obj.mealIdString forKey:pMealId];
            [mealDict setValue:[NSString stringWithFormat:@"%ld",(long)obj.quantity] forKey:pQuantity];
            [mealDict setValue:@"false" forKey:pAddons];
            [mealDict setValue:@"" forKey:pAddonsDetails];
            
            [mealArray addObject:mealDict];

        }
        
        [chefDict setValue:mealArray forKey:pMeal];
        [chefArray addObject:chefDict];
    }
    
    [dict setValue:chefArray forKey:@"order"];
    
    [ServiceHelper request:dict apiName:kAPISendRequest method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];

            if ([statusCode integerValue] == 200) {
                
                [AlertController title:@"Your meal request sent successfully." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    MDOrderStatusBaseVC *orderStatusBaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderStatusBaseVC"];
                    orderStatusBaseVC.isBack = YES;
                    [self.navigationController pushViewController: orderStatusBaseVC animated:YES];
                }];
                
              } else {
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
