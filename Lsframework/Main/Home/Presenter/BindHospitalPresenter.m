//
//  BindHospitalPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BindHospitalPresenter.h"

@implementation BindHospitalPresenter

- (void)bindHospitalWithExpertID:(NSString *)expertID{
    WS(ws);
    [[FPNetwork POST:API_BindHospital withParams:@{@"ExpertID":expertID,@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion: info:)]){
                [ws.delegate onCompletion:response.success info:response.message];
                
            }
            
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];

}

@end
