//
//  ViewController.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *placeholderArr,*todaysOrderListArray;
    CookSettingsModal *todaysOrderList;
}
@property (strong, nonatomic) IBOutlet UIButton *chatWithDinerBtn;
@property (strong, nonatomic) IBOutlet UIView *mealView;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIButton *foodTypeBtn;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitial];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Initial SetUp
-(void)setUpInitial{
    placeholderArr = [[NSMutableArray alloc] initWithObjects:@"Allergies",@"Username",@"Zip",@"Cuisine Name",@"Cuisine Type",@"Store Around",@"Special Req.",@"Steps",@"Ingredients Req",@"Spice Level",@"Time Requested",@"Remaining Time", nil];
    
    todaysOrderListArray = [[NSMutableArray alloc] init];
    todaysOrderList = [[CookSettingsModal alloc] init];
    self.chatWithDinerBtn.layer.borderWidth = 1.0f;
    self.chatWithDinerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.chatWithDinerBtn.layer.masksToBounds = YES;
    self.mealView.layer.borderWidth = 1.5f;
    self.mealView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    self.mealView.layer.masksToBounds = YES;
    self.dateView.layer.borderWidth = 1.5f;
    self.dateView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    self.dateView.layer.masksToBounds = YES;
    self.dateView.layer.borderWidth = 1.0f;
    self.dateView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0].CGColor;
    self.mealView.layer.borderWidth = 1.0f;
    self.mealView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0].CGColor;
    [self callApiForTodayOrder];
}

#pragma mark - Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [todaysOrderListArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [placeholderArr count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 12)
        return 68.0f;
    else
    return 52.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    todaysOrderList = [todaysOrderListArray objectAtIndex:indexPath.section];
    if(indexPath.row == 12){
        static NSString *cellIdentifier = @"MDSettingsUpdateAddressCell";
        MDSettingsUpdateAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  cellIdentifier];
        if (cell == nil) {
            cell = [[MDSettingsUpdateAddressCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.chatWithDinerBtn.tag = indexPath.section;
        [cell.chatWithDinerBtn addTarget:self action:@selector(chatWithDinerBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else{
    static NSString *cellIdentifier = @"MDTodayOrderCell";
    MDTodayOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[MDTodayOrderCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.placeholderLbl.text = [placeholderArr objectAtIndex:indexPath.row];
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    switch (indexPath.row) {
        case 0:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderAllergies;
        }
            break;
        case 1:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderUsername;
        }
            break;
        case 2:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderZip;
        }
            break;
        case 3:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderCuisineName;
        }
            break;
        case 4:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderCuisineType;
        }
            break;
        case 5:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderStoreAround;
        }
            break;
        case 6:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderSpecialRequirements;
        }
            break;
        case 7:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = NO;
            cell.dataLbl.hidden = YES;
            cell.txtViewCell.text = todaysOrderList.strTodaysOrderSteps;
        }
            break;
        case 8:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = todaysOrderList.strTodaysOrderIngredientsReq;
        }
            break;
        case 9:{
            cell.spiceLevelView.hidden = NO;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = YES;
            cell.spiceLevelView.value = [todaysOrderList.strTodaysOrderSpiceLevel floatValue];
        }
            break;
        case 10:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            cell.dataLbl.text = [AppUtility timestampToTime:todaysOrderList.strTodaysOrderPickUpDate];
        }
            break;
        case 11:{
            cell.spiceLevelView.hidden = YES;
            cell.txtViewCell.hidden = YES;
            cell.dataLbl.hidden = NO;
            double currentt = [[NSDate new] timeIntervalSince1970];
            NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[todaysOrderList.strTodaysOrderPickUpDate intValue]]];
            NSInteger ti = (NSInteger)differ;
            //NSInteger seconds = ti % 60;
            NSInteger minutes = (ti / 60) % 60;
            //NSInteger hours = (ti / 3600);
            cell.dataLbl.text = [NSString stringWithFormat:@"%02ld Min",(long)minutes];
        }
            break;
            
        default:
            break;
    }
        return cell;

    }
    return nil;
}

#pragma mark Button Action Methods

- (void)chatWithDinerBtn:(UIButton*)sender {
    todaysOrderList = [todaysOrderListArray objectAtIndex:sender.tag];
    MDChatVC *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDChatVC"];
    chatVC.strReceiverImage = todaysOrderList.strTodaysOrderDinerImage;
    chatVC.strDishName = todaysOrderList.strTodaysOrderCuisineName;
    chatVC.strDishImage = todaysOrderList.strTodaysOrderMealImage;
    chatVC.strReciverId = todaysOrderList.strTodaysOrderDinerId;
    chatVC.strReceiverName = todaysOrderList.strTodaysOrderUsername;
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (IBAction)foodTypeBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"Veg", @"NonVeg", @"Both"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        [self.foodTypeBtn setTitle:selectedValues.firstObject forState:UIControlStateNormal];
        [self callApiForTodayOrder];
       // [self.tblView reloadData];
    }];
}

- (IBAction)dateBtnAction:(id)sender {

    [self.view endEditing:YES];
      [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
          
        [self.dateBtn setTitle:[AppUtility getStringFromTime:date] forState:UIControlStateNormal];
    }];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

// Web API for Today,s Orders List in Chef Section

# pragma mark Web API Integration

- (void)callApiForTodayOrder {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pChefId];
    
    if ([self.foodTypeBtn.titleLabel.text isEqualToString:@"Veg"]) {
        [dict setValue:@"veg" forKey:pMealType];
    } else if ([self.foodTypeBtn.titleLabel.text isEqualToString:@"NonVeg"]) {
        [dict setValue:@"nonveg" forKey:pMealType];
    } else
        [dict setValue:@"" forKey:pMealType];
    

    [ServiceHelper request:dict apiName:kAPITodaysOrderListChef method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                todaysOrderListArray = [CookSettingsModal parseDataFromTodaysOrdersList:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


@end
