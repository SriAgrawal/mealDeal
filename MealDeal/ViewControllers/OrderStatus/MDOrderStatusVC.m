//
//  MDOrderStatusVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 25/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDOrderStatusVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDOrderStatusCell";

@interface MDOrderStatusVC (){
    NSMutableArray *orderStatusDataArray;
    RequestMealModal *orderStatusData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MDOrderStatusVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;
    orderStatusDataArray = [[NSMutableArray alloc] init];
    orderStatusData = [[RequestMealModal alloc] init];
   
  [self callApiForOrderStatus];
}

#pragma mark - UIButton Selector Methods

-(void) chatButtonSelector :(IndexPathButton *)button {
    
    MDChatVC *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDChatVC"];
    chatVC.strReciverId = [NSUSERDEFAULT valueForKey:p_id];
    [self.navigationController pushViewController: chatVC animated:YES];

}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [orderStatusDataArray count]; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    orderStatusData = [orderStatusDataArray objectAtIndex:indexPath.row];
    
    MDOrderStatusCell *cell = (MDOrderStatusCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.chatButton.hidden = YES;
    [cell.chatButton setIndexPath:indexPath];
    
    [cell.chatButton addTarget:self action:@selector(chatButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    if([orderStatusData.strOrderStatusMealStatus isEqualToString:@"Accepted"]){
        cell.chatButton.hidden = NO;
        [cell.bottomImageView setImage:[UIImage imageNamed:@"green_img"]];
        [cell.orderStatusButton setTitle:@"Accepted" forState:UIControlStateNormal];
        [cell.orderStatusButton setImage:[UIImage imageNamed:@"accept_icoN"] forState:UIControlStateNormal];
    }
    else if ([orderStatusData.strOrderStatusMealStatus isEqualToString:@"Pending"]){
        
        [cell.bottomImageView setImage:[UIImage imageNamed:@"yellow_img"]];
        [cell.orderStatusButton setTitle:@"Pending" forState:UIControlStateNormal];
        [cell.orderStatusButton setImage:[UIImage imageNamed:@"pending_icon_yellow"] forState:UIControlStateNormal];
        cell.paymentTypeLabel.text = @"COD/Paypal";
    } else if ([orderStatusData.strOrderStatusMealStatus isEqualToString:@"Rejected"]) {
        [cell.bottomImageView setImage:[UIImage imageNamed:@"red_img"]];
        [cell.orderStatusButton setTitle:@"Rejected" forState:UIControlStateNormal];
        [cell.orderStatusButton setImage:[UIImage imageNamed:@"pending_icon_yellow"] forState:UIControlStateNormal];
        
        cell.paymentTypeLabel.text = @"COD/Paypal";

    }
    
    cell.chefNameLabel.text = ([orderStatusData.strOrderStatusChefName isEqualToString:@""]) ? @"None" : orderStatusData.strOrderStatusChefName;
    cell.dishNameLabel.text = orderStatusData.strOrderStatusDishName;
    [cell.mealImageView sd_setImageWithURL:orderStatusData.photoURL placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [cell.mealImageView setContentMode:UIViewContentModeScaleToFill];

    cell.orderTimeLabel.text = orderStatusData.strOrderStatusOrderTime;
    cell.pickUpTimeLabel.text = [NSString stringWithFormat:@"%@, %@", orderStatusData.strOrderStatusPickUptime,orderStatusData.strOrderStatusPickUpDate];

/*   [cell.bottomImageView setImage:[UIImage imageNamed:@"green_img"]];
    if (indexPath.row == 1) {
        
        cell.chatButton.hidden = YES;

        [cell.orderStatusButton setTitle:@"Pending" forState:UIControlStateNormal];
        [cell.orderStatusButton setImage:[UIImage imageNamed:@"pending_icon_yellow"] forState:UIControlStateNormal];
        [cell.bottomImageView setImage:[UIImage imageNamed:@"yellow_img"]];
        
    }else{
        cell.chatButton.hidden = NO;
        
        [cell.orderStatusButton setTitle:@"Accepted" forState:UIControlStateNormal];
        [cell.orderStatusButton setImage:[UIImage imageNamed:@"accept_icoN"] forState:UIControlStateNormal];
        [cell.bottomImageView setImage:[UIImage imageNamed:@"green_img"]];
    }*/

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Web Api Section

- (void)callApiForOrderStatus {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    
    [ServiceHelper request:dict apiName:kAPIDinerOrderStatus method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
        
               orderStatusDataArray = [RequestMealModal getOrderStatusDataFromArray:[resultDict objectForKey:@"data"]];
                [self.tableView reloadData];
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
