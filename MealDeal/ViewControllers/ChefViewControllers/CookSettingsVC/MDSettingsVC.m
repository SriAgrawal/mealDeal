//
//  MDSettingsVC.m
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDSettingsVC.h"


@interface MDSettingsVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CookSettingsModal *settings;
    BOOL isNameEdit,isPasswordEdit,isPhoneEdit,isEmailEdit,isZipEdit,isEdit,isPhotoEdit;
    NSMutableArray *statesListArray;
    NSString *strImageData;
}

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UISwitch *pushNotificationSwitch;
@property (strong, nonatomic) IBOutlet UIButton *preferenceBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldName;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldPhoneNo;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldZipCode;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *rateView;
@property (strong, nonatomic) IBOutlet UILabel *lblReviews;
@property (strong, nonatomic) IBOutlet UIButton *nameEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *passwordEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneNoEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *emailEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *zipCodeEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountDetailBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblAccountDetails;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldSpeciality;
@property (strong, nonatomic) IBOutlet UIButton *eatBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblPreference;
@property (strong, nonatomic) IBOutlet UIButton *cookBtn;
@property (strong, nonatomic) IBOutlet UIView *accountDetailsView;
@property (strong, nonatomic) IBOutlet UIView *preferenceView;
@property (strong, nonatomic) IBOutlet UIButton *reviewsBtn;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *preferenceSaveBtnView;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
- (IBAction)editBtnAction:(id)sender;
@end

@implementation MDSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitial];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.accountDetailBtn setSelected:YES];
    [self.accountDetailBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
}

