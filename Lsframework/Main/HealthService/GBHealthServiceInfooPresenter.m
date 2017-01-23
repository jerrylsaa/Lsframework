//
//  GBHealthServiceInfooPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBHealthServiceInfooPresenter.h"

@implementation GBHealthServiceInfooPresenter

-(void)loadHealthServiceInfoWithTid:(NSNumber*)tid{
    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试
    
    NSDictionary* parames = @{@"TID":tid,@"UserID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_Get_EVAL_QUESTS withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [HealthServiceInfo mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onComplete:info:)]){
            [ws.delegate onComplete:response.success info:response.message];
        }
    }];
}

-(void)loadMoreDataWithTid:(NSNumber*)tid{
    [self  loadHealthServiceInfoWithTid:tid];
}
//提交服务器
-(void)commitWithEvalName:(NSString*)evalName andJsparam:(NSString*)Jsparam{
    NSDictionary  *parames = @{@"EvalName":evalName,@"JSPARAM":Jsparam};
    WS(ws);
    [[FPNetwork POST:API_Get_EVAL_SAVE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        NSDictionary  *dic = response.data;
        
        _ResultID = [dic  objectForKey:@"ID"];
        _IsHealth = [[dic  objectForKey:@"IsHealth"]boolValue];
        NSArray  *ResultArr =  [dic  objectForKey:@"Result"];
        _Result = [ResultArr[0] objectForKey:@"CONTENT"];
        
     NSLog(@"测评结果:%@---%@---%hhd",_ResultID,_Result,_IsHealth);
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitOnCompletion:info:)]){
            [ws.delegate commitOnCompletion:response.success info:response.message];
        }
    }];
    
    
    
}

- (void)loadFoodServiceInfoWithTid:(NSNumber*)TypeID{

    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试
    
    NSDictionary* parames = @{@"TypeID":TypeID,@"UserID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_GET_QUEST_QUESTLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.FoodSource = [FoodDetailService mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onComplete:info:)]){
            [ws.delegate FoodSericeComplete:response.success info:response.message];
        }
    }];



}
-(void)commitWithJsparam:(NSString*)Jsparam{
    
    NSDictionary  *parames = @{@"UserID":@(kCurrentUser.userId),@"JSPARAM":Jsparam};
    WS(ws);
    [[FPNetwork POST:API_GET_QUEST_CHOICERESULT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitFoodOnCompletion:info:)]){
            
            _Result = [response.data  objectForKey:@"Result"];
    
            [ws.delegate commitFoodOnCompletion:response.success info:response.message];
        }
    }];
    




}


@end
