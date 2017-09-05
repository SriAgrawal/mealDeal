//
//  ServiceHelper.h
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 05/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

//@@@@@@@@@@@@@@@ Version v3 @@@@@@@@@@@@@@@@@@@@@@@

#import <Foundation/Foundation.h>

typedef enum {
    GET = 0,
    POST = 1,
    DELETE = 2,
    PUT = 3
    
} Method;

@interface ServiceHelper : NSObject

+ (void)request:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType completionBlock:(void (^)(id result, NSError *error))handler;

// Need to test

+ (void)multiPartRequest:(NSMutableDictionary *)parameterDict images:(NSArray *)images apiName:(NSString *)name completionBlock:(void (^)(id result, NSError *error))handler;

@end
