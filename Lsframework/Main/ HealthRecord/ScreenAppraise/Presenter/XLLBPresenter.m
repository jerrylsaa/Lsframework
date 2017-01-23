//
//  XLLBPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "XLLBPresenter.h"
#import "DefaultChildEntity.h"

@implementation XLLBPresenter
- (void)getXLLBData{
    WS(ws);
    
    NSDictionary* parames = @{@"childId":[DefaultChildEntity defaultChild].babyID,@"UserID":@(kCurrentUser.userId),@"tableName":_tableName};
    [[FPNetwork POST:API_GetScaleMeaSureByTableNameAndChildID withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            
            ws.xllbDataSource = [XLLBEntity mj_objectArrayWithKeyValuesArray:response.data];
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
