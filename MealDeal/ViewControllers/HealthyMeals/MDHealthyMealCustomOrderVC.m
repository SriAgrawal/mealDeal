//
//  MDHealthyMealCustomOrderVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 02/12/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDHealthyMealCustomOrderVC.h"


static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";
static NSString *cellIdentifier2 = @"MDTitleRatingCell";
static NSString *cellIdentifier3 = @"MDTitlePriceDateCell";

@interface MDHealthyMealCustomOrderVC ()

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UIView         *payByFooterView;

@property (weak, nonatomic) IBOutlet UIButton       *payButton;

@property (weak, nonatomic) IBOutlet UILabel        *navigationTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView    *mealImageView;

@property (strong, nonatomic) NSArray               *titleArray;

@property (weak, nonatomic) IBOutlet UIButton       *codButton;
@property (weak, nonatomic) IBOutlet UIButton       *paypalButton;

@end

@implementation MDHealthyMealCustomOrderVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tableView.tableFooterView = self.payByFooterView;
    
    if (self.isHealthyMealDealAccepted) {
        self.payButton.hidden = NO;
        self.navigationTitleLabel.text = @"Meal Deal";
        [self.payByFooterView setFrame:CGRectMake(0, 0, windowWidth, 170)];
        self.payByFooterView.hidden = NO;
        
    } else {
        self.payButton.hidden = YES;
        self.navigationTitleLabel.text = @"Custom Order";
        [self.payByFooterView setFrame:CGRectMake(0, 0, windowWidth, 0)];
        self.payByFooterView.hidden = YES;
    }
}

#pragma mark - Private Methods

