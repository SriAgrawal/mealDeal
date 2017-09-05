//
//  Macro.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define KTextField(tag)             (UITextField*)[self.view viewWithTag:tag]
#define KTextView(tag)               (UITextView*)[self.view viewWithTag:tag]


#define KButton(tag)                (UIButton *)[self.view viewWithTag:tag]
#define windowWidth                 [UIScreen mainScreen].bounds.size.width
#define windowHeight                [UIScreen mainScreen].bounds.size.height

#define KNSLOCALIZEDSTRING(key)     NSLocalizedString(key, nil)

#define APPDELEGATE                 (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mainStoryboard              [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define NSUSERDEFAULT               [NSUserDefaults standardUserDefaults]

#define AppColor                    [UIColor colorWithRed:170.0/255.0f green:42.0/255.0f blue:24.0/255.0f alpha:1.0f]
#define AppFont(X)                  [UIFont fontWithName:@"RockwellStd" size:X]

#define DEGREES_TO_RADIANS(degrees) (M_PI * (degrees) / 180.0)

//log label

#define LOG_LEVEL           1

#define LogInfo(frmt, ...)                 if(LOG_LEVEL) NSLog((@"%s" frmt), __PRETTY_FUNCTION__, ## __VA_ARGS__);

#define RGBCOLOR(r,g,b,a)               [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define TRIM_SPACE(str)                 [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]


//Device Check
#define SCREEN_MAX_LENGTH (MAX(windowWidth, windowHeight))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


/****************** Validation Alerts ****************************/
#define             BLANK_NAME                                  "Please enter name."
#define             BLANK_EMAIL                                 "Please enter email."
#define             BLANK_USERNAME                              "Please enter username."
#define             BLANK_PASSWORD                              "Please enter password."
#define             BLANK_REVIEW                                "Please enter review."
#define             BLANK_Need_Help                             "Please enter your query."
#define             BLANK_ROLE                                  "Please select role."
#define             VALID_EMAIL                                 "Please enter a valid email."
#define             VALID_USERNAME                              "Please enter a valid username."
#define             VALID_PHONE                                 "Please enter a valid phone number"
#define             BLANK_PHONE                                 "Please enter phone number."
#define             BLANK_ADDRESS                               "Please enter address."
#define             BLANK_OLD_PASSWORD                          "Please enter old password."
#define             BLANK_NEW_PASSWORD                          "Please enter new password."
#define             BLANK_CONFIRM_PASSWORD                      "Please enter confirm password."
#define             VALID_PASSWORD                              "Password must contain 6 to 15 characters."
#define             VALID_OLD_PASSWORD                          "Old password must contain at least 6 to 15 characters."
#define             VALID_NEW_PASSWORD                          "New password must contain at least 6 to 15 characters."
#define             PASSWORD_CONFIRM_PASSWORD_NOT_MATCH         "New password and confirm new password do not match."

#pragma mark - Frameworks

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <linkedin-sdk/LISDK.h>
#import <Google/SignIn.h>
#import <MobileCoreServices/UTCoreTypes.h>


//#import <Social/Social.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import <SDWebImage/UIImageView+WebCache.h>

#pragma mark - Modal Classes

#import "UserInfo.h"
#import "ErrorModal.h"
#import "ChatModal.h"
#import "RequestMealModal.h"
#import "MealDetails.h"
#import "LocationModal.h"
#import "CookReviewsModal.h"
#import "CartModal.h"
#import "CanceledOrderDetail.h"

////////////////// Chef //////////////////////////
#import "CookSettingsModal.h"
#import "CookPrepareAMealModal.h"

#pragma mark - External Classes

#import "JASidePanelController.h"
#import "HCSStarRatingView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CarbonKit.h"
#import "MWPhotoBrowser.h"
#import "EXPhotoViewer.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "CountryPicker.h"

#pragma mark - Web Services Helper Classes

#import "ApiConstants.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ServiceHelper.h"

#pragma mark - Sub Classes

#import "IndexPathButton.h"
#import "TextField.h"
#import "GradientView.h"
#import "AHTextView.h"

#pragma mark - Category Classes

#import "NSString+Addition.h"
#import "UIView+Addition.h"
#import "UIViewController+Addition.h"
#import "UIImageView+Addition.h"
#import "UIImage+Addition.h"
#import "NSDictionary+APIAddition.h"
#import "NSDate+Addition.h"
#import "UIButton+Addition.h"

#pragma mark - Utility Files

