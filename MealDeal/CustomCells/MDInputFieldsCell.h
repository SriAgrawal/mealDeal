//
//  MDInputFieldsCell.h
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexPathButton.h"
#import "TextField.h"

@interface MDInputFieldsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TextField *buttonTextField;
@property (weak, nonatomic) IBOutlet IndexPathButton *button;
@property (weak, nonatomic) IBOutlet TextField *textField;

@property (weak, nonatomic) IBOutlet IndexPathButton *cookButton;
@property (weak, nonatomic) IBOutlet IndexPathButton *eatButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
