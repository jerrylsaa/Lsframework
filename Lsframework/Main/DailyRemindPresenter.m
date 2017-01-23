//
//  DailyRemindPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyRemindPresenter.h"


@implementation DailyRemindPresenter

- (void)getDailyEventWithDay:(NSUInteger)day{
    WS(ws);
    [[FPNetwork POST: API_GET_GETDAILYREMINDER withParams:@{@"userid":@(kCurrentUser.userId), @"now":@(day)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            ws.DailySource = [DailyRemind mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetDailyEventWithCompletion:Day:)]){
            [ws.delegate  onGetDailyEventWithCompletion:response.success Day:day];
        }
    }];
}


@end
