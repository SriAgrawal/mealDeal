//
//  MDPrepareAMealVC.m
//  MealDealApp
//
//  Created by Mohit on 08/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDPrepareAMealVC.h"
#import "Macro.h"

@interface MDPrepareAMealVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CookPrepareAMealModal *prepareAMeal;
    NSMutableArray *statesListArray;
    NSMutableDictionary *cuisineDict, *addressDict, *healthyMealDict;
    BOOL isHealthyMeal;
}
@property (strong, nonatomic) IBOutlet UIButton *btnVeg;
@property (strong, nonatomic) IBOutlet UIButton *btnNonVeg;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;

@property (strong, nonatomic) NSMutableArray                        *attatchmentImageArray;

@property (strong, nonatomic) NSMutableArray                        *attatchmentVideoArray;

@property (nonatomic) NSInteger                                     imageCount;
@property (nonatomic) NSInteger                                     videoCount;

@end

@implementation MDPrepareAMealVC

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
    prepareAMeal = [[CookPrepareAMealModal alloc] init];
    statesListArray = [[NSMutableArray alloc] init];
    _attatchmentImageArray = [NSMutableArray array];
 //   _attachmentImageDataArray = [NSMutableArray array];
    self.imageCount = 0;
    self.videoCount = 0;
    self.btnVeg.selected = YES;
    self.attatchmentImageArray = [NSMutableArray array];
    self.attatchmentVideoArray = [NSMutableArray array];
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    if(isHealthyMeal)
       return 22;
    else
        return 18;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(isHealthyMeal) {
//        [AppUtility delay:0.2 :^{
//            [self.tblView scrollRectToVisible:CGRectMake(0, self.tblView.contentSize.height-10, self.tblView.contentSize.width, 10) animated:YES];
//        }];
//    }
    if(indexPath.row == 2){
        return 53.0;
    }else if(indexPath.row == 9){
        return 82.0f;
    }
    else if(indexPath.row == 17){
        return 128.0f;
    }
    else if(indexPath.row == 21){
        return 117.0f;
    }else{
        return 45.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        static NSString *cellIdentifier = @"MDCustomMealCell";
        MDCustomMealCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        cellIdentifier];
        if (cell == nil) {
            cell = [[MDCustomMealCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.attachButton addTarget:self action:@selector(attachButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        [cell.collectionView reloadData];
        return cell;
        
    }
    else if (indexPath.row == 9){
        static NSString *cellIdentifier = @"MDSpiceLevelCell";
        MDSpiceLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                               cellIdentifier];
        if (cell == nil) {
            cell = [[MDSpiceLevelCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.spiceLevelView setEmptyStarImage:[UIImage imageNamed:@"spice_icon_gry"]];
        [cell.spiceLevelView setFilledStarImage:[UIImage imageNamed:@"spice_icon"]];
        
        [cell.healthMeterView setEmptyStarImage:[UIImage imageNamed:@"heart_icon_gray"]];
        [cell.healthMeterView setFilledStarImage:[UIImage imageNamed:@"heart_icon"]];
        
        
        cell.healthMeterView.value = [prepareAMeal.strHealthMeter floatValue];
        cell.spiceLevelView.value = [prepareAMeal.strSpiceLevel floatValue];

        
        [cell.healthMeterView addTarget:self action:@selector(onHealthRatingView:) forControlEvents:UIControlEventValueChanged];
        [cell.spiceLevelView addTarget:self action:@selector(onSpiceRatingView:) forControlEvents:UIControlEventValueChanged];

        
   //     prepareAMeal.strHealthMeter = [NSString stringWithFormat:@"%f",cell.healthMeterView.value];
    //    prepareAMeal.strSpiceLevel = [NSString stringWithFormat:@"%f",cell.spiceLevelView.value];
        
        return cell;
        
    }
    else if (indexPath.row == 17 || indexPath.row == 21){
        static NSString *cellIdentifier = @"MDTextViewCell";
        MDTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  cellIdentifier];
        if (cell == nil) {
            cell = [[MDTextViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.txtViewData.delegate = self;
        cell.txtViewData.backgroundColor = [UIColor clearColor];
        if(indexPath.row == 21){
            cell.btnAddAsHealthyMeal.hidden = YES;
            cell.lblHeathyMeal.hidden = YES;
            cell.txtViewData.tag = indexPath.row;
            cell.txtViewData.placeholderText = @"Nutrients";
            cell.txtViewData.text = prepareAMeal.strNutrients;
        }else{
            cell.btnAddAsHealthyMeal.hidden = NO;
            cell.lblHeathyMeal.hidden = NO;
            cell.btnAddAsHealthyMeal.tag = indexPath.row;
            cell.txtViewData.placeholderText = @"Street Name, Unit/Apt.";
            cell.txtViewData.text = prepareAMeal.strStreetName;
            cell.txtViewData.tag = indexPath.row;
            [cell.btnAddAsHealthyMeal addTarget:self action:@selector(btnAddHealthyMeal:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
        
    }
    else{
        static NSString *cellIdentifier = @"MDTextFieldCell";
        MDTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       cellIdentifier];
        if (cell == nil) {
            cell = [[MDTextFieldCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.txtFieldData.delegate = self;
        switch (indexPath.row) {
            case 0:{
                cell.txtFieldData.placeholder = @"Cuisine Name";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strCuisineName;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 1:{
                cell.txtFieldData.placeholder = @"Cuisine Type";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strCuisineType;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 3:{
                cell.txtFieldData.placeholder = @"Ingredients";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strIngredients;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 4:{
                cell.txtFieldData.placeholder = @"Calories per serving(approx)";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strCaloriesPerServing;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                [cell.txtFieldData setKeyboardType:UIKeyboardTypePhonePad];
                [cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];
               // cell.txtFieldData.returnKeyType = UIReturnKeyNext;

            }
                break;
            case 5:{
                cell.txtFieldData.placeholder = @"Price(per date)";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strPricePerDate;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                [cell.txtFieldData setKeyboardType:UIKeyboardTypePhonePad];
                [cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];
               // cell.txtFieldData.returnKeyType = UIReturnKeyNext;

            }
                break;
            case 6:{
                cell.txtFieldData.placeholder = @"Add-on Cost";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strAddOnCost;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                [cell.txtFieldData setKeyboardType:UIKeyboardTypePhonePad];
                [cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];
                //cell.txtFieldData.returnKeyType = UIReturnKeyNext;


            }
                break;
            case 7:{
                cell.txtFieldData.placeholder = @"Servings";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strServings;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];

            }
                break;
            case 8:{
                cell.txtFieldData.placeholder = @"Sides";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strSides;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];

            }
                break;
            case 10:{
                cell.txtFieldData.placeholder = @"Time";
                cell.btnPicker.hidden = NO;
                cell.txtFieldData.userInteractionEnabled = NO;
                cell.txtFieldData.tag = indexPath.row;
                cell.btnPicker.tag = indexPath.row;
                cell.txtFieldData.text = prepareAMeal.strTime;
                [cell.btnPicker addTarget:self action:@selector(btnPrepareMealTimePicker:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 11:{
                cell.txtFieldData.placeholder = @"Date";
                cell.btnPicker.hidden = NO;
                cell.txtFieldData.userInteractionEnabled = NO;
                cell.txtFieldData.tag = indexPath.row;
                cell.btnPicker.tag = indexPath.row;
                cell.txtFieldData.text = prepareAMeal.strDate;
                [cell.btnPicker addTarget:self action:@selector(btnPrepareMealDatePicker:) forControlEvents:UIControlEventTouchUpInside];

            }
                break;
            case 12:{
                cell.txtFieldData.placeholder = @"Meal Count";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strMealCount;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                [cell.txtFieldData setKeyboardType:UIKeyboardTypePhonePad];
                [cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];            }
                break;
            case 13:{
                cell.txtFieldData.placeholder = @"Country";
                cell.btnPicker.hidden = NO;
                cell.txtFieldData.userInteractionEnabled = NO;
                cell.txtFieldData.tag = indexPath.row;
                cell.btnPicker.tag = indexPath.row;
                [cell.txtFieldData setText:prepareAMeal.strCountry];
                [cell.btnPicker addTarget:self action:@selector(btnPrepareMealCountryPicker:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 14:{
                cell.txtFieldData.placeholder = @"State";
                cell.btnPicker.hidden = NO;
                cell.txtFieldData.userInteractionEnabled = NO;
                cell.txtFieldData.tag = indexPath.row;
                cell.btnPicker.tag = indexPath.row;
                [cell.txtFieldData setText:prepareAMeal.strState];
                [cell.btnPicker addTarget:self action:@selector(btnPrepareMealStatePicker:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 15:{
                cell.txtFieldData.placeholder = @"City";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.text = prepareAMeal.strCity;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 16:{
                cell.txtFieldData.placeholder = @"Zip Code";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strZipCode;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
               // [cell.txtFieldData setKeyboardType:UIKeyboardTypePhonePad];
                //[cell.txtFieldData setInputAccessoryView:[self getToolBarForNumberPad]];
                cell.txtFieldData.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

            }
                break;
            case 18:{
                cell.txtFieldData.placeholder = @"Minerals";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strMinerals;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 19:{
                cell.txtFieldData.placeholder = @"Quantity to be consumed";
                cell.btnPicker.hidden = YES;
                cell.txtFieldData.text = prepareAMeal.strQuantityToConsume;
                cell.txtFieldData.tag = indexPath.row;
                cell.txtFieldData.userInteractionEnabled = YES;
                cell.txtFieldData.returnKeyType = UIReturnKeyNext;
                cell.txtFieldData.keyboardType = UIKeyboardTypeDefault;
                [cell.txtFieldData setInputAccessoryView:nil];
            }
                break;
            case 20:{
                cell.txtFieldData.placeholder = @"Meal Time";
                cell.txtFieldData.text = prepareAMeal.strMealTime;
                cell.btnPicker.hidden = NO;
                cell.txtFieldData.userInteractionEnabled = NO;
                cell.txtFieldData.tag = indexPath.row;
                cell.btnPicker.tag = indexPath.row;
                [cell.btnPicker addTarget:self action:@selector(btnMealTimePicker:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    return nil;
}


#pragma mark UICollectionViewDataSource/Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.attatchmentImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDBannerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDBannerImageCollectionViewCell" forIndexPath:indexPath];
    
    NSMutableDictionary *imageDict = [self.attatchmentImageArray objectAtIndex:indexPath.row];
    cell.bannerImageView.image = [imageDict valueForKey:@"image"];
    [cell.bannerImageView setContentMode:UIViewContentModeScaleToFill];
    
    [cell.imageCrossBtn setIndexPath:indexPath];
    [cell.previewButton setIndexPath:indexPath];

    [cell.imageCrossBtn addTarget:self action:@selector(crossButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [cell.previewButton addTarget:self action:@selector(previewButtonSelector:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(55 , 55);
}


#pragma mark Selector Methods

- (void)onHealthRatingView:(HCSStarRatingView *)ratingValue {
    [self.view endEditing:YES];
    
    prepareAMeal.strHealthMeter = [NSString stringWithFormat:@"%f", ratingValue.value];
    LogInfo(@"%f",ratingValue.value);
    
    [self.tblView reloadData];
}

- (void)onSpiceRatingView:(HCSStarRatingView *)ratingValue {
    [self.view endEditing:YES];
    
    prepareAMeal.strSpiceLevel = [NSString stringWithFormat:@"%f", ratingValue.value];
    LogInfo(@"%f",ratingValue.value);
    
    [self.tblView reloadData];
}


#pragma mark TextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            prepareAMeal.strCuisineName = TRIM_SPACE(textField.text);
            break;
            
        case 1:
            prepareAMeal.strCuisineType = TRIM_SPACE(textField.text);
            break;
            
        case 3:
            prepareAMeal.strIngredients = TRIM_SPACE(textField.text);
            break;
            
        case 4:
            prepareAMeal.strCaloriesPerServing = TRIM_SPACE(textField.text);
            break;
            
        case 5:
            prepareAMeal.strPricePerDate = TRIM_SPACE(textField.text);
            break;
            
        case 6:
            prepareAMeal.strAddOnCost = TRIM_SPACE(textField.text);
            break;
            
        case 7:
            prepareAMeal.strServings = TRIM_SPACE(textField.text);
            break;
            
        case 8:
            prepareAMeal.strSides = TRIM_SPACE(textField.text);
            break;
            
//        case 10:
//            prepareAMeal.strTime = TRIM_SPACE(textField.text);
//            break;
//            
//        case 11:
//            prepareAMeal.strDate = TRIM_SPACE(textField.text);
//            break;
            
        case 12:
            prepareAMeal.strMealCount = TRIM_SPACE(textField.text);
            break;
            
        case 13:
            break;
            
        case 14:
            break;
            
        case 15:
            prepareAMeal.strCity = TRIM_SPACE(textField.text);
            break;
            
        case 16:
            prepareAMeal.strZipCode = TRIM_SPACE(textField.text);
            break;
            
        case 17:
            break;
            
        case 18:
            prepareAMeal.strMinerals = TRIM_SPACE(textField.text);
            break;
            
        case 19:
            prepareAMeal.strQuantityToConsume = TRIM_SPACE(textField.text);
            break;
            
        case 21:
            prepareAMeal.strNutrients = TRIM_SPACE(textField.text);
            break;

        default:
            break;
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 17:
            prepareAMeal.strStreetName = TRIM_SPACE(textView.text);
            break;
            
        case 21:
            prepareAMeal.strNutrients = TRIM_SPACE(textView.text);
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch ((textField.tag)) {
        case 0:{
            [KTextField(1) becomeFirstResponder];
            return YES;

        }
            break;
        case 1:{
            [KTextField(3) becomeFirstResponder];
            return YES;

        }
            break;
        case 3:{
            [KTextField(4) becomeFirstResponder];
            return YES;

        }
            break;
            
        case 4:{
            [KTextField(5) becomeFirstResponder];
            return YES;

        }
            break;
            
        case 5:{
            [KTextField(6) becomeFirstResponder];
            return YES;
        }
            break;
        case 6:{
            [KTextField(7) becomeFirstResponder];
            return YES;
        }
            break;
        case 7:{
            [KTextField(8) becomeFirstResponder];
            return YES;
        }
            break;
        case 8:{
            [KTextField(12) becomeFirstResponder];
            return YES;
        }
            break;
        case 12:{
            [KTextField(15) becomeFirstResponder];
            return YES;
        }
            break;
        case 15:{
            [KTextField(16) becomeFirstResponder];
            return YES;
        }
            break;
        case 16:{
            [KTextField(17) becomeFirstResponder];
            return YES;
        }
            break;
            
        case 18:{
            [KTextField(19) becomeFirstResponder];
            return YES;
        }
            break;
        case 19:{
            [KTextField(21) becomeFirstResponder];
            return YES;
        }
            break;
               default:
            break;
    }
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        {
            return NO;
        }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    
    switch (textView.tag) {
        case 21:{
            if ([text isEqualToString:@"\n"]) {
                [textView resignFirstResponder];
                return NO;
            }
        }
            break;
        case 17:{
            if(isHealthyMeal){
            if ([text isEqualToString:@"\n"]) {
                [KTextField(18) becomeFirstResponder];
                return NO;
            }
            }else{
                if ([text isEqualToString:@"\n"]) {
                    [textView resignFirstResponder];
                    return NO;
                }
            }
        }
            break;

            
        default:
            break;
    }    return YES;
}


#pragma mark Validation method

- (BOOL)validatePrepareAMeal {
    
    if (![TRIM_SPACE(prepareAMeal.strCuisineName) length]) {
        [AlertController title:@"Please enter cuisine name."];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strCuisineType) length]) {
        [AlertController title:@"Please enter cuisine type"];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strIngredients) length]) {
        [AlertController title:@"Please enter ingredients"];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strCaloriesPerServing) length]) {
        [AlertController title:@"Please enter calories per serving."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strPricePerDate) length]) {
        [AlertController title:@"Please enter price."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strAddOnCost) length]) {
        [AlertController title:@"Please enter add on cost."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strServings) length]) {
        [AlertController title:@"Please enter servings."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strSides) length]) {
        [AlertController title:@"Please enter sides."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strTime) length]) {
        [AlertController title:@"Please select time."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strDate) length]) {
        [AlertController title:@"Please select date."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strMealCount) length]) {
        [AlertController title:@"Please enter meal count."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strCountry) length]) {
        [AlertController title:@"Please select country."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strState) length]) {
        [AlertController title:@"Please select state."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strCity) length]) {
        [AlertController title:@"Please enter city."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strZipCode) length]) {
        [AlertController title:@"Please enter zip code."];
        return NO;
    }
    else if ([TRIM_SPACE(prepareAMeal.strZipCode) length] <= 2 || [TRIM_SPACE(prepareAMeal.strZipCode) length] >= 11) {
        [AlertController title:@"Please enter zip code between 3 to 10 characters."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strStreetName) length]) {
        [AlertController title:@"Please enter street name."];
        return NO;
    }
       else {
        return YES;
    }
}


#pragma mark Validation method

- (BOOL)validatePrepareAMealAsHealthyMeal {
    
    if (![TRIM_SPACE(prepareAMeal.strCuisineName) length]) {
        [AlertController title:@"Please enter cuisine name."];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strCuisineType) length]) {
        [AlertController title:@"Please enter cuisine type"];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strIngredients) length]) {
        [AlertController title:@"Please enter ingredients"];
        return NO;
    } else if (![TRIM_SPACE(prepareAMeal.strCaloriesPerServing) length]) {
        [AlertController title:@"Please enter calories per serving."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strPricePerDate) length]) {
        [AlertController title:@"Please enter price."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strAddOnCost) length]) {
        [AlertController title:@"Please enter add on cost."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strServings) length]) {
        [AlertController title:@"Please enter servings."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strSides) length]) {
        [AlertController title:@"Please enter sides."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strTime) length]) {
        [AlertController title:@"Please select time."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strDate) length]) {
        [AlertController title:@"Please select date."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strMealCount) length]) {
        [AlertController title:@"Please enter meal count."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strCountry) length]) {
        [AlertController title:@"Please select country."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strState) length]) {
        [AlertController title:@"Please select state."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strCity) length]) {
        [AlertController title:@"Please enter city."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strZipCode) length] ) {
        [AlertController title:@"Please enter zip code."];
        return NO;
    }
    else if ([TRIM_SPACE(prepareAMeal.strZipCode) length] <= 2 || [TRIM_SPACE(prepareAMeal.strZipCode) length] >= 11) {
        [AlertController title:@"Please enter zip code between 3 to 10 characters."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strStreetName) length]) {
        [AlertController title:@"Please enter street name."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strMinerals) length]) {
        [AlertController title:@"Please enter minerals."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strQuantityToConsume) length]) {
        [AlertController title:@"Please enter quantity to be consumed."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strMealTime) length]) {
        [AlertController title:@"Please select meal time."];
        return NO;
    }
    else if (![TRIM_SPACE(prepareAMeal.strNutrients) length]) {
        [AlertController title:@"Please enter nutrients."];
        return NO;
    }

    else {
        return YES;
    }
}



