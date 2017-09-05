//
//  MDChangePasswordVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 20/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDChangePasswordVC.h"
#import "Macro.h"

@interface MDChangePasswordVC ()

@property (weak, nonatomic) IBOutlet TextField *oldPasswordTextField;

@property (weak, nonatomic) IBOutlet TextField *passwordNewTextField;

@property (weak, nonatomic) IBOutlet TextField *confirmPasswordTextField;

@end

@implementation MDChangePasswordVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private Methods

-(BOOL)validateOnSaveButton {
    
    BOOL isAllValid = YES;
    
    if (![TRIM_SPACE([self.oldPasswordTextField text]) length]) {
        [AlertController title:@BLANK_OLD_PASSWORD];
        return NO;
    } else if (!([TRIM_SPACE([self.oldPasswordTextField text]) length] > 5)) {
        [AlertController title:@VALID_OLD_PASSWORD];
        return NO;
    } else if (![TRIM_SPACE([self.passwordNewTextField text]) length]) {
        [AlertController title:@BLANK_NEW_PASSWORD];
        return NO;
    } else if (!([TRIM_SPACE([self.passwordNewTextField text]) length] > 5)) {
        [AlertController title:@VALID_NEW_PASSWORD];
        return NO;
    } else if (![TRIM_SPACE([self.confirmPasswordTextField text]) length]) {
        [AlertController title:@BLANK_CONFIRM_PASSWORD];
        return NO;
    }  else if (![[self.passwordNewTextField text] isEqualToString:[self.confirmPasswordTextField text]]) {
        [AlertController title:@PASSWORD_CONFIRM_PASSWORD_NOT_MATCH];
        return NO;
    }

    return isAllValid;
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    
    if (textField.tag == 100)
        return (self.oldPasswordTextField.text.length > 14 && range.length == 0)? NO : YES;
    
    if (textField.tag == 101)
        return (self.passwordNewTextField.text.length > 14 && range.length == 0)? NO : YES;
    
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    TextField *field = (TextField *)textField;
    field.active = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TextField *field = (TextField *)textField;
    field.active = NO;
}

#pragma mark - UIButtonAction

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateOnSaveButton]) {
        
        //[self callApiForChangePassword];
        
        [AlertController title:@"Password changed successfully !" message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - Web Api Section

- (void)callApiForChangePassword {
    
    NSString *md5 = [self.passwordNewTextField.text MD5String]; // returns NSString of the MD5 of test
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pUserID];
    [dict setValue:[self.oldPasswordTextField text] forKey:pPassword];
    [dict setValue:md5 forKey:@"newPassword"];
    
    [ServiceHelper request:dict apiName:kAPIChangePassword method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                [AlertController title:responseMessage message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
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
