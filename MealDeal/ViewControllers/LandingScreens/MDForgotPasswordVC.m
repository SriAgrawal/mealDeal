//
//  MDForgotPasswordVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDForgotPasswordVC.h"
#import "Macro.h"

@interface MDForgotPasswordVC ()

@property (weak, nonatomic) IBOutlet TextField *emailTextField;

@end

@implementation MDForgotPasswordVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private Methods

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)validateOnSumitButton {
  
    BOOL isAllValid = YES;
    
    if (![TRIM_SPACE(self.emailTextField.text) length] || ![self.emailTextField.text isValidEmail]) {
        isAllValid = NO;
        
        [AlertController title:![TRIM_SPACE(self.emailTextField.text) length] ? @BLANK_EMAIL : @VALID_EMAIL];
    }
     return isAllValid;
    
}

#pragma mark - UIButton Action

- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateOnSumitButton]) {
//        [AlertController title:@"Password sent to your registered email id." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
        [self callApiForForgotPassword];
        
    }
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Web Api Section

- (void)callApiForForgotPassword {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.emailTextField.text forKey:pEmail];
    
    [ServiceHelper request:dict apiName:kAPIForgotPassword method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                [AlertController title:@"Success!" message:responseMessage andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
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
