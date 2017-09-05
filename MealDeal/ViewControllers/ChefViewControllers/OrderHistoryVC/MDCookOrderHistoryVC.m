//
//  MDOrderHistoryVC.m
//  MealDealApp
//
//  Created by Mohit on 05/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDCookOrderHistoryVC.h"

@interface MDCookOrderHistoryVC (){
    NSMutableArray *orderHistoryArray,*futureOrdersArray;
    CookSettingsModal *orderHistory;
}

@property (strong, nonatomic) IBOutlet UIButton *dateBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblOutstandingOrders;
@property (strong, nonatomic) IBOutlet UIButton *btnFutureOrders;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderHistory;
@property (strong, nonatomic) IBOutlet UILabel *lblFutureOrders;
@property (strong, nonatomic) IBOutlet UILabel *lblUpcomingOrders;

@property (strong, nonatomic) IBOutlet UIButton *btnOrderHistory;
@property (strong, nonatomic) IBOutlet UILabel *lblEarnings;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *viewOrderHistory;
@property (strong, nonatomic) IBOutlet UIView *viewFutureOrders;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *tblHeaderView;
@end

@implementation MDCookOrderHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnOrderHistory setSelected:YES];
    [self.btnOrderHistory setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
    orderHistoryArray = [[NSMutableArray alloc] init];
    futureOrdersArray = [[NSMutableArray alloc] init];
    orderHistory = [[CookSettingsModal alloc] init];
    [self callApiForOrderHistory];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.lblEarnings.layer.cornerRadius = 5.0f;
    self.lblOutstandingOrders.layer.cornerRadius = 5.0f;
    self.lblUpcomingOrders.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.btnFutureOrders.selected)
    return [futureOrdersArray count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    if(self.btnFutureOrders.selected){
        return 6;
    }else
        return [orderHistoryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.btnOrderHistory.selected)
    return 199.0;
    else if(self.btnFutureOrders.selected){
        if(indexPath.row == 0)
            return 259.0;
        else if(indexPath.row == 5)
            return 70.0f;
        else
            return 63.0f;
    }
    return 0.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    if(self.btnOrderHistory.selected){
        [self.tblHeaderView setFrame:CGRectMake(0, 0, 375, 311)];
    orderHistory = [orderHistoryArray objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"MDCookOrderHistoryCell";
    MDCookOrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
    if (cell == nil) {
        cell = [[MDCookOrderHistoryCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
         cell.lblHistoryOrderDate.text = [NSString stringWithFormat:@"%@",[AppUtility timestamp2date:orderHistory.strOrderHistoryDate]];
        [cell.imagHistoryOrder sd_setImageWithURL:[NSURL URLWithString:orderHistory.strOrderHistoryImageUrl]];
        
    return cell;
    }else if (self.btnFutureOrders.selected){
        orderHistory = [futureOrdersArray objectAtIndex:indexPath.section];
        if(indexPath.row == 0){
            static NSString *cellIdentifier = @"MDFutureOrdersCellMealImage";
            MDFutureOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        cellIdentifier];
            if (cell == nil) {
                cell = [[MDFutureOrdersCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.chefFutureOrderImage sd_setImageWithURL:[NSURL URLWithString:orderHistory.strFutureOrderImage]];
            if ([orderHistory.strFutureOrderStatus isEqualToString:@""]) {
                [cell.chefFutureOrderImage setImage:[UIImage imageNamed:@""]];
            }else{
                [cell.chefFutureOrderImage setImage:[UIImage imageNamed:@""]];
            }
            return cell;
        }else if(indexPath.row == 5){
            static NSString *cellIdentifier = @"MDFutureOrdersCellCancelButton";
            MDFutureOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        cellIdentifier];
            if (cell == nil) {
                cell = [[MDFutureOrdersCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.chefFutureOrderCancelBtn.tag = indexPath.section;
            [cell.chefFutureOrderCancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }else{
        static NSString *cellIdentifier = @"MDFutureOrdersCell";
        MDFutureOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    cellIdentifier];
        if (cell == nil) {
            cell = [[MDFutureOrdersCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        switch (indexPath.row) {
            case 1:{
                cell.lblMenu.text = @"Username";
                cell.lblData.text = orderHistory.strFutureOrderUsername;
            }
                break;
            case 2:{
                cell.lblMenu.text = @"Special-Wraps";
                cell.lblData.text = orderHistory.strFutureOrderSpecialWraps;
            }
                break;
            case 3:{
                cell.lblMenu.text = @"Price";
                cell.lblData.text = orderHistory.strFutureOrderPrice;
            }
                break;
            case 4:{
                cell.lblMenu.text = @"Payment Type";
                cell.lblData.text = orderHistory.strFutureOrderPaymentType;
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
  }
    return nil;
}


#pragma mark Button Action Methods
-(void)cancelBtnAction:(UIButton*)sender{
    orderHistory = [futureOrdersArray objectAtIndex:sender.tag];
    MDRefundAmount_CanceledOrderVC *cancelOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRefundAmount_CanceledOrderVC"];
    cancelOrder.strUserName = orderHistory.strFutureOrderUsername;
    cancelOrder.strOrderImage = orderHistory.strFutureOrderImage;
    cancelOrder.strOrderStatus = orderHistory.strFutureOrderStatus;
    cancelOrder.strOrderId = orderHistory.strFutureOrderId;
    cancelOrder.strMealId = orderHistory.strFutureOrderMealId;
    [self.navigationController pushViewController: cancelOrder animated:YES];
}

- (IBAction)orderHistoryBtnAction:(id)sender {
    [self.btnOrderHistory setSelected:YES];
    [self.btnFutureOrders setSelected:NO];
    self.lblFutureOrders.hidden = YES;
    self.lblOrderHistory.hidden = NO;
    [self.tblHeaderView setFrame:CGRectMake(0, 0, 375, 311)];
    [self.btnOrderHistory setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.btnFutureOrders setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:136/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.viewFutureOrders.hidden = YES;
    self.viewOrderHistory.hidden = NO;
    self.footerView.hidden = YES;
    [self.tblView reloadData];
}

- (IBAction)futureOrdersBtnAction:(id)sender {
    [self.btnOrderHistory setSelected:NO];
    [self.btnFutureOrders setSelected:YES];
    self.lblFutureOrders.hidden = NO;
    self.lblOrderHistory.hidden = YES;
    self.viewOrderHistory.hidden = YES;
    self.viewFutureOrders.hidden = NO;
    [self.btnOrderHistory setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:136/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.btnFutureOrders setTitleColor:[UIColor colorWithRed:0/255.0 green:218/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.footerView.hidden = YES;
    [self callApiForChefFutureOrders];
    [self.tblView reloadData];
}

- (IBAction)backBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)dateBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
        //Optionally for time zone conversions
        [self.dateBtn setTitle:[AppUtility getStringFromDate:date] forState:UIControlStateNormal];
        //[button setTitle:self.reqModatObj.dateString forState:UIControlStateNormal];

    }];
            //self.editableUser.dateOfBirthString = [AppUtility getStringFromDate:date];
        //self.editableUser.dateOfBirthDate = date;g
}
- (IBAction)cancelButton:(id)sender {
    MDRefundAmount_CanceledOrderVC *cancelOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRefundAmount_CanceledOrderVC"];
     [self.navigationController pushViewController: cancelOrder animated:YES];
}

#pragma mark Web API Integration

- (void)callApiForOrderHistory {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    
    [ServiceHelper request:dict apiName:kAPIChefOrderHistory method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                NSDictionary *orderHistoryDict = [resultDict objectForKey:@"data"];
                self.lblEarnings.text = [NSString stringWithFormat:@"%@$",[orderHistoryDict objectForKey:@"Earnings"]];
                self.lblUpcomingOrders.text = [NSString stringWithFormat:@"%@$",[orderHistoryDict objectForKey:@"UpcomingOrders"]];
                self.lblOutstandingOrders.text = [NSString stringWithFormat:@"%@",[orderHistoryDict objectForKey:@"Outstanding"]];
                orderHistoryArray = [CookSettingsModal gettingDataFromArray:[orderHistoryDict objectForKey:@"LastTwoOrders"]];
                [self.tblView reloadData];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForChefFutureOrders {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    
    [ServiceHelper request:dict apiName:kAPIChefFutureOrders method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                futureOrdersArray = [CookSettingsModal getDataFromFutureOrdersArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


@end
