//
//  HealthServicePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthServicePresenter.h"
#import "FPNetWork.h"
#import "MJExtension.h"


@implementation HealthServicePresenter
- (instancetype)init{
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)loadHealthService:(HealthServiceComplete)block{
        NSInteger userID = kCurrentUser.userId;
        NSDictionary* parames = @{@"userid":@(userID)};
    [[FPNetwork POST:API_Get_EVAL_TABLES withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == true) {
            if (response.data != nil && [(NSArray *)response.data count] == 0) {
                block(FALSE,nil);
            }else{
                _dataSource = [HealthService mj_objectArrayWithKeyValuesArray:response.data];
                block(TRUE,response.message);
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];

}

- (void)loadFoodService:(FoodServiceComplete)block{

    NSInteger userID = kCurrentUser.userId;
    NSDictionary* parames = @{@"UserID":@(userID)};
    [[FPNetwork POST:API_GET_QUEST_TYPELIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == true) {
            if (response.data != nil && [(NSArray *)response.data count] == 0) {
                block(FALSE,nil);
            }else{
                _dataSource = [FoodService mj_objectArrayWithKeyValuesArray:response.data];
                block(TRUE,response.message);
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

-(void)loadHealthService{

    NSInteger userID = kCurrentUser.userId;
    NSDictionary* parames = @{@"userid":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_Get_EVAL_TABLES withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success ) {
            if (response.data != nil && [(NSArray *)response.data count] != 0) {
           
            ws.HealthSource = [HealthService mj_objectArrayWithKeyValuesArray:response.data];
               
            }
            
        }else{
            [ProgressUtil showError:response.message];
        }
        
      if(ws.delegate && [ws.delegate respondsToSelector:@selector(LoadHealthonComplete:info:)]){
            [ws.delegate  LoadHealthonComplete:response.success info:response.message];
        }

    }];
    



}

@end
