//
//  MHealthServicePresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHealthServicePresenter.h"

@implementation MHealthServicePresenter



- (void)loadMHealthSerivieOderList{
    
    _detailArr =[NSMutableArray array];
    
    
    _addressArr =[NSMutableArray array];
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:API_GetMyOrderListV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {

            if (response.data!=nil) {
                NSArray *arr =response.data;
                NSDictionary *dic =arr[0];
                if (dic!=nil) {
                    
                
                ws.dataSource = [MHealthServiceOderListEntity mj_objectArrayWithKeyValuesArray:response.data];
                    
                    for (int i =0; i<arr.count;i++) {
                        NSDictionary *dic =arr[i];

                        ws.detailDataSource = [MHSOderDetailEntity mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"Items"]];
                        [_detailArr addObject:ws.detailDataSource];
                        
                        NSData *JSONData = [((NSString *)[dic objectForKey:@"USER_CONTACT"]) dataUsingEncoding:NSUTF8StringEncoding];
                        NSJSONSerialization *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                        
                        ws.addressDataSource =[MHSOderAddressEntity mj_objectWithKeyValues:responseJSON];
                        [_addressArr addObject:ws.addressDataSource];

                    }
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadHealthServiceComplete:message:)]){
                    [ws.delegate loadHealthServiceComplete:response.success message:response.message];
                }
                }
            }
            else {
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadHealthServiceComplete:message:)]){
                    [ws.delegate loadHealthServiceComplete:NO message:response.message];
                }
            }
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
    
}

- (void)getWxPayParamsWithOderID:( NSNumber * _Nonnull )oderID{
    

    NSDictionary* parames = @{@"userID":@(kCurrentUser.userId),@"orderID":oderID,@"Token":kCurrentUser.token};
    WS(ws);
    [[FPNetwork GETtigerhuang007:API_CreateGoodsWxOrder withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                NSDictionary* responseDic = response.data;
                
                NSString* orderNO = [responseDic objectForKey:@"orderNO"];
                NSDictionary* wxParams = [responseDic objectForKey:@"wxParams"];
                
                NSLog(@"orderNO = %@,wxParams = %@",orderNO,wxParams);
                
                //发起微信支付
                [WXPayUtil payWithWXParames:wxParams callback:^{
                    
                    [ws checkWXPayResultWithOder:orderNO];
                    
                    
                    
                    
                }];

                
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
}

- (void)checkWXPayResultWithOder:(NSString *)oder{
    WS(ws);
    [[FPNetwork GETtigerhuang007:@"QueryGoodsWxOrderState" withParams:@{@"token":kCurrentUser.token,@"userID":@(kCurrentUser.userId),@"orderNo":oder}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCheckWXPayResultWithOderCompletion:info:Url:)]){
                [ws.delegate onCheckWXPayResultWithOderCompletion:response.success info:response.message Url:nil];
                
            }
            
        }else {
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCheckWXPayResultWithOderCompletion:info:Url:)]){
                [ws.delegate onCheckWXPayResultWithOderCompletion:NO info:response.message Url:nil];
            }
            
        }
    }];
}

- (void)cancelOderWithOderID:(NSNumber *)oderID{
    WS(ws);
    [[FPNetwork POST:API_CloseOrder withParams:@{@"UserID":@(kCurrentUser.userId),@"OrderID":oderID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
                
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(cancelOderComplete:message:)]){
                [ws.delegate cancelOderComplete:response.success message:response.message];
            
            }
            
        }else {
            if (response.message !=nil&&![response.message isEqualToString:@""]) {
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(cancelOderComplete:message:)]){
                    [ws.delegate cancelOderComplete:response.success message:response.message];
                }
            }else{
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(cancelOderComplete:message:)]){
                    [ws.delegate cancelOderComplete:NO message:@"网络不可用,请重试"];
                }
            }
        }
    }];
}

@end
