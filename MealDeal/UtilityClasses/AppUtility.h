//
//  AppUtility.h
//  AAWorks
//
//  Created by Chandra Shekhar on 3/3/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtility : NSObject

+ (void)delay:(double)delayInSeconds :(void(^)(void))callback;

+ (UIFont *)rockwellRegularFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellBoldFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellItalicFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellBoldItalicFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellCondensedFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellBoldCondensedFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellExtraBoldFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellLightFontWithSize:(CGFloat)size;

+ (UIFont *)rockwellLightItalicFontWithSize:(CGFloat)size;

+ (NSDate *)getDateFromString:(NSString *)dateStr;
+ (NSString *)getStringFromDate:(NSDate *)date;
+ (NSString *)getStringFromTime:(NSDate *)date;
+(NSString*)timestamp2date:(NSString*)timestamp;
+(NSString*)timestampToDateAndTime:(NSString*)timestamp;
+(NSString*)timestampToTime:(NSString*)timestamp;
+ (NSString *)getStringFromFullTime:(NSDate *)date;

    @end
