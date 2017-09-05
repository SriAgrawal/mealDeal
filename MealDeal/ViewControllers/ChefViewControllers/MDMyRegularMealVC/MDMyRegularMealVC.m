//
//  MDMyRegularMealVC.m
//  MealDealApp
//
//  Created by Mohit on 07/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDMyRegularMealVC.h"

@interface MDMyRegularMealVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *myRegularMealMenuArr,*myRegularMealDataArray;
    NSString *strDate;
    CookPrepareAMealModal *myRegularMeal;
}
@property (strong, nonatomic) IBOutlet UITextField *txtFieldMealCategory;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldDatePicker;

@end

@implementation MDMyRegularMealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitial];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpInitial{
    myRegularMealMenuArr = [[NSMutableArray alloc] initWithObjects:@"Dish Type",@"Ingredients",@"Calories per serving(approx)",@"Cost(per plate)",@"Additional Cost",@"Servings",@"Slides",@"Spice Level",@"Health Meter",@"Preparation Time",@"Date",@"Country",@"State",@"City",@"Zip",@"Street Name,Unit/Apt", nil];
    myRegularMealDataArray = [[NSMutableArray alloc] init];
    myRegularMeal = [[CookPrepareAMealModal alloc] init];
    strDate = @"Daily";
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtFieldMealCategory.leftView = paddingView1;
    self.txtFieldMealCategory.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtFieldDatePicker.leftView = paddingView2;
    self.txtFieldDatePicker.leftViewMode = UITextFieldViewModeAlways;
    [self callApiForMyRegularMeals];
}

