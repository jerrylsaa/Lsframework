//
//  CheckProjectPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CheckProjectPresenter.h"
#import "CheckProject.h"

@implementation CheckProjectPresenter

- (void)request {
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_CHECK_PROJECT_LIST withParams:@{}] addCompleteHandler:^(FPResponse *response) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [CheckProject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"projectName" : @"ym",
                         @"projectID" : @"id"
                         };
            }];
            
            for (NSDictionary *dict in response.data) {
                
                CheckProject *model = [CheckProject mj_objectWithKeyValues:dict];
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
