//
//  BehaviourContentPresenter.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BehaviourContentPresenter.h"
#import "JMFoundation.h"


@implementation BehaviourContentPresenter

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block{
    
    NSString* doctorID = [NSString stringWithFormat:@"%@",doctorId];
    if(doctorID.length==0){
        doctorID = @"";
    }
    WS(ws);
  NSDictionary *parameters = @{@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId],@"DoctorID":doctorID};
    [[FPNetwork POST:@"GetDoctorGuidance" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        //拉取医生详细信息
        if (response.success) {
            NSArray *modelArray = [BehaviourGuide mj_objectArrayWithKeyValuesArray:@[response.data]];
            ws.BehaviourGuide = [modelArray lastObject];
            block(response.success ,(BehaviourGuide *)(modelArray.lastObject));
        }
    }];
}



@end
