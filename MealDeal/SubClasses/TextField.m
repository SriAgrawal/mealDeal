//
//  TextField.m
//  MeAndChange
//
//  Created by Raj Kumar Sharma on 25/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "TextField.h"
#import "Macro.h"

@interface TextField ()

@property (strong, nonatomic) UIImageView   *iconImageView;
@property (strong, nonatomic) UIView        *paddingView;
@property (strong, nonatomic) UIView        *dividerView;

@property (strong, nonatomic) UIColor       *errorColor;
@property (strong, nonatomic) UIColor       *normalColor;
@property (strong, nonatomic) UIColor       *placeHolderColor;
@property (strong, nonatomic) CALayer       *underLine;

@end

@implementation TextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self defaultSetup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    
    if(self){
        //[self defaultSetup];
    }
    
    return self;
}

#pragma mark - Private methods

- (void)defaultSetup {
    
    self.errorColor = [UIColor redColor];
    self.normalColor = [UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1.0];
    self.placeHolderColor = [UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1.0];

    self.tintColor = [UIColor colorWithRed:177.0/255.0f green:41.0/255.0f blue:15.0/255.0f alpha:1.0f];
    
//    self.layer.cornerRadius = 0.0f;
//    self.layer.borderColor = [[UIColor clearColor] CGColor];
//    self.layer.borderWidth = 0.0f;
//    self.clipsToBounds = YES;
//    [self setBorderStyle:UITextBorderStyleNone];
    
    self.font = [UIFont fontWithName:@"RockwellStd" size:14];
    [self placeHolderText:self.placeholder];
    
    self.active = NO;
}

- (void)addPaddingWithValue:(CGFloat )value {
    
    if (!self.paddingView) {
        self.paddingView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, value, self.frame.size.height)];
      
        [self setLeftView:self.paddingView];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        
    } else {
        [self.paddingView setFrame:CGRectMake(8, 0, value, self.frame.size.height)];
    }
    
    self.paddingView.tag = 1098;
}

- (void)addDivider {
    
    CGFloat xValueForDividerLine = self.paddingView.frame.size.width - 8;

    CGFloat yValueForDividerLine = 8.0f;
    CGFloat dividerLineHeight = 22.0f;

    CGRect frame = CGRectMake(xValueForDividerLine, yValueForDividerLine, 1, dividerLineHeight);
    
    if (!self.dividerView) {
        
        self.dividerView = [[UIView alloc] initWithFrame:frame];
        [self.dividerView setTag:1099];
        [self.dividerView setBackgroundColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0]];
        [self addSubview:self.dividerView];
    }
    
    [self.dividerView setFrame:frame];

}

- (void)addplaceHolderImageInsideView:(UIView *)view placeHolderImage:(UIImage *)image {

    if (!self.paddingView) {
        [self addPaddingWithValue:42];
        view = self.paddingView;
    }
    
    UIImageView *placeHolderImageView = [view viewWithTag:1999];
    if (!placeHolderImageView) {
        placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        placeHolderImageView.tag = 1999;
        [view addSubview:placeHolderImageView];
        [placeHolderImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [placeHolderImageView setImage:image];
    placeHolderImageView.center = CGPointMake(view.frame.size.width  / 2,
                                              view.frame.size.height / 2);

    self.iconImageView = placeHolderImageView;
    [self addDivider];

    self.active = NO;
}

- (void)setPlaceholderImage:(UIImage *)iconImage {
    if (iconImage) {
        [self setPaddingIcon:iconImage];
    }
}

#pragma mark - Public methods

- (void)setActive:(BOOL)active {
    
    if (active) {
        [self.iconImageView color:AppColor];
        self.underLine.borderColor = [AppColor CGColor];
        [self placeHolderTextWithColor:[self.attributedPlaceholder string] :AppColor];
    } else {
        [self.iconImageView color:self.normalColor];
        self.underLine.borderColor = [self.normalColor CGColor];
        [self placeHolderTextWithColor:[self.attributedPlaceholder string] :self.normalColor];
    }
}

- (void)error:(BOOL)status {
    self.layer.borderColor = status ? [self.errorColor CGColor]:[self.normalColor CGColor];
}

- (void)setPaddingIcon:(UIImage *)iconImage {
    
    [self addplaceHolderImageInsideView:self.paddingView placeHolderImage:iconImage];
}
- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}

- (void)placeHolderText:(NSString *)text {
    
    if (text.length) {//for avoiding nil placehoder
        
        if (self.placeHolderColor) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: self.placeHolderColor}];
        } else {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        }
    }
}

- (void)placeHolderTextWithColor:(NSString *)text :(UIColor *)color {
    
    if (text.length) {//for avoiding nil placehoder
        
        if (color) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
        } else {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        }
    }
}

@end
