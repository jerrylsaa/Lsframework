//
//  MBabyManager.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MBabyManagerPresenter.h"

@implementation MBabyManagerPresenter



-(void)getAllBaby{
    NSInteger userId = kCurrentUser.userId;
//    userId = 1;//测试
    NSDictionary* parames = @{@"userID":@(userId)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVESLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
           ws.dataSource = [BabayArchList mj_objectArrayWithKeyValuesArray:response.data];
        }
        BabayArchList* b = [ws.dataSource firstObject];
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
        [ws.delegate onCompletion:response.success info:response.message];
        }

        
    }];
}

-(void)setDefaultBaby:(BabayArchList *)baby{
    NSInteger babyID = baby.childID;
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parames = @{@"UserID":@(userID),@"BabyID":@(babyID)};
    
    WS(ws);
    [[FPNetwork POST:API_SET_DEFAULTBABY withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.currentBaby = baby;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(setDefaultBabyCompletion:info:)]){
            [ws.delegate setDefaultBabyCompletion:response.success info:response.message];
        }
        
    }];
    
    
}

-(void)updateAllBabyList{
    NSInteger userId = kCurrentUser.userId;
    //    userId = 1;//测试
    NSDictionary* parames = @{@"userID":@(userId)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVESLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [BabayArchList mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(updateListCompletion:info:)]){
            [ws.delegate updateListCompletion:response.success info:response.message];
        }
        
        
    }];

}



@end
