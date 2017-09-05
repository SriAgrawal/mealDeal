//
//  MDFutureOrderVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 21/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDFutureOrderVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"MDTitleDetailLabelCell";

@interface MDFutureOrderVC ()

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UILabel *  dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic) NSArray               *titleArray;
@property (strong, nonatomic) NSArray               *dummyDetailArray;
@end

@implementation MDFutureOrderVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    self.tableView.alwaysBounceVertical = NO;
    
    //Tittle Array initialization
    self.titleArray = @[@"Username", @"Special-Wraps", @"Pick Up Address", @"Price", @"Payment Type"];
    
    self.dummyDetailArray = @[@"Robret Thomasan", @"Special-Wraps", @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", @"35$", @"COD"];
    
    self.tableView.estimatedRowHeight = 55;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UIButton Actions

- (void)cancelOrderBtnAction:(UIButton*)sender {
    [AlertController title:@"Order cancelled successfully !"];

}

- (IBAction)FilterButtonAction:(UIButton *)button {
    
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"Weekly", @"Monthly"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
     
        [self.filterButton setTitle:selectedValues.firstObject forState:UIControlStateNormal];
    }];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 5){
        MDSettingsUpdateAddressCell *cell = (MDSettingsUpdateAddressCell *)[tableView dequeueReusableCellWithIdentifier:@"MDSettingsUpdateAddressCell" forIndexPath:indexPath];
        cell.dinerFutureOrdersCancelOrderBtnAction.tag = indexPath.section;
        [cell.dinerFutureOrdersCancelOrderBtnAction addTarget:self action:@selector(cancelOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
  
    } else {
        
    MDTitleDetailLabelCell *cell = (MDTitleDetailLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.detailLabel.text = [self.dummyDetailArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 2) {
        [cell.detailLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return cell;
    }
    return nil;
}

#pragma mark - Web Api Section
//-(void)



#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
