//
//  TimeFormat.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TimeFormat.h"

@implementation TimeFormat

+ (NSString *)timeFromString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    formatter.locale = locale;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeString];
    [formatter setDateFormat:@"dd,MMM"];
    NSString *timeFormat = [formatter stringFromDate:date];
    return [[self class] dayFormat:timeFormat];
}

+ (BOOL)isCurrentTimeBeforeTime:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeString];
    NSDate *endTime = [[self class] dateFormGTMDate:date];
    NSDate *currentTime = [[self class] currentTime];
    return [[currentTime earlierDate:endTime] isEqualToDate:currentTime];
}

//获取当前时间（已计算时区偏移量）
+ (NSDate *)currentTime {
    return [[self class] dateFormGTMDate:[NSDate date]];
}

//计算当前时区时间
+ (NSDate *)dateFormGTMDate:(NSDate *)GMTDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [zone secondsFromGMTForDate:GMTDate];
    return [GMTDate dateByAddingTimeInterval:seconds];
}

+ (NSString *)dayFormat:(NSString *)format {
    if ([format length] <= 2) {
        return format;
    }
    int day = [[format substringToIndex:2] intValue];
    NSString *monthFormat = [format substringFromIndex:2];
    NSString *dayFormat = nil;
    switch (day) {
        case 1:
            dayFormat = [NSString stringWithFormat:@"%dst",day];
            break;
        case 2:
            dayFormat = [NSString stringWithFormat:@"%dnd",day];
            break;
        case 3:
            dayFormat = [NSString stringWithFormat:@"%drd",day];
            break;
        default:
            dayFormat = [NSString stringWithFormat:@"%dth",day];
            break;
    }
    return [NSString stringWithFormat:@"%@%@",dayFormat,monthFormat];
}

@end
