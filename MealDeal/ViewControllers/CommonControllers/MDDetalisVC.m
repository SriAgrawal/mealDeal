//
//  MDDetalisVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDDetalisVC.h"
#import "Macro.h"

static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";
static NSString *cellIdentifier2 = @"MDTitleRatingCell";

static CGFloat  animationDuration = 3;

@interface MDDetalisVC ()

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;

@property (weak, nonatomic) IBOutlet UIPageControl      *pageControl;
@property (weak, nonatomic) IBOutlet UILabel            *cooksSpecialityLabel;
@property (weak, nonatomic) IBOutlet UILabel            *reviewLabel;
@property (weak, nonatomic) IBOutlet UIButton           *addonsButton;
@property (weak, nonatomic) IBOutlet UIView             *addonsFooterView;

@property (weak, nonatomic) IBOutlet UITextView         *addonsTextView;
@property (weak, nonatomic) IBOutlet UILabel            *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addonsBottomConstraint;
@property (weak, nonatomic) IBOutlet HCSStarRatingView  *ratingView;

@property (strong, nonatomic) NSArray                   *bannerList;
@property (strong, nonatomic) NSIndexPath               *currentIndexPath;

@property (strong, nonatomic) NSArray                   *titleArray;
@property (strong, nonatomic) NSArray                   *dummyDetailArray;

@property (strong, nonatomic) MealDetails               *mealDetailsObj;

@end

@implementation MDDetalisVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Private Methods

-(void)initialSetup {
   
    self.tableView.tableFooterView = self.addonsFooterView;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;

    // textview user interaction set no till addons button is not checked
         self.addonsTextView.userInteractionEnabled = NO;
    
    //Tittle Array initialization
    self.titleArray = @[@"Cook Name", @"Type", @"Cuisine Name", @"Cuisine Type", @"Ingredients", @"Calories (approx)", @"Price (per plate)", @"Price on Addons", @"Cuisine Includes",@"Servings", @"Prep. time"];
    
//    // dummy detail array
//    self.dummyDetailArray = @[@"Robret Thomasan", @"Veg", @"Fried Chicken", @"Chinese", @"Chinese, Butter", @"250", @"$5", @"$1", @"Gravy", @"2%", @"30 min"];
    
//    // dummy image array
//    self.bannerList = @[@"banner_img.png", @"banner_img1.png", @"burger_img.png", @"cake_img.png"];
    
    [self.pageControl setHidden:YES];

    [self callApiForMealDetail];
}

- (void)slideShow {
    
    if (self.currentIndexPath.row < self.mealDetailsObj.imageUrlArray.count - 1) {
        
        NSIndexPath *nextScrollableIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
        self.currentIndexPath = nextScrollableIndexPath;
        [self.collectionView scrollToItemAtIndexPath:nextScrollableIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
       // NSIndexPath *nextScrollableIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
       // self.currentIndexPath = nextScrollableIndexPath;
       // [self.collectionView scrollToItemAtIndexPath:nextScrollableIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    self.pageControl.currentPage =  self.currentIndexPath.row;
    
    [AppUtility delay:animationDuration :^{
        [self slideShow];
    }];
}

#pragma mark - UIButton Actions

- (IBAction)locationButtonAction:(id)sender {
    
    MDLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLocationVC"];
    locationVC.isAfterLogin = YES;
    locationVC.isBack = YES;

    [self.navigationController pushViewController:locationVC animated:YES];

}

- (IBAction)backbuttonaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addMealButtonAction:(id)sender {
    
    [self callApiForAddMealToCart];

}

- (IBAction)reviewButtonAction:(id)sender {
    MDCookReviewsVC *cookReviewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCookReviewsVC"];
    cookReviewsVC.strChefId = self.mealDetailsObj.chefIdString;
    cookReviewsVC.strCookName = self.mealDetailsObj.chefNameString;
    [self.navigationController pushViewController:cookReviewsVC animated:YES];
}

- (IBAction)customMealButtonAction:(id)sender {
    MDCustomOrderVC *customOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCustomOrderVC"];
    customOrderVC.cusomMealObj = self.mealDetailsObj;
    [self.navigationController pushViewController: customOrderVC animated:YES];
}

- (IBAction)addonsButtonAction:(id)sender {
    
    self.addonsButton.selected = !self.addonsButton.selected;
    
    if (self.addonsButton.selected == YES) {
        
        [AlertController title:[NSString stringWithFormat:@"Add-ons will be charged $%@",self.mealDetailsObj.additionalCostString] message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            self.addonsTextView.userInteractionEnabled = YES;
            [self.addonsTextView becomeFirstResponder];
        }];
    } else {
        self.addonsTextView.userInteractionEnabled = NO;
        [self.addonsTextView resignFirstResponder];
    }
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 13;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row <11) {
    
    MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
                
            case 0: [cell.detailLabel setText:self.mealDetailsObj.chefNameString]; break;
                
            case 1: [cell.detailLabel setText: self.mealDetailsObj.mealTypeString]; break;
                
            case 2: [cell.detailLabel setText:self.mealDetailsObj.cuisineNameString]; break;
                
            case 3: [cell.detailLabel setText:self.mealDetailsObj.cuisineTypeString]; break;
                
            case 4: [cell.detailLabel setText:self.mealDetailsObj.ingredientsString]; break;
                
            case 5: [cell.detailLabel setText:self.mealDetailsObj.caloriesString]; break;
                
            case 6: (self.mealDetailsObj.priceString)? [cell.detailLabel setText:[@"$" stringByAppendingString:self.mealDetailsObj.priceString]] : [cell.detailLabel setText:@""]; break;

            case 7: (self.mealDetailsObj.additionalCostString)? [cell.detailLabel setText:[@"$" stringByAppendingString:self.mealDetailsObj.additionalCostString]] : [cell.detailLabel setText:@""]; break;
           
            case 8: [cell.detailLabel setText:self.mealDetailsObj.cuisineIncludes]; break;

            case 9: (self.mealDetailsObj.servingsString)? [cell.detailLabel setText:[self.mealDetailsObj.servingsString stringByAppendingString:@"%"]] : [cell.detailLabel setText:@""]; break;

            case 10: [cell.detailLabel setText:self.mealDetailsObj.timeRequiredString]; break;

        }
        
        return cell;
        
    } else {
        
        MDTitleRatingCell *cell = (MDTitleRatingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.ratingView.userInteractionEnabled = NO;

        if (indexPath.row == 11) {
          cell.titleLabel.text = @"Spice Level";
            cell.ratingView.emptyStarImage = [UIImage imageNamed:@"spice_icon_gry"];
            cell.ratingView.filledStarImage = [UIImage imageNamed:@"spice_icon"];
            cell.ratingView.value = [self.mealDetailsObj.spiceLevelString floatValue];

        } else {
            cell.titleLabel.text = @"Health Meter";
            cell.ratingView.emptyStarImage = [UIImage imageNamed:@"heart_icon_gray"];
            cell.ratingView.filledStarImage = [UIImage imageNamed:@"heart_icon"];
            cell.ratingView.value = [self.mealDetailsObj.healthMeterString floatValue];
        }
        
        return cell;
    }
}

