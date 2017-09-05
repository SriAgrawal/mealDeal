//
//  UIViewController+Addition.m
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 04/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UIViewController+Addition.h"

@implementation UIViewController (Addition)

- (void)moveUIComponentWithValue:(CGFloat)value forLayoutConstraint:(NSLayoutConstraint *)layoutConstraint forDuration:(CGFloat)duration {
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:duration];
    
    [layoutConstraint setConstant:value];
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Tool Bar <<<<<<<<<<<<<<<<<<<<<<<<*/

- (UIToolbar *)getToolBarForNumberPad {
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barButton.tintColor = [UIColor colorWithRed:177.0/255.0f green:41.0/255.0f blue:15.0/255.0f alpha:1.0f];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barButton,
                           
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Tool bar selector <<<<<<<<<<<<<<<<<<<<<<<<*/

- (void)doneWithNumberPad {
    [self.view endEditing:YES];
}

@end