#import "AppDelegate.h"
#import "AppUtility.h"
#import "GooglePlusLogin.h"
#import "ApiConstants.h"
#import "FacebookLogin.h"
#import "AlertController.h"
#import "OptionPickerManager.h"
#import "DatePickerManager.h"

#pragma mark - View Controllers

//////////////////////////// Diner ///////////////////////////

#import "MDLoginVC.h"
#import "MDSignUpVC.h"
#import "MDForgotPasswordVC.h"
#import "MDTermsAndConditionVC.h"
#import "MDChangePasswordVC.h"
#import "MDSlideMenuVC.h"
#import "MDRoleSelectPopUpVC.h"

// Common View Controller
#import "MDSpecial_Surprise_NutritionVC.h"
#import "MDDetalisVC.h"
#import "MDCustomOrderVC.h"
#import "MDFutureOrderVC.h"

// Healthy Meals ViewControllers
#import "MDLocationVC.h"
#import "MDHealthyMealVC.h"
#import "MDHealthyMealDetailVC.h"
#import "MDHealthyMealCustomOrderVC.h"

// Order ViewControllers
#import "MDOrderStatusBaseVC.h"
#import "MDOrderStatusVC.h"
#import "MDOrderHistoryVC.h"

// Settings ViewControllers
#import "MDSettingsBaseVC.h"
#import "MDAccountDetailsVC.h"
#import "MDPreferenceVC.h"

// Reviews ViewControllers
#import "MDReviewVC.h"
#import "MDCookReviewsVC.h"

// Chat ViewController
#import "MDChatVC.h"

// Notification Viewcontroller

#import "MDNotificationsVC.h"
#import "MDNewQuotedPriceVC.h"
#import "MDRefundAmount_CanceledOrderVC.h"
#import "MDNewOrderRequestVC.h"

#import "MDNeedHelpVC.h"
#import "MDCartVC.h"
#import "MDCustomMealVC.h"

#pragma mark - UITableViewCells

#import "MDInputFieldsCell.h"
#import "MDSlideMenuCell.h"
#import "MDTitleDetailLabelCell.h"
#import "MDHomeCell.h"
#import "MDTitleRatingCell.h"
#import "MDHealthyMealCell.h"
#import "MDOrderStatusCell.h"
#import "MDOrderHistoryCell.h"
#import "MDAccountDetailsCell.h"
#import "MDCookReviewsCell.h"
#import "MDCartViewCell.h"

#import "MDCustomMealCell.h"

#import "MDChatSenderCell.h"
#import "MDChatRecieverCell.h"

#import "MDNotification3LabelCell.h"
#import "MDNotification5LabelCell.h"
#import "MDNotification2LabelCell.h"


#pragma mark - UICollectionViewCells
#import "MDBannerImageCollectionViewCell.h"


// Cook Section View Controllers

#import "ViewController.h"
#import "MDTodayOrderCell.h"
#import "MDRequestsVC.h"
#import "MDRequestVC.h"
#import "MDDealRequestCell.h"
#import "MDRequestCell.h"
#import "MDQuoteNewPriceVC.h"
#import "MDQuoteNewPriceCell.h"
#import "MDReviewsVC.h"
#import "MDReviewsCell.h"
#import "MDSettingsVC.h"
#import "MDSettingsCell.h"
#import "MDSettingsSectionHeaderCell.h"
#import "MDSettingsUpdateAddressCell.h"
#import "MDCookOrderHistoryVC.h"
#import "MDCookOrderHistoryCell.h"
#import "MDFutureOrdersCell.h"
#import "MDCookHealthyMealVc.h"
#import "MDCookHealthyMealCell.h"
#import "MDRegularMealersVC.h"
#import "MDRegularMealersDataCell.h"
#import "MDRegularMealersSectiohHeaderCell.h"
#import "MDMenuVC.h"
#import "MDMenuCell.h"
#import "MDMealHeaderCell.h"
#import "MDMyRegularMealVC.h"
#import "MDRegularMealDataCell.h"
#import "MDRegularMealImageCell.h"
#import "MDRegularMealTodaySpecialCell.h"
#import "MDImageAttachmentCell.h"
#import "MDPrepareAMealVC.h"
#import "MDSpiceLevelCell.h"
#import "MDTextFieldCell.h"
#import "MDTextViewCell.h"

#pragma mark - Web API Helper Class

#import "NSDictionary+NullChecker.h"



#endif /* Macro_h */
