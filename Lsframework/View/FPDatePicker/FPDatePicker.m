//
//  FPDatePicker.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPDatePicker.h"
#import "UUDatePicker.h"

@interface FPDatePicker()<UUDatePickerDelegate>
@property (nonatomic, strong) NSString * currentDateStr;
@end

@implementation FPDatePicker{
    UUDatePicker * _datePicker;
    TMDatePickerBlock block;
    NSString * date;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self install];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self install];
    }
    return self;
}

-(void)install{
    
    UIView * container = [UIView new];
    [self addSubview:container];
    container.backgroundColor = [UIColor whiteColor];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, container)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[container(216)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, container)]];
    
    UIView * view = [UIView new];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -1);
    view.layer.shadowOpacity = 0.8f;
    view.layer.shadowRadius = 3.0;
    
    view.backgroundColor = RGB(240, 240, 240);
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.backgroundColor = [UIColor clearColor];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake((kScreenWidth - 320) / 2, 40, kScreenWidth, 180) Delegate:self PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    
    [container addSubview:_datePicker];
    
//    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
//    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_datePicker(180)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container, _datePicker)]];
//    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_datePicker]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container, _datePicker)]];
    
    [container addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container, view)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(40)]-0-[_datePicker]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container, view, _datePicker)]];
    
    [view addSubview:cancelBtn];
    [view addSubview:okBtn];
    
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cancelBtn(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, cancelBtn)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, cancelBtn)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[okBtn(80)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, okBtn)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[okBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, okBtn)]];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)]];
    
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setPickerType:YearMonthDay];
    _currentDateStr = [[NSDate date] format2String:@"yyyy-MM-dd HH:mm"];
}

-(void)showInView:(UIView *)view{
    [view endEditing:YES];
    self.hidden = NO;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.frame = view.bounds;
    [view addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y += 250;
    self.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= 250;
        self.frame = frame;
    }];
}

-(void)dismissTap:(id)sender{
    [self dismiss];
}

-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += 250;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)okAction:(id)sender{
    if (block) {
        NSDate * d = [NSDate format2DateWithStyle:@"yyyy-MM-dd HH:mm" withDateString:_currentDateStr];
        block(date, d);
        NSLog(@"%@,%@", date, d);
        
    }
    [self dismiss];
}

-(void)cancelAction:(id)sender{
    [self dismiss];
}

-(void)setPickerType:(PickerType)type{
    _pickerType = type;
    if (type == ALL) {
        [_datePicker setDatePickerStyle:UUDateStyle_YearMonthDayHourMinute];
    }else if (type == YearMonthDay){
        [_datePicker setDatePickerStyle:UUDateStyle_YearMonthDay];
    }else if (type == MonthDayHourMinute){
        [_datePicker setDatePickerStyle:UUDateStyle_MonthDayHourMinute];
    }
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    if (_pickerType == ALL) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else if (_pickerType == YearMonthDay){
        [df setDateFormat:@"yyyy-MM-dd"];
    }else if (_pickerType == MonthDayHourMinute){
        [df setDateFormat:@"MM-dd HH:mm"];
    }
    date  = [df stringFromDate:[NSDate new]];
}

-(void)uuDatePicker:(UUDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay{
    if (_pickerType == ALL) {
        date = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute];
    }else if (_pickerType == YearMonthDay){
        date = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    }else if (_pickerType == MonthDayHourMinute){
        date = [NSString stringWithFormat:@"%@-%@ %@:%@", month, day, hour, minute];
    }
    _currentDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute];
}

-(void)addDatePickerHandler:(TMDatePickerBlock)datePickerBlock{
    block = [datePickerBlock copy];
}

-(void)setMinDate:(NSDate*)minDate{
    [_datePicker setMinLimitDate:minDate];
}

-(void)setMaxDate:(NSDate*)maxDate{
    [_datePicker setMaxLimitDate:maxDate];
}
@end
