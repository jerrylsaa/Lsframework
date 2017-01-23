//
//  NSDate+Category.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

-(NSString *)format2String:(NSString *)style{
    NSDateFormatter * df = [NSDateFormatter new];
    df.dateFormat = style;
    return [df stringFromDate:self];
}

+(NSDate *)format2DateWithStyle:(NSString *)style withDateString:(NSString *)dateStr{
    NSDateFormatter * df = [NSDateFormatter new];
    df.dateFormat = style;
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [df dateFromString:dateStr];
}

-(NSString *)formatToChinese:(NSDate*)birthDate{
    NSUInteger age = 0;
    NSUInteger month = 0;
    NSUInteger day = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDate toDate:self options:0];
    age = date.year;
    month = date.month;
    day = date.day;
    return [NSString stringWithFormat:@"%lu岁%lu月%lu天", (unsigned long)age, month, day];
}

-(NSDate *)tomorrow{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

-(NSDate *)yesterday{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

-(NSDate *)beforeDate:(NSUInteger)count{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-count];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

-(NSDate *)afterYear:(NSUInteger)count{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:count];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

-(NSString *)weekFromBirthday:(NSDate *)birthDate{
    if (birthDate == nil) {
        return @"0周";
    }
    NSUInteger week = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDate toDate:self options:0];
    week = date.weekOfYear;
    return [NSString stringWithFormat:@"%lu周", week];
}

+ (NSString *)showMyDate:(NSTimeInterval)myTime withDateFormatter:(NSString *)myDateFormatter {
    
    if (myTime == 0) {
        return @"";
    }
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:myTime];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:myDate];
    NSDate *localeDate = [myDate dateByAddingTimeInterval: interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:myDateFormatter];
    return [dateFormatter stringFromDate:localeDate];
    
}


+(NSTimeInterval)compareDate:(NSString *)dateStr{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate* birth = [formatter dateFromString:dateStr];
    
    
    NSTimeInterval result = [[NSDate date] timeIntervalSinceDate:birth];
    return result;
}

+(NSString *)getDateCompare:(NSString *)dateStr{
    
    NSDate* now = [NSDate date];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* formatterDate = [formatter dateFromString:dateStr];
    

    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents* components = [calendar components:unit fromDate:formatterDate toDate:now options:0];
    
    
//    NSLog(@"str = %@--now = %@---history = %@",dateStr,now,formatterDate);
//    NSLog(@"d=%ld---h=%ld--m=%ld--s=%ld",components.day,components.hour,components.minute,components.second);

    NSString* resultDate = nil;
    if(components.day >= 30){
        NSDate* tempDate = [NSDate format2DateWithStyle:@"yyyy-MM-dd HH:mm:ss" withDateString:dateStr];
        formatter.dateFormat = @"yyyy-MM-dd";
        resultDate = [formatter stringFromDate:tempDate];
    }else if(components.day >= 1){
    //一天前
        resultDate = [NSString stringWithFormat:@"%ld天前",components.day];
    }else if(components.hour >= 1){
    //小时
        resultDate = [NSString stringWithFormat:@"%ld小时前",components.hour];

    }else if(components.minute >= 1){
    //分钟
        resultDate = [NSString stringWithFormat:@"%ld分钟前",components.minute];

    }else if(components.second >= 1){
        resultDate = [NSString stringWithFormat:@"%ld秒前",components.second];
    }else{
        //提问完，马上显示日期，此时 components.second ＝ 0，特色处理一下，暂时写死都为2秒
        resultDate = [NSString stringWithFormat:@"%d秒前",2];
    }
    
    return resultDate;
}


@end
