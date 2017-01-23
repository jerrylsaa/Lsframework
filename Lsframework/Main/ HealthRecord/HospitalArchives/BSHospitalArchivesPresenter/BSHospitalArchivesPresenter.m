//
//  BSHospitalArchivesPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalArchivesPresenter.h"
#import "HospitalFileList.h"

@implementation BSHospitalArchivesPresenter

- (void)request {
    
    NSLog(@"%ld", kCurrentUser.userId);
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_HOSPITAL_ARCHIVES withParams:@{@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [HospitalFileList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"projectName" : @"ym",
                         @"pacsContent" : @"PacsContent",
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
            [ProgressUtil dismiss];
//            [ProgressUtil showSuccess:response.message];
        }else {
            
            NSLog(@" 😥");
            [ProgressUtil showError:response.message];
        }
        
        [ws.delegate sendData:dataArray];
    }];
    
}


@end
