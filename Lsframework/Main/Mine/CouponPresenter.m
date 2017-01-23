//
//  CouponPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CouponPresenter.h"

@implementation CouponPresenter
-(void)getCouPonList{

    WS(ws);
    [[FPNetwork POST: API_GET_MYCOUPONLIST withParams:@{@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"优惠券列表：%@",response.data);
            ws.dataSource = [CouponList  mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouPonListCompletion:info:)]){
            [ws.delegate  GetCouPonListCompletion:response.success info:response.message];
        }
    }];
 
}
@end
