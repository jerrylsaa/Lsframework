//
//  HWChartPresenter.m
//  FamilyPlatForm
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HWChartPresenter.h"
#import "DefaultChildEntity.h"

@implementation HWChartPresenter

- (void)loadData:(NSString *)type{
    
    NSString *sex = [DefaultChildEntity defaultChild].childSex;
    sex = [sex isEqualToString:@"1"] ? @"0" : @"1";
    WS(ws);
    [ProgressUtil show];
    [[FPNetwork POST:@"GetStandardData" withParams:@{@"sex":sex,@"type":type}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            _highArray = [response.data objectForKey:@"height"];
            _middleArray = [response.data objectForKey:@"middle"];
            _lowArray = [response.data objectForKey: @"low"];
            [ws GetBabyBodyDataByBabyID:type];
        }else{
            [ws.delegate complete:response.success message:response.message];
        }
    }];
}


- (void)GetBabyBodyDataByBabyID:(NSString *)type{
    
    NSNumber *babyid = [DefaultChildEntity defaultChild].babyID;
    type = [type isEqualToString:@"0"] ? @"1" : @"2";
    [[FPNetwork POST:@"GetBabyBodyDataByBabyID" withParams:@{@"UserID":@(kCurrentUser.userId),@"babyID":babyid,@"type":type}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
        if (response.success == YES) {
            _dataArray = response.data;
        }
        [self.delegate complete:response.success message:response.message];
    }];
    
}

@end
