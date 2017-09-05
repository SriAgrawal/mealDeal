//
//  MDCustomMealVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 03/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDCustomMealVC.h"
#import "Macro.h"

static NSString *cellIDMDTextFieldCell          = @"MDTextFieldCell";
static NSString *cellIDMDSingleButtonCell       = @"MDSingleButtonCell";
static NSString *cellIDMDAttatchmentCell        = @"MDAttatchmentCell";
static NSString *cellIDMDTextViewCell           = @"MDTextViewCell";
static NSString *cellIDMDTitleRatingCell        = @"MDTitleRatingCell";
static NSString *cellIDMDAllergiesCell          = @"MDAllergiesCell";

@interface MDCustomMealVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *statesListArray;
}

@property (weak, nonatomic) IBOutlet UITableView                    *tableView;

@property (weak, nonatomic) IBOutlet UIButton                       *vegButton;
@property (weak, nonatomic) IBOutlet UIButton                       *nonvegButton;

@property (strong, nonatomic) RequestMealModal                      *reqModatObj;

@property (strong, nonatomic) NSMutableArray                        *attatchmentImageArray;

@property (strong, nonatomic) NSMutableArray                        *attatchmentVideoArray;

@property (nonatomic, strong) NSArray                               *allergiesArray;

@property (nonatomic) NSInteger                                     imageCount;
@property (nonatomic) NSInteger                                     videoCount;

@end

@implementation MDCustomMealVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self callApiForAllergiesData];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    
    self.imageCount = 0;
    self.videoCount = 0;
    self.reqModatObj = [[RequestMealModal alloc] init];
    statesListArray = [[NSMutableArray alloc] init];
    self.attatchmentImageArray = [NSMutableArray array];
    self.attatchmentVideoArray = [NSMutableArray array];

      [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
}

#pragma mark- Validation Method

- (BOOL)isAllFieldsVerified {
    
    BOOL isAllValid = YES;
    
    if (!self.vegButton.selected && !self.nonvegButton.selected) {
        
        [AlertController title: @"Please select meal type."];
        isAllValid = NO;
        
    } else if (![TRIM_SPACE(self.reqModatObj.cuisineNameString) length]) {
        
        [AlertController title: ![TRIM_SPACE(self.reqModatObj.cuisineNameString) length] ? @"Please enter cuisine name." : @"Please enter valid cuisine name."];
        isAllValid = NO;
        
    } else if (![TRIM_SPACE(self.reqModatObj.cuisineTypeString) length] || ![self.reqModatObj.cuisineTypeString isValidFullName]) {
        
        [AlertController title: ![TRIM_SPACE(self.reqModatObj.cuisineTypeString) length] ? @"Please enter cuisine type." :@"Please enter valid cuisine type."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.allergiesString) length]) {
        
        [AlertController title: @"Please enter allergies."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.storeAroundString) length]) {
        
        [AlertController title: @"Please enter store around."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.splRequirementsString) length]) {
        
        [AlertController title: @"Please enter special requirements"];
        isAllValid = NO;

       
    } else if (![TRIM_SPACE(self.reqModatObj.stepsString) length]) {
        
        [AlertController title:@"Please enter steps." ];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.ingredientsReqString) length]) {
        
        [AlertController title:@"Please enter ingredients required." ];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.countryString) length]) {
        
        [AlertController title: @"Please select country."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.stateString) length]) {
        
        [AlertController title: @"Please select state."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.zipCodeString) length] || [TRIM_SPACE(self.reqModatObj.zipCodeString) length] <= 2 || [TRIM_SPACE(self.reqModatObj.zipCodeString) length] >= 11) {
       
        [AlertController title: ![TRIM_SPACE(self.reqModatObj.zipCodeString) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters." ];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.addressCodeString) length]) {
        
        [AlertController title: @"Please enter address."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.priceString) length]) {
        
        [AlertController title: @"Please enter price."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.quantityString) length]) {
        
        [AlertController title: @"Please enter quantity."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.dateString) length]) {
        
        [AlertController title: @"Please select date."];
        isAllValid = NO;

        
    } else if (![TRIM_SPACE(self.reqModatObj.timeString) length]) {
        
        [AlertController title: @"Please select time."];
        isAllValid = NO;
        
    }
    
    return isAllValid;
}

