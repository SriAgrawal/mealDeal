//
//  MDCookReviewsVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDCookReviewsVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDCookReviewsCell";

@interface MDCookReviewsVC (){
    NSMutableArray *reviewsListArray;
    CookReviewsModal *cookReviews;
}

@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView            *tableView;

@end

@implementation MDCookReviewsVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    
    self.tableView.alwaysBounceVertical = NO;
    reviewsListArray = [[NSMutableArray alloc] init];
    cookReviews = [[CookReviewsModal alloc] init];
    
    if ([self.navigationController respondsToSelector:@selector(edgesForExtendedLayout)])
        [self.navigationController setEdgesForExtendedLayout:UIRectEdgeNone];
    self.navigationTitleLabel.text = ([self.strCookName isEqualToString:@""]) ? [NSString stringWithFormat:@"Chef - None"] : [NSString stringWithFormat:@"Chef - %@",self.strCookName];
    self.tableView.estimatedRowHeight = 129;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self callApiForReviewsList];
}

#pragma mark - UIButton Selector Methods

- (void)onEditSelector:(IndexPathButton *)button {
    cookReviews = [reviewsListArray objectAtIndex:button.tag];
    MDReviewVC *reviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDReviewVC"];
    reviewVC.strChefId = self.strChefId;
    reviewVC.isFromReviewsList = YES;
    reviewVC.strCookName = cookReviews.strReviewsListCookName;
    reviewVC.strComments = cookReviews.strReviewsListReviewDescription;
    reviewVC.strCookImageUrl = cookReviews.strReviewsListCookImageUrl;
    reviewVC.strReviews = cookReviews.strReviewsListCookRatings;
    reviewVC.strDishType = @"Veg";
    [self.navigationController pushViewController: reviewVC animated:YES];
}

#pragma mark - UIButton Action

- (IBAction)backbuttonaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [reviewsListArray count]; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cookReviews = [reviewsListArray objectAtIndex:indexPath.row];
    
    MDCookReviewsCell *cell = (MDCookReviewsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.editReviewButton.hidden = indexPath.row;
    if(indexPath.row == 0){
        if([cookReviews.strReviewsListDinerId isEqualToString:[NSUSERDEFAULT objectForKey:p_id]]){
            cell.editReviewButton.hidden = NO;
            [cell.editReviewButton addTarget:self action:@selector(onEditSelector:) forControlEvents:UIControlEventTouchUpInside];
        }else
            cell.editReviewButton.hidden = YES;
    }else{
        cell.editReviewButton.hidden = YES;
    }
    cell.ratingView.emptyStarImage = [UIImage imageNamed:@"rate_icon.png"];
    cell.ratingView.filledStarImage = [UIImage imageNamed:@"rate_icon_sel.png"];
    cell.ratingView.userInteractionEnabled = NO;
    cell.ratingView.value = [cookReviews.strReviewsListCookRatings floatValue];
    cell.usernameLabel.text = self.strCookName;
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:cookReviews.strReviewsListCookImageUrl]];
    cell.timeDateLabel.text = [AppUtility timestamp2date:cookReviews.strReviewsListReviewDate];
    cell.reviewdetailLabel.text = cookReviews.strReviewsListReviewDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

#pragma mark - Web Api Section

- (void)callApiForReviewsList {
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pDinerId];
    [dict setValue:self.strChefId forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPIReviewsListDiner method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                reviewsListArray = [CookReviewsModal getReviewsListDataFromArray:[resultDict objectForKey:@"data"]];
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

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