-(void)initialSetUp {
    
    //Tittle Array initialization
    
    self.titleArray = @[@"Minerals", @"Quantity to be Consumed", @"Meal Time", @"Nutrients", @"Meal Type", @"Cuisine Name", @"Cuisine Type", @"Ingredients", @"Calories (approx)", @"Cost (per plate)", @"Cost on Addons", @"Servings", @"Cuisine Includes",@"Time Required"];
    
    [self.mealImageView sd_setImageWithURL:self.cusomMealObj.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    
    if (!self.isHealthyMealDealAccepted)
        
        self.cusomMealObj.editpriceString = [@"$" stringByAppendingString:self.cusomMealObj.priceString];
    
}

#pragma mark - UIButtonSelector methods


- (void)onRatingView:(HCSStarRatingView *)ratingValue {
    [self.view endEditing:YES];
    
    self.cusomMealObj.spiceLevelString = [NSString stringWithFormat:@"%f", ratingValue.value];
    LogInfo(@"%f",ratingValue.value);
    
    [self.tableView reloadData];
}

- (void)onDate:(IndexPathButton *)button {
    
    [self.view endEditing:YES];
    
    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
        
        self.cusomMealObj.dateString = [AppUtility getStringFromDate:date];
        self.cusomMealObj.date = date;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UIButton Actions

- (IBAction)backbuttonaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dealButtonAction:(id)sender {
    
    [self callApiForCustomMeal];
    
}

- (IBAction)payButtonAction:(id)sender {
    
    [AlertController title:@"Work in progress..."];
    
}

- (IBAction)cashOnDeliveryButtonAction:(id)sender {
    self.codButton.selected = YES;
    self.paypalButton.selected = NO;
}

- (IBAction)paypalButtonAction:(id)sender {
    self.codButton.selected = NO;
    self.paypalButton.selected = YES;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    LogInfo(@"%@",textField.text);
    
    if (textField.tag == 100)
        self.cusomMealObj.editpriceString = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == 100)
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 18; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <14) {
        
        MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        
        cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
                
            case 0: [cell.detailLabel setText:self.cusomMealObj.mineralstString]; break;
                
            case 1: [cell.detailLabel setText: self.cusomMealObj.consumedQuantityString]; break;
                
            case 2: [cell.detailLabel setText:self.cusomMealObj.mealTimeString]; break;
                
            case 3: [cell.detailLabel setText:self.cusomMealObj.nutrientsString]; break;
                
            case 4: [cell.detailLabel setText:self.cusomMealObj.mealTypeString]; break;
                
            case 5: [cell.detailLabel setText:self.cusomMealObj.cuisineNameString]; break;
                
            case 6: [cell.detailLabel setText:self.cusomMealObj.cuisineTypeString]; break;
                
            case 7: [cell.detailLabel setText:self.cusomMealObj.ingredientsString]; break;
                
            case 8: [cell.detailLabel setText:self.cusomMealObj.caloriesString]; break;
                
            case 9: (self.cusomMealObj.priceString)? [cell.detailLabel setText:[@"$" stringByAppendingString:self.cusomMealObj.priceString]] : [cell.detailLabel setText:@""]; break;
                
            case 10: (self.cusomMealObj.additionalCostString)? [cell.detailLabel setText:[@"$" stringByAppendingString:self.cusomMealObj.additionalCostString]] : [cell.detailLabel setText:@""]; break;
                
            case 11: [cell.detailLabel setText:self.cusomMealObj.servingsString]; break;
                
            case 12: [cell.detailLabel setText:self.cusomMealObj.cuisineIncludes]; break;
                
            case 13: [cell.detailLabel setText:self.cusomMealObj.timeRequiredString]; break;
                
        }
        
        return cell;
        
    } else if(indexPath.row == 14 || indexPath.row == 15){
        
        MDTitleRatingCell *cell = (MDTitleRatingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.ratingView.userInteractionEnabled = NO;
        
        if (indexPath.row == 14) {
            if (self.isHealthyMealDealAccepted)
                cell.ratingView.userInteractionEnabled = NO;
            else
                cell.ratingView.userInteractionEnabled = YES;
            
            cell.titleLabel.text = @"Spice Level";
            cell.ratingView.emptyStarImage = [UIImage imageNamed:@"spice_icon_gry.png"];
            cell.ratingView.filledStarImage = [UIImage imageNamed:@"spice_icon.png"];
            cell.ratingView.value = [self.cusomMealObj.spiceLevelString floatValue];
            
             [cell.ratingView addTarget:self action:@selector(onRatingView:) forControlEvents:UIControlEventValueChanged];
            
        } else {
            cell.titleLabel.text = @"Health Meter";
            cell.ratingView.emptyStarImage = [UIImage imageNamed:@"heart_icon_gray"];
            cell.ratingView.filledStarImage = [UIImage imageNamed:@"heart_icon"];
            cell.ratingView.value = [self.cusomMealObj.healthMeterString floatValue];
        }
        
        return cell;
    } else {
        
        MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 16:
                cell.priceTextField.tag = 100;
                
                if (self.isHealthyMealDealAccepted)
                    cell.priceTextField.userInteractionEnabled = NO;
                else
                    cell.priceTextField.userInteractionEnabled = YES;
                
                cell.dateButton.hidden = YES;
                cell.dropImageView.hidden = YES;
                
                cell.titleLabel.text = @"My Price";
                [cell.priceTextField setInputAccessoryView:[self getToolBarForNumberPad]];
                cell.priceTextField.text = ([self.cusomMealObj.editpriceString isEqualToString:@""]) ? @"" : self.cusomMealObj.editpriceString;
                return cell;
                break;
                
            default:
                
                if (self.isHealthyMealDealAccepted) {
                    cell.dateButton.userInteractionEnabled = NO;
                    cell.dropImageView.hidden = YES;
                    
                }
                else {
                    cell.dateButton.userInteractionEnabled = YES;
                    cell.dropImageView.hidden = NO;
                    
                }
                
                cell.priceTextField.hidden = YES;
                cell.titleLabel.text = @"Date";
                [cell.dateButton setTitle: ([self.cusomMealObj.dateString isEqualToString:@""]) ? @"10 jan" : self.cusomMealObj.dateString forState:UIControlStateNormal];
                [cell.dateButton addTarget:self action:@selector(onDate:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                break;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Web Api Section


- (void)callApiForCustomMeal {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    
    [dict setValue:self.cusomMealObj.mineralstString forKey:pMinerals];
    [dict setValue:self.cusomMealObj.consumedQuantityString forKey:pConsumedQuantity];
    [dict setValue:self.cusomMealObj.mealTimeString forKey:pMealTime];
    [dict setValue:self.cusomMealObj.nutrientsString forKey:pNutrients];
    
    [dict setValue:self.cusomMealObj.chefIdString forKey:pChefId];
    [dict setValue:self.cusomMealObj.chefNameString forKey:pChefName];
    [dict setValue:self.cusomMealObj.mealTypeString forKey:pMealType];
    
    [dict setValue:[self.cusomMealObj.ingredientsString componentsSeparatedByString:@","] forKey:pIngredients];
    [dict setValue:self.cusomMealObj.caloriesString forKey:pCalories];
    [dict setValue:self.cusomMealObj.priceString forKey:pPrice];
    [dict setValue:self.cusomMealObj.additionalCostString forKey:pAddons];
    [dict setValue:self.cusomMealObj.servingsString forKey:pServings];
    [dict setValue:self.cusomMealObj.timeRequiredString forKey:pTimeRequired];
    [dict setValue:self.cusomMealObj.healthMeterString forKey:pHealthMeter];
    
    NSMutableDictionary *cuisineDict = [NSMutableDictionary dictionary];
    [cuisineDict setValue:self.cusomMealObj.cuisineNameString forKey:pName];
    [cuisineDict setValue:self.cusomMealObj.cuisineTypeString forKey:pType];
    [dict setValue:cuisineDict forKey:pCuisineDetail];
    
    NSMutableArray *imageArray = [NSMutableArray new];
    
    for (NSURL *imageUrl in self.cusomMealObj.imageUrlArray)
        [imageArray addObject:[NSString stringWithFormat:@"%@", imageUrl]];
    
    [dict setValue:imageArray forKey:pImages];
    
    [dict setValue:self.cusomMealObj.spiceLevelString forKey:pSpiceLevel];
    [dict setValue:self.cusomMealObj.editpriceString forKey:@"offeredPrice"];
    [dict setValue:[self.cusomMealObj.date UTCDateFormat] forKey:pDate];
    
    [ServiceHelper request:dict apiName:kAPIDetailCustomMeal method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [AlertController title:@"" message:@"Your meal request sent successfully." andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
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
