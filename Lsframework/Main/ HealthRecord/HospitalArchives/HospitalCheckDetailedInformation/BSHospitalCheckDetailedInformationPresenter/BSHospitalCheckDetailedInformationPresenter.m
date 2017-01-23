//
//  BSHospitalCheckDetailedInformationPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalCheckDetailedInformationPresenter.h"
#import "HospitalFileDetails.h"

@implementation BSHospitalCheckDetailedInformationPresenter

- (void)requestWithID:(NSInteger)ID {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *myType = [user objectForKey:@"bsArchivesType"];
    NSString *post = [NSString string];
    NSString *paramsIDKey = [NSString string];
    NSDictionary *dic = [NSDictionary dictionary];
    if ([myType isEqualToString:@"0"]) {
        post = API_QUERY_HOSPITAL_ARCHIVES_DETAIL;
        paramsIDKey = @"PacsID";
        dic = @{
                @"ID" : @"id",
                @"imageUrl" : @"PacsImg"
                };
    }else if ([myType isEqualToString:@"1"]) {
        post = API_QURE_EMR_ARCHIVES_DETAIL;
        paramsIDKey = @"EMRID";
        dic = @{
                @"ID" : @"id",
                @"imageUrl" : @"EMRImg"
                };
    }
    
    WS(ws);
    [[FPNetwork POST:post withParams:@{paramsIDKey:@(ID)}] addCompleteHandler:^(FPResponse *response) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        if (response.success) {
            
            NSLog(@"\n%@", response.data);
            
            [HospitalFileDetails mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return dic;
            }];
            
            for (NSDictionary *dict in response.data) {
                
                HospitalFileDetails *model = [HospitalFileDetails mj_objectWithKeyValues:dict];
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
