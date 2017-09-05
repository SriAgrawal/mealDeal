//
//  MDLoginVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDLoginVC.h"
#import "Macro.h"

@interface MDLoginVC ()<GIDSignInUIDelegate,GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UIButton               *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton        *googleLoginButton;
@property (weak, nonatomic) IBOutlet UIButton               *loginButton;
@property (weak, nonatomic) IBOutlet UIButton               *rememberMeButton;

@property (weak, nonatomic) IBOutlet UIView                 *backgroundView;

@property (weak, nonatomic) IBOutlet TextField              *emailTextField;
@property (weak, nonatomic) IBOutlet TextField              *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton               *cookButton;
@property (weak, nonatomic) IBOutlet UIButton               *eatButton;
@property (weak, nonatomic) IBOutlet UIImageView            *semicircleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *bottomHieghtConstraint;

@property (strong, nonatomic) NSString                      *socialType;
@property (strong, nonatomic) NSString                      *role;

@end

@implementation MDLoginVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.cookButton.selected = NO;
    self.eatButton.selected = NO;
    
    [self showRemeberMe];
    
    if (IS_IPHONE_4_OR_LESS)
        [self.bottomHieghtConstraint setConstant:3];
    else if(IS_IPHONE_5)
        [self.bottomHieghtConstraint setConstant:10];
    else if(IS_IPHONE_6)
        [self.bottomHieghtConstraint setConstant:60];
    else if (IS_IPHONE_6P)
        [self.bottomHieghtConstraint setConstant:70];

    if ([self.userType isEqualToString:@"chef"]) {
        [self.navigationController pushViewController:[APPDELEGATE getSlidePanelChef] animated:NO];
    } else if([self.userType isEqualToString:@"diner"]) {
        MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
        locationVC.isCook = NO;
        locationVC.isAfterLogin = YES;
        locationVC.isBack = NO;
        [self.navigationController pushViewController: locationVC animated:NO];
    }
}

#pragma mark - Private Methods

- (void)initialSetup {
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [self.semicircleImageView color:RGBCOLOR(0, 0, 0, 0.85)];
}

// Validation Methods

- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(self.emailTextField.text) length]) {
        [AlertController title:@BLANK_USERNAME];
        return NO;
    } else if (![[self.emailTextField text] containsOnlyNumbersAndLetters] && ![[self.emailTextField text] isValidEmail]) {
        [AlertController title:@VALID_USERNAME];
        return NO;
    } else if (![TRIM_SPACE([self.passwordTextField text]) length]) {
        [AlertController title:@BLANK_PASSWORD];
        return NO;
    } else if (!([TRIM_SPACE([self.passwordTextField text]) length] > 5)) {
        [AlertController title:@VALID_PASSWORD];
        return NO;
    } else if (!(self.eatButton.selected == YES|| self.cookButton.selected == YES)) {
        [AlertController title:@BLANK_ROLE];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)doRememberMe {
    if (self.rememberMeButton.selected) {
        [NSUSERDEFAULT setObject:self.emailTextField.text forKey:pEmail];
        [NSUSERDEFAULT setObject:self.passwordTextField.text forKey:pPassword];
        if (self.cookButton.selected)
            [NSUSERDEFAULT setObject:@"chef" forKey:pRole];
        else if (self.eatButton.selected)
            [NSUSERDEFAULT setObject:@"diner" forKey:pRole];
    }
   // [self showRemeberMe];
}

- (void)showRemeberMe {
    
    if ([NSUSERDEFAULT objectForKey:pEmail] && [NSUSERDEFAULT objectForKey:pPassword]) {
        [self.emailTextField setText:[NSUSERDEFAULT objectForKey:pEmail]];
        [self.passwordTextField setText:[NSUSERDEFAULT objectForKey:pPassword]];
        if ([[NSUSERDEFAULT objectForKey:pRole] isEqual: @"chef"])
            self.cookButton.selected = YES;
        else
            self.eatButton.selected = YES;
        
        [self.rememberMeButton setSelected:YES];
    } else {
        [self.rememberMeButton setSelected:NO];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIButton Actions

- (IBAction)onRememberMe:(UIButton *)sender {
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
}

- (IBAction)onLoginWithFB:(UIButton *)sender {
    [self.view endEditing:YES];
    
    MDRoleSelectPopUpVC *roleSelectPopUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRoleSelectPopUpVC"];
    [roleSelectPopUpVC showRoleSelectionPopUp:Facebook completionBlock:^(NSString *role) {
        
        self.role = role;
        [self facebookLogin];
    }];
}

- (IBAction)onGoogleSignin:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
//    MDRoleSelectPopUpVC *roleSelectPopUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRoleSelectPopUpVC"];
//    [roleSelectPopUpVC showRoleSelectionPopUp:Facebook completionBlock:^(NSString *role) {
//        
//        self.role = role;
//        [self googleLogin];
//    }];
    
    [self googleLogin];

   }

- (IBAction)onLogin:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateAndEnableLoginButton]) {
        [self doRememberMe];
     
        [self callApiForLoginIn];
    }
}
- (IBAction)linkedInBtnAction:(id)sender {
    [self.view endEditing:YES];

    MDRoleSelectPopUpVC *roleSelectPopUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRoleSelectPopUpVC"];
    [roleSelectPopUpVC showRoleSelectionPopUp:Facebook completionBlock:^(NSString *role) {
        
        self.role = role;
        [self linkedInLogin];
    }];
    
}