#pragma mark - UICollectionViewDataSource/Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.mealDetailsObj.imageUrlArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDBannerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDBannerImageCollectionViewCell" forIndexPath:indexPath];
    
   // cell.bannerImageView.image = [UIImage imageNamed:[self.bannerList objectAtIndex:indexPath.row]];
    //    [cell.bannerImageView sd_setImageWithURL:[self.bannerList objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"placeholder"]];

//    cell.bannerImageView.image = [UIImage imageNamed:[self.mealDetailsObj.imageUrlArray objectAtIndex:indexPath.row]];
    
    /*[cell.bannerImageView sd_setImageWithURL:[self.mealDetailsObj.imageUrlArray objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [cell.bannerImageView setContentMode:UIViewContentModeScaleToFill];*/
    if(indexPath.row < [self.mealDetailsObj.imageUrlArray count]) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[self.mealDetailsObj.imageUrlArray objectAtIndex:indexPath.row]];
        // Load image in UIWebView
        cell.imageVideoWebView.scalesPageToFit = YES;
        [cell.imageVideoWebView loadRequest: imageRequest];
        cell.btnPlayVideoDetails.hidden = YES;
    } else {
        NSString *url=@"http://www.html5videoplayer.net/html5video/mp4-h-264-video-test/";
        [cell.imageVideoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        cell.imageVideoWebView.scrollView.bounces = NO;
        [cell.imageVideoWebView setMediaPlaybackRequiresUserAction:NO];
        cell.btnPlayVideo.tag = indexPath.item;
        [cell.btnPlayVideo addTarget:self action:@selector(btnPlayVideoDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlayVideoDetails.hidden = YES;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

-(void)btnPlayVideoDetailsAction:(UIButton*)sender{
    NSIndexPath *indexPath;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    MDBannerImageCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.btnPlayVideoDetails.hidden = YES;
}

#pragma mark - Web Api Section

- (void)callApiForMealDetail {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.chefIdString forKey:pChefId];
    [dict setValue:self.mealIdString forKey:pMealId];

    [ServiceHelper request:dict apiName:kAPIMealsDetail method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                                
                self.mealDetailsObj = [MealDetails mealDetails:resultDict];
                
                self.reviewLabel.text = [NSString stringWithFormat:@"(%@ Reviews)", self.mealDetailsObj.totalReviewString];
                self.cooksSpecialityLabel.text = ([self.mealDetailsObj.specialityString isEqualToString:@""]) ? [NSString stringWithFormat:@"Chef's Speciality - %@", @"None"] : [NSString stringWithFormat:@"Chef's Speciality - %@", self.mealDetailsObj.specialityString];
                self.ratingView.value = [self.mealDetailsObj.totalRatingString floatValue];

                if (self.mealDetailsObj.imageUrlArray.count) {
                    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.collectionView reloadData];
                    
                    (self.mealDetailsObj.imageUrlArray.count <= 1) ? [self.pageControl setHidden:YES] : [self.pageControl setHidden:NO];
                    
                    [self.pageControl setNumberOfPages:[self.mealDetailsObj.imageUrlArray count] + 1];
                    
//                    [AppUtility delay:animationDuration :^{
//                        [self slideShow];
//                    }];
                }
                
                [self.tableView reloadData];
                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForAddMealToCart {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.mealDetailsObj.chefIdString forKey:pChefId];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:pDinerId];
    
    NSMutableDictionary *mealDetail = [NSMutableDictionary dictionary];
    [mealDetail setValue:self.mealIdString forKey:pMealId];
    [mealDetail setValue:@"1" forKey:pQuantity];
    [mealDetail setValue:(self.addonsButton.selected)? @"true" : @"false" forKey:pAddons];
    [mealDetail setValue:(self.addonsButton.selected) ? self.addonsTextView.text : @"" forKey:pAddonsDetails];
    
    [dict setValue:mealDetail forKey:pMeal];
    
    [ServiceHelper request:dict apiName:kAPIAddToCart method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                [APPDELEGATE setCartCount:[APPDELEGATE cartCount] + 1];

                MDCartVC *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDCartVC"];
                cartVC.isBack = YES;
                [self.navigationController pushViewController: cartVC animated:YES];
                                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
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
