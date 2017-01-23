//
//  HWPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HWPresenter.h"
#import "DefaultChildEntity.h"

@interface HWPresenter ()

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *sex;

@end

@implementation HWPresenter

//判断是上传身高还是体重
- (void)getAdviseByBody:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight sex:(NSString *)sex{
    
    _birthday = birthday;
    _height = height;
    _weight = weight;
    _sex = [sex isEqualToString:@"2"] ? @"1" : @"0";
    if ((height.length == 0 && weight.length == 0) || !height || !weight) {
        [ProgressUtil showError:@"请先填写身高或体重"];
        return;
    }
    
    if (height.length > 0) {
        [self postHeight];
        [self insertBabyHeight:_height];
    }else{
        [self postWeight];
        [self insertBabyWeight:_weight];
    }
}

- (void)postHeight{
    [[FPNetwork POST:API_GET_ADVISE_BY_BODY withParams:@{@"birthday":_birthday,@"height":_height,@"sex":_sex}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = response.data;
            [self.delegate load:YES message:[NSString stringWithFormat:@"%@",dic[@"AdviseResult"]] tips:dic[@"AdviseContent"]isHeight:YES];
        }else{
            
        }
    }];
}
- (void)postWeight{
    if (!_weight) {
        [ProgressUtil showError:@"请填写体重"];
        return;
    }
    [[FPNetwork POST:API_GET_ADVISE_BY_BODY withParams:@{@"birthday":_birthday,@"weight":_weight,@"sex":_sex}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = response.data;
            [self.delegate load:YES message:[NSString stringWithFormat:@"%@",dic[@"AdviseResult"]] tips:dic[@"AdviseContent"]isHeight:NO];
        }else{
            
        }
    }];
}


- (void)insertBabyHeight:(NSString *)height{
    
    NSNumber *babyid = [DefaultChildEntity defaultChild].babyID;
    
    [[FPNetwork POST:@"InsertBabyBodyData" withParams:@{@"UserID":@(kCurrentUser.userId),@"babyID":babyid,@"type":@1,@"data":height}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
    }];
}
- (void)insertBabyWeight:(NSString *)weight{
    NSNumber *babyid = [DefaultChildEntity defaultChild].babyID;
    
    [[FPNetwork POST:@"InsertBabyBodyData" withParams:@{@"UserID":@(kCurrentUser.userId),@"babyID":babyid,@"type":@2,@"data":weight}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
    }];
}

- (NSInteger)babyAgeMonth{
    
    NSString *age = [DefaultChildEntity defaultChild].nL;
    age = [age stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange yearRange = [age rangeOfString:@"岁"];
    NSRange monthRange = [age rangeOfString:@"月"];
    NSInteger year;
    NSInteger month;
    if (yearRange.length > 0) {
        //有岁
        NSRange range = {0,yearRange.location};
        NSString *yearMonth = [age substringWithRange:range];
        year = [yearMonth integerValue];
        
        if (monthRange.length > 0) {
            //有月
            NSRange rangeM = {yearRange.location + yearRange.length + 1,monthRange.location};
            NSString *monthStr = [age substringWithRange:rangeM];
            month = [monthStr integerValue]+1+year*12;
        }else{
            //无月
            month = year * 12;
        }
    }else{
        //无岁
        if (monthRange.length > 0) {
            //有月
            NSRange rangeM = {0,monthRange.location};
            NSString *monthStr = [age substringWithRange:rangeM];
            month = [monthStr integerValue]+1;
        }else{
            //无月
            month = 1;
        }
    }
    
    return month;
}

@end
