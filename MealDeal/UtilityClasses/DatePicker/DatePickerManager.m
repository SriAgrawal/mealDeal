//
//  DatePicker.m
//  MeAndChange
//
//  Created by Raj Kumar Sharma on 27/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "DatePickerManager.h"

@interface DatePickerManager ()

@property (nonatomic, strong) UIViewController *parentController;

@end

@implementation DatePickerManager

+ (DatePickerManager *)dateManager {
    
    static DatePickerManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[DatePickerManager alloc] init];
    });
    return _sharedManager;
}

- (void)showDatePicker:(UIViewController *)parentController andUIDateAndTimePickerMode:(NSString *)mode completionBlock:(void (^)(NSDate *date))block {
    [self showDatePicker:parentController withTitle:nil andUIDateAndTimePickerMode:(NSString *)mode completionBlock:block];
}

- (void)showDatePicker:(UIViewController *)parentController withTitle:(NSString *)title andUIDateAndTimePickerMode:(NSString *)mode completionBlock:(void (^)(NSDate *date))block {
   
    self.parentController = parentController;
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        //NSLog(@"Successfully selected date: %@", controller.contentView.date);
        block(controller.contentView.date);
    }];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        //NSLog(@"Date selection was cancelled");
        //block(nil);
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = title;
    //dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
//    RMAction<RMActionController<UIDatePicker *> *> *in15MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:15*60];
//        NSLog(@"15 Min button tapped");
//    }];
//    in15MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in30MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:30*60];
//        NSLog(@"30 Min button tapped");
//    }];
//    in30MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in45MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:45*60];
//        NSLog(@"45 Min button tapped");
//    }];
//    in45MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in60MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:60*60];
//        NSLog(@"60 Min button tapped");
//    }];
//    in60MinAction.dismissesActionController = NO;
//    
//    RMGroupedAction<RMActionController<UIDatePicker *> *> *groupedAction = [RMGroupedAction<RMActionController<UIDatePicker *> *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
//    
//    [dateSelectionController addAction:groupedAction];
    
    
    if (self.showCurrentDateOption) {
        RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
            controller.contentView.date = [NSDate date];
            NSLog(@"Now button tapped");
        }];
        nowAction.dismissesActionController = NO;
        
        [dateSelectionController addAction:nowAction];
    }
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = NO;
    dateSelectionController.disableBlurEffects = YES;
    
    //You can access the actual UIDatePicker via the datePicker property
    if ([mode isEqualToString:@"date"]) {
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    }else if([mode isEqualToString:@"time"]){
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    }
    
     // UIDatePickerModeDateAndTime
    //dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    [dateSelectionController.datePicker setMinimumDate:[NSDate date]];

    //[dateSelectionController.datePicker setMaximumDate:[NSDate date]];

//    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
//    //(Of course only if we are running on iOS 8 or later)
////    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
////        //First we set the modal presentation style to the popover style
////        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
////        
////        //Then we tell the popover presentation controller, where the popover should appear
////        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
////        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
////    }
//    
//    //Now just present the date selection controller using the standard iOS presentation method
    [parentController presentViewController:dateSelectionController animated:YES completion:nil];
    
}

@end
