 //
//  MDPreferenceVCr.m
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDPreferenceVC.h"
#import "Macro.h"

@interface MDPreferenceVC (){
    NSString *strMealType,*strChefStatus,*strRange;
}
@property (weak, nonatomic) IBOutlet UIButton               *vegButton;
@property (weak, nonatomic) IBOutlet UIButton                   *nonvegButton;
@property (weak, nonatomic) IBOutlet UIButton                   *bothButton;
@property (weak, nonatomic) IBOutlet UIButton                   *chefButton;
@property (weak, nonatomic) IBOutlet UIButton                   *dinerButton;
@property (weak, nonatomic) IBOutlet UIButton                   *searchAreaButton;
@property (weak, nonatomic) IBOutlet UIButton                   *verifiedButton;
@property (weak, nonatomic) IBOutlet UIButton                   *nonVerifiedButton;
@property (weak, nonatomic) IBOutlet UIButton                   *anyButton;

@property (weak, nonatomic) IBOutlet TextField                  *cuisienPrefTextField;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField    *allergiesTextField;

@property (weak, nonatomic) IBOutlet HCSStarRatingView          *spiceRatingView;

@property (weak, nonatomic) IBOutlet UITableView                *tableView;

@property (strong, nonatomic) UserInfo                          *userPreferenceObj;

@property (nonatomic, strong) NSArray                           *allergiesArray;

@end

@implementation MDPreferenceVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self callApiForAllergiesData];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    
    self.tableView.alwaysBounceVertical = NO;
    self.userPreferenceObj = [UserInfo getDefaultInfo];
    
    if ([[NSUSERDEFAULT valueForKey:pRole] isEqual: @"Chef"])
        self.chefButton.selected = YES;
    else
        self.dinerButton.selected = YES;
    
    self.allergiesTextField.tag = 100;
    self.allergiesTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Allergies" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1.0]}];
    
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    self.allergiesTextField.autocompleteType = HTAutocompleteTypeColor;
    
    [self tapGestureMethod];
    [self callApiForShowPreference];
    
}

- (void)tapGestureMethod {
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.allergiesTextField resignFirstResponder];
}

- (void)showUserPreferences {
    
    if([self.userPreferenceObj.mealType isEqualToString:@"veg"]) {
        self.vegButton.selected = YES;
        self.nonvegButton.selected = NO;
        self.bothButton.selected = NO;
    }
    if ([self.userPreferenceObj.mealType isEqualToString:@"nonveg"]) {
        self.vegButton.selected = NO;
        self.nonvegButton.selected = YES;
        self.bothButton.selected = NO;
        
    }
    if ([self.userPreferenceObj.mealType isEqualToString:@""]) {
        self.vegButton.selected = NO;
        self.nonvegButton.selected = NO;
        self.bothButton.selected = YES;
    }
    
    if ([self.userPreferenceObj.chefType isEqualToString:@""]) {
        self.verifiedButton.selected = NO;
        self.nonVerifiedButton.selected = NO;
        self.anyButton.selected = YES;
        
    }
    if ([self.userPreferenceObj.chefType isEqualToString:@"false"]) {
        self.verifiedButton.selected = NO;
        self.nonVerifiedButton.selected = YES;
        self.anyButton.selected = NO;
        
    }
    if ([self.userPreferenceObj.chefType isEqualToString:@"true"]) {
        self.verifiedButton.selected = YES;
        self.nonVerifiedButton.selected = NO;
        self.anyButton.selected = NO;
        
    }
    self.cuisienPrefTextField.text = self.userPreferenceObj.cuisinePreferenceString;
    
    self.userPreferenceObj.allergiesString = @"";
    for (NSString * str in self.userPreferenceObj.allergiesArray) {
        
        NSString * tempString = [self.userPreferenceObj.allergiesString stringByAppendingString:str];
        self.userPreferenceObj.allergiesString = [tempString stringByAppendingString:@","];
    }
    
    self.userPreferenceObj.allergiesString = [self.userPreferenceObj.allergiesString stringByReplacingCharactersInRange:NSMakeRange(self.userPreferenceObj.allergiesString.length - 1,1) withString:@""];
    
    self.allergiesTextField.text = self.userPreferenceObj.allergiesString;
    
    LogInfo(@"%@", self.allergiesTextField.text);
    
    [self.searchAreaButton setTitle:self.userPreferenceObj.rangeString forState:UIControlStateNormal];
    self.spiceRatingView.value = [self.userPreferenceObj.spiceLevelString floatValue];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIButton Action

- (IBAction)saveButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self callApiForSavePreference];
}

- (IBAction)searchAreaButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"5 Miles", @"10 Miles", @"15 Miles"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        [self.searchAreaButton setTitle:selectedValues.firstObject forState:UIControlStateNormal];
        self.userPreferenceObj.rangeString = [selectedValues.firstObject stringByReplacingOccurrencesOfString:@" Miles" withString:@""];
        
    }];
}

- (IBAction)vegButtonAction:(id)sender {
    
    self.vegButton.selected = YES;
    self.nonvegButton.selected = NO;
    self.bothButton.selected = NO;
    self.userPreferenceObj.mealType = @"veg";
}

- (IBAction)nonvegButtonAction:(id)sender {
    
    self.vegButton.selected = NO;
    self.nonvegButton.selected = YES;
    self.bothButton.selected = NO;
    self.userPreferenceObj.mealType = @"nonveg";
}

- (IBAction)bothButtonAction:(id)sender {
    
    self.vegButton.selected = NO;
    self.nonvegButton.selected = NO;
    self.bothButton.selected = YES;
    self.userPreferenceObj.mealType = @"";
}

