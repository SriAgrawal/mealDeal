//
//  AlertController.h
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertController : NSObject

//>>>>>>>>>>>>>>>>>>>>>>> Alert >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)title:(NSString *)title;

+ (void)message:(NSString *)message;

+ (void)title:(NSString *)title message:(NSString *)message;

+ (void)title:(NSString*)title
      message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles
dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock;

//>>>>>>>>>>>>>>>>>>>>>>> ActionSheet >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)actionSheet:(NSString*)title
            message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles
      dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock;


@end
