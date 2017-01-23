//
//  HospitalListPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalListPresenter.h"
#import "HospitalList.h"
#import "JMFoundation.h"
#import "AppDelegate.h"

@implementation HospitalListPresenter
{
    NSString *cityID;
}

- (void)request {
    
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_HOSPITAL withParams:@{@"City":@""}] addCompleteHandler:^(FPResponse *response) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [HospitalList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"keyID" : @"keyid",
                         @"hName" : @"HName"
                         };
            }];
            
            for (NSDictionary *dict in response.data) {
                
                HospitalList *model = [HospitalList mj_objectWithKeyValues:dict];
                [dataArray addObject:model];
                
            }
            [ProgressUtil showSuccess:response.message];
        }else {
            
            NSLog(@" 😥");
            [ProgressUtil showError:response.message];
        }
        
        [ws.delegate sendData:dataArray];
        
    }];
    
}

@end
