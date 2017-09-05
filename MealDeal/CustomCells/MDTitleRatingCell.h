//
//  MDTitleRatingCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface MDTitleRatingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end
