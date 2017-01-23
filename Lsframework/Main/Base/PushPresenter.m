//
//  PushPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PushPresenter.h"

@implementation PushPresenter


-(void)loadPushDoctorAnswerinfoWithType:(NSNumber*)type UUID:(NSNumber*)uuid{


    WS(ws);
    if ([type  integerValue]== 8) {
        type = @(0);
    }else if ([type  integerValue]== 9){
        type = @(1);
    }
    
    NSDictionary* parames = @{@"Type":type,@"UserID":@(kCurrentUser.userId),@"UUID":uuid};
    
    [[FPNetwork POST:API_GET_Push_DOCANSWERCONSULATIONV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            if (response.data!=nil) {
                ws.AnswerSource = [MyAnserEntity mj_objectArrayWithKeyValuesArray:response.data];
                ws.IsAnwer = [response.data[0]  objectForKey:@"isAnser"];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadPushDoctorAnswerCompletion:info:)]){
                    [ws.delegate loadPushDoctorAnswerCompletion:response.success info:response.message];
                }
            }
            
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];





}

@end
