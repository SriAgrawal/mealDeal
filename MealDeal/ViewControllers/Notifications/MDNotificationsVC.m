//
//  MDNotificationsVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 08/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDNotificationsVC.h"
#import "Macro.h"

static NSString *cellIdentifier1 = @"MDNotification5LabelCell";
static NSString *cellIdentifier2 = @"MDNotification3LabelCell";
static NSString *cellIdentifier3 = @"MDNotification2LabelCell";

@interface MDNotificationsVC ()

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) NSArray                   *dummyNatificatiuonStatusArray;

@end

@implementation MDNotificationsVC

#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;

//    self.tableView.rowHeight = 110;
//    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //Tittle Array initialization
    self.dummyNatificatiuonStatusArray = @[@"Refund to your wallet", @"New Deal", @"Chat Message", @"Deal Completed", @"Cancelled Order", @"New Quoted Price", @"Deal Accepted"];
}

- (IBAction)backButtonAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}


#pragma mark - UITableView Datasource/Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 4)
        return 145.0f; // textView cell
    else if (indexPath.row == 2)
        return 110.0f;
    else
        return 85.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 4) {
        
        MDNotification5LabelCell *cell = (MDNotification5LabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        
        cell.notificationStatusNameLabel.text = [self.dummyNatificatiuonStatusArray objectAtIndex:indexPath.row];
        
        return cell;
        
    } else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6){
        
        MDNotification2LabelCell *cell = (MDNotification2LabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
        cell.notificationStatusNameLabel.text = [self.dummyNatificatiuonStatusArray objectAtIndex:indexPath.row];

        return cell;
        
    } else {
        
        MDNotification3LabelCell *cell = (MDNotification3LabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        
        cell.notificationStatusNameLabel.text = [self.dummyNatificatiuonStatusArray objectAtIndex:indexPath.row];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDel.isFromCook){
      
       if(indexPath.row == 5){
            MDQuoteNewPriceVC *quotePrice = [self.storyboard instantiateViewControllerWithIdentifier:@"MDQuoteNewPriceVC"];
            [self.navigationController pushViewController:quotePrice animated:YES];
        }
        
    } else{
        
        if (indexPath.row == 0 || indexPath.row == 4) {
            MDRefundAmount_CanceledOrderVC *refundAmount_CanceledOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRefundAmount_CanceledOrderVC"];
            [self.navigationController pushViewController: refundAmount_CanceledOrderVC animated:YES];
            
            if (indexPath.row == 0)
                refundAmount_CanceledOrderVC.contentType = Refund_Amount;
            else
                refundAmount_CanceledOrderVC.contentType = Canceled_Order;
        } else if (indexPath.row == 5) {
            MDNewQuotedPriceVC *newQuotedPriceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDNewQuotedPriceVC"];
            [self.navigationController pushViewController: newQuotedPriceVC animated:YES];
            
        } else if (indexPath.row == 1) {
            MDNewOrderRequestVC *newOrderRequestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDNewOrderRequestVC"];
            [self.navigationController pushViewController: newOrderRequestVC animated:YES];
        
        } else if (indexPath.row == 6) {
            MDCustomOrderVC *customOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCustomOrderVC"];
            customOrderVC.isDealAccepted = YES;
            [self.navigationController pushViewController: customOrderVC animated:YES];
        }
    }
}

#pragma mark - Web Api Section

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
