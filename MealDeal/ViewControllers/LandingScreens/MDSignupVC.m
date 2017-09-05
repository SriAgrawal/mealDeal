//
//  MDSignupVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDSignupVC.h"
#import "Macro.h"

static NSString *cellIDMDTextFieldCell          = @"MDTextFieldCell";
static NSString *cellIDMDSingleButtonCell       = @"MDSingleButtonCell";
static NSString *cellIDMDMultiButtonCell        = @"MDMultiButtonCell";
static NSString *cellIDMDErrorCell              = @"MDErrorCell";

@interface MDSignupVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *statesListArray;
}

@property (weak, nonatomic) IBOutlet UIButton                       *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton                       *termsConditionButton;
@property (weak, nonatomic) IBOutlet UIButton                       *addPhotoButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView    *tableView;
@property (weak, nonatomic) IBOutlet UIImageView                    *profileImageView;
@property (weak, nonatomic) IBOutlet AHTextView                     *streetNameTextView;
@property (weak, nonatomic) IBOutlet UIImageView                    *semiCircleImageView;

@property (strong, nonatomic) UserInfo                              *userDetails;
@property (strong, nonatomic) ErrorModal                            *errorInfo;

@end

@implementation MDSignupVC

#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark -

#pragma mark - Private Methods

- (void)initialSetup {
    
    self.userDetails = [UserInfo getDefaultInfo];
    self.errorInfo = [ErrorModal getDefaultInfo];
    statesListArray = [[NSMutableArray alloc] init];
    self.streetNameTextView.placeholderText = @"Street Name, Unit/Apt.";
    [self.semiCircleImageView color:RGBCOLOR(0, 0, 0, 0.45)];

}

#pragma mark -

#pragma mark - UIButton Actions

- (IBAction)onLogin:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSignUp:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldsVerified]) {
        
        if (self.termsConditionButton.selected) {
            
            [self callApiForSignUp];
        
        } else {
            [AlertController title:@"Please accept terms and conditions."];
        }
    }
}

- (IBAction)onAddPhoto:(id)sender {
    [self.view endEditing:YES];
    
    [AlertController actionSheet:nil message:nil andButtonsWithTitle:@[@"Take from Camera", @"Choose from Gallery"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc] init];
        profileImagePicker.delegate = self;
        profileImagePicker.allowsEditing = YES;
        
        if (!index) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:profileImagePicker animated:YES completion:NULL];
            } else {
                [AlertController title:@"Camera is not available."];
            }
        } else if (index == 1) {
            [self presentViewController:profileImagePicker animated:YES completion:NULL];
        }
    }];
}

- (IBAction)onTermsConditionCheckBox:(UIButton *)button {
    [self.view endEditing:YES];
    
    button.selected = !button.selected;
}

- (IBAction)onTermsConditionButton:(id)sender {
    MDTermsAndConditionVC *termsAndConditionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDTermsAndConditionVC"];
    [self.navigationController pushViewController: termsAndConditionVC animated:YES];
}

#pragma mark -

#pragma mark - Selector Method Actions

- (void)onCountry:(IndexPathButton *)button {
    [self.view endEditing:YES];
    NSArray *countries = [CountryPicker countryNames];
    NSDictionary *codesWithName = [CountryPicker countryCodesByName];
    if (button.indexPath.section == 7) {
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:countries completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        self.userDetails.countryString = selectedValues.firstObject;
        NSString *code = [codesWithName valueForKey:selectedValues.firstObject];
        [self.tableView reloadData];
        [self callApiForStateList:code];
        //[button setTitle:self.userDetails.countryString forState:UIControlStateNormal];
    }];
   }
}

- (void)onState:(IndexPathButton *)button {
    [self.view endEditing:YES];
  
    if (button.indexPath.section == 8) {

        if([self.userDetails.countryString isEqualToString:@""]){
            [AlertController title:@"Please select country first."];
        }else{
        [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:statesListArray completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        self.userDetails.stateString = selectedValues.firstObject;
        [self.tableView reloadData];
        //[button setTitle:self.userDetails.stateString forState:UIControlStateNormal];
    }];
    }
}
}

- (void)onCook:(IndexPathButton *)button {
    
    self.userDetails.roleType = Cook;
    [self.tableView reloadData];
}

- (void)onEat:(IndexPathButton *)button {

    self.userDetails.roleType = Eat;
    [self.tableView reloadData];
}

