//
//  MDReviewsVC.m
//  MealDealApp
//
//  Created by Mohit on 04/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "MDReviewsVC.h"
#import "MDReviewsCell.h"

@interface MDReviewsVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *reviewsListArray;
    CookReviewsModal *dinerReviews;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
    

@end

@implementation MDReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialSetUp{
    reviewsListArray = [[NSMutableArray alloc] init];
    dinerReviews = [[CookReviewsModal alloc] init];
    [self callApiForReviewsList];
}

#pragma mark - Table View Data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [reviewsListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 184.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    dinerReviews = [reviewsListArray objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"MDReviewsCell";
    
    MDReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
    if (cell == nil) {
        cell = [[MDReviewsCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imgUser.layer.cornerRadius  = cell.imgUser.frame.size.width / 2;
        cell.imgUser.clipsToBounds = YES;
    });
    [cell.imgUser sd_setImageWithURL:[NSURL URLWithString:dinerReviews.strReviewsListDinerImageUrl]];
    cell.lblUserName.text = dinerReviews.strReviewsListDinerName;
    cell.lblDate.text = [AppUtility timestamp2date:dinerReviews.strReviewsListDinerReviewDate];
    cell.txtViewReview.text = dinerReviews.strReviewsListDinerReviewDescription;
    cell.rateView.value = [dinerReviews.strReviewsListDinerRatings floatValue];
    return cell;
}

#pragma mark Button Action Methods
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Api Section

- (void)callApiForReviewsList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:pChefId];
    
    [ServiceHelper request:dict apiName:kAPIReviewsListDiner method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                reviewsListArray = [CookReviewsModal getReviewsListDataFromArray:[resultDict objectForKey:@"data"]];
                [self.tblView reloadData];
                
            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
    
}



@end
