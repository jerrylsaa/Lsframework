//
//  HospitalMedicalRecordsPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalMedicalRecordsPresenter.h"
#import "HospitalFileList.h"

@implementation HospitalMedicalRecordsPresenter


- (void)request {
    
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_HOSPITAL_MER_LIST withParams:@{@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [HospitalFileList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"chiefComplaint" : @"ChiefComplaint",
                         @"emrContent" : @"EMRContent",
                         @"userName" : @"UserName",
                         @"hospitalName" : @"HName",
                         @"ID" : @"id",
                         @"babyName" : @"CHILD_NAME",
                         @"inspectTime" : @"InspectTime"
                         };
            }];
            
            for (NSDictionary *dict in response.data) {
                
                HospitalFileList *model = [HospitalFileList mj_objectWithKeyValues:dict];
                [dataArray addObject:model];
                
            }
            
//            [ProgressUtil showSuccess:response.message];
            [ProgressUtil dismiss];
        }else {
            
            NSLog(@" 😥");
            [ProgressUtil showError:response.message];
        }
        
        [ws.delegate sendData:dataArray];
        
    }];
    
}


@end