- (IBAction)forgotPasswordButtonAction:(id)sender {
    [self.view endEditing:YES];
    MDForgotPasswordVC *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDForgotPasswordVC"];
    [self.navigationController pushViewController: forgotPasswordVC animated:YES];
}

- (IBAction)signUpButtonAction:(id)sender {
    [self.view endEditing:YES];

    MDSignupVC *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDSignupVC"];
    [self.navigationController pushViewController: signupVC animated:YES];
}

- (IBAction)cookButtonAction:(id)sender {
    self.cookButton.selected = YES;
    self.eatButton.selected = NO;
}

- (IBAction)eatButtonAction:(id)sender {
    self.eatButton.selected = YES;
    self.cookButton.selected = NO;
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordTextField becomeFirstResponder];
    } else
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    
    return (self.passwordTextField.text.length > 14 && range.length == 0)? NO : YES;
    
    return YES;

}

#pragma mark - Social Login Methods

- (void)facebookLogin {
    
    [FacebookLogin getFacebookInfoWithCompletionHandler:self completionBlock:^(NSDictionary *infoDict, NSError *error) {
        
        if (!error) {
            
            UserInfo *user = [[UserInfo alloc] init];
            user.fullNameString = [infoDict valueForKey:@"name"];
            user.emailString = [infoDict valueForKey:@"email"];
            
            NSDictionary *pictureDict = [infoDict objectForKeyNotNull:@"picture" expectedObj:[NSDictionary dictionary]];
            NSDictionary *dataDict = [pictureDict objectForKeyNotNull:@"data" expectedObj:[NSDictionary dictionary]];
            NSString *urlString = [dataDict objectForKeyNotNull:@"url" expectedObj:@""];
            
            user.photoURL = [NSURL URLWithString:urlString];
            user.socialIdString = [infoDict valueForKey:@"id"];
            self.socialType = @"Facebook";
            
            LogInfo(@"infoDict>>>   %@",infoDict);
            [self callSocialLogInIntegration:user];
            
        } else {
            
            LogInfo(@"infoDict>>>   %@",error);
            
            NSString *errorString = error.localizedDescription;
            
            if (!errorString.length) {
                errorString = @"Error! Please try again.";
            }
            [AlertController message:errorString];
        }
        
        
        [self.view setUserInteractionEnabled:YES];
    }];
    
}

- (void)googleLogin {
    
   // [[GIDSignIn sharedInstance] signIn];
    
    [[GooglePlusLogin sharedManager] getGooglePlusInfoWithCompletionHandler:self didSignIn:^(NSDictionary *infoDict, NSError *error) {
        
        if (!error) {
            
            LogInfo(@"infoDict>>>   %@",infoDict);
            
            UserInfo *user = [[UserInfo alloc] init];
            
            user.fullNameString = [infoDict valueForKey:@"fullName"];
            user.emailString = [infoDict valueForKey:@"email"];
            user.socialIdString = [infoDict valueForKey:@"userId"];
            NSString *urlString = [infoDict valueForKey:@"profileImageURL"];
            user.photoURL = [NSURL URLWithString:urlString];
            
            self.socialType = @"Google+";
            [self callSocialLogInIntegration:user];
            
        } else {
            NSString *errorString = error.localizedDescription;
            
            if (!errorString.length) {
                errorString = @"Error! Please try again.";
            }
            LogInfo(@"infoDict>>>   %@",error);
            [AlertController message:errorString];
        }
    } didDisconnect:nil];
    
}