#pragma mark - UIButton Action

- (IBAction)vegButtonAction:(id)sender {
    self.vegButton.selected = YES;
    self.nonvegButton.selected = NO;
}

- (IBAction)nonvegButtonAction:(id)sender {
    self.nonvegButton.selected = YES;
    self.vegButton.selected = NO;
}

- (IBAction)sendRequestButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self isAllFieldsVerified]) {
    
        [self callApiForCustomMeal];
        
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - Selector Method Actions

- (void)onRatingView:(HCSStarRatingView *)ratingValue {
    [self.view endEditing:YES];
    
    self.reqModatObj.spiceRating = [NSString stringWithFormat:@"%f", ratingValue.value];
    LogInfo(@"%f",ratingValue.value);
    
    [self.tableView reloadData];
}


- (void)onCountry:(IndexPathButton *)button {
    [self.view endEditing:YES];
    if (button.indexPath.row == 9) {
        NSArray *countries = [CountryPicker countryNames];
        NSDictionary *codesWithName = [CountryPicker countryCodesByName];
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:countries completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        self.reqModatObj.countryString = selectedValues.firstObject;
        NSString *code = [codesWithName valueForKey:selectedValues.firstObject];
        [self.tableView reloadData];
        [self callApiForStateList:code];
    }];
    }
}

- (void)onState:(IndexPathButton *)button {
    [self.view endEditing:YES];
  
    if (button.indexPath.row == 10) {

        if(self.reqModatObj.countryString == nil || self.reqModatObj.countryString == (id)[NSNull null] || ![statesListArray count]){
            [AlertController title:@"Please select country first."];
        }else{
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:statesListArray completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        self.reqModatObj.stateString = selectedValues.firstObject;
        [self.tableView reloadData];
    }];
    }
}
}

- (void)onTime:(IndexPathButton *)button {
    
    [self.view endEditing:YES];
    if (button.indexPath.row == 16) {
        [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"time" completionBlock:^(NSDate *date) {
            self.reqModatObj.timeString = [AppUtility getStringFromTime:date];
            self.reqModatObj.time = date;

            //[button setTitle:[NSString stringWithFormat:@"%@",date] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }];
    }

}

- (void)onDate:(IndexPathButton *)button {
    
    [self.view endEditing:YES];
    
    if (button.indexPath.row == 15) {

    [[DatePickerManager dateManager] showDatePicker:self andUIDateAndTimePickerMode:@"date" completionBlock:^(NSDate *date) {
        self.reqModatObj.dateString = [AppUtility getStringFromDate:date];
        self.reqModatObj.date = date;

        //[button setTitle:self.reqModatObj.dateString forState:UIControlStateNormal];
        [self.tableView reloadData];
    }];
  }
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
    
    [self.tableView reloadData];
}

- (void) previewButtonSelector:(IndexPathButton *)sender {
   
    LogInfo(@"%ld", (long)sender.indexPath.row);
    UIImageView *previewImage = [[UIImageView alloc]init];
    
    NSMutableDictionary *imageDict = [self.attatchmentImageArray objectAtIndex:sender.indexPath.row];
    previewImage.image = [imageDict valueForKey:@"image"];
    [EXPhotoViewer showImageFrom: previewImage];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TextField *field = (TextField *)textField;
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        MDCustomMealCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:field.indexPath.row + 1 inSection:0]];
        [nextCell.inputTextfield becomeFirstResponder];
        
    } else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (!(textField.tag == 100)) {
        TextField *field = (TextField *)textField;
        field.active = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ((textField.tag == 100)) {
        self.reqModatObj.allergiesString = textField.text;
    }
    else {
        TextField *field = (TextField *)textField;
        field.active = NO;
        
        [self updateDatForTextField:field];
    }
}