-(void)setUpInitial {
    
    if ([[NSUSERDEFAULT valueForKey:pRole] isEqual: @"chef"])
        self.cookBtn.selected = YES;
    else
        self.eatBtn.selected = YES;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 5, 20)];
    self.txtFieldSpeciality.leftView = paddingView;
    self.txtFieldSpeciality.leftViewMode = UITextFieldViewModeAlways;
    [self.txtFieldPhoneNo setInputAccessoryView:[self getToolBarForNumberPad]];
    statesListArray = [[NSMutableArray alloc] init];
    
    settings = [[CookSettingsModal alloc] init];
   /* settings.strName = @"Name";
    settings.strPassword = @"mohitkumar";
    settings.strPhoneNo = @"+0987654321";
    settings.strEmail = @"xyz@abc.com";
    settings.strZipcode = @"123456";*/
   [self callApiForGetSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.accountDetailBtn.selected){
    return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    if(self.accountDetailBtn.selected){
    if(section == 0){
        return 6;
    }else if (section == 1){
    return 2;
    }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.accountDetailBtn.selected){
    if(indexPath.section == 0){
        if(indexPath.row == 4){
            return 111.0f;
        }
    else{
        return 50.0f;
      }
    }
    else if (indexPath.section == 1){
        return 50.0f;
    }
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 5){
        static NSString *cellIdentifier = @"MDSettingsUpdateAddressCell";
        MDSettingsUpdateAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
        if (cell == nil) {
            cell = [[MDSettingsUpdateAddressCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.updateBtn addTarget:self action:@selector(updateAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        static NSString *cellIdentifier = @"MDSettingsUpdateAddressCell";
        MDSettingsUpdateAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           cellIdentifier];
        if (cell == nil) {
            cell = [[MDSettingsUpdateAddressCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.updateBtn addTarget:self action:@selector(updatePayPalDetails:) forControlEvents:UIControlEventTouchUpInside];

        return cell;

    }else{
        static NSString *cellIdentifier = @"MDSettingsCell";
        MDSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    cellIdentifier];
        if (cell == nil) {
            cell = [[MDSettingsCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.txtViewData.tag = indexPath.row;
        cell.txtFieldData.tag = indexPath.row;
        
        if(indexPath.section == 0){
            switch (indexPath.row) {
                case 0:{
                    cell.txtViewData.hidden = YES;
                    cell.txtFieldData.hidden = NO;
                    cell.btnPicker.hidden = NO;
                    cell.lblTextViewPlaceholder.hidden = YES;
                    cell.txtFieldData.userInteractionEnabled = NO;
                    [cell.txtFieldData setText:settings.strCountry];
                    cell.txtFieldData.placeholder = @"Country";
                    cell.btnPicker.tag = indexPath.row;
                    [cell.btnPicker addTarget:self action:@selector(selectCountryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                case 1:{
                    cell.txtViewData.hidden = YES;
                    cell.txtFieldData.hidden = NO;
                    cell.btnPicker.hidden = NO;
                    cell.lblTextViewPlaceholder.hidden = YES;
                    cell.txtFieldData.userInteractionEnabled = NO;
                    [cell.txtFieldData setText:settings.strState];
                    cell.txtFieldData.placeholder = @"State";
                    cell.btnPicker.tag = indexPath.row;
                    [cell.btnPicker addTarget:self action:@selector(selectStateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                case 2:{
                    cell.txtViewData.hidden = YES;
                    cell.txtFieldData.hidden = NO;
                    cell.btnPicker.hidden = YES;
                    cell.lblTextViewPlaceholder.hidden = YES;
                    cell.txtFieldData.userInteractionEnabled = YES;
                    [cell.txtFieldData setText:settings.strCity];
                    cell.txtFieldData.placeholder = @"City";
                }
                    break;
                case 3:{
                    cell.txtViewData.hidden = YES;
                    cell.txtFieldData.hidden = NO;
                    cell.btnPicker.hidden = YES;
                    cell.lblTextViewPlaceholder.hidden = YES;
                    cell.txtFieldData.userInteractionEnabled = YES;
                    [cell.txtFieldData setText:settings.strZipcode];
                    cell.txtFieldData.placeholder = @"Zip Code";
                }
                    break;
                case 4:{
                    cell.txtViewData.hidden = NO;
                    cell.txtViewData.placeholderText = @"Street Name, Unit/Apt.";
                    cell.txtFieldData.hidden = YES;
                    [cell.txtViewData setText:settings.strStreetName];
                    cell.btnPicker.hidden = YES;
                }
                    break;
                    
                default:
                    break;
            }
        }
    
        if(indexPath.section == 1){
            switch (indexPath.row) {
                case 0:{
                    cell.txtViewData.hidden = YES;
                    cell.txtFieldData.hidden = NO;
                    cell.btnPicker.hidden = YES;
                    cell.txtFieldData.tag = 101;
                    cell.lblTextViewPlaceholder.hidden = YES;
                    cell.txtFieldData.userInteractionEnabled = YES;
                    cell.txtFieldData.placeholder = @"Account Number";
                    cell.txtFieldData.keyboardType = UIKeyboardTypePhonePad;
                    [cell.txtFieldData setText:settings.strAccountNumber];
                    [cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];

                }
                    break;
                    
                default:
                    break;
            }
        }
        
   return cell;
    }
    return nil;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"MDSettingsSectionHeaderCell";
    
    MDSettingsSectionHeaderCell *sectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    sectionHeaderCell.contentView.backgroundColor = [UIColor whiteColor];
    if(section == 0)
        sectionHeaderCell.lblSectionHeader.text = @"Address";
    else
        sectionHeaderCell.lblSectionHeader.text = @"Pay Pal Details";
    
    // don't leave this transparent
    
    return sectionHeaderCell.contentView;
    
}


#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [KTextField(1) becomeFirstResponder];
    } else if (textField.tag == 1)
        [KTextField(2) becomeFirstResponder];
    else if (textField.tag == 2)
        [KTextField(3) becomeFirstResponder];
    else if (textField.tag == 3)
        [KTextView(4) becomeFirstResponder];
    else if (textField.tag == 1000)
        [KTextField(1000) resignFirstResponder];

    
    else
        [textField resignFirstResponder];
    
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 04:{
            settings.strStreetName = textView.text;
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    switch (textView.tag) {
        case 4:{
            if ([text isEqualToString:@"\n"]) {
                [textView resignFirstResponder];
                return NO;
            }
        }
            break;
            
            
        default:
            break;
    }    return YES;
}



#pragma mark - TextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            settings.strName = TRIM_SPACE(textField.text);
            break;
            
        case 200:
            settings.strPassword = TRIM_SPACE(textField.text);
            break;
            
        case 300:
            settings.strPhoneNo = TRIM_SPACE(textField.text);
            break;
            
        case 400:
            settings.strEmail = TRIM_SPACE(textField.text);
            break;
            
        case 500:
            settings.strZipcode = TRIM_SPACE(textField.text);
            break;
        case 2:
            settings.strCity = TRIM_SPACE(textField.text);
            break;
            
        case 3:
            settings.strZipCodeAddress = TRIM_SPACE(textField.text);
            break;
            
        case 101:
            settings.strAccountNumber = TRIM_SPACE(textField.text);
            break;
            
        default:
            break;
    }
}


// Validation Methods

- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(self.txtFieldSpeciality.text) length]) {
        [AlertController title:@"Please enter your speciality."];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark Button Action Methods

/*- (IBAction)nameBtnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.view endEditing:YES];
        self.txtFieldName.userInteractionEnabled = YES;
        [self.nameEditBtn setImage:[UIImage imageNamed:@"save-icon"] forState:UIControlStateNormal];
    }
    else if(!sender.selected){
        if (![TRIM_SPACE(settings.strName) length] || ![settings.strName containsOnlyLetters])
            [AlertController title: ![TRIM_SPACE(settings.strName) length] ? @"Please enter name." :@"Please enter valid name."];
        else{
        [self.view endEditing:YES];
           // [self callApiForSetSettings];
        self.txtFieldName.userInteractionEnabled = NO;
        [self.nameEditBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)phoneNoBtnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.view endEditing:YES];
        self.txtFieldPhoneNo.userInteractionEnabled = YES;
        [self.phoneNoEditBtn setImage:[UIImage imageNamed:@"save-icon"] forState:UIControlStateNormal];
    }else if(!sender.selected){
        if (![TRIM_SPACE(settings.strPhoneNo) length] || ![settings.strPhoneNo isValidPhoneNumber] || [TRIM_SPACE(settings.strPhoneNo) length] < 10 || [TRIM_SPACE(settings.strPhoneNo) length] > 15) {
            
            if ([TRIM_SPACE(settings.strPhoneNo) length] < 10 || [TRIM_SPACE(settings.strPhoneNo) length] > 15)
                [AlertController title: @"Please enter phone number between 10 to 15 digits."];
            
            else
                [AlertController title: ![TRIM_SPACE(settings.strPhoneNo) length] ? @"Please enter phone." : @"Please enter valid phone."];
        }
        else{
            [self.view endEditing:YES];
            //[self callApiForSetSettings];
            self.txtFieldPhoneNo.userInteractionEnabled = NO;
            [self.phoneNoEditBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)passwordBtnAction:(UIButton*)sender {
    MDChangePasswordVC *changePassword = [self.storyboard instantiateViewControllerWithIdentifier:@"MDChangePasswordVC"];
    [self.navigationController pushViewController:changePassword animated:YES];

}
- (IBAction)emailBtnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.view endEditing:YES];
        self.txtFieldEmail.userInteractionEnabled = YES;
        [self.emailEditBtn setImage:[UIImage imageNamed:@"save-icon"] forState:UIControlStateNormal];
    }else if(!sender.selected){
        if (![TRIM_SPACE(settings.strEmail) length] || ![settings.strEmail isValidEmail])
            
            [AlertController title: ![TRIM_SPACE(settings.strEmail) length] ? @"Please enter email." : @"Please enter valid email."];
        else{
            [self.view endEditing:YES];
           // [self callApiForSetSettings];
            self.txtFieldEmail.userInteractionEnabled = NO;
            [self.emailEditBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)zipCodeBtnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.view endEditing:YES];
        self.txtFieldZipCode.userInteractionEnabled = YES;
        [self.zipCodeEditBtn setImage:[UIImage imageNamed:@"save-icon"] forState:UIControlStateNormal];
    }else if(!sender.selected){
        if (![TRIM_SPACE(settings.strZipcode) length] || [TRIM_SPACE(settings.strZipcode) length] < 5)
            [AlertController title: ![TRIM_SPACE(settings.strZipcode) length] ? @"Please enter zip code." : @"Please enter valid zip code."];
        else{
            [self.view endEditing:YES];
           // [self callApiForSetSettings];
            self.txtFieldZipCode.userInteractionEnabled = NO;
            [self.zipCodeEditBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        }
    }
}*/
- (IBAction)btnCameraAction:(id)sender {
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

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.imgUser setImage:image];
    isPhotoEdit = TRUE;
    strImageData = [image getBase64StringWithQuality:0.1];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)editBtnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.view endEditing:YES];
        isEdit = YES;
        self.txtFieldZipCode.userInteractionEnabled = YES;
        self.txtFieldName.userInteractionEnabled = YES;
        self.txtFieldPhoneNo.userInteractionEnabled = YES;
        self.txtFieldEmail.userInteractionEnabled = YES;
        self.txtFieldZipCode.userInteractionEnabled = YES;
        self.btnCamera.hidden = NO;
        [self.editBtn setImage:[UIImage imageNamed:@"save-icon"] forState:UIControlStateNormal];
    }
    else if(!sender.selected){
        [self.view endEditing:YES];
        
        if (![TRIM_SPACE(settings.strZipcode) length] || [TRIM_SPACE(settings.strZipcode) length] <= 2 || [TRIM_SPACE(settings.strZipcode) length] >= 11){
            [AlertController title: ![TRIM_SPACE(settings.strZipcode) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters."];
        } else if(![TRIM_SPACE(settings.strName) length] || ![settings.strName isValidFullName]){
            [AlertController title: ![TRIM_SPACE(settings.strName) length] ? @"Please enter name." :@"Please enter valid name."];
        } else if(![TRIM_SPACE(settings.strPhoneNo) length] || ![settings.strPhoneNo isValidPhoneNumber] || [TRIM_SPACE(settings.strPhoneNo) length] < 10 || [TRIM_SPACE(settings.strPhoneNo) length] > 15){
            if ([TRIM_SPACE(settings.strPhoneNo) length] < 10 || [TRIM_SPACE(settings.strPhoneNo) length] > 15)
                [AlertController title: @"Please enter phone number between 10 to 15 digits."];
            else
                [AlertController title: ![TRIM_SPACE(settings.strPhoneNo) length] ? @"Please enter phone." : @"Please enter valid phone."];
        } else if(![TRIM_SPACE(settings.strEmail) length] || ![settings.strEmail isValidEmail]){
            [AlertController title: ![TRIM_SPACE(settings.strEmail) length] ? @"Please enter email." : @"Please enter valid email."];
        }
        else{
            [self.view endEditing:YES];
             [self callApiForSetSettings];
//            isEdit = NO;
//            self.txtFieldZipCode.userInteractionEnabled = NO;
//            self.txtFieldName.userInteractionEnabled = NO;
//            self.txtFieldPhoneNo.userInteractionEnabled = NO;
//            self.txtFieldEmail.userInteractionEnabled = NO;
//            self.txtFieldZipCode.userInteractionEnabled = NO;
//            [self.editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)changePasswordBtnAction:(id)sender {
    if(isEdit){
        MDChangePasswordVC *changePassword = [self.storyboard instantiateViewControllerWithIdentifier:@"MDChangePasswordVC"];
        [self.navigationController pushViewController:changePassword animated:YES];
    }
}


- (IBAction)accountDetailsBtnAction:(id)sender {
    [self.accountDetailBtn setSelected:YES];
    [self.preferenceBtn setSelected:NO];
    self.lblPreference.hidden = YES;
    self.lblAccountDetails.hidden = NO;
    [self.accountDetailBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.preferenceBtn setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:136/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.accountDetailsView.hidden = NO;
    self.preferenceView.hidden = YES;
    [self.tblView reloadData];
}

- (IBAction)preferenceBtnAction:(id)sender {
    [self.accountDetailBtn setSelected:NO];
    [self.preferenceBtn setSelected:YES];
    self.lblPreference.hidden = NO;
    self.lblAccountDetails.hidden = YES;
    self.preferenceView.hidden = NO;
    self.accountDetailsView.hidden = YES;
    [self.accountDetailBtn setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:136/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.preferenceBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.tblView reloadData];
}



- (IBAction)cookBtnAction:(id)sender {
    
    if (!self.cookBtn.selected) {
        
        [AlertController title:@"Confirm" message:@"Do you want to switch role?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                [self callApiForSwitchUserRole : @"chef"];
            }
        }];
    }
}


- (IBAction)eatBtnAction:(id)sender {
    
    if (!self.eatBtn.selected) {
        [AlertController title:@"Confirm" message:@"Do you want to switch role?" andButtonsWithTitle:@[@"NO", @"YES"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index) {
                [self callApiForSwitchUserRole : @"diner"];
            }
        }];
    }
}

- (IBAction)menuBtnAction:(id)sender {
    
    [self.sidePanelController showLeftPanelAnimated:YES];
}


- (IBAction)saveBtnAction:(id)sender {
    [self.view endEditing:YES];
    if([self validateAndEnableLoginButton]){
        self.txtFieldSpeciality.text = @"";
       // [AlertController title:@"Preference updated successfully."];
        [self callApiForSavePreference];
    }
}

-(void)updateAddressBtn:(UIButton*)sender{
    [self.view endEditing:YES];
    if([self validateAddress]){
       // [AlertController title:@"Address updated successfully."];
        [self callApiForSetAddress];
    }
}

-(void)updatePayPalDetails:(UIButton*)sender{
    [self.view endEditing:YES];
    if([self validatePaypalDetails]){
        //[AlertController title:@"Pay Pal details updated successfully."];
        [self callApiForSetPayPalDetails];
    }
}
- (IBAction)reviewsBtnAction:(id)sender {
    [self.view endEditing:YES];
    if(isEdit){
    MDReviewsVC *reviews = [self.storyboard instantiateViewControllerWithIdentifier:@"MDReviewsVC"];
    [self.navigationController pushViewController:reviews animated:YES];
    }
}

-(void)selectCountryBtnAction:(UIButton*)sender{
    [self.view endEditing:YES];

    if(sender.tag == 0){
        NSArray *countries = [CountryPicker countryNames];
        NSDictionary *codesWithName = [CountryPicker countryCodesByName];
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:countries completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        settings.strCountry = selectedValues.firstObject;
        NSString *code = [codesWithName valueForKey:selectedValues.firstObject];
        [self.tblView reloadData];
        [self callApiForStateList:code];
    }];
    }
   
}

-(void)selectStateBtnAction:(UIButton*)sender{
    [self.view endEditing:YES];
    if(settings.strCountry == nil || settings.strCountry == (id)[NSNull null] || ![statesListArray count]){
        [AlertController title:@"Please select country first."];
    }else{
    if(sender.tag == 1){
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:statesListArray completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        settings.strState = selectedValues.firstObject;
        [self.tblView reloadData];
    }];
    }
}
}

- (BOOL)validateAddress {
    
    if (![TRIM_SPACE(settings.strCountry) length]) {
        [AlertController title:@"Please select country."];
        return NO;
    } else if (![TRIM_SPACE(settings.strState) length]) {
        [AlertController title:@"Please select state"];
        return NO;
    } else if (![TRIM_SPACE(settings.strCity) length] || ![settings.strCity containsOnlyLetters]){
        [AlertController title: ![TRIM_SPACE(settings.strCity) length] ? @"Please enter city." :@"Please enter valid city name."];
        return NO;
    }   else if (![TRIM_SPACE(settings.strZipCodeAddress) length] || [TRIM_SPACE(settings.strZipCodeAddress) length] <= 2 || [TRIM_SPACE(settings.strZipCodeAddress) length] >= 11){
        [AlertController title: ![TRIM_SPACE(settings.strZipCodeAddress) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters."];
        return NO;
    }
     else if (![TRIM_SPACE(settings.strStreetName) length]) {
        [AlertController title:@"Please enter street name."];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)validatePaypalDetails {
    
    if (![TRIM_SPACE(settings.strAccountNumber) length]) {
        [AlertController title:@"Please enter account number."];
        return NO;
    }  else if (!([TRIM_SPACE(settings.strAccountNumber) length] == 16)){
        [AlertController title:@"Account number should be of 16 digits."];
        return NO;
    }
 else {
        return YES;
    }
}

#pragma mark - Web Api Section

- (void)callApiForGetSettings {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"userId"];
    
    [ServiceHelper request:dict apiName:kAPIGetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                NSDictionary *dict = [resultDict objectForKey:@"data"];
                NSDictionary *chefDetails = [dict objectForKey:@"chefdetails"];
                settings = [CookSettingsModal gettingDataFromResponse:chefDetails];
                
                self.txtFieldName.text = settings.strName;
                [self.imgUser sd_setImageWithURL:[NSURL URLWithString:settings.strImageUrl] placeholderImage:[UIImage imageNamed:@"user"]];
                self.lblUserName.text = settings.strUsername;
                self.txtFieldPassword.text = settings.strPassword;
                self.txtFieldEmail.text = settings.strEmail;
                self.txtFieldPhoneNo.text = settings.strPhoneNo;
                self.txtFieldZipCode.text = settings.strZipcode;
                [self.reviewsBtn setTitle:settings.strReviews forState:UIControlStateNormal];
                self.rateView.value = [settings.strTotalRating integerValue];
                if(settings.pushNotificationStatus)
                   [self.pushNotificationSwitch setOn:YES];
                else
                    [self.pushNotificationSwitch setOn:NO];
                
                if([settings.strCountry length]){
                NSDictionary *codesWithName = [CountryPicker countryCodesByName];
                NSString *code = [codesWithName valueForKey:settings.strCountry];
                [self callApiForStateList:code];
                }
                [self.tblView reloadData];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}



- (void)callApiForSetSettings {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"userId"];
    [dict setValue:(isPhotoEdit?strImageData:settings.strImageUrl) forKey:@"image"];
    [dict setValue:settings.strUsername forKey:@"userName"];
    [dict setValue:settings.strName forKey:@"fullName"];
    [dict setValue:settings.strEmail forKey:@"email"];
    [dict setValue:settings.strPhoneNo forKey:@"phoneNumber"];
    [dict setValue:settings.strPassword forKey:@"password"];
    [dict setValue:@"chef" forKey:@"type"];
    [dict setValue:settings.strAccountNumber forKey:@"paypalDetail"];
    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:settings.strCountry forKey:@"country"];
    [addressDict setValue:settings.strState forKey:@"state"];
    [addressDict setValue:settings.strCity forKey:@"city"];
    [addressDict setValue:settings.strZipcode forKey:@"zipCode"];
    [addressDict setValue:settings.strStreetName forKey:@"streetName"];
    [dict setValue:addressDict forKey:@"address"];
    
    [ServiceHelper request:dict apiName:kAPISetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                settings = [CookSettingsModal gettingDataFromResponse:[resultDict objectForKey:@"data"]];
                self.txtFieldName.text = settings.strName;
                [self.imgUser sd_setImageWithURL:[NSURL URLWithString:settings.strImageUrl] placeholderImage:[UIImage imageNamed:@"user"]];

                self.lblUserName.text = settings.strUsername;
                self.txtFieldPassword.text = settings.strPassword;
                self.txtFieldPhoneNo.text = settings.strPhoneNo;
                self.txtFieldEmail.text = settings.strEmail;
                self.txtFieldZipCode.text = settings.strZipcode;
                [self.reviewsBtn setTitle:settings.strReviews forState:UIControlStateNormal];
                self.rateView.value = [settings.strTotalRating integerValue];
                if(settings.pushNotificationStatus)
                    [self.pushNotificationSwitch setOn:YES];
                else
                    [self.pushNotificationSwitch setOn:NO];
                
                isEdit = NO;
                self.txtFieldZipCode.userInteractionEnabled = NO;
                self.txtFieldName.userInteractionEnabled = NO;
                self.txtFieldPhoneNo.userInteractionEnabled = NO;
                self.txtFieldEmail.userInteractionEnabled = NO;
                self.txtFieldZipCode.userInteractionEnabled = NO;
                self.btnCamera.hidden = YES;
                [self.editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
                
                [self.tblView reloadData];
                
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForSetAddress {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"userId"];
    [dict setValue:settings.strImageUrl forKey:@"image"];
    [dict setValue:settings.strUsername forKey:@"userName"];
    [dict setValue:settings.strName forKey:@"fullName"];
    [dict setValue:settings.strEmail forKey:@"email"];
    [dict setValue:settings.strPhoneNo forKey:@"phoneNumber"];
    [dict setValue:settings.strPassword forKey:@"password"];
    [dict setValue:@"chef" forKey:@"type"];
    [dict setValue:settings.strAccountNumber forKey:@"paypalDetail"];
    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:settings.strCountry forKey:@"country"];
    [addressDict setValue:settings.strState forKey:@"state"];
    [addressDict setValue:settings.strCity forKey:@"city"];
    [addressDict setValue:settings.strZipcode forKey:@"zipCode"];
    [addressDict setValue:settings.strStreetName forKey:@"streetName"];
    [dict setValue:addressDict forKey:@"address"];
    
    [ServiceHelper request:dict apiName:kAPISetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                settings = [CookSettingsModal gettingDataFromResponse:[resultDict objectForKey:@"data"]];
               [AlertController title:@"Address updated successfully."];
                [self.tblView reloadData];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


- (void)callApiForSetPayPalDetails {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"userId"];
    [dict setValue:settings.strImageUrl forKey:@"image"];
    [dict setValue:settings.strUsername forKey:@"userName"];
    [dict setValue:settings.strName forKey:@"fullName"];
    [dict setValue:settings.strEmail forKey:@"email"];
    [dict setValue:settings.strPhoneNo forKey:@"phoneNumber"];
    [dict setValue:settings.strPassword forKey:@"password"];
    [dict setValue:@"chef" forKey:@"type"];
    [dict setValue:settings.strAccountNumber forKey:@"paypalDetail"];
    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:settings.strCountry forKey:@"country"];
    [addressDict setValue:settings.strState forKey:@"state"];
    [addressDict setValue:settings.strCity forKey:@"city"];
    [addressDict setValue:settings.strZipcode forKey:@"zipCode"];
    [addressDict setValue:settings.strStreetName forKey:@"streetName"];
    [dict setValue:addressDict forKey:@"address"];
    
    [ServiceHelper request:dict apiName:kAPISetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                settings = [CookSettingsModal gettingDataFromResponse:[resultDict objectForKey:@"data"]];
                 [AlertController title:@"Paypal details updated successfully."];
                [self.tblView reloadData];
                
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


- (void)callApiForSavePreference {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"dinerId"];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:@"chefId"];
    [dict setValue:_eatBtn.selected ? @"eat" : @"cook" forKey:@"mealType"];
    [dict setValue:@"" forKey:@"range"];
    [dict setValue:@"" forKey:@"chefType"];
    [dict setValue:self.txtFieldSpeciality.text forKey:@"cuisinePreference"];
    [dict setValue:@"" forKey:@"allergies"];
    [dict setValue:@"" forKey:@"spiceLevel"];
    
    [ServiceHelper request:dict apiName:kAPISaveDinerPreference method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [AlertController title:@"Preference saved successfully."];
       //         [self.tblView reloadData];

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
              //  [statesListArray removeAllObjects];
                statesListArray = [resultDict objectForKey:@"data"];
                
            } else {
                [statesListArray removeAllObjects];
                [AlertController title:responseMessage];
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
                
                if ([role isEqualToString:@"chef"]) {
                    
                    [NSUSERDEFAULT setObject:@"chef" forKey:pRole];
                    self.cookBtn.selected = YES;
                    self.eatBtn.selected = NO;
                    
                    [APPDELEGATE setIsFromCook:YES];
                    for (UIViewController *controller in [APPDELEGATE navigationController].viewControllers) {
                        if ([controller isKindOfClass:[MDLoginVC class]]) {
                            [(MDLoginVC *)controller setUserType:@"chef"];
                            [[APPDELEGATE navigationController] popToViewController:controller animated:NO];
                        }
                    }
                } else {
                    
                    [NSUSERDEFAULT setObject:@"diner" forKey:pRole];
                    self.cookBtn.selected = NO;
                    self.eatBtn.selected = YES;
                    
                    [APPDELEGATE setIsFromCook:NO];
                    
                    for (UIViewController *controller in [APPDELEGATE navigationController].viewControllers) {
                        if ([controller isKindOfClass:[MDLoginVC class]]) {
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

@end
