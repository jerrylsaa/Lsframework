//
//  MyFavoritePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyFavoritePresenter.h"
@interface MyFavoritePresenter (){
    NSInteger _page;
    
}
@end

@implementation MyFavoritePresenter
- (instancetype)init{
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

-(void)GetMyFavoriteList{
    
    if(self.dataSource){
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
    }
    _page = 1;
    
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    
    
    
    WS(ws);
    
    [[FPNetwork POST: @"GetUserPraiseListV1" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data!=nil) {
                ws.dataSource = [MyFavoriteEntity mj_objectArrayWithKeyValuesArray:response.data];
                
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMyFavoriteListCompletion:info:)]){
                [ws.delegate GetMyFavoriteListCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}


-(void)GetMyFavoriteMoreList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    WS(ws);
    
    [[FPNetwork POST:@"GetUserPraiseListV1" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [MyFavoriteEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMyFavoriteMoreListCompletion:info:)]){
            [ws.delegate GetMyFavoriteMoreListCompletion:response.success info:response.message];
        }
        
    }];
}



@end
