//
//  MDRequestVC.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDRequestVC.h"

static CGFloat  animationDuration = 3;

@interface MDRequestVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *placeholderArray;
    NSString *strStatus;
    CookPrepareAMealModal *requestedMealDetail;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray                   *bannerList;
@property (strong, nonatomic) NSIndexPath               *currentIndexPath;


@end

@implementation MDRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationDict = [[NSDictionary alloc]init];
    
    placeholderArray = [[NSMutableArray alloc] initWithObjects:@"Diner",@"Diner zip",@"Cuisine Name",@"Cuisine Type",@"Allergies",@"Store Around",@"Special Req.",@"Steps",@"Ingredients Req",@"Spice Level",@"Price Offering",@"Pick Up Date",@"Pick Up Time", nil];
    // Do any additional setup after loading the view.
    [self callApiForRequestDetails];
    // dummy image array
    self.bannerList = @[@"banner_img.png", @"banner_img1.png", @"burger_img.png", @"cake_img.png",@""];
//    
//    [self.pageControl setNumberOfPages:[self.bannerList count]];
//    
 //   self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
 //   [self.pageControl setNumberOfPages:5];
 //   [AppUtility delay:animationDuration :^{
 //       [self slideShow];
 //   }];

}

- (void)slideShow {
    
    if (self.currentIndexPath.row < requestedMealDetail.requestDetailMealImages.count - 1) {
        
        NSIndexPath *nextScrollableIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
        self.currentIndexPath = nextScrollableIndexPath;
        [self.collectionView scrollToItemAtIndexPath:nextScrollableIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
      //  NSIndexPath *nextScrollableIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
      //  self.currentIndexPath = nextScrollableIndexPath;
      //  [self.collectionView scrollToItemAtIndexPath:nextScrollableIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    self.pageControl.currentPage =  self.currentIndexPath.row;
    
    [AppUtility delay:animationDuration :^{
        [self slideShow];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [placeholderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MDDealRequestCell";
    
    MDDealRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              cellIdentifier];
    if (cell == nil) {
        cell = [[MDDealRequestCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.lblRequestMenu.text = [placeholderArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailDinerName;
        }
            break;
        case 1:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailDinerZip;
            
        }
            break;
        case 2:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailCuisineName;
        }
            break;
        case 3:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailCuisineType;
        }
            break;
        case 4:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailAllergies;

        }
            break;
        case 5:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailStoreAround;
        }
            break;
        case 6:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailSpecialRequirements;

        }
            break;
        case 7:{
            cell.txtViewRequest.hidden = NO;
            cell.lblRequestMenuData.hidden = YES;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.txtViewRequest.text = requestedMealDetail.strRequestDetailSteps;
        }
            break;
        case 8:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailIngredientesReq;
        }
            break;
        case 9:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = YES;
            cell.spiceViewRequest.hidden = NO;
            [cell.spiceViewRequest setEnabled:NO];
            cell.btnSpiceLevel.hidden = NO;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.spiceViewRequest.value = [requestedMealDetail.strRequestDetailSpiceLevel floatValue];
            cell.btnSaveSpiceLevel.tag = indexPath.row;
            cell.btnSpiceLevel.tag = indexPath.row;
            [cell.btnSpiceLevel addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnSaveSpiceLevel addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 10:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = [NSString stringWithFormat:@"$%@",requestedMealDetail.strRequestDetailPriceOffering];
        }
            break;
        case 11:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailPickUpDate;
        }
            break;
        case 12:{
            cell.txtViewRequest.hidden = YES;
            cell.lblRequestMenuData.hidden = NO;
            cell.spiceViewRequest.hidden = YES;
            cell.btnSpiceLevel.hidden = YES;
            cell.btnSaveSpiceLevel.hidden = YES;
            cell.lblRequestMenuData.text = requestedMealDetail.strRequestDetailPickUpTime;
        }
            break;
            
        default:
            break;
    }
   /* if(indexPath.row == 7){
        cell.txtViewRequest.hidden = NO;
        cell.lblRequestMenuData.hidden = YES;
        cell.spiceViewRequest.hidden = YES;
        cell.btnSpiceLevel.hidden = YES;
        cell.btnSaveSpiceLevel.hidden = YES;

        
    }else if (indexPath.row == 9){
        cell.txtViewRequest.hidden = YES;
        cell.lblRequestMenuData.hidden = YES;
        cell.spiceViewRequest.hidden = NO;
        [cell.spiceViewRequest setEnabled:NO];
        cell.btnSpiceLevel.hidden = NO;
        cell.btnSaveSpiceLevel.hidden = YES;
        cell.btnSaveSpiceLevel.tag = indexPath.row;
        cell.btnSpiceLevel.tag = indexPath.row;
        [cell.btnSpiceLevel addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSaveSpiceLevel addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.txtViewRequest.hidden = YES;
        cell.lblRequestMenuData.hidden = NO;
        cell.spiceViewRequest.hidden = YES;
        cell.btnSpiceLevel.hidden = YES;
        cell.btnSaveSpiceLevel.hidden = YES;
    }*/
    
    return cell;
}

