//
//  MDoctorEvalutePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorEvalutePresenter.h"
#import "JMFoundation.h"


@implementation MDoctorEvalutePresenter

- (void)request {
//- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block
//{

    WS(ws);
//    NSString* doctorID = [NSString stringWithFormat:@"%@",doctorId];
//    if(doctorID.length==0){
//        doctorID = @"";
//    }
    NSDictionary *parameters = @{@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    [[FPNetwork POST:API_QUERY_MY_EVALUTE_LIST withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        
         NSMutableArray *dataArray = [NSMutableArray array];
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [MyDoctorEvaluation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"userName" : @"UserName",
                         @"hName" : @"HName",
                         @"departName" : @"Depart_Name",
                         @"duties" : @"Duties",
                         @"doctorName" : @"DoctorName",
                         @"title" : @"Title",
                         @"field" : @"Field",
                         @"userImg" : @"UserImg",
                         @"applyTime" : @"ApplyTime",
                         @"orderState" : @"OrderState",
                         @"babyName" : @"BabyName",
                         @"isEvaluate" : @"IsEvaluate",
                         @"askMode" : @"AskMode",
                         @"descriptionDisease": @"DescriptionDisease",
                         @"starNum":@"StarNum",
                         @"doctorID":@"DoctorID",
                          @"followUp":@"FollowUp",
                         @"patientNum":@"PatientNum"

                         };
            }];
            
           
            for (NSDictionary *dict in response.data) {
                
                MyDoctorEvaluation *stu = [MyDoctorEvaluation mj_objectWithKeyValues:dict];
                [dataArray addObject:stu];
                
            }
           
//        [ProgressUtil showSuccess:response.message];
//            block(response.success ,(MyDoctorEvaluation *)(dataArray.lastObject));
           [ProgressUtil showSuccess:response.message];
        }else {
            
            NSLog(@" 😥");
            [ProgressUtil showInfo:@"请求失败"];
            
        }
        [ws.delegate sendData:dataArray];
    }];
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
