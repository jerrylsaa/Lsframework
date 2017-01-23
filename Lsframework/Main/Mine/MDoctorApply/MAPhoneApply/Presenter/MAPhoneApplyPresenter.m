//
//  MAPhoneApplyPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAPhoneApplyPresenter.h"

@implementation MAPhoneApplyPresenter

- (void)getMAPhoneApply{
    NSInteger userID = kCurrentUser.userId;
    userID = 8;//测试
    NSDictionary* parames = @{@"UserID":@(userID)};
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_MY_PHONE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [MineApplyFamilyDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];

}

- (void)refreshHeader{
    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试52
    NSDictionary* parames = @{@"UserID":@(userID)};
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_MY_FAMILY_DOCTOR withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [MineApplyFamilyDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
}


@end