#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        
        NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
        [imageDict setObject:[info objectForKey:UIImagePickerControllerOriginalImage] forKey:@"image"];
        [imageDict setObject:@"image" forKey:@"type"];
        
        [self.attatchmentImageArray addObject:imageDict];
        self.imageCount = self.imageCount + 1;
    }
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [videoUrl path];
        
        NSData *videoData = [NSData dataWithContentsOfFile:[videoUrl path]];
        
        NSMutableDictionary *videoDict = [NSMutableDictionary dictionary];
        [videoDict setObject:[self generateThumbImage:moviePath] forKey:@"image"];
        [videoDict setObject:@"video" forKey:@"type"];
        
        [self.attatchmentImageArray addObject:videoDict];
        [self.attatchmentVideoArray addObject:videoData];
        self.videoCount = self.videoCount + 1;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.tblView reloadData];
    
}

-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

#pragma mark Button Action Methods

- (IBAction)vegBtnAction:(id)sender {
    
    self.btnVeg.selected = YES;
    self.btnNonVeg.selected = NO;
}

- (IBAction)nonVegBtnAction:(id)sender {
    
    self.btnVeg.selected = NO;
    self.btnNonVeg.selected = YES;
}

- (IBAction)uploadDishBtnAction:(id)sender {
    [self.view endEditing:YES];


    if(isHealthyMeal){
        if ([self validatePrepareAMealAsHealthyMeal]) {
           // [AlertController title:@"Meal prepared successfully."];
            cuisineDict = [NSMutableDictionary dictionary];
            [cuisineDict setValue:prepareAMeal.strCuisineName forKey:@"name"];
            [cuisineDict setValue:prepareAMeal.strCuisineType forKey:@"type"];
            
            addressDict = [NSMutableDictionary dictionary];
            [addressDict setValue:prepareAMeal.strCountry forKey:@"country"];
            [addressDict setValue:prepareAMeal.strState forKey:@"state"];
            [addressDict setValue:prepareAMeal.strCity forKey:@"city"];
            [addressDict setValue:prepareAMeal.strZipCode forKey:@"zipCode"];
            [addressDict setValue:prepareAMeal.strStreetName forKey:@"streetName"];
            // AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSArray * locationArray = [[NSArray alloc]init];
            if ([APPDELEGATE longitude] && [APPDELEGATE latitude])
                locationArray = @[[APPDELEGATE longitude], [APPDELEGATE latitude]];
            else
                locationArray = @[@"77.1025", @"28.7041"];
            [addressDict setValue:locationArray forKey:@"loc"];
            [self callApiForPrepareMeal];
        }
    } else {
        if ([self validatePrepareAMeal]) {
            cuisineDict = [NSMutableDictionary dictionary];
            [cuisineDict setValue:prepareAMeal.strCuisineName forKey:@"name"];
            [cuisineDict setValue:prepareAMeal.strCuisineType forKey:@"type"];
            
            addressDict = [NSMutableDictionary dictionary];
            [addressDict setValue:prepareAMeal.strCountry forKey:@"country"];
            [addressDict setValue:prepareAMeal.strState forKey:@"state"];
            [addressDict setValue:prepareAMeal.strCity forKey:@"city"];
            [addressDict setValue:prepareAMeal.strZipCode forKey:@"zipCode"];
            [addressDict setValue:prepareAMeal.strStreetName forKey:@"streetName"];
            // AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSArray * locationArray = [[NSArray alloc]init];
            if ([APPDELEGATE longitude] && [APPDELEGATE latitude])
                locationArray = @[[APPDELEGATE longitude], [APPDELEGATE latitude]];
            else
                locationArray = @[@"77.1025", @"28.7041"];
            [addressDict setValue:locationArray forKey:@"loc"];
            //[AlertController title:@"Meal prepared successfully."];
            [self callApiForPrepareMeal];
        }
      }
    }