//Getting values

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    // Perform any operations on signed in user here.
    UserInfo *userobj = [[UserInfo alloc] init];

    userobj.emailString = user.profile.email;
    userobj.socialIdString = user.userID;
    userobj.fullNameString = user.profile.name;
    
    self.socialType = @"Google+";
    [self callSocialLogInIntegration:userobj];
    
    //    NSString *userId = user.userID;                  // For client-side use only!
    //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    //    NSString *fullName = user.profile.name;
    //    NSString *givenName = user.profile.givenName;
    //    NSString *familyName = user.profile.familyName;
    //    NSString *email = user.profile.email;
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)linkedInLogin {

    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
     {
         NSLog(@"%s","success called!");
         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
         NSLog(@"Session : %@", session.description);
     } errorBlock:^(NSError *error)
     {
         NSLog(@"%s","error called!");
     }];
    
    
    [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
                                        success:^(LISDKAPIResponse *response)
     {
         NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"Authenticated user name : %@ %@", [dictResponse valueForKey: @"firstName"], [dictResponse valueForKey: @"lastName"]);
     } error:^(LISDKAPIError *apiError)
     {
         NSLog(@"Error : %@", apiError);
     }];

}



// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    // [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Web Api Section

- (void)callApiForLoginIn {
    
    NSString *md5 = [self.passwordTextField.text MD5String]; // returns NSString of the MD5 of test
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.emailTextField.text forKey:pEmail];
    [dict setValue:md5 forKey:pPassword];
    (self.cookButton.selected) ? [dict setValue:@"chef" forKey:pType] : [dict setValue:@"diner" forKey:pType];
    (self.cookButton.selected) ? [NSUSERDEFAULT setValue:@"chef" forKey:pRole] : [NSUSERDEFAULT setValue:@"diner" forKey:pRole];

    [dict setValue:kDeviceType forKey:pDeviceType];
    [dict setValue:[NSUSERDEFAULT objectForKey:pDevice_token] forKey:pDevice_token];
    
    [ServiceHelper request:dict apiName:kAPILogin method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *userInfoDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                NSString *userId = [userInfoDict objectForKeyNotNull:p_id expectedObj:@""];
                NSString *userName = [userInfoDict objectForKeyNotNull:pUserName expectedObj:@""];
                NSString *userImage = [userInfoDict objectForKeyNotNull:@"image" expectedObj:@""];
                [NSUSERDEFAULT setObject:userId forKey:p_id];
                [NSUSERDEFAULT setObject:userName forKey:pUserName];
                [NSUSERDEFAULT setObject:userImage forKey:@"userImage"];
                if(self.cookButton.selected){
                    [APPDELEGATE setIsFromCook:YES];
                    [self.navigationController pushViewController:[APPDELEGATE getSlidePanelChef] animated:YES];
                } else {
                    
                    [APPDELEGATE setIsFromCook:NO];

                    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
                    locationVC.isCook = NO;
                    locationVC.isAfterLogin = YES;
                    locationVC.isBack = NO;
                    [self.navigationController pushViewController: locationVC animated:YES];

                }
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callSocialLogInIntegration:(UserInfo *)user {
    
    NSString *md5 = [user.passwordString MD5String]; // returns NSString of the MD5 of test
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:user.emailString forKey:pEmail];
    [dict setValue:user.fullNameString forKey:pFullName];
    [dict setValue:(user.passwordString)?md5:@"" forKey:pPassword];
    [dict setValue:user.socialIdString forKey:pSocialId];
    [dict setValue:self.socialType forKey:pSocialType];
    [dict setValue:kDeviceType forKey:pDeviceType];
    [dict setValue:[NSUSERDEFAULT objectForKey:pDevice_token] forKey:pDevice_token];
    
    ([self.role isEqualToString:@"chef"]) ? [dict setValue:@"chef" forKey:pType] : [dict setValue:@"diner" forKey:pType];
    [dict setValue:[NSString stringWithFormat:@"%@", user.photoURL] forKey:pPhoto];
    
    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:(user.countryString)?(user.countryString):@"" forKey:pCountry];
    [addressDict setValue:(user.stateString)?(user.stateString):@"" forKey:pState];
    [addressDict setValue:(user.cityString)?(user.cityString):@"" forKey:pCity];
    [addressDict setValue:(user.zipCodeString)?(user.zipCodeString):@"" forKey:pZipCode];
    [addressDict setValue:(user.descriptionString)?(user.descriptionString):@"" forKey:pStreetName];
    
    [dict setValue:addressDict forKey:pAddress];
    
    [ServiceHelper request:dict apiName:kAPILoginSocial method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *userInfoDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                NSString *userId = [userInfoDict objectForKeyNotNull:p_id expectedObj:@""];
                
                [NSUSERDEFAULT setObject:userId forKey:p_id];
                
                if([self.role isEqualToString:@"chef"]){
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