#pragma mark UICollectionViewDataSource/Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [requestedMealDetail.requestDetailMealImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDBannerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDBannerImageCollectionViewCell" forIndexPath:indexPath];
    
    if(indexPath.row < [requestedMealDetail.requestDetailMealImages count]){
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[requestedMealDetail.requestDetailMealImages objectAtIndex:indexPath.row]]];
    // Load image in UIWebView
    cell.requestDetailsVideoWebView.scalesPageToFit = YES;
    [cell.requestDetailsVideoWebView loadRequest: imageRequest];
        cell.btnPlayVideo.hidden = YES;
    }else{
        NSString *url=@"http://www.html5videoplayer.net/html5video/mp4-h-264-video-test/";
        [cell.requestDetailsVideoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        cell.requestDetailsVideoWebView.scrollView.bounces = NO;
        [cell.requestDetailsVideoWebView setMediaPlaybackRequiresUserAction:NO];
        cell.btnPlayVideo.tag = indexPath.item;
        [cell.btnPlayVideo addTarget:self action:@selector(btnPlayVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlayVideo.hidden = YES;
    }
  //  cell.requestImgView.image = [UIImage imageNamed:[self.bannerList objectAtIndex:indexPath.row]];
    //    [cell.bannerImageView sd_setImageWithURL:[self.bannerList objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"placeholder"]];
  //  [cell.requestImgView setContentMode:UIViewContentModeScaleToFill];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}



#pragma mark Button Action Method

-(void)btnPlayVideoAction:(UIButton*)sender{
    NSIndexPath *indexPath;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    MDBannerImageCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.btnPlayVideo.hidden = YES;
}

-(void)editBtnAction:(UIButton*)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
    MDDealRequestCell *cell = (MDDealRequestCell *)[self.tblView cellForRowAtIndexPath:indexPath];
    cell.btnSpiceLevel.hidden = YES;
    cell.btnSaveSpiceLevel.hidden = NO;
    [cell.spiceViewRequest setEnabled:YES];
}


- (IBAction)menuBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveBtnAction:(UIButton*)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
    MDDealRequestCell *cell = (MDDealRequestCell *)[self.tblView cellForRowAtIndexPath:indexPath];
    cell.btnSpiceLevel.hidden = NO;
    cell.btnSaveSpiceLevel.hidden = YES;
    [cell.spiceViewRequest setEnabled:NO];

}

- (IBAction)cancelBtnAction:(id)sender{
    strStatus = @"Rejected";
    [self callApiForAcceptDealApi];
    
}

- (IBAction)dealBtnAction:(id)sender {
    strStatus = @"Accepted";
    [self callApiForAcceptDealApi];
}

#pragma mark - Web Api Section

- (void)callApiForAcceptDealApi {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:requestedMealDetail.strRequestDetailDinerId forKey:@"dinerId"];
    [dict setValue:self.strMealId forKey:@"mealId"];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    [dict setValue:strStatus forKey:@"status"];
    
    [ServiceHelper request:dict apiName:kAPIChefRequestCancelDeal method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];

            if ([statusCode integerValue] == 200) {
                
                [AlertController title:@"Success!" message:responseMessage andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            } else {
                [AlertController title:responseMessage];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

- (void)callApiForRequestDetails {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"chefId"];
    (self.isNotification) ? [dict setValue:[self.notificationDict objectForKeyNotNull:@"orderId" expectedObj:@""] forKey:@"orderId"] : [dict setValue:self.strOrderId forKey:@"orderId"];

    (self.isNotification) ? [dict setValue:[self.notificationDict objectForKeyNotNull:@"mealId" expectedObj:@""] forKey:@"mealId"] : [dict setValue:self.strMealId forKey:@"mealId"];
    
    [ServiceHelper request:dict apiName:kAPIRequestDetailsChef method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                requestedMealDetail = [CookPrepareAMealModal getDataFromDictionary:[resultDict objectForKey:@"data"]];
                self.bannerList = requestedMealDetail.requestDetailMealImages;
                
                [self.pageControl setNumberOfPages:[requestedMealDetail.requestDetailMealImages count]];
                (requestedMealDetail.requestDetailMealImages.count <= 1) ? [self.pageControl setHidden:YES] : [self.pageControl setHidden:NO];
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [AppUtility delay:animationDuration :^{
                    [self slideShow];
                }];

                [self.tblView reloadData];
                [self.collectionView reloadData];
                
            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}

@end
