//
//  NSDate+Addition.m
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 06/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

- (NSString *)UTCDateFormat {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"];
    
    return [dateFormat stringFromDate:self];
}

- (NSString *)getDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    
    return [dateFormatter stringFromDate:self];
}


- (NSString *)getDateTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)getTimeDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"hh:mm a, dd/MM/yyyy"];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)getDateStringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)getTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[self enUSPosixlocal]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    return [dateFormatter stringFromDate:self];
    
}

- (NSLocale *)enUSPosixlocal {
    return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}


@end
