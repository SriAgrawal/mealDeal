//
//  MDRefundAmount_CanceledOrderVC.h
//  MealDeal
//
//  Created by Krati Agarwal on 11/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum RefundAmount_CanceledOrder_Content {
    Refund_Amount,
    Canceled_Order,
} ContentType2;

@interface MDRefundAmount_CanceledOrderVC : UIViewController

@property (nonatomic) ContentType2 contentType;

@property(strong, nonatomic)NSString *strOrderImage;
@property(strong, nonatomic)NSString *strOrderStatus;
@property(strong, nonatomic)NSString *strUserName;
@property(strong, nonatomic)NSString *strOrderId;
@property(strong, nonatomic)NSString *strMealId;



@end
