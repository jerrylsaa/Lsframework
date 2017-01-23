//
//  MDoctorApplyPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorApplyPresenter.h"

#define kCount 3 //请求个数

@implementation MDoctorApplyPresenter


-(void)getMyApply{
    self.request = [DataTaskManager new];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:kCount];
    
    NSInteger userID = kCurrentUser.userId;
//    userID = 8;//测试52
    NSDictionary* parames = @{@"UserID":@(userID)};
    WS(ws);
    
    //家庭医生申请
    FPNetwork* familyDoctorRequest = [[FPNetwork POST:API_QUERY_MY_FAMILY_DOCTOR withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        ws.familyDoctorResponse = response;
        [ws.request countDown];
    }];
    [array addObject:familyDoctorRequest];
    
    //在线申请
    FPNetwork* onlineRequest =[[FPNetwork POST:API_QUERY_MY_ONLINE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        ws.onlineResponse = response;
        [ws.request countDown];
    }];
    [array addObject:onlineRequest];
    
    //电话申请
    FPNetwork* phoneRequest = [[FPNetwork POST:API_QUERY_MY_PHONE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        ws.phoneResponse = response;
        [ws.request countDown];
    }];
    [array addObject:phoneRequest];
    
    [self.request requestWithDataTasks:array withComplete:^{
       
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion)]){
            [ws.delegate onCompletion];
        }
    }];


    
}

@end
