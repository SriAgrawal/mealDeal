//
//  MDRequestsVC.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDRequestsVC.h"

@interface MDRequestsVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *requestsArray;
    CookPrepareAMealModal *requestedMealList;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation MDRequestsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitial];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [self callApiForRequestedMeal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpInitial{
    requestsArray = [[NSMutableArray alloc] init];
    requestedMealList = [[CookPrepareAMealModal alloc] init];
}

#pragma mark - Table View Data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 153.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [requestsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDRequestCell";
    requestedMealList = [requestsArray objectAtIndex:indexPath.row];
    MDRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              cellIdentifier];
    if (cell == nil) {
        cell = [[MDRequestCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.lblDinerName.text = requestedMealList.strRequestedMealDinerName;
    cell.lblZipForDiner.text = requestedMealList.strRequestedMealZipForDiner;
    cell.lblCuisineName.text = requestedMealList.strRequestedMealCuisineName;
    cell.lblCuisineType.text = requestedMealList.strRequestedMealCuisineType;
    cell.lblPickUpDate.text = requestedMealList.strRequestedMealPickUpDate;
    cell.lblPickUpTime.text = requestedMealList.strRequestedMealPickUpTime;
    [cell.imgMeal sd_setImageWithURL:[NSURL URLWithString:requestedMealList.strRequestedMealImageUrl]];
    if([requestedMealList.strRequestedMealStatus isEqualToString:@"Pending"])
    {
        cell.mealInProcessImg.image = [UIImage imageNamed:@"meal_icon2"];
        cell.mealStatusImg.image = [UIImage imageNamed:@"yellow_img"];
    }else if ([requestedMealList.strRequestedMealStatus isEqualToString:@"Accepted"]){
        cell.mealInProcessImg.image = [UIImage imageNamed:@"meal_icon2"];
        cell.mealStatusImg.image = [UIImage imageNamed:@"green_img"];
    }else if ([requestedMealList.strRequestedMealStatus isEqualToString:@"Rejected"]){
        cell.mealInProcessImg.image = [UIImage imageNamed:@"future_icon"];
        cell.mealStatusImg.image = [UIImage imageNamed:@"red_img"];
    }

    /*switch (indexPath.row) {
        case 0:{
            cell.mealInProcessImg.image = [UIImage imageNamed:@"meal_icon2"];
        }
            break;
        case 1:{
            cell.mealStatusImg.image = [UIImage imageNamed:@"yellow_img"];
            cell.mealInProcessImg.image = [UIImage imageNamed:@"future_icon"];
        }
            break;

        case 2:{
            cell.mealStatusImg.image = [UIImage imageNamed:@"red_img"];
            cell.mealInProcessImg.image = [UIImage imageNamed:@"future_icon"];
        }
            break;

        case 3:{
            cell.mealInProcessImg.image = [UIImage imageNamed:@"meal_icon2"];
        }
            break;

            
        default:
            break;
    }
    if(indexPath.row == 1)
        cell.mealStatusImg.image = [UIImage imageNamed:@"yellow_img"];
    else if (indexPath.row == 2)
        cell.mealStatusImg.image = [UIImage imageNamed:@"red_img"];*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    requestedMealList = [requestsArray objectAtIndex:indexPath.row];
    MDRequestVC *requestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDRequestVC"];
    requestVC.strOrderId = requestedMealList.strRequestedMealOrderId;
    requestVC.strMealId = requestedMealList.strRequestedMealId;
    requestVC.strDinerId = requestedMealList.strRequestedMealDinerId;
    [self.navigationController pushViewController: requestVC animated:YES];
}

#pragma mark - Web Api Section

- (void)callApiForRequestedMeal {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPIRequestedMeals method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                requestsArray = [CookPrepareAMealModal getDataFromRequestedMealArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
                
            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}



#pragma Button Action Methods

- (IBAction)menuBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}



@end
