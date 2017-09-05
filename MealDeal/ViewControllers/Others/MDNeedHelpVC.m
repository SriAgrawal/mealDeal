//
//  MDNeedHelpVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 28/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDNeedHelpVC.h"
#import "Macro.h"

@interface MDNeedHelpVC ()

@property (weak, nonatomic) IBOutlet UIButton               *adminButton;
@property (weak, nonatomic) IBOutlet UIButton               *chefButton;
@property (weak, nonatomic) IBOutlet UIButton               *helpMeButton;

@property (weak, nonatomic) IBOutlet UITextView             *detailTextView;

@property (weak, nonatomic) IBOutlet UIView                 *navigationBarView;
@property (weak, nonatomic) IBOutlet UITableView            *tableView;

@property (strong, nonatomic) NSArray                       *dummyNeedHelpArray;

@end

@implementation MDNeedHelpVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self tapGestureMethod];

}

#pragma mark - Private Methods

- (void)initialSetup {
    self.dummyNeedHelpArray = @[@"Help with a Meal", @"Help with the charge on the Card Meal", @"Other"];
    self.adminButton.selected = YES;
    
    if (self.isPopUp)
        self.navigationBarView.hidden = YES
        ;
    else
       self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.alwaysBounceVertical = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     if(self.isPopUp)
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    if(self.isPopUp)
        [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)validateOnSendButton {
    
    BOOL isValid = YES;
    
    if (![TRIM_SPACE(self.detailTextView.text) length]) {
        [AlertController title:@BLANK_Need_Help];
        return NO;
    }
    return isValid;
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
     [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)helpMeButtonAction:(id)sender {
   
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:self.dummyNeedHelpArray completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes   %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        
        [self.helpMeButton setTitle:selectedValues.firstObject forState:UIControlStateNormal];
    }];
}

- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];

    if ([self validateOnSendButton]) {
        
        [self callApiForNeedHelp];
//        [AlertController title:@"Query sent successfully." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//            if(self.isPopUp)
//        [self dismissViewControllerAnimated:YES completion:nil];
//         }];
    }
}

- (IBAction)adminButtonAction:(id)sender {
    self.adminButton.selected = YES;
    self.chefButton.selected = NO;

}

- (IBAction)chefButtonAction:(id)sender {
    self.chefButton.selected = YES;
    self.adminButton.selected = NO;
}

#pragma mark - Web Api Section

- (void)callApiForNeedHelp {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.detailTextView.text forKey:pText];
    (self.chefButton.selected) ? [dict setValue:@"chef" forKey:pHelpFrom] : [dict setValue:@"admin" forKey:pHelpFrom];
    [dict setValue:[APPDELEGATE chefId] forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPINeedHelp method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [AlertController title:@"Query sent successfully." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    if(self.isPopUp)
                        [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
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