#pragma mark -

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.tableView.expandableSections containsIndex:section]) {
        return 2; // for showing error cell
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row) {
        return 30.0f; // error cell
    }
    
    return 49.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDInputFieldsCell *cell = (MDInputFieldsCell *)[tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];

    if (!indexPath.row) {
        
        [cell.textField setIndexPath:indexPath];
        [cell.button setIndexPath:indexPath];

        [cell.textField setSecureTextEntry:NO];
        [cell.textField setReturnKeyType:UIReturnKeyNext];
        [cell.textField setKeyboardType:UIKeyboardTypeASCIICapable];
        [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [cell.textField setInputAccessoryView:nil];

        switch (indexPath.section) {
               
      //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDTextFieldCell >>>>>>>>>>>>>>>>>>>>>>>
            case 0: {
                [cell.textField placeHolderText:@"Username"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"user_icon"];
                [cell.textField setText:self.userDetails.userNameString];
            }
                break;
                
            case 1: {
                [cell.textField placeHolderText:@"Full Name"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"user_icon1"];

                [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [cell.textField setReturnKeyType:UIReturnKeyNext];
                [cell.textField setText:self.userDetails.fullNameString];
            }
                break;
                
            case 2: {
                [cell.textField placeHolderText:@"Email"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"email_icon"];
                [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
                [cell.textField setText:self.userDetails.emailString];
            }
                break;
                
            case 3: {
                [cell.textField placeHolderText:@"Phone"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"phone_icon"];
                [cell.textField setKeyboardType:UIKeyboardTypePhonePad];
                [cell.textField setText:self.userDetails.phoneString];
                [cell.textField setInputAccessoryView:[self getToolBarForNumberPad]];
            }
                break;
                
            case 4: {
                [cell.textField placeHolderText:@"Password"];
                [cell.textField setSecureTextEntry:YES];
                cell.textField.paddingIcon = [UIImage imageNamed:@"password_icon"];
                [cell.textField setText:self.userDetails.passwordString];
            }
                break;
                
            case 5: {
                [cell.textField placeHolderText:@"Confirm Password"];
                [cell.textField setSecureTextEntry:YES];
                cell.textField.paddingIcon = [UIImage imageNamed:@"confirm_password_icon"];

                [cell.textField setText:self.userDetails.confirmPasswordString];
                [cell.textField setReturnKeyType:UIReturnKeyDone];
            }
                break;
                
            case 9: {
                [cell.textField placeHolderText:@"City"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"city_icon"];

                [cell.textField setText:self.userDetails.cityString];
            }
                break;
                
            case 10: {
                [cell.textField placeHolderText:@"Zip Code"];
                cell.textField.paddingIcon = [UIImage imageNamed:@"zip_code_icon"];
                [cell.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];

                [cell.textField setText:self.userDetails.zipCodeString];
               
            }
                break;
                
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDSingleButtonCell >>>>>>>>>>>>>>>>>>>>>>>

            case 7: {
                [cell.buttonTextField setIndexPath:indexPath];

                [cell.buttonTextField setUserInteractionEnabled:NO];
                [cell.buttonTextField placeHolderText:@"Country"];
                cell.buttonTextField.paddingIcon = [UIImage imageNamed:@"country_icon"];
                [cell.button addTarget:self action:@selector(onCountry:) forControlEvents:UIControlEventTouchUpInside];
               
                [cell.buttonTextField setText:self.userDetails.countryString];

//                NSString *countryString = self.userDetails.countryString.length ? self.userDetails.countryString : @"Country";
//                [cell.button setTitle:countryString forState:UIControlStateNormal];
   
            }
                break;
                
            case 8: {
                [cell.buttonTextField setIndexPath:indexPath];

                [cell.buttonTextField setUserInteractionEnabled:NO];
                [cell.buttonTextField placeHolderText:@"State"];
                cell.buttonTextField.paddingIcon = [UIImage imageNamed:@"state_icon"];
                [cell.button addTarget:self action:@selector(onState:) forControlEvents:UIControlEventTouchUpInside];
               
                [cell.buttonTextField setText:self.userDetails.stateString];

//                NSString *stateString = self.userDetails.stateString.length ? self.userDetails.stateString : @"State";
//                [cell.button setTitle:stateString forState:UIControlStateNormal];
        
            }
                break;
                
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDMultiButtonCell >>>>>>>>>>>>>>>>>>>>>>>

            default: {

                [cell.cookButton addTarget:self action:@selector(onCook:) forControlEvents:UIControlEventTouchUpInside];
                [cell.eatButton addTarget:self action:@selector(onEat:) forControlEvents:UIControlEventTouchUpInside];
                [cell.eatButton setIndexPath:indexPath];
                [cell.cookButton setIndexPath:indexPath];
                
                if (self.userDetails.roleType == Cook) {
                    [cell.cookButton setSelected:YES];
                    [cell.eatButton setSelected:NO];

                }
                else if (self.userDetails.roleType == Eat) {
                    [cell.eatButton setSelected:YES];
                    [cell.cookButton setSelected:NO];

                }
            }
                break;
        }
        
        
    } else {
        
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDErrorCell >>>>>>>>>>>>>>>>>>>>>>>

        [cell.errorLabel setText:[self errorStringForIndexPath:indexPath]];
    }
    
    return cell;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row) {
        return cellIDMDErrorCell;
    }
    
    switch (indexPath.section) {
        case 6: return cellIDMDMultiButtonCell;
        case 7:
        case 8: return cellIDMDSingleButtonCell;
            
        default: return cellIDMDTextFieldCell;
    }
}

- (NSString *)errorStringForIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: return self.errorInfo.userNameErrorString;
        case 1: return self.errorInfo.fullNameErrorString;
        case 2: return self.errorInfo.emailErrorString;
        case 3: return self.errorInfo.phoneErrorString;
        case 4: return self.errorInfo.passwordErrorString;
        case 5: return self.errorInfo.confirmPasswordErrorString;
        case 6: return self.errorInfo.roleErrorString;
        case 7: return self.errorInfo.countryErrorString;
        case 8: return self.errorInfo.stateErrorString;
        case 9: return self.errorInfo.cityErrorString;
        case 10: return self.errorInfo.zipCodeErrorString;

        default: return @"Temp Error";
    }
    
}

