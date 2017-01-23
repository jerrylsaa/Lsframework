//
//  PayManager.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//


#import "PayManager.h"
#import "FPNetwork.h"

#define payStatus @"payStatus"

@interface PayManager ()

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSNumber *expertID;
@property (nonatomic, strong) NSNumber *consultationID;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) NSNumber *uuid;

@end

@implementation PayManager

- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID uuid:(NSNumber *)uuid{
    _payType = payType;
    _expertID = expertID;
    _consultationID = consultationID;
    _uuid = uuid;
    //根据uuid查询上次状态
    //1.无状态 2.支付成功状态 3.插入状态
    NSString *key = [NSString stringWithFormat:@"%@",_uuid];
    if (![kDefaultsUser objectForKey:key]) {
        [self getOrderId];
    }else{
        NSDictionary *status = [kDefaultsUser objectForKey:key];
        
        _orderID = status[@"orderID"];
        _expertID = status[@"expertID"];
        _consultationID = status[@"consultationID"];
            
        if ([status[@"code"] isEqual:@1]) {
            [self paySuccess];
        }else if ([status[@"code"] isEqual:@2]){
            [self insertListen];
        }
        
    }
    
}
//获取订单号
- (void)getOrderId{
    [ProgressUtil showWithStatus:@"正在获取订单号"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userID"];
    [parameters setObject:@(1.f) forKey:@"Price"];
    [parameters setObject:@"listenBiz" forKey:@"Business"];
    [parameters setObject:_payType forKey:@"PayType"];
    
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = [response.data firstObject];
            _orderID = [NSString stringWithFormat:@"%@",dic[@"OrderID"]];
            NSLog(@"订单号%@",_orderID);
            [ProgressUtil showWithStatus:@"正在支付"];
            [self insertListenRecords];
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}
//插入偷听记录
- (void)insertListenRecords{
    NSDictionary *parameters = @{@"Expert_ID":_expertID,@"ConsultationID":_consultationID,@"UserID":@(kCurrentUser.userId),@"Price":@(1),@"OrderID":_orderID};
    [[FPNetwork POST:API_INSERT_LISTEN_QUESTION_RECORDS withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            [self pay];
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

//跳转支付
- (void)pay{
    [AliPayUtil payWithTitle:@"1元旁听" withDetail:@"detail" withOrderNum:[NSString stringWithFormat:@"%@",_orderID] withPrice:1.f callback:^(NSDictionary *dict) {
        switch ( [dict[@"resultStatus"] integerValue]) {
            case 9000:{
                NSLog(@"订单支付成功");
                [self paySuccess];
                break;
            }
            case 8000:{
                NSLog(@"订单正在处理中");
                [ProgressUtil showInfo:@"订单正在处理中"];
                break;
            }
            case 4000:{
                NSLog(@"订单支付失败");
                [ProgressUtil showInfo:@"订单支付失败"];
                break;
            }
            case 6001:{
                NSLog(@"订单取消");
                [ProgressUtil showInfo:@"订单取消"];
                break;
            }
            case 6002:{
                NSLog(@"网络连接出错");
                [ProgressUtil showInfo:@"网络连接出错"];
                break;
            }
            default:
                break;
        }
    }];
}
//支付成功接口
- (void)paySuccess{

    NSMutableDictionary *status = [NSMutableDictionary new];
    status[@"code"] = @1;
    status[@"orderID"] = _orderID;
    status[@"consultationID"] = _consultationID;
    status[@"expertID"] = _expertID;
    NSString *key = [NSString stringWithFormat:@"%@",_uuid];
    [kDefaultsUser setObject:status forKey:key];
    
    [[FPNetwork POST:API_PAY_SUCCESS_BY_PAY_ORDER withParams:@{@"UserID":@(kCurrentUser.userId),@"OrderID":_orderID}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
        if (response.status == 200) {
            //            [ProgressUtil showSuccess:@"支付成功"];
            [self insertListen];
        }else if (response.status == 500){
            [ProgressUtil showError:@"支付失败"];
        }
    }];
}
//插入偷听
- (void)insertListen{
    //删除成功支付的问题的uuid状态：支付成功
    //存储插入偷听的问题的uuid状态：插入偷听
    NSMutableDictionary *status = [NSMutableDictionary new];
    status[@"code"] = @2;
    status[@"orderID"] = _orderID;
    status[@"consultationID"] = _consultationID;
    status[@"expertID"] = _expertID;
    NSString *key = [NSString stringWithFormat:@"%@",_uuid];
    [kDefaultsUser setObject:status forKey:key];
    
    NSDictionary *parameters = @{@"Expert_ID":_expertID,@"ConsultationID":_consultationID,@"User_ID":@(kCurrentUser.userId),@"Price":@(1.f),@"OrderID":_orderID};
    
    [[FPNetwork POST:API_INSERT_LISTEN_QUESTION withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
            [ProgressUtil showSuccess:@"支付成功"];
            //回调
            [self paySuccess:YES];
            //删除插入偷听的问题uuid状态：插入偷听
            [kDefaultsUser removeObjectForKey:key];
        }else{
            [ProgressUtil dismiss];
            [self paySuccess:NO];
        }
        NSLog(@"%@",response.message);
    }];
}

- (void)paySuccess:(BOOL) success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(payComplete:)]) {
        [self.delegate payComplete:success];
    }
}



@end
