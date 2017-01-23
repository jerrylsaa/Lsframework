//
//  ACDoctorDetailPresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACDoctorDetailPresenter.h"

@implementation ACDoctorDetailPresenter




- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block{
    
   NSString* doctorID = [NSString stringWithFormat:@"%@",doctorId];
    if(doctorID.length==0){
        doctorID = @"";
    }
    WS(ws);
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:doctorID forKey:@"DoctorID"];
    [[FPNetwork POST:API_PHONE_QUERY_DOCTOR_INFO withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        //拉取医生详细信息
        if (response.success) {
            NSArray *modelArray = [DoctorList mj_objectArrayWithKeyValuesArray:@[response.data]];
            ws.doctor = [modelArray lastObject];
            block(response.success ,(DoctorList *)(modelArray.lastObject));
        }
    }];
}

- (void)addAttention:(NSNumber *)doctorId complete:(Complete)block{
    NSString* doctorID = [NSString stringWithFormat:@"%@",doctorId];
    if(doctorID.length==0){
        doctorID = @"";
    }
//    WS(ws);
    NSDictionary *parameters = @{@"DoctorID":doctorID,@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    [[FPNetwork POST:API_ADD_COLLECTION withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        [ProgressUtil showSuccess:response.message];
        block(response.success,nil);
    }];
    
}

- (void)deleteAttention:(NSNumber *)doctorId complete:(Complete)block{
    NSString* doctorID = [NSString stringWithFormat:@"%@",doctorId];
    if(doctorID.length==0){
        doctorID = @"";
    }
    NSDictionary *parameters = @{@"DoctorID":doctorID,@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    [[FPNetwork POST:API_REMOVE_COLLECTION withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        [ProgressUtil showSuccess:response.message];
        block(response.success,nil);
    }];
}

@end
