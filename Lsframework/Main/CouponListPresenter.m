//
//  CouponListPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//



#import "CouponListPresenter.h"

@implementation CouponListPresenter
-(void)getCouPonList{
    
    WS(ws);
    [[FPNetwork POST: API_GET_MYCOUPONLIST withParams:@{@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"优惠券列表：%@",response.data);
            ws.CouponListSource = [CouponList  mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouPonListCompletion:info:)]){
            [ws.delegate  GetCouPonListCompletion:response.success info:response.message];
        }
    }];
    
}
-(void)GetConsultationConsumptionCouponPriceWithCouponID:(NSNumber*)coupid  Expert_ID:(NSNumber*)expertID{
    [ProgressUtil show];
    
    WS(ws);
    [[FPNetwork POST: API_GET_CONSULATIONCONSUMPTIONCOUPON withParams:@{@"UserID":@(kCurrentUser.userId),@"CouponID":coupid,@"Expert_ID":expertID}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"金额和状态：%@",response.data);
            if (response.data !=nil) {
                self.Status = [response.data[@"status"] integerValue];
                self.price = [response.data[@"price"]  floatValue];
            }else{
                
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetConsultationCouponPriceCompletion:info:)]){
            [ws.delegate  GetConsultationCouponPriceCompletion:response.success info:response.message];
        }
    }];
}
@end