-(void)btnPrepareMealCountryPicker:(UIButton*)sender{
    [self.view endEditing:YES];
    if(sender.tag == 13){
        NSArray *countries = [CountryPicker countryNames];
        NSDictionary *codesWithName = [CountryPicker countryCodesByName];
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:countries completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        prepareAMeal.strCountry = selectedValues.firstObject;
        NSString *code = [codesWithName valueForKey:selectedValues.firstObject];
        [self.tblView reloadData];
        [self callApiForStateList:code];
    }];
    }
 
}

-(void)btnPrepareMealStatePicker:(UIButton*)sender{
    [self.view endEditing:YES];

    if(sender.tag == 14){
        
        if(prepareAMeal.strCountry == nil || prepareAMeal.strCountry == (id)[NSNull null] || ![statesListArray count]){
            [AlertController title:@"Please select country first."];
        }
        else{
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:statesListArray completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        prepareAMeal.strState = selectedValues.firstObject;
        [self.tblView reloadData];
    }];
    }
   }
}

-(void)btnMealTimePicker:(UIButton*)sender{
    [self.view endEditing:YES];
    if(sender.tag == 20){
        [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"Breakfast", @"Lunch", @"Dinner"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
            LogInfo(@"selectedIndexes    %@", selectedIndexes);
            LogInfo(@"selectedValues    %@", selectedValues);
            prepareAMeal.strMealTime = selectedValues.firstObject;
            [self.tblView reloadData];
        }];
    }
}

