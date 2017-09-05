//
//  MDSocketHelper.h
//  MealDeal
//
//  Created by Ankit Kumar Gupta on 01/12/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface MDSocketHelper : NSObject


@property (nonatomic, readonly) NSString *socketID;
@property (nonatomic, readonly) NSURL *  socketURL;
@property (nonatomic, readonly) BOOL isSocketConnected;

+(id)sharedSocketHelper;

// No need to call, as initialisation done once in the shared helper
-(void)initializeSocket;

-(void)connect;


-(void)disconnect;

// use to send the data on socket
-(void)emitWith:(NSString *)eventName andParams:(NSMutableDictionary *)params;




@end