#pragma mark -


#pragma mark- Validation Method

- (BOOL)isAllFieldsVerified {
    
    BOOL isAllValid = YES;
    
    NSMutableArray *arrayAddIndexes = [NSMutableArray array];
    NSMutableArray *arrayDeleteIndexes = [NSMutableArray array];
    
    if (![TRIM_SPACE(self.userDetails.userNameString) length] || ![self.userDetails.userNameString containsOnlyNumbersAndLetters] || ([TRIM_SPACE(self.userDetails.userNameString) length] > 0 && [TRIM_SPACE(self.userDetails.userNameString) length] <= 3)) {
        
        if ([TRIM_SPACE(self.userDetails.userNameString) length] > 0 && [TRIM_SPACE(self.userDetails.userNameString) length] <= 3) {
            
            self.errorInfo.userNameErrorString = @"Username must contain more than 3 characters.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:0]];
            
        } else {

            self.errorInfo.userNameErrorString = ![TRIM_SPACE(self.userDetails.userNameString) length] ? @"Please enter username." : @"Please enter valid username.";
        
            [arrayAddIndexes addObject:[NSNumber numberWithInt:0]];
        }
        
    } else {
        
        self.errorInfo.userNameErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:0]];
    }
    
    if (![TRIM_SPACE(self.userDetails.fullNameString) length] || ![self.userDetails.fullNameString isValidFullName] || ([TRIM_SPACE(self.userDetails.fullNameString) length] > 0  && [TRIM_SPACE(self.userDetails.fullNameString) length] <= 3)) {
        
        if ([TRIM_SPACE(self.userDetails.fullNameString) length] > 0  && [TRIM_SPACE(self.userDetails.fullNameString) length] <= 3) {
            
            self.errorInfo.fullNameErrorString = @"Full name must contain more than 3 characters.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:1]];
            
        } else {

            self.errorInfo.fullNameErrorString = ![TRIM_SPACE(self.userDetails.fullNameString) length] ? @"Please enter full name." :@"Please enter valid name.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:1]];
        }
        
    } else {
        
        self.errorInfo.fullNameErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:1]];
    }
    
    if (![TRIM_SPACE(self.userDetails.emailString) length] || ![self.userDetails.emailString isValidEmail]) {
        
        self.errorInfo.emailErrorString = ![TRIM_SPACE(self.userDetails.emailString) length] ? @"Please enter email." : @"Please enter valid email.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:2]];
        
    } else {
        
        self.errorInfo.emailErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:2]];
    }
    
    if (![TRIM_SPACE(self.userDetails.phoneString) length] || ![self.userDetails.phoneString isValidPhoneNumber] || [TRIM_SPACE(self.userDetails.phoneString) length] < 10 || [TRIM_SPACE(self.userDetails.phoneString) length] > 15) {
        
        if ([TRIM_SPACE(self.userDetails.phoneString) length] < 10 || [TRIM_SPACE(self.userDetails.phoneString) length] > 15) {
            
            self.errorInfo.phoneErrorString = @"Please enter at least 10 digits phone number.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:3]];

        } else {
        
        self.errorInfo.phoneErrorString = ![TRIM_SPACE(self.userDetails.phoneString) length] ? @"Please enter phone." : @"Please enter valid phone.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:3]];
        }
        
    } else {
        self.errorInfo.phoneErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:3]];
    }
    
    if (![TRIM_SPACE(self.userDetails.passwordString) length] || [TRIM_SPACE(self.userDetails.passwordString) length] < 6 || [TRIM_SPACE(self.userDetails.passwordString) length] > 15) {
        
        if ([TRIM_SPACE(self.userDetails.passwordString) length] < 6 || [TRIM_SPACE(self.userDetails.passwordString) length] > 15) {
            
            self.errorInfo.passwordErrorString = @"Please enter at least 6 characters password.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:4]];
            
        } else {
            
            self.errorInfo.passwordErrorString = @"Please enter password.";
            [arrayAddIndexes addObject:[NSNumber numberWithInt:4]];
        }
                
    } else {
        self.errorInfo.passwordErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:4]];
    }
    
    if (![TRIM_SPACE(self.userDetails.confirmPasswordString) length] || ![self.userDetails.passwordString isEqualToString:self.userDetails.confirmPasswordString]) {
        
        self.errorInfo.confirmPasswordErrorString = ![TRIM_SPACE(self.userDetails.confirmPasswordString) length] ? @"Please enter confirm password." : @"Password and confirm password do not match.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:5]];
        
    } else {
        self.errorInfo.confirmPasswordErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:5]];
    }
    
    if (self.userDetails.roleType == None) {
        self.errorInfo.roleErrorString = @"Please select user role.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:6]];
        
    } else {
        self.errorInfo.roleErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:6]];
    }
    
    if (![TRIM_SPACE(self.userDetails.countryString) length]) {
        self.errorInfo.countryErrorString = @"Please select country.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:7]];
        
    } else {
        self.errorInfo.countryErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:7]];
    }
    
    if (![TRIM_SPACE(self.userDetails.stateString) length]) {
        self.errorInfo.stateErrorString = @"Please select state.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:8]];
        
    } else {
        self.errorInfo.stateErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:8]];
    }
    
    if (![TRIM_SPACE(self.userDetails.cityString) length]) {
        self.errorInfo.cityErrorString = @"Please enter city.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:9]];
        
    } else {
        self.errorInfo.cityErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:9]];
    }
    
    if (![TRIM_SPACE(self.userDetails.zipCodeString) length] || [TRIM_SPACE(self.userDetails.zipCodeString) length] <= 2 || [TRIM_SPACE(self.userDetails.zipCodeString) length] >= 11) {
        self.errorInfo.zipCodeErrorString = ![TRIM_SPACE(self.userDetails.zipCodeString) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters.";
        [arrayAddIndexes addObject:[NSNumber numberWithInt:10]];
        
    } else {
        self.errorInfo.zipCodeErrorString = @"";
        [arrayDeleteIndexes addObject:[NSNumber numberWithInt:10]];
    }
    
    isAllValid = !arrayAddIndexes.count;
    
    [self.tableView animatedExpandAndCollapseCellsWithDeletableIndexPaths:arrayDeleteIndexes expandabelIndexPaths:arrayAddIndexes];
    
    
    [AppUtility delay:0.5 :^{
        [self.tableView reloadData];
    }];
    
    return isAllValid;
}