- (void)updateDatForTextField:(TextField *)field {
    
    switch (field.indexPath.row) {
            
        case 0: self.reqModatObj.cuisineNameString = field.text; break;
            
        case 1: self.reqModatObj.cuisineTypeString = field.text; break;
            
        case 4: self.reqModatObj.storeAroundString = field.text; break;
            
        case 5: self.reqModatObj.splRequirementsString = field.text; break;
            
        case 7: self.reqModatObj.ingredientsReqString = field.text; break;
            
        case 9: self.reqModatObj.countryString = field.text; break;
            
        case 10: self.reqModatObj.stateString = field.text; break;
        
        case 11: self.reqModatObj.zipCodeString = field.text; break;

        case 13: self.reqModatObj.priceString = field.text; break;
            
        case 14: self.reqModatObj.quantityString = field.text; break;
            
        case 15: self.reqModatObj.dateString = field.text; break;
            
        case 16: self.reqModatObj.timeString = field.text; break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidEndEditing:(UITextView *)textField {
    
    AHTextView *field = (AHTextView *)textField;
    
    switch (field.indexPath.row) {
            
        case 6: self.reqModatObj.stepsString = field.text; break;
            
        case 12: self.reqModatObj.addressCodeString = field.text; break;
            
        default:
            break;
    }
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 17;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6 || indexPath.row == 12)
        return 70.0f; // textView cell
    else if (indexPath.row == 8)
        return 35.0f;
    else if (indexPath.row == 2)
        return 60.0f;
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDCustomMealCell *cell = (MDCustomMealCell *)[tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    
    [cell.inputTextfield setIndexPath:indexPath];
    [cell.buttonTextfield setIndexPath:indexPath];
    [cell.inputTextView setIndexPath:indexPath];
    
    [cell.button setIndexPath:indexPath];
    
    [cell.inputTextfield setSecureTextEntry:NO];
    [cell.inputTextfield setReturnKeyType:UIReturnKeyNext];
    [cell.inputTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [cell.inputTextfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [cell.inputTextfield setInputAccessoryView:nil];
    
    switch (indexPath.row) {
            
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDTextFieldCell >>>>>>>>>>>>>>>>>>>>>>>
        case 0:
            [cell.inputTextfield placeHolderText:@"Cuisine Name"];
            cell.inputTextfield.text = self.reqModatObj.cuisineNameString;
            
            [cell.inputTextfield setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        
            break;
            
        case 1:
            [cell.inputTextfield placeHolderText:@"Cuisine Type"];
            cell.inputTextfield.text = self.reqModatObj.cuisineTypeString;
            
            [cell.inputTextfield setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [cell.inputTextfield setReturnKeyType:UIReturnKeyDone];
            
            break;
            
        case 2:
            [cell.attachButton addTarget:self action:@selector(attachButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
            cell.collectionView.delegate = self;
            cell.collectionView.dataSource = self;
            [cell.collectionView reloadData];
        
            break;
            
        case 3:
           
            cell.allergiesTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Allergies" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1.0]}];
            cell.allergiesTextField.tag = 100;
            cell.allergiesTextField.autocompleteType = HTAutocompleteTypeColor;
            cell.allergiesTextField.text = self.reqModatObj.allergiesString;
            
            break;
            
        case 4:
            [cell.inputTextfield placeHolderText:@"Store Around"];
            cell.inputTextfield.text = self.reqModatObj.storeAroundString;
            
        
            break;
            
        case 5:
            [cell.inputTextfield placeHolderText:@"Spl. Requirements"];
            cell.inputTextfield.text = self.reqModatObj.splRequirementsString;
            [cell.inputTextfield setReturnKeyType:UIReturnKeyDone];
        
            break;
            
        case 6:
            cell.inputTextView.placeholderText = @"Steps";
            cell.inputTextfield.text = self.reqModatObj.stepsString;
            
        
            break;
            
        case 7:
            [cell.inputTextfield placeHolderText:@"Ingredients Required"];
            cell.inputTextfield.text = self.reqModatObj.ingredientsReqString;
            [cell.inputTextfield setReturnKeyType:UIReturnKeyDone];
            
    
            break;
       
        case 8:
          
            cell.ratingView.value = [self.reqModatObj.spiceRating floatValue];
            
            [cell.ratingView addTarget:self action:@selector(onRatingView:) forControlEvents:UIControlEventValueChanged];
            
            break;

        case 11:
            [cell.inputTextfield placeHolderText:@"Zip"];
            [cell.inputTextfield setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            //[cell.inputTextfield setInputAccessoryView:[self getToolBarForNumberPad]];
            cell.inputTextfield.text = self.reqModatObj.zipCodeString;
            [cell.inputTextfield setReturnKeyType:UIReturnKeyDone];
        
            break;
            
        case 12:
            cell.inputTextView.placeholderText = @"Address";
            cell.inputTextfield.text = self.reqModatObj.addressCodeString;
            
            break;
            
        case 13:
            [cell.inputTextfield placeHolderText:@"Price Offering"];
            [cell.inputTextfield setKeyboardType:UIKeyboardTypePhonePad];
            [cell.inputTextfield setInputAccessoryView:[self getToolBarForNumberPad]];
            cell.inputTextfield.text = self.reqModatObj.priceString;
            
            break;
            
        case 14:
            [cell.inputTextfield placeHolderText:@"Quantity"];
            [cell.inputTextfield setKeyboardType:UIKeyboardTypePhonePad];
            [cell.inputTextfield setInputAccessoryView:[self getToolBarForNumberPad]];
            cell.inputTextfield.text = self.reqModatObj.quantityString;
            [cell.inputTextfield setReturnKeyType:UIReturnKeyDone];
            
        
            break;
            
        case 15:
            [cell.buttonTextfield placeHolderText:@"Date"];
            cell.buttonTextfield.text = self.reqModatObj.dateString;
            [cell.button addTarget:self action:@selector(onDate:) forControlEvents:UIControlEventTouchUpInside];
        
         break;
            
        case 16:
            [cell.buttonTextfield placeHolderText:@"Time"];
            cell.buttonTextfield.text = self.reqModatObj.timeString;
            [cell.button addTarget:self action:@selector(onTime:) forControlEvents:UIControlEventTouchUpInside];
        
            break;
            
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDSingleButtonCell >>>>>>>>>>>>>>>>>>>>>>>
            
        case 9:
            [cell.buttonTextfield placeHolderText:@"Country"];
            [cell.button addTarget:self action:@selector(onCountry:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonTextfield setText:self.reqModatObj.countryString ];

        
            break;
            
        case 10:
            [cell.buttonTextfield placeHolderText:@"State"];
            [cell.button addTarget:self action:@selector(onState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonTextfield setText:self.reqModatObj.stateString ];
            
        
            break;
            
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cellIDMDMultiButtonCell >>>>>>>>>>>>>>>>>>>>>>>
            
        default:
            
            break;
    }
    
    return cell;
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
    
    [cell.crossButton setIndexPath:indexPath];
    [cell.previewButton setIndexPath:indexPath];

    [cell.crossButton addTarget:self action:@selector(crossButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    [cell.previewButton addTarget:self action:@selector(previewButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(55 , 55);
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 2: return cellIDMDAttatchmentCell;
        case 3: return cellIDMDAllergiesCell;
        case 6: return cellIDMDTextViewCell;
        case 8: return cellIDMDTitleRatingCell;
        case 9: return cellIDMDSingleButtonCell;
        case 10: return cellIDMDSingleButtonCell;
        case 12: return cellIDMDTextViewCell;
        case 15: return cellIDMDSingleButtonCell;
        case 16: return cellIDMDSingleButtonCell;
            
        default: return cellIDMDTextFieldCell;
    }
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        
        NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
        [imageDict setObject:[info objectForKey:UIImagePickerControllerEditedImage] forKey:@"image"];
        [imageDict setObject:@"image" forKey:@"type"];
        
        [self.attatchmentImageArray addObject:imageDict];
        self.reqModatObj.attachedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
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

    [self.tableView reloadData];

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

- (NSData *)generatePostDataForData:(NSData *)uploadData
{
    // Generate the post header:
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"somefile\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length]];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

#pragma mark - Web Api Section

- (void)callApiForCustomMeal {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    
    (self.vegButton.selected) ? [dict setValue:@"veg" forKey:pMealType] : [dict setValue:@"nonveg" forKey:pMealType];
    
    [dict setValue:[APPDELEGATE longitude] forKey:pLongitude];
    [dict setValue:[APPDELEGATE latitude] forKey:platitude];
    
    NSMutableDictionary *cuisineDict = [NSMutableDictionary dictionary];
    [cuisineDict setValue:self.reqModatObj.cuisineNameString forKey:pName];
    [cuisineDict setValue:self.reqModatObj.cuisineTypeString forKey:pType];
    [dict setValue:cuisineDict forKey:pCuisineDetail];
    
    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
    [addressDict setValue:self.reqModatObj.countryString forKey:pCountry];
    [addressDict setValue:self.reqModatObj.stateString forKey:pState];
    [addressDict setValue:self.reqModatObj.zipCodeString forKey:pZipCode];
    [addressDict setValue:self.reqModatObj.addressCodeString forKey:pStreetName];
    [dict setValue:addressDict forKey:pAddress];

    [dict setValue:self.reqModatObj.priceString forKey:pPrice];
    [dict setValue:[self.reqModatObj.ingredientsReqString componentsSeparatedByString:@","] forKey:pIngredients];
    [dict setValue:self.reqModatObj.quantityString forKey:pQuantity];
    
    [dict setValue:[self.reqModatObj.date UTCDateFormat] forKey:pDate];
    [dict setValue:[self.reqModatObj.time UTCDateFormat] forKey:pTime];
    [dict setValue:[self.reqModatObj.storeAroundString componentsSeparatedByString:@","] forKey:pStoresArounds];
    [dict setValue:self.reqModatObj.splRequirementsString forKey:pSpecialRequirements];
    [dict setValue:self.reqModatObj.stepsString forKey:pSteps];
    [dict setValue:self.reqModatObj.spiceRating forKey:pSpiceLevel];
    [dict setValue:[self.reqModatObj.allergiesString componentsSeparatedByString:@","] forKey:pAllergies];
   
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
//        NSData *postData = [self generatePostDataForData: self.attatchmentVideoArray.firstObject];
//        [videoDict setValue:postData forKey:@"videoData"];
//        [videoDict setValue:thumbnailImageBase64Array forKey:@"thumbnail"];
//    } else
//        [videoDict setValue:@"" forKey:@"videoData"];
//        [videoDict setValue:thumbnailImageBase64Array forKey:@"thumbnail"];
//    
//    [dict setValue:videoDict forKey:@"video"];

    [ServiceHelper request:dict apiName:kAPICustomMeal method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                        [AlertController title:@"" message:@"Your meal request sent successfully." andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                            MDOrderStatusBaseVC *orderStatusBaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDOrderStatusBaseVC"];
                            orderStatusBaseVC.isBack = YES;
                            [self.navigationController pushViewController: orderStatusBaseVC animated:YES];
                            
                        }];

            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForAllergiesData {
    
    [ServiceHelper request:[NSMutableDictionary dictionary] apiName:kAPIForAutoAllergies method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSArray array]];
                
                self.allergiesArray = [dataDict objectForKeyNotNull:pAllAllergies expectedObj:[NSArray array]];
                
                [HTAutocompleteManager sharedManager].allAllergiesArray = self.allergiesArray ;
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
            //    [statesListArray removeAllObjects];
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

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
