//
//  MDQuoteNewPriceVC.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDQuoteNewPriceVC.h"
#import "MDQuoteNewPriceCell.h"

@interface MDQuoteNewPriceVC ()<UITextFieldDelegate>{
    NSString *strYourQuotedText;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) ErrorModal                            *errorInfo;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;


@end

@implementation MDQuoteNewPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.imgUser.layer.cornerRadius  = self.imgUser.frame.size.width / 2;
    self.imgUser.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDQuoteNewPriceCell";
    
    MDQuoteNewPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               cellIdentifier];
    if (cell == nil) {
        cell = [[MDQuoteNewPriceCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.txtFieldYourQuoted.delegate = self;
    switch (indexPath.row) {
        case 0:{
            cell.lblUserChoices.text = @"Diner Quoted";
            cell.lblYourQuoted.text = @"40 $";
            cell.txtFieldYourQuoted.hidden = YES;
            cell.lblYourQuoted.hidden = NO;
        }
            break;
            
        case 1:{
            cell.lblUserChoices.text = @"You Quoted";
            cell.txtFieldYourQuoted.hidden = NO;
            [cell.txtFieldYourQuoted setUserInteractionEnabled:YES];
            cell.lblYourQuoted.hidden = YES;
        }
            break;
            
        case 2:{
            cell.lblUserChoices.text = @"Preparation Time";
            cell.lblYourQuoted.text = @"2 Hours";
            cell.txtFieldYourQuoted.hidden = YES;
            cell.lblYourQuoted.hidden = NO;
        }
            break;
            
        default:
            break;
    }
        
    return cell;
}



#pragma mark TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  //  TextField *txtField = (TextField *)textField;
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    strYourQuotedText = textField.text;
    }



#pragma mark Button Action Methods
- (IBAction)sendNewDealBtnAction:(id)sender {
    if ([self validateAndEnableLoginButton]) {
        
    }}


- (IBAction)menuBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Validation Method

// Validation Methods

- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(strYourQuotedText) length]) {
        [AlertController title:@"Please enter your quoted price."];
        return NO;
    }  else {
        return YES;
    }
}


@end
