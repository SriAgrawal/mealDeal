//
//  MDHealthyMealDetailVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 24/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDHealthyMealDetailVC.h"

static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";
static NSString *cellIdentifier2 = @"MDTitleRatingCell";


@interface MDHealthyMealDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UILabel        *navigationTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView    *mealImageView;

@property (strong, nonatomic) NSArray               *titleArray;
@property (strong, nonatomic) NSArray               *dummyDetailArray;

@property (nonatomic) BOOL                          isCustomMealTapped;

@end

@implementation MDHealthyMealDetailVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;
    self.navigationTitleLabel.text = self.mealName;
    
    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self.mealImageView sd_setImageWithURL:self.mealDetail.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [self.mealImageView setContentMode:UIViewContentModeScaleToFill];
    
    //Tittle Array initialization
    self.titleArray = @[@"Minerals", @"Quantity to be Consumed", @"Meal Time", @"Nutrients", @"Meal Type", @"Cuisine Name", @"Cuisine Type", @"Ingredients", @"Calories (approx)", @"Cost (per plate)", @"Cost on Addons", @"Servings", @"Cuisine Includes",@"Time Required"];
 
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)locationButtonAction:(id)sender {
    
    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    locationVC.isAfterLogin = YES;
    locationVC.isBack = YES;

    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)addMealButtonAction:(id)sender {
    
    [self callApiForAddMealToCart];
    
}

- (IBAction)customMealButtonAction:(id)sender {
    
    MDHealthyMealCustomOrderVC *healthyMealCustomOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDHealthyMealCustomOrderVC"];
    
    healthyMealCustomOrderVC.cusomMealObj = self.mealDetail;
    
    [self.navigationController pushViewController:healthyMealCustomOrderVC animated:YES];

}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 16; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       if (indexPath.row <14) {
           
           MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
           
           cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
           
           switch (indexPath.row) {
                   
               case 0: [cell.detailLabel setText:self.mealDetail.mineralstString]; break;
                   
               case 1: [cell.detailLabel setText: self.mealDetail.consumedQuantityString]; break;
                   
               case 2: [cell.detailLabel setText:self.mealDetail.mealTimeString]; break;
                   
               case 3: [cell.detailLabel setText:self.mealDetail.nutrientsString]; break;
                   
               case 4: [cell.detailLabel setText:self.mealDetail.mealTypeString]; break;
                   
               case 5: [cell.detailLabel setText:self.mealDetail.cuisineNameString]; break;
                   
               case 6: [cell.detailLabel setText:self.mealDetail.cuisineTypeString]; break;
                   
               case 7: [cell.detailLabel setText:self.mealDetail.ingredientsString]; break;
                   
               case 8: [cell.detailLabel setText:self.mealDetail.caloriesString]; break;
                   
               case 9: [cell.detailLabel setText:[@"$" stringByAppendingString:self.mealDetail.priceString]]; break;
                   
               case 10: [cell.detailLabel setText:[@"$" stringByAppendingString:self.mealDetail.additionalCostString]]; break;
               
               case 11: [cell.detailLabel setText:self.mealDetail.servingsString]; break;

               case 12: [cell.detailLabel setText:self.mealDetail.cuisineIncludes]; break;

               case 13: [cell.detailLabel setText:self.mealDetail.timeRequiredString]; break;
                   
           }
           
           
           return cell;
       } else {
           
           MDTitleRatingCell *cell = (MDTitleRatingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
           cell.ratingView.userInteractionEnabled = NO;
           
           if (indexPath.row == 14) {
               
               cell.titleLabel.text = @"Spice Level";
               cell.ratingView.emptyStarImage = [UIImage imageNamed:@"spice_icon_gry.png"];
               cell.ratingView.filledStarImage = [UIImage imageNamed:@"spice_icon.png"];
               cell.ratingView.value = [self.mealDetail.spiceLevelString floatValue];
           } else {
               cell.titleLabel.text = @"Health Meter";
               cell.ratingView.emptyStarImage = [UIImage imageNamed:@"heart_icon_gray"];
               cell.ratingView.filledStarImage = [UIImage imageNamed:@"heart_icon"];
               cell.ratingView.value = [self.mealDetail.healthMeterString floatValue];

           }
           return cell;
       }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
}

#pragma mark - Web Api Section

- (void)callApiForAddMealToCart {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.mealDetail.chefIdString forKey:pChefId];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:pDinerId];
    
    NSMutableDictionary *mealDetail = [NSMutableDictionary dictionary];
    [mealDetail setValue:self.mealDetail.mealIdString forKey:pMealId];
    [mealDetail setValue:@"1" forKey:pQuantity];
    [mealDetail setValue:@"false" forKey:pAddons];
    [mealDetail setValue:@"" forKey:pAddonsDetails];
    
    [dict setValue:mealDetail forKey:pMeal];
    
    [ServiceHelper request:dict apiName:kAPIAddToCart method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [APPDELEGATE setCartCount:[APPDELEGATE cartCount] + 1];

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
