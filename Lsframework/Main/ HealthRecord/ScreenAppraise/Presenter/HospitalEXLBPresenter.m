//
//  HospitalEXLBPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalEXLBPresenter.h"
#import "DefaultChildEntity.h"

@implementation HospitalEXLBPresenter
- (void)getEXLBData{
    WS(ws);
    
    NSDictionary* parames = @{@"childId":[DefaultChildEntity defaultChild].babyID,@"UserID":@(kCurrentUser.userId)};
    [[FPNetwork POST:API_GetEHR_Erxin_Result withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            
            ws.exlbDataSource = [EXLBEntity mj_objectArrayWithKeyValuesArray:response.data];
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion: info:)]){
                [ws.delegate onCompletion:response.success info:response.message];
            }
            
        }else if (response.status ==0){
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }else{
            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
                
            }
        }
        
        
    }];
    
    
}
@end