#pragma mark -

#pragma mark - UITextField Delegate Methode

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TextField *txtField = (TextField *)textField;
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield

    switch (txtField.indexPath.section) {
        case 0:
            self.userDetails.userNameString = TRIM_SPACE(textField.text);
            break;
            
        case 1:
            self.userDetails.fullNameString = TRIM_SPACE(textField.text);
            break;
            
        case 2:
            self.userDetails.emailString = TRIM_SPACE(textField.text);
            break;
            
        case 3:
            self.userDetails.phoneString = TRIM_SPACE(textField.text);
            LogInfo(@"????????%@",self.userDetails.phoneString);
            break;
            
        case 4:
            self.userDetails.passwordString = TRIM_SPACE(textField.text);
            break;
            
        case 5:
            self.userDetails.confirmPasswordString = TRIM_SPACE(textField.text);
            break;
            
        case 9:
            self.userDetails.cityString = TRIM_SPACE(textField.text);
            break;
            
        case 10:
            self.userDetails.zipCodeString = TRIM_SPACE(textField.text);
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TextField *txtField = (TextField *)textField;

    if (txtField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:txtField.indexPath.section + 1];
        MDInputFieldsCell *nextCell = (MDInputFieldsCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        
        if (nextCell) {
            [nextCell.textField becomeFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    
    TextField *txtField = (TextField *)textField;
    
    if (txtField.indexPath.section == 3)
        return (txtField.text.length > 14 && range.length == 0)? NO : YES;
    
    if (txtField.indexPath.section == 4)
        return (txtField.text.length > 14 && range.length == 0)? NO : YES;

    if ([[[txtField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])

        return NO;
    
   return YES;

}

#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView {

    self.userDetails.descriptionString = TRIM_SPACE(textView.text);

}

#pragma mark -

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.profileImageView setImage:image];

    self.userDetails.profileImage = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -

#pragma mark UIResponder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

#pragma mark - Web Api Section

- (void)callApiForSignUp {
    
    NSString *md5 = [self.userDetails.passwordString MD5String]; // returns NSString of the MD5
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.userDetails.userNameString forKey:pUserName];
    [dict setValue:self.userDetails.fullNameString forKey:pFullName];
    [dict setValue:self.userDetails.emailString forKey:pEmail];
    [dict setValue:md5 forKey:pPassword];
    [dict setValue:self.userDetails.phoneString forKey:pPhone];

    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    
    [addressDict setValue:self.userDetails.countryString forKey:pCountry];
    [addressDict setValue:self.userDetails.stateString forKey:pState];
    [addressDict setValue:self.userDetails.cityString forKey:pCity];
    [addressDict setValue:self.userDetails.zipCodeString forKey:pZipCode];
    [addressDict setValue:self.userDetails.descriptionString forKey:pStreetName];
    
    NSArray * locationArray = [[NSArray alloc]init];
    if ([APPDELEGATE longitude] && [APPDELEGATE latitude])
        locationArray = @[[APPDELEGATE longitude], [APPDELEGATE latitude]];
    else
    locationArray = @[@"", @""];

    [addressDict setValue: locationArray forKey:pLoc];
    
    [dict setValue:addressDict forKey:pAddress];

    (self.userDetails.roleType == Eat) ? [dict setValue:@"diner" forKey:pType]: [dict setValue:@"chef" forKey:pType];;
    (self.userDetails.roleType == Eat) ? [NSUSERDEFAULT setValue:@"diner" forKey:pType] : [NSUSERDEFAULT setValue:@"chef" forKey:pType];

    [dict setValue:kDeviceType forKey:pDeviceType];
    [dict setValue:[NSUSERDEFAULT objectForKey:pDevice_token] forKey:pDevice_token];
    [dict setValue:[self.userDetails.profileImage getBase64StringWithQuality:0.1] forKey:pPhoto];
    
    [ServiceHelper request:dict apiName:kAPISignUp method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *userInfoDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                NSString *userId = [userInfoDict objectForKeyNotNull:p_id expectedObj:@""];
                
                [NSUSERDEFAULT setObject:userId forKey:p_id];
                
                            if(self.userDetails.roleType == Cook){
                                [APPDELEGATE setIsFromCook:YES];
                                [self.navigationController pushViewController:[APPDELEGATE getSlidePanelChef] animated:YES];
                            } else {
                                
                                [APPDELEGATE setIsFromCook:NO];

                                MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
                                [self.navigationController pushViewController: locationVC animated:YES];
                                locationVC.isCook = NO;
                                locationVC.isAfterLogin = YES;
                                locationVC.isBack = NO;
                            }
                
                //[self.navigationController pushViewController:[APPDELEGATE getSlidePanel] animated:YES];
                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForStateList:(NSString *)counryCode {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *api = [NSString stringWithFormat:@"%@/%@/ISO2",kAPIGetAllStates,counryCode];
    
    [ServiceHelper request:dict apiName:api method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
               // [statesListArray removeAllObjects];
                statesListArray = [resultDict objectForKey:@"data"];
                //[self.tableView reloadData];
            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

@end
