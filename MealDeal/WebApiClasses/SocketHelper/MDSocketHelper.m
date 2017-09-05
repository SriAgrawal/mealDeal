//
//  MDSocketHelper.m
//  MealDeal
//
//  Created by Ankit Kumar Gupta on 01/12/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDSocketHelper.h"
#import "MealDeal-Swift.h"



@interface MDSocketHelper()<NSStreamDelegate>
{
    
    SocketIOClient* socket;
    BOOL connected;
    
    NSOperationQueue *queue;
    NSOperationQueue *readStatusQueue;
    NSOperationQueue *discardStatusQueue;
    
}

@end

@implementation MDSocketHelper

static NSString *hostURL =  @"http://ec2-52-76-162-65.ap-southeast-1.compute.amazonaws.com:1420";

static MDSocketHelper *socketHelper = nil;




+(id)sharedSocketHelper
{
    if (!socketHelper) {
        socketHelper = [[MDSocketHelper alloc] init];
        
        [socketHelper initializeSocket];
    }
    return socketHelper;
    
}


-(NSString *)socketID
{
    return socket.sid;
}

-(NSURL *)  socketURL
{
    return socket.socketURL;
}

-(BOOL)isSocketConnected
{
    return connected;
}

-(void)initializeSocket
{
    
    queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount =1;
    
    readStatusQueue = [[NSOperationQueue alloc] init];
    readStatusQueue.maxConcurrentOperationCount =1;
    
    discardStatusQueue = [[NSOperationQueue alloc] init];
    discardStatusQueue.maxConcurrentOperationCount =1;
    
    NSURL *url = [NSURL URLWithString:hostURL];
    
    connected = NO;
    
    if (!socket) {
        socket = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
        
        [self connect];
    }
    
    NSLog(@">>>>>>>>>  %ld",socket.status);
    // [socket emit:@"initChat" with:[NSArray array]];
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        connected = YES;
        NSLog(@"socket connected  %@",data);
        NSLog(@">>>>>>>>22222>  %ld   %@",socket.status, socket.sid);
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:[NSUSERDEFAULT objectForKey:p_id] forKey:@"userId"];
        [params setObject:kDummyDeviceToken forKey:@"deviceToken"];
        [params setObject:[NSUSERDEFAULT objectForKey:pUserName] forKey:@"userName"];
        
        NSLog(@"Socketd Event:  initChat    %@",params);
        
        [socket emit:@"initChat" with:[NSArray arrayWithObject:params]];
        
    }];
    
    
    [socket on:@"disconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        connected = NO;
        NSLog(@"Socket disconnected  data ");
    }];
    
    NSLog(@">>>>>  %@   %d",url.host, url.port.intValue);
    
}
-(void)disconnect {
    [socket disconnect];
}

-(void)connect {
 
    [socket connect];
}

-(void)emitWith:(NSString *)eventName andParams:(NSMutableDictionary *)params {
    
    if (connected) {
        [socket emit:eventName with:[NSArray arrayWithObject:params]];
    }
    
}
        
@end
