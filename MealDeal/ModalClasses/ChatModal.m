//
//  ChatModal.m
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "ChatModal.h"
#import "AppDelegate.h"

@implementation ChatModal

+(NSMutableArray *)parseDataForChatHistory:(NSArray*)array{
    NSMutableArray *chatHistoryArray = [[NSMutableArray alloc] init];
    NSDictionary *lastMsgDict = [array objectAtIndex:0];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.strLastMsgId = [lastMsgDict objectForKey:@"lastmsgId"];
    for(NSDictionary *dict in array){
        ChatModal *chatHistoryData = [[ChatModal alloc]init];
        chatHistoryData.senderId = [dict objectForKey:@"senderId"];
        chatHistoryData.senderName = [dict objectForKey:@"senderName"];
        chatHistoryData.receiverId = [dict objectForKey:@"receiverId"];
        chatHistoryData.receiverName = [dict objectForKey:@"receiverName"];
        chatHistoryData.message = [dict objectForKey:@"message"];
        chatHistoryData.messageType = [dict objectForKey:@"messageType"];
        chatHistoryData.status = [dict objectForKey:@"status"];
        chatHistoryData.date = [dict objectForKey:@"timeStamp"];
        chatHistoryData.lastMsgId = [dict objectForKey:@"lastmsgId"];
        NSArray *imageArray = [dict objectForKey:@"media"];
        chatHistoryData.image = [imageArray objectAtIndex:0];
        [chatHistoryArray addObject:chatHistoryData];
    }
    return chatHistoryArray;
}


@end
