//
//  MDRoleSelectPopUpVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 18/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDRoleSelectPopUpVC.h"
#import "Macro.h"

@interface MDRoleSelectPopUpVC ()

@property (weak, nonatomic) IBOutlet UIButton *chefButton;
@property (weak, nonatomic) IBOutlet UIButton *dinnerButton;
@property (weak, nonatomic) IBOutlet UILabel *chooseRoleLabel;

@property (strong, nonatomic) NSString *socialType;
@property (nonatomic, strong) RoleSelectionBlock completionBlock;

@end

@implementation MDRoleSelectPopUpVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private Methods

- (id)getRootController {
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    }
    return rootViewController;
}

- (void)showRoleSelectionPopUp:(loginType)type completionBlock:(RoleSelectionBlock)block {
    
    self.completionBlock = block;
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[self getRootController] presentViewController:self animated:YES completion:nil];
    
    self.contentType = type;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIButton Actions

- (IBAction)chefButtonAction:(id)sender {
    self.chefButton.selected = YES;
    self.dinnerButton.selected = NO;
    [self.chooseRoleLabel setTextColor:[UIColor blackColor]];

}

- (IBAction)dinnerButtonAction:(id)sender {
    self.dinnerButton.selected = YES;
    self.chefButton.selected = NO;
    [self.chooseRoleLabel setTextColor:[UIColor blackColor]];

}

- (IBAction)loginButtonAction:(id)sender {
    
    if (self.chefButton.selected || self.dinnerButton.selected) {
        
        if(self.chefButton.selected)
            self.completionBlock(@"chef");
        else
            self.completionBlock(@"diner");

        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        
        [self.chooseRoleLabel setTextColor:[UIColor redColor]];
        
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
