//
//  MDAccountDetailsVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDAccountDetailsVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDAccountDetailsCell";

@interface MDAccountDetailsVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UIImageView            *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView            *cameraImageView;

@property (weak, nonatomic) IBOutlet UITextField            *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton               *userProfileButton;

@property (weak, nonatomic) IBOutlet UIButton               *editButton;
@property (weak, nonatomic) IBOutlet UIButton               *saveButton;
@property (weak, nonatomic) IBOutlet UISwitch               *pushNotification;

@property (assign, nonatomic) BOOL                          isEdit;
@property (strong, nonatomic) UserInfo                      *userDetails;

@end

@implementation MDAccountDetailsVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
   
    self.tableView.alwaysBounceVertical = NO;
    self.isEdit = NO;
    self.userDetails = [[UserInfo alloc]init];

    self.userNameTextField.placeholder = @"Username";
    self.userNameTextField.userInteractionEnabled = NO;
    [self.userNameTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    self.userNameTextField.returnKeyType = UIReturnKeyDone;
    self.userNameTextField.tag = 100;
    self.userProfileButton.userInteractionEnabled = NO;

    self.editButton.hidden = NO;
    self.saveButton.hidden = YES;
    self.cameraImageView.hidden = YES;
    
    [self apiCallViewProfile];
}

#pragma mark - UIButton Action

