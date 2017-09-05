//
//  MDRegularMealersVC.m
//  MealDealApp
//
//  Created by Mohit on 05/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDRegularMealersVC.h"
#import "MDRegularMealersSectiohHeaderCell.h"
#import "MDRegularMealersDataCell.h"

@interface MDRegularMealersVC ()<UITableViewDataSource,UITableViewDelegate>{
    CookSettingsModal *myRegularMealers;
    NSMutableArray *myRegularMealersArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation MDRegularMealersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitial];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpInitial{
    myRegularMealers = [[CookSettingsModal alloc] init];
    myRegularMealersArray = [[NSMutableArray alloc] init];
    [self callApiForMyRegularMealers];
}

#pragma mark - Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [myRegularMealersArray count]; //one male and other female
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDRegularMealersDataCell";
    myRegularMealers = [myRegularMealersArray objectAtIndex:indexPath.section];
    MDRegularMealersDataCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        cellIdentifier];
    if (cell == nil) {
        cell = [[MDRegularMealersDataCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:{
            cell.lblMenuRegularMealers.text = @"Diner";
            cell.lblDataRegularMealers.text = myRegularMealers.strRegularMealersDinerName;
            cell.lblSeperator.hidden = NO;
            cell.regularMealersImg.image = [UIImage imageNamed:@"dinner_icon"];
        }
            break;
        case 1:{
            cell.lblMenuRegularMealers.text = @"Dish Ordered";
            cell.lblDataRegularMealers.text = myRegularMealers.strRegularMealersDishOrdered;
            cell.lblSeperator.hidden = NO;
            cell.regularMealersImg.image = [UIImage imageNamed:@"dish_icon"];
        }
            break;

        case 2:{
            cell.lblMenuRegularMealers.text = @"Order Amount";
            cell.lblDataRegularMealers.text = [NSString stringWithFormat:@"$%@",myRegularMealers.strRegularMealersOrderAmount];
            cell.lblSeperator.hidden = YES;
            cell.regularMealersImg.image = [UIImage imageNamed:@"order_ico2n"];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"MDRegularMealersSectiohHeaderCell";
    myRegularMealers = [myRegularMealersArray objectAtIndex:section];
    MDRegularMealersSectiohHeaderCell *sectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    sectionHeaderCell.contentView.backgroundColor = [UIColor whiteColor]; // don't leave this transparent
    sectionHeaderCell.lblRegularMealerDate.text = [AppUtility timestamp2date:myRegularMealers.strRegularMealersDate];
    return sectionHeaderCell.contentView;
}

#pragma mark Button Action Methods

- (IBAction)menuBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];

}


# pragma mark Web API Integration

- (void)callApiForMyRegularMealers {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPIMyRegularMealers method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                myRegularMealersArray = [CookSettingsModal gettingDataFromRegularMealersArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}




@end
