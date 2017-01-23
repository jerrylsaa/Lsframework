//
//  FPDatePicker.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PickerType) {
    ALL,
    YearMonthDay,
    MonthDayHourMinute,
};

typedef void (^TMDatePickerBlock)(NSString * dateStr, NSDate * date);

@interface FPDatePicker : UIView

-(void)showInView:(UIView*)view;

-(void)addDatePickerHandler:(TMDatePickerBlock)datePickerBlock;

-(void)setMinDate:(NSDate*)minDate;

@property(nonatomic, assign) PickerType pickerType;

-(void)setMaxDate:(NSDate*)maxDate;
@end
