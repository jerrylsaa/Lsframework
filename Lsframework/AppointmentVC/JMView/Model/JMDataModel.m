//
//  JMDataModel.m
//  doctors
//
//  Created by 梁继明 on 16/4/3.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "JMDataModel.h"

@implementation JMDataModel

-(NSString *)dateStrWithFormate{

    return [self getStringFromDate:self.startTimeInterval andForm:@"yyyy-MM-dd"];

}

//根据时间戳，获取时间；
-(NSString *) getStringFromDate:(NSTimeInterval )time andForm:(NSString *)formate{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:formate];
    
    return [formatter stringFromDate:confromTimesp];
    
    
}

@end
