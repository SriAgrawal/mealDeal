//
//  MDBackgroundImageView.m
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDBackgroundImageView.h"

@implementation MDBackgroundImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
    [self setImage:[UIImage imageNamed:@"background"]];
}

@end