- (IBAction)pushNotificationSwitch:(id)sender {
    
    self.userDetails.notificationStatus = [sender isOn];
    [self callApiToEditProfile];
    
}
- (IBAction)userProfilrButtonAction:(id)sender {
    
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

#pragma mark - UIButton Selector Methods

- (IBAction)editButtonAction:(id)sender {
    
    self.isEdit = YES;
    self.editButton.hidden = YES;
    self.saveButton.hidden = NO;
    self.userNameTextField.userInteractionEnabled = YES;
    [self.userNameTextField becomeFirstResponder];
    self.userProfileButton.userInteractionEnabled = YES;
    self.cameraImageView.hidden = NO;
    [self.tableView reloadData];
    
}

- (IBAction)saveButtonAction:(id)sender {
    
    [self.view endEditing:YES];

    if ([self isAllFieldsVerified]) {
        self.isEdit = NO;
        self.editButton.hidden = NO;
        self.saveButton.hidden = YES;
        self.userNameTextField.userInteractionEnabled = NO;
        self.userProfileButton.userInteractionEnabled = NO;
        self.cameraImageView.hidden = YES;

        [self callApiToEditProfile];
    }
}

- (BOOL)isAllFieldsVerified {
    
    BOOL isAllValid = YES;

    if (![TRIM_SPACE(self.userDetails.fullNameString) length] || ![self.userDetails.fullNameString isValidFullName]) {
        
        [AlertController title: ![TRIM_SPACE(self.userDetails.fullNameString) length] ? @"Please enter name." :@"Please enter valid name."];
        isAllValid = NO;
    }
    
    else if (![TRIM_SPACE(self.userDetails.phoneString) length] || ![self.userDetails.phoneString isValidPhoneNumber] || [TRIM_SPACE(self.userDetails.phoneString) length] < 10 || [TRIM_SPACE(self.userDetails.phoneString) length] > 15) {
        
        isAllValid = NO;

        if ([TRIM_SPACE(self.userDetails.phoneString) length] < 10 || [TRIM_SPACE(self.userDetails.phoneString) length] > 15)
            [AlertController title: @"Please enter phone number between 10 to 15 digits."];
        
        else
            [AlertController title: ![TRIM_SPACE(self.userDetails.phoneString) length] ? @"Please enter phone." : @"Please enter valid phone."];
    }
    
    else if (![TRIM_SPACE(self.userDetails.emailString) length] || ![self.userDetails.emailString isValidEmail]) {
        
        [AlertController title: ![TRIM_SPACE(self.userDetails.emailString) length] ? @"Please enter email." : @"Please enter valid email."];
        isAllValid = NO;
    
    }

    else if (![TRIM_SPACE(self.userDetails.zipCodeString) length] || [TRIM_SPACE(self.userDetails.zipCodeString) length] <= 2 || [TRIM_SPACE(self.userDetails.zipCodeString) length] >= 11) {
        [AlertController title: ![TRIM_SPACE(self.userDetails.zipCodeString) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters."];
        isAllValid = NO;
    }
    
    return isAllValid;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (!(textField.tag == 100)) {
        TextField *field = (TextField *)textField;
        field.active = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 100)
        self.userDetails.userNameString = textField.text;
    else {
        TextField *txtField = (TextField *)textField;
        txtField.active = NO;
    switch (txtField.indexPath.row) {
        case 0:
            self.userDetails.fullNameString = textField.text;
            break;
        case 1:
            self.userDetails.passwordString = textField.text;
            break;
        case 2:
            self.userDetails.phoneString = textField.text;
            break;
        case 3:
            self.userDetails.emailString = textField.text;
            break;
        case 4:
            self.userDetails.zipCodeString = textField.text;
            break;
            
        default:
            break;
    }
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TextField *field = (TextField *)textField;
    
    if (textField.tag == 100)
        [textField resignFirstResponder];
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        MDAccountDetailsCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:field.indexPath.row + 1 inSection:0]];
        [nextCell.userDetailTextField becomeFirstResponder];
        
    } else
        [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    
    TextField *txtField = (TextField *)textField;
    
    if (!(textField.tag == 100)) {
            if (txtField.indexPath.row == 2)
        return (txtField.text.length > 14 && range.length == 0)? NO : YES;
}
    return YES;
    
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDAccountDetailsCell *cell = (MDAccountDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.userDetailTextField.returnKeyType = UIReturnKeyNext;
    [cell.userDetailTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [cell.userDetailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    [cell.userDetailTextField setIndexPath:indexPath];
    cell.rightArrowButton.hidden = YES;
    
    if (self.isEdit == YES)
        cell.userDetailTextField.userInteractionEnabled = YES;
    else
        cell.userDetailTextField.userInteractionEnabled = NO;
    
    switch (indexPath.row) {
        case 0: cell.userDetailTextField.placeholder = @"Full Name";
                cell.userDetailTextField.text = self.userDetails.fullNameString;
                cell.userDetailTextField.returnKeyType = UIReturnKeyDone;

            break;
            
        case 1:
            cell.userDetailTextField.placeholder = @"Password";
            cell.userDetailTextField.userInteractionEnabled = NO;
            cell.rightArrowButton.hidden = NO;
            cell.userDetailTextField.text = @"qqqqqq";
                [cell.userDetailTextField setSecureTextEntry:YES];
            break;
            
        case 2: cell.userDetailTextField.placeholder = @"Phone Number";
                cell.userDetailTextField.text = self.userDetails.phoneString;
                [cell.userDetailTextField setKeyboardType:UIKeyboardTypePhonePad];
                [cell.userDetailTextField setInputAccessoryView:[self getToolBarForNumberPad]];
            break;
            
        case 3: cell.userDetailTextField.placeholder = @"Email";
                cell.userDetailTextField.text = self.userDetails.emailString;
                [cell.userDetailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
 
            break;
            
        case 4: cell.userDetailTextField.placeholder = @"Zip Code";
                cell.userDetailTextField.text = self.userDetails.zipCodeString;
               [cell.userDetailTextField setKeyboardType:UIKeyboardTypePhonePad];
               [cell.userDetailTextField setInputAccessoryView:[self getToolBarForNumberPad]];
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
    
        MDChangePasswordVC *changePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDChangePasswordVC"];
        [self.navigationController pushViewController: changePasswordVC animated:YES];
    }
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.userImageView setImage:image];
    
    self.userDetails.profileImage = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Web Api Section

- (void)apiCallViewProfile {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT stringForKey:p_id] forKey:pUserID];
    
    [ServiceHelper request:dict apiName:kAPIGetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                self.userDetails = [UserInfo userDetail:[resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]]];
                
                [self.userImageView sd_setImageWithURL:self.userDetails.photoURL placeholderImage:[UIImage imageNamed:@"user"]];
                [self.userImageView setContentMode:UIViewContentModeScaleToFill];

                self.userNameTextField.text = self.userDetails.userNameString;
                
                [self.pushNotification setOn:self.userDetails.notificationStatus];
                [self.tableView reloadData];
            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiToEditProfile {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSUSERDEFAULT stringForKey:p_id] forKey:pUserID];
    [dict setValue:self.userDetails.emailString forKey:pEmail];
    [dict setValue:self.userDetails.fullNameString forKey:pFullName];
    [dict setValue:self.userDetails.userNameString forKey:pUserName];
    [dict setValue:self.userDetails.phoneString forKey:pPhone];
    [dict setValue:self.userDetails.passwordString forKey:pPassword];
    (self.userDetails.notificationStatus) ? [dict setValue:@"true" forKey:pPushNotification] : [dict setValue:@"false" forKey:pPushNotification];
    [dict setValue:@"diner" forKey:pType];

    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:self.userDetails.zipCodeString forKey:pZipCode];
    [dict setValue:addressDict forKey:pAddress];

    [dict setValue:[self.userDetails.profileImage getBase64StringWithQuality:0.1] forKey:pPhoto];
    
    [ServiceHelper request:dict apiName:kAPISetUserProfile method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [AlertController title:responseMessage];
                
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
