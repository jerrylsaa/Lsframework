//
//  ChatBaseCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatBaseCell.h"

@implementation ChatBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)time:(NSNumber *)time{
    
    NSTimeInterval timeInterval = [time longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //判断
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //年
//    [formatter setDateFormat:@"yyyy"];
//    long timeValue = [[formatter stringFromDate:date] longLongValue];
//    long timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
//    if (timeToday > timeValue) {
//        if (timeToday - timeValue < 5) {
//            return [NSString stringWithFormat:@"%ld年前",timeToday - timeValue];
//        }else{
//            return [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
//        }
//    }
//    //月
//    [formatter setDateFormat:@"MM"];
//    timeValue = [[formatter stringFromDate:date] longLongValue];
//    timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
//    if (timeToday > timeValue) {
//        if (timeToday - timeValue == 1) {
//            return @"上个月";
//        }else{
//            [formatter setDateFormat:@"MM-dd"];
//            return [formatter stringFromDate:date];
//        }
//    }
//    //日
//    [formatter setDateFormat:@"dd"];
//    timeValue = [[formatter stringFromDate:date] longLongValue];
//    timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
//    NSInteger day = timeToday - timeValue;
//    if (day == 1) {
//        [formatter setDateFormat:@"hh:mm:ss"];
//        return [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];
//    }else if (day == 2){
//        [formatter setDateFormat:@"hh:mm:ss"];
//        return [NSString stringWithFormat:@"前天 %@",[formatter stringFromDate:date]];
//    }else if (day > 2){
//        [formatter setDateFormat:@"MM-dd hh:mm"];
//        return [formatter stringFromDate:date];
//    }else if(day == 0){
//        [formatter setDateFormat:@"hh:mm:ss"];
//        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
//    }
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
    
}

@end
