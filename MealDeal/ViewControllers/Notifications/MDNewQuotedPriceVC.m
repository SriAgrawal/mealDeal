
//
//  MDNewQuotedPriceVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 08/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDNewQuotedPriceVC.h"
#import "Macro.h"

static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";

@interface MDNewQuotedPriceVC ()

@property (weak, nonatomic) IBOutlet UITableView        *tableView;

@property (weak, nonatomic) IBOutlet UIImageView        *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel            *cuisineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *cuisineTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel            *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel            *userNameLabel;

@property (weak, nonatomic) IBOutlet HCSStarRatingView  *ratingView;

@property (strong, nonatomic) NSArray                   *titleArray;
@property (strong, nonatomic) NSArray                   *dummyDetailArray;

@end

@implementation MDNewQuotedPriceVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];

}

#pragma mark - Private Methods

- (void)initialSetup {
    
    self.tableView.rowHeight = 50;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //Tittle Array initialization
    self.titleArray = @[@"Ingredients Req.", @"Price Offering", @"Preparation Time", @"Date"];
    
    // dummy detail array
    self.dummyDetailArray = @[@"Chicken, Butter", @"$5", @"60 min", @"10 Jan"];
    
}

#pragma mark - UIButton Actions

- (IBAction)backbuttonaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)noDealButtonAction:(id)sender {
}

- (IBAction)dealButtonAction:(id)sender {
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        
        cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = [self.dummyDetailArray objectAtIndex:indexPath.row];
        
        return cell;
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
