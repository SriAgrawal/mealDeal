//
//  MDCustomMealCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 03/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface MDCustomMealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TextField *inputTextfield;

@property (weak, nonatomic) IBOutlet AHTextView *inputTextView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet IndexPathButton *button;
@property (weak, nonatomic) IBOutlet UIButton *attachButton;

@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *allergiesTextField;

@property (weak, nonatomic) IBOutlet TextField *buttonTextfield;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