-(void)btnPrepareMealDatePicker:(UIButton*)sender{
    [self.view endEditing:YES];
    if(sender.tag == 11){
        
    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
            
        prepareAMeal.strDate = [AppUtility getStringFromDate:date];
        prepareAMeal.date = date;
        [self.tblView reloadData];
        
    }];
    }
}

-(void)btnPrepareMealTimePicker:(UIButton*)sender{
    [self.view endEditing:YES];
    if(sender.tag == 10){
    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"time" completionBlock:^(NSDate *date) {
        
        prepareAMeal.strTime = [AppUtility getStringFromFullTime:date];
        prepareAMeal.time = date;

        [self.tblView reloadData];
    }];
    }
}

-(void)btnAddHealthyMeal:(UIButton*)sender{
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if(sender.selected){
        isHealthyMeal = true;
    }
    else
        isHealthyMeal = false;
    
    
    if(isHealthyMeal) {
        [AppUtility delay:0.2 :^{
            [self.tblView scrollRectToVisible:CGRectMake(0, self.tblView.contentSize.height-10, self.tblView.contentSize.width, 10) animated:YES];
        }];
    }
    

    [self.tblView reloadData];
    
}

- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.sidePanelController showLeftPanelAnimated:YES];

}

-(void)attachButtonSelector:(IndexPathButton *)button {
    
    [AlertController actionSheet:nil message:nil andButtonsWithTitle:@[@"Take from Camera", @"Images", @"Videos"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        UIImagePickerController *actionPicker = [[UIImagePickerController alloc] init];
        actionPicker.delegate = self;
        actionPicker.allowsEditing = YES;
        
        UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
        videoPicker.delegate = self;
        videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        videoPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
        
        if (!index) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                actionPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:actionPicker animated:YES completion:NULL];
            } else {
                [AlertController title:@"Camera is not available."];
            }
        } else if (index == 1) {
            if (self.imageCount >= 5)
                [AlertController title:@"You can not attach more than 5 images."];
            else
                [self presentViewController:actionPicker animated:YES completion:NULL];
            
        } else if (index == 2) {
            
            if (self.videoCount >= 1)
                [AlertController title:@"You can not attach more than one video."];
            else
                [self presentViewController:videoPicker animated:YES completion:NULL];
            
        }
    }];
    
}

