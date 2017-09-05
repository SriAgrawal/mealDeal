//
//  MDStaticContentVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDTermsAndConditionVC.h"
#import "Macro.h"

@interface MDTermsAndConditionVC ()

@property (weak, nonatomic) IBOutlet UIWebView      *webView;

@end

@implementation MDTermsAndConditionVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Private Methods

- (void)initialSetup {
    
    if ([self.navigationController respondsToSelector:@selector(edgesForExtendedLayout)])
        [self.navigationController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    //[self callApiForTermsCondition];
    
    NSString *termsandConditionFile = [[NSBundle mainBundle] pathForResource:@"DummyHtml" ofType:@"html"];
    NSString* termsStr = [NSString stringWithContentsOfFile:termsandConditionFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:termsStr baseURL: [[NSBundle mainBundle] bundleURL]];
    
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Api Section

- (void)callApiForTermsCondition {
    
    [ServiceHelper request:[NSMutableDictionary dictionary] apiName:kAPITermsCondition method:GET completionBlock:^(NSDictionary *response, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [response objectForKeyNotNull:pResponse_code expectedObj:@""];
            
            if ([statusCode integerValue] == 200) {
                
                NSString *contentString;

                    NSDictionary *privacyPolicyDict = [response objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                    contentString = [privacyPolicyDict objectForKeyNotNull:pTermsCondition expectedObj:@""];

                [self.webView  loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#AAAAAA\" face=\"RockwellStd\" size=\"18\">%@</body></html>", contentString] baseURL: nil];
                
                //   [self.webView loadHTMLString:[htmlString description] baseURL:nil];
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
