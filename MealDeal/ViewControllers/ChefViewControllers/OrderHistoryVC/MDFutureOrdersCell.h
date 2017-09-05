//
//  MDFutureOrdersCell.h
//  MealDealApp
//
//  Created by Mohit on 05/11/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

#import "Macro.h"

@interface MDFutureOrdersCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblData;

@property (strong, nonatomic) IBOutlet UILabel *lblMenu;
@property (strong, nonatomic) IBOutlet UIImageView *chefFutureOrderStatusImage;
@property (strong, nonatomic) IBOutlet UIButton *chefFutureOrderCancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *chefFutureOrderImage;
@end
