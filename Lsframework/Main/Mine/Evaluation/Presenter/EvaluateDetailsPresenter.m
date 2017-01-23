//
//  EvaluateDetailsPresenter.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "EvaluateDetailsPresenter.h"
#import "JMFoundation.h"

@implementation EvaluateDetailsPresenter

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block{
    
//    NSString* doctorID1 = [NSString stringWithFormat:@"%@",doctorId];
//    if(doctorID1.length==0)
//        doctorID1 = @"";
//    }
//    
  
    WS(ws);
    
    NSDictionary *parameters = @{@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId],doctorId:@"DoctorID"};
    [[FPNetwork POST:API_QUERY_MY_EVALUTE_LIST withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
           NSLog(@"\n%@", response.data);
            
            NSArray *modelArray = [EvaluationDetail mj_objectArrayWithKeyValuesArray:@[response.data]];
            ws.evaluation = [modelArray lastObject];
            block(response.success ,(EvaluationDetail *)(modelArray.lastObject));
          

           
        }
//
        [ProgressUtil showSuccess:response.message];

        
    }];
    
    
}






@end
