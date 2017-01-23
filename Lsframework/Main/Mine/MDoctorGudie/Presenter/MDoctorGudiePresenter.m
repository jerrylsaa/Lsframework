//
//  MDoctorGudiePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorGudiePresenter.h"
#import "JMFoundation.h"



@implementation MDoctorGudiePresenter


- (void)request {
    
    NSLog(@"%ld", kCurrentUser.userId);

    WS(ws);
    [[FPNetwork POST:@"GetDoctorGuidance" withParams:@{@"Userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
          NSMutableArray *dataArray = [NSMutableArray array];
        if (response.success) {
            
          
            NSLog(@"\n%@", response.data);
            
            [BehaviourGuide mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"departName" : @"Depart_Name",
                         @"doctorName" : @"DoctorName",
                    @"dictionaryName":@"Dictionary_Name",
                         @"descriptionDisease" : @"DescriptionDisease",
                         @"userImage" : @"UserImg",
                         @"doctorID" :@"doctorid"
                         };
            }];
            
            
          
            for (NSDictionary *dict in response.data) {
                
                BehaviourGuide *stu = [BehaviourGuide mj_objectWithKeyValues:dict];
                [dataArray addObject:stu];
                
            }
            
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
