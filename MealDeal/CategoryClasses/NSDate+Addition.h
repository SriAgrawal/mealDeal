//
//  NSDate+Addition.h
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 06/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

- (NSString *)UTCDateFormat;
- (NSString *)getDateString;
- (NSString *)getDateStringWithFormat:(NSString *)format;
- (NSString *)getTimeString;
- (NSString *)getDateTimeString;
- (NSString *)getTimeDateString;

@end
