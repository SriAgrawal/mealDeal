//
//  GradientView.m
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 23/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self blackGradient];
}

- (void)blackGradient {
    // Create the colors
    UIColor *topColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIColor *bottomColor = [UIColor blackColor];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.bounds;
    //Add gradient to view
    [self.layer insertSublayer:theViewGradient atIndex:0];
}

@end
