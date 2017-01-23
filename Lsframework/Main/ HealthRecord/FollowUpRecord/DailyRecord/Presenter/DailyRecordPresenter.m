//
//  DailyRecordPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.

#import "DailyRecordPresenter.h"
#import "FPNetwork.h"
#import "FollowUp.h"
#import "DefaultChildEntity.h"

@interface DailyRecordPresenter ()<UIAlertViewDelegate>

@property (nonatomic ,strong) NSDictionary *patameters;

@end

@implementation DailyRecordPresenter

- (instancetype)init{
    if ((self = [super init])) {
        _dataSource = [NSMutableArray arrayWithObjects:@{@"title":@"MRWY",@"unit":@"次"},
                       @{@"title":@"YYBC",@"unit":@""},
                       @{@"title":@"PFNWY",@"unit":@"ml"},
                       @{@"title":@"FSTJ",@"unit":@""},
                       @{@"title":@"SM",@"unit":@"次"},
                       @{@"title":@"YN",@"unit":@"次/日"},
                       @{@"title":@"KN",@"unit":@"次/日"},
                       @{@"title":@"DB",@"unit":@"形状/次数"},
                       @{@"title":@"WSS",@"unit":@"IU/d"},
                       @{@"title":@"TJ",@"unit":@"mg/d"},
                       @{@"title":@"GJ",@"unit":@"mg/d"},
                       @{@"title":@"QT",@"unit":@"mg/d"},
                       @{@"title":@"TZ",@"unit":@"kg"},
                       @{@"title":@"SG",@"unit":@"cm"},
                       @{@"title":@"TW",@"unit":@"cm"},nil];
    }
    return self;
}



- (void)loadHistoryFollowUpDataWith:(CompleteWithAge)block byDate:(NSString *)date{
    WS(ws);
    [ProgressUtil show];
     NSArray *array = [DefaultChildEntity MR_findAll];
    if (array.count > 0) {
        DefaultChildEntity *entity = array.lastObject;
        NSString *nlStr = entity.nL;
        if (nlStr.length > 0) {
            nlStr = [nlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"");
            NSRange range_1 = [nlStr rangeOfString:@"岁"];
            NSRange range_2 = [nlStr rangeOfString:@"月"];
            NSRange range_3 = {0,range_1.length > 0 ? range_1.location : 0};
            NSRange range_4 = {range_1.length > 0 ? range_1.location+1 : 0 ,(range_2.length > 0 ? range_2.location : 0) - (range_1.length > 0 ? range_1.location-1 : 0)};
            
            NSInteger year = range_1.length > 0 ? [[nlStr substringWithRange:range_3] integerValue] : 0;
            NSInteger month = range_2.length > 0 ? [[nlStr substringWithRange:range_4] integerValue] : 0;
            NSInteger totalMonth = year*12+month;
            
        NSDictionary *parameters = @{@"BabyID":entity.babyID,@"Time":date};
        [[FPNetwork POST:API_QUERY_SCREENNING_RECORD withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
//            [ProgressUtil showSuccess:@"查询完成"];
            NSMutableArray *dicArray = [NSMutableArray array];
            NSDictionary *dic;
            if (response.success == YES) {
                dic = response.data;
            }else{
                
            }
            
            for (NSDictionary *subDic in ws.dataSource) {
                NSString *title = [subDic objectForKey:@"title"];
                NSString *content = [dic objectForKey:title];
                if(!content || [content isKindOfClass:[NSNull class]] || content.length == 0){
                    content = @"";
                }
                NSDictionary *insertDic = @{@"title":subDic[@"title"],@"unit":subDic[@"unit"],@"content":content};
                [dicArray addObject:insertDic];
            }
            ws.dataSource = dicArray;
            NSRange range_1 = {0,4};
            NSRange range_2 = {4,4};
            NSRange range_3 = {8,4};
            NSRange range_4 = {12,3};
            NSArray *totalArray;
            if (totalMonth > 36) {
                totalArray = @[[dicArray subarrayWithRange:range_2],[dicArray subarrayWithRange:range_3],[dicArray subarrayWithRange:range_4]];
            }else{
                totalArray = @[[dicArray subarrayWithRange:range_1],[dicArray subarrayWithRange:range_2],[dicArray subarrayWithRange:range_3],[dicArray subarrayWithRange:range_4]];
            }
            if (response.success == YES) {
                block(response.success,totalArray,[(NSDictionary *)response.data objectForKey:@"NL"]);
            }else{
                block(NO,totalArray,nil);
            }
        }];
    }
  }
}
- (void)upLoadFollowUpData:(FollowUp *)followUp
                   forBaby:(NSString *)BABYID
                      date:(NSString *)date
                       age:(NSString*) age
                  complete:(Complete)block{
    NSDictionary *dic = [self getObjectData:followUp];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *keyArray = [parameters allKeys];
    for (NSString *key in keyArray) {
        if (!parameters[key] || [parameters[key] isKindOfClass:[NSNull class]]) {
            [parameters setObject:@0 forKey:key];
//            [ProgressUtil showError:@"请输入数字"];
//            return;
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",parameters[key]];
            [parameters setObject:@([str integerValue]) forKey:key];
        }
    }
    
    [parameters setObject:BABYID forKey:@"BABYID"];
    [parameters setObject:date forKey:@"SCTIME"];
    [parameters setObject:BABYID forKey:@"NL"];
    self.patameters = parameters;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"提交后将不能修改，请确认提交！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alertView show];
    
}

- (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    [[FPNetwork POST:API_ADD_SCREENNING_RECORD withParams:self.patameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            [ProgressUtil showSuccess:@"保存成功"];
            kCurrentUser.needToUpdateChildInfo = YES;
            if ([self.delegate respondsToSelector:@selector(saveSuccess)]) {
                [self.delegate saveSuccess];
            }
        }else{
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}

@end
