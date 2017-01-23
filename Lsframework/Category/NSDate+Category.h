//
//  NSDate+Category.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

/**
 *  日期格式化
 *
 *  @param style yyyy-MM-dd
 *
 *  @return String
 */
- (NSString*)format2String:(NSString*)style;

/**
 *  日期格式化
 *
 *  @param style   yyyy-MM-dd
 *  @param dateStr 1997-01-01
 *
 *  @return NSDate
 */
+ (NSDate*)format2DateWithStyle:(NSString*)style withDateString:(NSString*)dateStr;


/**
 *  转换成奇葩格式
 *
 *  @return 0岁 5个月17天
 */
- (NSString*)formatToChinese:(NSDate*)birthDate;

-(NSDate*)tomorrow;

-(NSDate*)yesterday;

-(NSDate*)beforeDate:(NSUInteger)count;

-(NSDate*)afterYear:(NSUInteger)count;

-(NSString *)weekFromBirthday:(NSDate*)birthDate;

+ (NSString *)showMyDate:(NSTimeInterval)myTime withDateFormatter:(NSString *)myDateFormatter;

/**
 *  比较时间
 *
 *  @param dateStr 字符串，yyyy-MM-dd
 *
 *  @return 返回当前系统时间和制定时间的差值，单位是秒
 */
+ (NSTimeInterval)compareDate:(NSString*) dateStr;

/**
 *  计算发出的时间差
 *
 *  @param dateStr <#dateStr description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getDateCompare:(NSString*) dateStr;


@end
