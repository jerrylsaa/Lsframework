//
//  HospitalScreenAppraisePresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalScreenAppraisePresenter.h"
#import "DefaultChildEntity.h"

@implementation HospitalScreenAppraisePresenter
- (void)getGesellData{
    WS(ws);
    
    NSDictionary* parames = @{@"childId":[DefaultChildEntity defaultChild].babyID};
    [[FPNetwork POST:API_GetGESELLByChildID withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            
            ws.gesellDataSource = [GesellEntity mj_objectArrayWithKeyValuesArray:response.data];
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