-(void) crossButtonSelector:(IndexPathButton *)button {
    
    NSMutableDictionary *dict = [self.attatchmentImageArray objectAtIndex:button.indexPath.row];
    
    if ([[dict valueForKey:@"type"] isEqualToString:@"image"])
        self.imageCount = self.imageCount - 1;
    else {
        self.videoCount = self.videoCount - 1;
        [self.attatchmentVideoArray removeAllObjects];
        
    }
    [self.attatchmentImageArray removeObjectAtIndex:button.indexPath.row];
    
    [self.tblView reloadData];
}

- (void) previewButtonSelector:(IndexPathButton *)sender {
    
    LogInfo(@"%ld", (long)sender.indexPath.row);
    UIImageView *previewImage = [[UIImageView alloc]init];
    
    NSMutableDictionary *imageDict = [self.attatchmentImageArray objectAtIndex:sender.indexPath.row];
    previewImage.image = [imageDict valueForKey:@"image"];
    [EXPhotoViewer showImageFrom: previewImage];
}


#pragma mark - Web Api Section

- (void)callApiForPrepareMeal {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    (self.btnVeg.selected) ? [dict setValue:@"veg" forKey:@"mealType"] : [dict setValue:@"nonveg" forKey:@"mealType"];
    [dict setValue:@"true" forKey:@"prepareMeal"];
    [dict setValue:[NSNumber numberWithBool:isHealthyMeal] forKey:@"healthyMeal"];
    [dict setValue:cuisineDict forKey:@"cuisineDetail"];
    [dict setValue:addressDict forKey:@"PickUpAddress"];
    
    
    //////////////////// Sending images ////////////////////
    
    NSMutableArray *imageBase64Array = [NSMutableArray new];
    NSMutableArray *thumbnailImageBase64Array = [NSMutableArray new];
    
    for (NSMutableDictionary *imageDict in self.attatchmentImageArray) {
        
        if ([[imageDict valueForKey:@"type"] isEqualToString:@"image"])
            
            [imageBase64Array addObject:[[imageDict valueForKey:@"image" ] getBase64StringWithQuality:0.1]];
        else
            [thumbnailImageBase64Array addObject:[[imageDict valueForKey:@"image"] getBase64StringWithQuality:0.1]];
        
    }
    [dict setValue:imageBase64Array forKey:pImages];
    
    
    //////////////////// Sending video ////////////////
    
//    NSMutableDictionary *videoDict = [NSMutableDictionary dictionary];
//    
//    if (self.videoCount) {
//        //NSData *postData = [self generatePostDataForData: self.attatchmentVideoArray.firstObject];
//        [videoDict setValue:self.attatchmentVideoArray.firstObject forKey:@"videoData"];
//        [videoDict setValue:thumbnailImageBase64Array forKey:@"thumbnail"];
//    } else
//        [videoDict setValue:@"" forKey:@"videoData"];
//    [videoDict setValue:thumbnailImageBase64Array forKey:@"thumbnail"];
//    
//    [dict setValue:videoDict forKey:@"video"];

    
    NSMutableArray *ingredientsArray = [[NSMutableArray alloc] init];
    [ingredientsArray addObject:prepareAMeal.strIngredients];
    [dict setValue:ingredientsArray forKey:@"ingredients"];
    [dict setValue:prepareAMeal.strCaloriesPerServing forKey:@"calories"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strPricePerDate integerValue]] forKey:@"price"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strAddOnCost integerValue]] forKey:@"additionalCost"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strServings integerValue]] forKey:@"servings"];
    [dict setValue:prepareAMeal.strSides forKey:@"sides"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strSpiceLevel integerValue]] forKey:@"spiceLevel"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strHealthMeter integerValue]] forKey:@"healthMeter"];
    [dict setValue:[prepareAMeal.time UTCDateFormat] forKey:@"timeRequired"];
    [dict setValue:[prepareAMeal.date UTCDateFormat] forKey:@"date"];
    [dict setValue:prepareAMeal.strMealCount forKey:@"mealCount"];
    if(isHealthyMeal){
        [dict setValue:@"true" forKey:@"healthyMeal"];
        healthyMealDict = [NSMutableDictionary dictionary];
        [healthyMealDict setValue:prepareAMeal.strMinerals forKey:@"minerals"];
        [healthyMealDict setValue:[NSString stringWithFormat:@"%ld",(long)[prepareAMeal.strQuantityToConsume integerValue]] forKey:@"consumedQuantity"];
        [healthyMealDict setValue:prepareAMeal.strMealTime forKey:@"MealTime"];
        [healthyMealDict setValue:prepareAMeal.strNutrients forKey:@"nutrients"];

        [dict setValue:healthyMealDict forKey:@"addToHealthyMeal"];
    }else
        [dict setValue:@"false" forKey:@"healthyMeal"];

    
    [ServiceHelper request:dict apiName:kAPIPrepareAMeal method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
              //  isHealthyMeal = NO;
              //  [self.tblView reloadData];
                [AlertController title:@"Meal prepared successfully."];
               // [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForStateList:(NSString *)counryCode {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *api = [NSString stringWithFormat:@"%@/%@/ISO2",kAPIGetAllStates,counryCode];
    
    [ServiceHelper request:dict apiName:api method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
              //  [statesListArray removeAllObjects];
                statesListArray = [resultDict objectForKey:@"data"];
                
            } else {
                [statesListArray removeAllObjects];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


@end
