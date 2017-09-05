//
//  AppUtility.m
//  AAWorks
//
//  Created by Chandra Shekhar on 3/3/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "AppUtility.h"

@implementation AppUtility

+ (void)delay:(double)delayInSeconds :(void(^)(void))callback {
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        if(callback){
            callback();
        }
    });
}

+ (NSDate *)getDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"];
    
    return [dateFormatter dateFromString: dateStr];
}

+(NSString*)timestamp2date:(NSString*)timestamp{
    NSString * timeStampString =timestamp;
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy"];
    return [_formatter stringFromDate:date];
}

+(NSString*)timestampToDateAndTime:(NSString*)timestamp{
    NSString * timeStampString =timestamp;
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"'HH':'mm' aa', dd/MM/yy"];
    return [_formatter stringFromDate:date];
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    return [formatter stringFromDate:date];
    
}

+ (NSString *)getStringFromTime:(NSDate *)date {

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"HH:mm"];
  //NSString *timeString = [formatter stringFromDate:[NSDate date]];
  return [formatter stringFromDate:date];
    
}
+ (NSString *)getStringFromFullTime:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm aa"];
    //NSString *timeString = [formatter stringFromDate:[NSDate date]];
    return [formatter stringFromDate:date];
    
}


+(NSString*)timestampToTime:(NSString*)timestamp{
    NSString * timeStampString =timestamp;
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"HH:mm aa"];
    return [_formatter stringFromDate:date];
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Font <<<<<<<<<<<<<<<<<<<<<<<<*/

+ (UIFont *)rockwellRegularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd" size:size];
}

+ (UIFont *)rockwellBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-Bold" size:size];
}

+ (UIFont *)rockwellItalicFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-Italic" size:size];
}

+ (UIFont *)rockwellBoldItalicFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-BoldItalic" size:size];
}

+ (UIFont *)rockwellCondensedFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-Condensed" size:size];
}

+ (UIFont *)rockwellBoldCondensedFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-BoldCondensed" size:size];
}

+ (UIFont *)rockwellExtraBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-ExtraBold" size:size];
}

+ (UIFont *)rockwellLightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-Light" size:size];
}

+ (UIFont *)rockwellLightItalicFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RockwellStd-LightItalic" size:size];
}

@end
