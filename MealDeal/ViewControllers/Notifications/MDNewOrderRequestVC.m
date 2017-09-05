//
//  MDNewOrderRequestVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDNewOrderRequestVC.h"
#import "Macro.h"

static NSString *cellIdentifier1 = @"MDTitleDetailLabelCell";

@interface MDNewOrderRequestVC ()

@property (weak, nonatomic) IBOutlet UITableView        *tableView;

@property (weak, nonatomic) IBOutlet UIImageView        *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel            *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel            *usernameLabel;

@property (strong, nonatomic) NSArray                   *titleArray;
@property (strong, nonatomic) NSArray                   *dummyDetailArray;

@end

@implementation MDNewOrderRequestVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Private Methods

-(void)initialSetup {
    
    self.tableView.rowHeight = 50;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //Tittle Array initialization
    self.titleArray = @[@"Zip for User", @"Cuisine Name", @"Cuisine Type", @"Ingredients", @"Allergies", @"Store Amount", @"Special Req.", @"Step", @"Ingredients Req."];
    
    // dummy detail array
    self.dummyDetailArray = @[@"125874", @"Fried Chicken", @"Chinese", @"Chicken, Butter", @"250", @"$5", @"$1", @"Gravy", @"Pepper"];
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
    
    return self.titleArray.count;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.detailLabel.text = [self.dummyDetailArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
