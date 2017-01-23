//
//  MyBindDoctorPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyBindDoctorPresenter.h"

@implementation MyBindDoctorPresenter

- (void)getBindExpertList{
    WS(ws);
    [[FPNetwork POST:API_GetBindExpertList withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success == YES) {
            ws.doctorDataSource = [MyBindDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(getBindExpertListSuccess)]) {
                [ws.delegate getBindExpertListSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
            
        }
    }];

}

- (void)cancelBindExpertByExpertID:(NSNumber *)expertID{

    WS(ws);
    [[FPNetwork POST:API_CancelBindExpert withParams:@{@"userid":@(kCurrentUser.userId),@"expertid":expertID}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success == YES) {
            
            [ws getBindExpertList];
            
            
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
            
        }
    }];
    
}


@end