#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [myRegularMealDataArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        return 182.0;
    }else if(indexPath.row == 17){
        return 104.0f;
    }else{
    return 50.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
   // myRegularMeal = [myRegularMealDataArray objectAtIndex:indexPath.section];
    myRegularMeal = [myRegularMealDataArray objectAtIndex:indexPath.section];
    if(indexPath.row == 1){
        static NSString *cellIdentifier = @"MDRegularMealImageCell";
        MDRegularMealImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
        if (cell == nil) {
            cell = [[MDRegularMealImageCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.imgDish sd_setImageWithURL:[NSURL URLWithString:myRegularMeal.strMyRegularMealDishImageUrl]];
        return cell;

    }
    else if (indexPath.row == 17){
        static NSString *cellIdentifier = @"MDRegularMealTodaySpecialCell";
        MDRegularMealTodaySpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        cellIdentifier];
        if (cell == nil) {
            cell = [[MDRegularMealTodaySpecialCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.btnTodaySpecialPicker addTarget:self action:@selector(btnDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [cell.txtFieldTodaySpecial setText:strDate];
        return cell;
 
    }else{
    static NSString *cellIdentifier = @"MDRegularMealDataCell";
    MDRegularMealDataCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            cellIdentifier];
    if (cell == nil) {
        cell = [[MDRegularMealDataCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }switch (indexPath.row) {
        case 0:{
            cell.lblMyRegularMealMenu.text = @"Dish Type";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealDishType;
        }
            break;
        case 2:{
            cell.lblMyRegularMealMenu.text = @"Ingredients";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealIngredientes;
        }
            break;
        case 3:{
            cell.lblMyRegularMealMenu.text = @"Calories per serving(approx)";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = [NSString stringWithFormat:@"$%@",myRegularMeal.strMyRegularMealCaloriesPerServing];
        }
            break;
        case 4:{
            cell.lblMyRegularMealMenu.text = @"Cost(per plate)";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = [NSString stringWithFormat:@"$%@",myRegularMeal.strMyRegularMealCostPerPlate];
        }
            break;
        case 5:{
            cell.lblMyRegularMealMenu.text = @"Additional Cost";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = [NSString stringWithFormat:@"$%@",myRegularMeal.strMyRegularMealAdditionalCost];
        }
            break;
        case 6:{
            cell.lblMyRegularMealMenu.text = @"Servings";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = [NSString stringWithFormat:@"%@", myRegularMeal.strMyRegularMealServings];
        }
            break;
        case 7:{
            cell.lblMyRegularMealMenu.text = @"Slides";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealSlides;
        }
            break;
        case 8:{
            cell.lblMyRegularMealMenu.text = @"Spice Level";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = NO;
            cell.lblMyRegularMealData.hidden = YES;
            [cell.spiceLevelView setUserInteractionEnabled:NO];
            cell.spiceLevelView.value = [myRegularMeal.strMyRegularMealSpiceLevel floatValue];
            [cell.spiceLevelView setEmptyStarImage:[UIImage imageNamed:@"spice_icon_gry"]];
            [cell.spiceLevelView setFilledStarImage:[UIImage imageNamed:@"spice_icon"]];
        }
            break;
        case 9:{
            cell.lblMyRegularMealMenu.text = @"Health Meter";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = NO;
            cell.lblMyRegularMealData.hidden = YES;
            [cell.spiceLevelView setUserInteractionEnabled:NO];
            cell.spiceLevelView.value = [myRegularMeal.strMyRegularMealHealthMeter floatValue];
            [cell.spiceLevelView setEmptyStarImage:[UIImage imageNamed:@"heart_icon_gray"]];
            [cell.spiceLevelView setFilledStarImage:[UIImage imageNamed:@"heart_icon"]];
        }
            break;
        case 10:{
            cell.lblMyRegularMealMenu.text = @"Preparation Time";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealPreparationTime;
        }
            break;
        case 11:{
            cell.lblMyRegularMealMenu.text = @"Date";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = [AppUtility timestamp2date:myRegularMeal.strMyRegularMealDate];
        }
            break;
        case 12:{
            cell.lblMyRegularMealMenu.text = @"Country";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealCountry;
        }
            break;
        case 13:{
            cell.lblMyRegularMealMenu.text = @"State";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealState;
        }
            break;
        case 14:{
            cell.lblMyRegularMealMenu.text = @"City";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealCity;
        }
            break;
        case 15:{
            cell.lblMyRegularMealMenu.text = @"Zip";
            cell.backgroundColor = [UIColor whiteColor];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealZip;
        }
            break;
        case 16:{
            cell.lblMyRegularMealMenu.text = @"Street Name,Unit/Apt";
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.spiceLevelView.hidden = YES;
            cell.lblMyRegularMealData.hidden = NO;
            cell.lblMyRegularMealData.text = myRegularMeal.strMyRegularMealStreetName;
        }
            break;
            
        default:
            break;
    }
        
//        if(indexPath.row % 2 == 0){
//            ff dffdd [UIColor lightGrayColor];
//            if(indexPath.row == 8){
//                cell.spiceLevelView.hidden = NO;
//            }else
//                cell.spiceLevelView.hidden = YES;
//        }else{
//            cell.backgroundColor = [UIColor whiteColor];
//            if(indexPath.row == 9){
//                cell.spiceLevelView.hidden = NO;
//            }else
//                cell.spiceLevelView.hidden = YES;
//        }
        return cell;
    }
    return nil;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"MDMealHeaderCell";
    myRegularMeal = [myRegularMealDataArray objectAtIndex:section];
    MDMealHeaderCell *sectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    sectionHeaderCell.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    sectionHeaderCell.lblDishName.text = myRegularMeal.strMyRegularMealDishName;
    // don't leave this transparent
    
    return sectionHeaderCell.contentView;
    
}

#pragma mark Button Action Methods
- (IBAction)datePickerBtnAction:(id)sender {
    [self.view endEditing:YES];
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"Daily", @"Weekly", @"Monthly"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        [self.txtFieldDatePicker setText:selectedValues.firstObject];
        [self callApiForMyRegularMeals];
        //[self.tblView reloadData];
    }];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)mealCategoryPickerBtnAction:(id)sender {
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"Veg", @"Non Veg",@"Both"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        [self.txtFieldMealCategory setText:selectedValues.firstObject];
        [self callApiForMyRegularMeals];
        [self.tblView reloadData];
    }];
}

-(void)btnDatePicker{
    [self.view endEditing:YES];
  [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
        //self.editableUser.dateOfBirthString = [AppUtility getStringFromDate:date];
        //self.editableUser.dateOfBirthDate = date;g
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/mm/yyyy"];
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        NSString *stringFromDate = [formatter stringFromDate:date];
        strDate = stringFromDate;
        [self.tblView reloadData];
    }];

}
# pragma mark Web API Integration

- (void)callApiForMyRegularMeals {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    
    if ([self.txtFieldMealCategory.text isEqualToString:@"Veg"]) {
        [dict setValue:@"veg" forKey:@"mealType"];
    } else if ([self.txtFieldMealCategory.text isEqualToString:@"Non Veg"]) {
        [dict setValue:@"nonveg" forKey:@"mealType"];
    } else
        [dict setValue:@"both" forKey:@"mealType"];

    if ([self.txtFieldDatePicker.text isEqualToString:@"Daily"]) {
        [dict setValue:@"daily" forKey:@"date"];
    } else if ([self.txtFieldDatePicker.text isEqualToString:@"Weekly"]) {
        [dict setValue:@"weekly" forKey:@"date"];
    } else
        [dict setValue:@"monthly" forKey:@"date"];
    
    [ServiceHelper request:dict apiName:kAPIMyRegularMeals method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                myRegularMealDataArray = [CookPrepareAMealModal getDataFromArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
                
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

@end
