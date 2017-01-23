//
//  MDoctorSettingPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorSettingPresenter.h"

@implementation MDoctorSettingPresenter



-(void)SetExpertDoctorCouponCountWithExpertID:(NSNumber*)ExpertID  Count:(NSNumber*)count{
    
    WS(ws);
    [[FPNetwork POST: API_SET_EXPERTDOCTORCOUPONCOUNT withParams:@{@"ExpertDoctorID":ExpertID,@"Count":count}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate  onCompletion:response.success info:response.message];
        }
    }];
}
-(void)SetExpertDoctorIsVacationWithExpertID:(NSNumber*)ExpertID  IsVacation:(NSNumber*)Vacation{
    
    [[FPNetwork POST: API_SET_EXPERTDOCTORISVACATION withParams:@{@"ExpertDoctorID":ExpertID,@"IsVacation":Vacation}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
        }
        
        
    }];




}
-(void)SetExpertDoctorPriceWithExpertID:(NSNumber*)ExpertID  price:(NSNumber*)price{
    [[FPNetwork POST: API_SET_EXPERTDOCTORPRICE withParams:@{@"expertID":ExpertID,@"price":price}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
        }
    }];
}

-(void)GetExpertDoctorIsVacationAndCountWithExpertID:(NSNumber*)ExpertID{
    
    WS(ws);
    [[FPNetwork POST: API_GET_EXPERTDOCTORISVACATIONANDCOUNT withParams:@{@"ExpertDoctorID":ExpertID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            ws.dataSource = [DoctorCouponInfo  mj_objectArrayWithKeyValuesArray:response.data];

        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetExpertDoctorCompletion:info:)]){
            [ws.delegate  onGetExpertDoctorCompletion:response.success info:response.message];
        }
    }];
}

-(void)GetExpertConsumptionInfoWithExpert_ID:(NSNumber*)ExpertID{

    WS(ws);
    [[FPNetwork POST: API_GET_EXPERTCONSUMPTIONINFO withParams:@{@"UserID":@(kCurrentUser.userId),@"Expert_ID":ExpertID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            self.CouponCount = response.data[@"CouponCount"];
            self.CouponTotalMoney = response.data[@"CouponTotalMoney"];

        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetExpertConsumptionInfoCompletion:info:)]){
            [ws.delegate  onGetExpertConsumptionInfoCompletion:response.success info:response.message];
        }
    }];




}
@end
