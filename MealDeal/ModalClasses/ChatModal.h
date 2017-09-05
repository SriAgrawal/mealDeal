//
//  ChatModal.h
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatModal : NSObject

@property  (strong, nonatomic)  NSString  *senderImage;
@property  (strong, nonatomic)  NSString  *senderName;
@property  (strong, nonatomic)  NSString  *senderId;
@property  (strong, nonatomic)  NSString  *details;
@property  (strong, nonatomic)  NSString  *date;
@property  (strong, nonatomic)  NSString  *messageType;
@property  (strong, nonatomic)  NSString  *receiverId;
@property  (strong, nonatomic)  NSString  *receiverName;
@property  (strong, nonatomic)  NSString  *status;

@property  (strong, nonatomic)  NSString  *lastMsgId;



@property  (strong, nonatomic)  NSString  *message;
@property (strong, nonatomic)   NSString   *image;



+(NSMutableArray *)parseDataForChatHistory:(NSArray*)array;

@end
