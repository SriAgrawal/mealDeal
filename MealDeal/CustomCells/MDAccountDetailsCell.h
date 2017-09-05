//
//  MDAccountDetailsCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 26/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPathButton.h"
#import "TextField.h"

@interface MDAccountDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TextField *userDetailTextField;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;

@end
