//
//  FDHealthCasePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDHealthCasePresenter.h"

@implementation FDHealthCasePresenter

- (void)requtestData{
    NSInteger userID = kCurrentUser.userId;
//    userID = 636;//测试
    
    NSDictionary* parames = @{@"BabyID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_QUERY_HEALTHCASE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [FDHealthCaseEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
}



@end
