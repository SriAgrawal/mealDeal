//
//  MDReviewVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 27/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDReviewVC.h"
#import "Macro.h"

@interface MDReviewVC ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNmaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishnmaeLable;
@property (weak, nonatomic) IBOutlet UILabel *dishTypeLabel;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet AHTextView *reviewTextView;


@end

@implementation MDReviewVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Private Methods

-(void)initialSetUp {
    if(self.isFromReviewsList){
        self.reviewTextView.text = self.strComments;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:self.strCookImageUrl]];
        self.dishnmaeLable.text = self.strDishName;
        self.dishTypeLabel.text = self.strDishType;
        self.userNmaeLabel.text = self.strCookName;
        self.ratingView.value = [self.strReviews floatValue];
    }else
    self.reviewTextView.placeholderText = @"Comments";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)validateOnAddReviewButton {
    
    BOOL isValid = YES;
    
    if (![TRIM_SPACE(self.reviewTextView.text) length]) {
        [AlertController title:@BLANK_REVIEW];
        return NO;
    }
    return isValid;
}

#pragma mark - UIButton Action

- (IBAction)addReviewButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    LogInfo(@"rating value: --------- %f",self.ratingView.value);
    if ([self validateOnAddReviewButton]) {
        
        [self callApiForChefReview];
        
//            [AlertController title:@"Review added successfully !" message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
        }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextview Delegate methods

- (BOOL)textFieldShouldReturn:(UITextView *)textview {
    if (textview.returnKeyType == UIReturnKeyDone)
        [textview resignFirstResponder];
        return YES;
}


#pragma mark - Web Api Section

- (void)callApiForChefReview {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT objectForKey:p_id] forKey:@"dinerId"];
    [dict setValue:self.strChefId forKey:@"chefId"];
    [dict setValue:[NSString stringWithFormat:@"%f",self.ratingView.value] forKey:@"rating"];
    [dict setValue:self.reviewTextView.text forKey:@"review"];
    
    [ServiceHelper request:dict apiName:kAPIRatingChef method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                [AlertController title:@"Review added successfully !" message:@"" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            } else {
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
    
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