- (IBAction)verifiedButtonAction:(id)sender {
    self.verifiedButton.selected = YES;
    self.nonVerifiedButton.selected = NO;
    self.anyButton.selected = NO;
    self.userPreferenceObj.chefType = @"true";
}

- (IBAction)nonverifiedButtonAction:(id)sender {
    self.verifiedButton.selected = NO;
    self.nonVerifiedButton.selected = YES;
    self.anyButton.selected = NO;
    self.userPreferenceObj.chefType = @"false";
}

- (IBAction)anyButtonAction:(id)sender {
    self.verifiedButton.selected = NO;
    self.nonVerifiedButton.selected = NO;
    self.anyButton.selected = YES;
    self.userPreferenceObj.chefType = @"";
}

- (IBAction)chefButtonAction:(id)sender {
    
    if (!self.chefButton.selected) {
        
        [AlertController title:@"Confirm" message:@"Do you want to switch role?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                [self callApiForSwitchUserRole : @"chef"];
            }
        }];
    }
}

- (IBAction)dinerButtonAction:(id)sender {
    
    if (!self.dinerButton.selected) {
        [AlertController title:@"Confirm" message:@"Do you want to switch role?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                [self callApiForSwitchUserRole : @"diner"];
            }
        }];
    }
}

#pragma mark - UITextfield Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.allergiesTextField becomeFirstResponder];
    } else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (!(textField.tag == 100)) {
        
        TextField *field = (TextField *)textField;
        field.active = YES;
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (!(textField.tag == 100)) {
        
        TextField *field = (TextField *)textField;
        field.active = NO;
        
    }
}

#pragma mark - Web Api Section

- (void)callApiForShowPreference {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    
    [ServiceHelper request:dict apiName:kAPIShowDinerPreferences method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSMutableDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                
                self.userPreferenceObj.mealType = [dataDict objectForKeyNotNull:pMealType expectedObj:@""];
                self.userPreferenceObj.cuisinePreferenceString = [dataDict objectForKeyNotNull:pCuisinePreference expectedObj:@""];
                self.userPreferenceObj.spiceLevelString = [dataDict objectForKeyNotNull:pSpiceLevel expectedObj:@""];
                self.userPreferenceObj.chefType = [dataDict objectForKeyNotNull:pChefType expectedObj:@""];
                self.userPreferenceObj.allergiesArray = [dataDict objectForKeyNotNull:pAllergies expectedObj:@""];
                if ([dataDict objectForKeyNotNull:pRange expectedObj:@""]) {
                    self.userPreferenceObj.rangeString = [[dataDict objectForKeyNotNull:@"range" expectedObj:@""] stringByAppendingString:@" Miles"];
                }
                
                [self showUserPreferences];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForSavePreference {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    [dict setValue:self.userPreferenceObj.mealType forKey:pMealType];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[self.userPreferenceObj.rangeString integerValue]] forKey:@"range"];
    [dict setValue:self.userPreferenceObj.chefType forKey:pChefType];
    [dict setValue:self.cuisienPrefTextField.text forKey:pCuisinePreference];
    [dict setValue:[self.allergiesTextField.text componentsSeparatedByString:@","] forKey:pAllergies];
    [dict setValue:[NSString stringWithFormat:@"%f",self.spiceRatingView.value] forKey:pSpiceLevel];
    
    [ServiceHelper request:dict apiName:kAPISaveDinerPreference method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForAllergiesData {
    
    [ServiceHelper request:[NSMutableDictionary dictionary] apiName:kAPIForAutoAllergies method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSArray array]];
                
                self.allergiesArray = [dataDict objectForKeyNotNull:pAllAllergies expectedObj:[NSArray array]];
                
                [HTAutocompleteManager sharedManager].allAllergiesArray = self.allergiesArray ;
            }
            
        } else {
            
            [AlertController title:error.localizedDescription];
            
        }
    }];
}

- (void)callApiForSwitchUserRole : (NSString *)role {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pUserID];
    ([role isEqualToString:@"chef"]) ? [dict setValue:@"diner" forKey:pType] : [dict setValue:@"chef" forKey:pType];
    
    [ServiceHelper request:dict apiName:kAPIForSwitchRole method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                
                [NSUSERDEFAULT setValue: [dataDict objectForKeyNotNull:p_id expectedObj:@""] forKey:p_id];
                NSArray *array = [APPDELEGATE navigationController].viewControllers;
                if ([role isEqualToString:@"chef"]) {
                    
                    for (UIViewController *controller in [APPDELEGATE navigationController].viewControllers) {
                        if ([controller isKindOfClass:[MDLoginVC class]]) {
                            
                            [NSUSERDEFAULT setObject:@"chef" forKey:pRole];
                            self.chefButton.selected = YES;
                            self.dinerButton.selected = NO;
                            
                            [APPDELEGATE setIsFromCook:YES];
                            
                            [(MDLoginVC *)controller setUserType:@"chef"];
                            [[APPDELEGATE navigationController] popToViewController:controller animated:NO];
                        }
                    }
                } else {
                    
                    for (UIViewController *controller in [APPDELEGATE navigationController].viewControllers) {
                        if ([controller isKindOfClass:[MDLoginVC class]]) {
                            
                            [NSUSERDEFAULT setObject:@"diner" forKey:pRole];
                            self.chefButton.selected = NO;
                            self.dinerButton.selected = YES;
                            
                            [APPDELEGATE setIsFromCook:NO];
                            [(MDLoginVC *)controller setUserType:@"diner"];
                            [[APPDELEGATE navigationController] popToViewController:controller animated:NO];
                        }
                    }
                }
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
