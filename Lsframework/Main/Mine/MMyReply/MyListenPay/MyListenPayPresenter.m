//
//  MyListenPayPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyListenPayPresenter.h"

@interface MyListenPayPresenter ()

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSNumber *expertID;
@property (nonatomic, strong) NSNumber *consultationID;
@property (nonatomic, strong) NSString *orderID;

@end

@implementation MyListenPayPresenter

- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID{
    _payType = payType;
    _expertID = expertID;
    _consultationID = consultationID;
    [self getOrderId];
}
//获取订单号
- (void)getOrderId{
    [ProgressUtil showWithStatus:@"正在获取订单号"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userID"];
    [parameters setObject:@(0.01) forKey:@"Price"];
    [parameters setObject:@"listenBiz" forKey:@"Business"];
    [parameters setObject:_payType forKey:@"PayType"];
    
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = [response.data firstObject];
            _orderID = [NSString stringWithFormat:@"%@",dic[@"OrderID"]];
            NSLog(@"订单号%@",_orderID);
            [ProgressUtil showWithStatus:@"正在支付"];
            [self pay];
        }
    }];
}
//跳转支付
- (void)pay{
    [AliPayUtil payWithTitle:@"1元旁听" withDetail:@"detail" withOrderNum:[NSString stringWithFormat:@"%@",_orderID] withPrice:0.01f callback:^(NSDictionary *dict) {
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
    
    NSDictionary *parameters = @{@"Expert_ID":_expertID,@"ConsultationID":_consultationID,@"User_ID":@(kCurrentUser.userId),@"Price":@(1),@"OrderID":_orderID};
    
    [[FPNetwork POST:API_INSERT_LISTEN_QUESTION withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
            [ProgressUtil showSuccess:@"支付成功"];
            //回调
            [self paySuccess:YES];
        }else{
            [ProgressUtil showError:@""];
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
