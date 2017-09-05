//
//  MDRoleSelectPopUpVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 18/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

typedef enum loginContent {
    Facebook,
    Google,
    Pintrest,
    LinkedIn
} loginType;

#import <UIKit/UIKit.h>

typedef void (^RoleSelectionBlock) (NSString * role);

@interface MDRoleSelectPopUpVC : UIViewController

@property (nonatomic) loginType contentType;

- (void)showRoleSelectionPopUp:(loginType )type completionBlock:(RoleSelectionBlock)block;

@end
