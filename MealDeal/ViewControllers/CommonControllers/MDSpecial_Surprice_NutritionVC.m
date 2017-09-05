//
//  MDSpecial_Surprise_NutritionVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDSpecial_Surprise_NutritionVC.h"
#import "DRCellSlideGestureRecognizer.h"

static NSString *cellIdentifier = @"MDHomeCell";

@interface MDSpecial_Surprise_NutritionVC (){
    NSString *strCookName;
}

@property (weak, nonatomic) IBOutlet UIButton               *backButton;
@property (weak, nonatomic) IBOutlet UILabel                *navigationBarTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UIView                 *cookDetailView;

@property (weak, nonatomic) IBOutlet HCSStarRatingView      *ratingView;
@property (weak, nonatomic) IBOutlet UILabel                *cookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel                *cartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel                *reviewCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *tableViewTopConstraint;

@property (nonatomic) NSInteger                             count;

@property (strong, nonatomic) NSArray                       *dataSourceArray;

@property (strong, nonatomic) MealDetails                   *mealObj;

@end

@implementation MDSpecial_Surprise_NutritionVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self resetData];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;
    self.count = 0;
//    self.cartCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    self.cartCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE cartCount]];

    self.navigationBarTitleLabel.text = @"Today's Special";

    if (self.contentType == Todays_Special) {
        self.navigationBarTitleLabel.text = @"Today's Special";
        self.tableViewTopConstraint.constant = 55;
        [self callApiForTodaysSpecial];

    }
    else if (self.contentType == Surprise_Me) {
        self.navigationBarTitleLabel.text = @"Surprise Me";
        self.cookDetailView.hidden = YES;
        self.tableViewTopConstraint.constant = 0;
        [self callApiForSurpriseMe];
    }
    else {
        self.navigationBarTitleLabel.text = @"Personal Nutrition";
        self.cookDetailView.hidden = YES;
        self.tableViewTopConstraint.constant = 0;
        [self callApiForPersonalNutrition];
    }
}

- (void)resetData
{
    [self.tableView reloadData];
}

#pragma mark - UIButton Actions

- (IBAction)locationButtonAction:(id)sender {
    
//    for (UIViewController *controller in [APPDELEGATE navigationController].viewControllers) {
//        if ([controller isKindOfClass:[MDLocationVC class]]) {
//            
//            [(MDLocationVC *)controller setIsAfterLogin:YES];
//            [(MDLocationVC *)controller setIsBack:YES];
//            [[APPDELEGATE navigationController] popToViewController:controller animated:NO];
//        }
//    }
    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    locationVC.isAfterLogin = YES;
    locationVC.isBack = YES;

    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)reviewButtonAction:(id)sender {
    MDCookReviewsVC *cookReviewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCookReviewsVC"];
    cookReviewsVC.strChefId = _mealObj.chefIdString;
    cookReviewsVC.strCookName = strCookName;
    [self.navigationController pushViewController:cookReviewsVC animated:YES];

}

- (IBAction)cartButtonAction:(id)sender {
    
    MDCartVC *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCartVC"];
    cartVC.isBack = YES;
 
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDHomeCell *cell = (MDHomeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
    //UIColor *greenColor = [UIColor colorWithRed:91/255.0 green:220/255.0 blue:88/255.0 alpha:1];
    
    DRCellSlideAction *squareAction = [DRCellSlideAction actionForFraction:0.25];
    //squareAction.activeBackgroundColor = greenColor;
    
    squareAction.behavior  = DRCellSlideActionPullBehavior;
    squareAction.elasticity = 500;
    squareAction.didTriggerBlock = [self pullTriggerBlock];
    
    [slideGestureRecognizer addActions:@[squareAction]];
    
    [cell addGestureRecognizer:slideGestureRecognizer];
    
    self.mealObj = self.dataSourceArray[indexPath.row];

    cell.dishNameLabel.text = self.mealObj.cuisineNameString;
     self.mealObj = self.dataSourceArray[indexPath.row];
    
    NSString *myString = @"$";
    NSString *price = [myString stringByAppendingString:self.mealObj.priceString];
    cell.dishPriceLabel.text = price;
    
    [cell.dishImageView sd_setImageWithURL:self.mealObj.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    
    [cell.dishImageView setContentMode:UIViewContentModeScaleToFill];
  
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mealObj = self.dataSourceArray[indexPath.row];
    
    MDDetalisVC *detalisVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDDetalisVC"];
    detalisVC.mealIdString = self.mealObj.mealIdString;
    detalisVC.chefIdString = self.mealObj.chefIdString;
    [self.navigationController pushViewController: detalisVC animated:YES];
    
}

//
//- (DRCellSlideActionBlock)pushTriggerBlock {
//    return ^(UITableView *tableView, NSIndexPath *indexPath) {
//        
//        
//        [tableView beginUpdates];
////        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        [tableView endUpdates];
//    };
//}

- (DRCellSlideActionBlock)pullTriggerBlock {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        
        [AlertController title:@"Confirm" message:@"Do you want to add meal to your cart?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                
                self.mealObj = self.dataSourceArray[indexPath.row];

                [self callApiForAddMealToCart: self.mealObj];
            }
        }];
    };
}

#pragma mark - Web Api Section

- (void)callApiForTodaysSpecial {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //[dict setValue:@"58426807afcc6a62915af07b" forKey:pChefId];
    [dict setValue:[APPDELEGATE chefId] forKey:pChefId];

    [ServiceHelper request:dict apiName:kAPITodaysSpecial method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
    
    if (!error) {
        
        NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
        
        if ([statusCode integerValue] == 200) {
            
            NSMutableDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
            self.reviewCountLabel.text = [NSString stringWithFormat:@"(%@ Reviews)", [dataDict objectForKeyNotNull:pTotalreview expectedObj:@""]];
            self.ratingView.value =  [[dataDict objectForKeyNotNull:pTotalRating expectedObj:@""] floatValue];
           
            NSDictionary *chefDetaildict = [dataDict objectForKeyNotNull:pChefdetails expectedObj:[NSDictionary dictionary]];
            self.cookNameLabel.text = [chefDetaildict objectForKeyNotNull:pFullName expectedObj:@""];
            strCookName = [chefDetaildict objectForKeyNotNull:pFullName expectedObj:@""];
            
            self.dataSourceArray = [MealDetails meals:[resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]]];
            
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

- (void)callApiForSurpriseMe {
    
    [ServiceHelper request:[NSMutableDictionary dictionary] apiName:kAPISurpriseMe method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                self.dataSourceArray = [MealDetails meals:[resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]]];
                
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

- (void)callApiForPersonalNutrition {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setValue:[APPDELEGATE longitude] forKey:pLongitude];
    [dict setValue:[APPDELEGATE latitude] forKey:platitude];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:pDinerId];

    [ServiceHelper request:dict apiName:kAPIPersonalNutrition method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                self.dataSourceArray = [MealDetails meals:[resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]]];
                
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

- (void)callApiForAddMealToCart : (MealDetails *)mealObj{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:mealObj.chefIdString forKey:pChefId];
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
               
                [APPDELEGATE setCartCount:[APPDELEGATE cartCount] + 1];
                self.cartCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE cartCount]];

               // self.count = self.count + 1;
//                self.cartCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
                
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
