//
//  MDRefundAmount_CanceledOrderVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDRefundAmount_CanceledOrderVC.h"
#import "Macro.h"

static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";

@interface MDRefundAmount_CanceledOrderVC ()

@property (weak, nonatomic) IBOutlet UITableView            *tableView;

@property (weak, nonatomic) IBOutlet UILabel                *navigationBarTitleLabel;
@property (weak, nonatomic) IBOutlet AHTextView             *resonTextView;
@property (weak, nonatomic) IBOutlet UIImageView            *dishImageView;

@property (weak, nonatomic) IBOutlet UIButton               *canelMealButton;
@property (weak, nonatomic) IBOutlet UIButton               *sendRequestButton;

@property (strong, nonatomic) NSArray                       *titleArray;
@property (strong, nonatomic) NSArray                       *dummyDetailArray;

@end

@implementation MDRefundAmount_CanceledOrderVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Private Methods

-(void)initialSetup {
    //MealDetails *mealObj = [[MealDetails alloc] init];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.rowHeight = 44;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    if (self.contentType == Refund_Amount) {
        self.navigationBarTitleLabel.text = @"Refund Amount" ;
        self.canelMealButton.hidden = YES;
        self.sendRequestButton.hidden = NO;
        self.resonTextView.placeholderText = @"Reason for refund";

    }
    else {
        self.navigationBarTitleLabel.text = @"Cancelled Order";
        self.canelMealButton.hidden = NO;
        self.sendRequestButton.hidden = YES;
        self.resonTextView.placeholderText = @"Reason for cancellation";
    }
    
    //Tittle Array initialization
    self.titleArray = @[@"Dish Name", @"Price", @"Ordered On"];
    
    // dummy detail array
    self.dummyDetailArray = @[@"Chicken", @"$5", @"10 Jan"];
}

#pragma mark - UIButton Actions

- (IBAction)backbuttonaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelMealButtonAction:(id)sender {
    
//    [AlertController title:@"Your order cancelled successfully." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}

- (IBAction)sendRequestButtonAction:(id)sender {
    [self callApiForCancelRequest];
      //  [AlertController title:@"Your request for refund amount is sent successfully." message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
     //   [self.navigationController popViewControllerAnimated:YES];
    //}];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.detailLabel.text = [self.dummyDetailArray objectAtIndex:indexPath.row];
    
    return cell;
}

// Web API For Cancel Future Order

- (void)callApiForChefCancelFutureOrder {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    [dict setValue:self.strMealId forKey:@"mealId"];
    [dict setValue:self.resonTextView.text forKey:@"reason"];

    [ServiceHelper request:dict apiName:kAPIChefCancelFutureOrder method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web API Helper Methods

-(void)callApiForCancelRequest{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   // CanceledOrderDetail *cancelOrderObj = [[CanceledOrderDetail alloc] init];
    [dict setObject:@"152551" forKey:pMealId];
    [dict setObject:@"52635623" forKey:pChefId];
    [dict setObject:self.resonTextView.text forKey:pReason];
    [ServiceHelper request:dict apiName:kAPIChefCancelFutureOrder method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                MDRequestVC *requestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRefundAmount_CanceledOrderVC"];
                [self.navigationController pushViewController: requestVC animated:YES];

            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];

}

@end
