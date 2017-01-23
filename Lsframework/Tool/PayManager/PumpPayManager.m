//
//  PumpPayManager.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PumpPayManager.h"
#import "FPNetwork.h"

#define pumpPayStatus @"pumpPayStatus"

@interface PumpPayManager ()

@property (nonatomic, strong) NSDictionary *wxParams;
//@property (nonatomic, copy) NSString *orderNO;

@end

@implementation PumpPayManager

- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID uuid:(NSNumber *)uuid price:(float)price{
    _payType = payType;
    _expertID = expertID;
    _consultationID = consultationID;
    _uuid = uuid;
    _price = price;
    self.pay = PayTypeAli;
    //根据uuid查询上次状态
    //1.无状态 2.支付成功状态 3.插入状态
//    NSString *key = [NSString stringWithFormat:@"%@_Pump",_uuid];
//    if (![kDefaultsUser objectForKey:key]) {
        [self getOrderId];
//    }else{
//        NSDictionary *status = [kDefaultsUser objectForKey:key];
//        
//        _orderID = status[@"orderID_Pump"];
//        _expertID = status[@"expertID_Pump"];
//        _consultationID = status[@"consultationID_Pump"];
        
//        if ([status[@"code"] isEqual:@1]) {
//            [self paySuccess];
//        }else if ([status[@"code"] isEqual:@2]){
//            [self.delegate InsertConsultingRecordsTrace];
//        }
//    }
}
//获取订单号
- (void)getOrderId{
    WS(ws);
    [ProgressUtil showWithStatus:@"正在获取订单号"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userid"];
    [parameters setObject:@(_price) forKey:@"Price"];
    [parameters setObject:@"questionBizTrace" forKey:@"Business"];
    [parameters setObject:_payType forKey:@"PayType"];
    
    [[FPNetwork POST:@"InsertBasePayOrderV1" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = [response.data firstObject];
            _orderID = [NSString stringWithFormat:@"%@",dic[@"OrderID"]];
            NSLog(@"订单号%@",_orderID);
            if (ws.price != 0) {
                [ProgressUtil showWithStatus:@"正在支付"];
                [self.delegate InsertConsultingRecordsTrace];
            }else{
                [ProgressUtil show];
                [self.delegate InsertConsultingRecordsTrace];
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

//跳转支付
- (void)pay{
    [AliPayUtil payWithTitle:@"半价追问" withDetail:@"detail" withOrderNum:[NSString stringWithFormat:@"%@",_orderID] withPrice:_price callback:^(NSDictionary *dict) {
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
    
//    NSMutableDictionary *status = [NSMutableDictionary new];
//    status[@"code"] = @1;
//    status[@"orderID_Pump"] = _orderID;
//    status[@"consultationID_Pump"] = _consultationID;
//    status[@"expertID_Pump"] = _expertID;
//    NSString *key = [NSString stringWithFormat:@"%@_Pump",_uuid];
//    [kDefaultsUser setObject:status forKey:key];
    
    [[FPNetwork POST:API_PAY_SUCCESS_BY_PAY_ORDER withParams:@{@"UserID":@(kCurrentUser.userId),@"OrderID":_orderID}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
        if (response.status == 200) {
            [ProgressUtil showSuccess:@"支付成功"];
            [self paySuccess:YES];
//            [self.delegate InsertConsultingRecordsTrace];
        }else if (response.status == 500){
            [ProgressUtil showError:@"支付失败"];
        }
    }];
}
//支付宝插入咨询
- (void)InsertConsultingRecordsTrace:(NSDictionary *)parameters{
//    //删除成功支付的问题的uuid状态：支付成功
//    //存储插入偷听的问题的uuid状态：插入咨询
//    NSMutableDictionary *status = [NSMutableDictionary new];
//    status[@"code"] = @2;
//    status[@"orderID_Pump"] = _orderID;
//    status[@"consultationID_Pump"] = _consultationID;
//    status[@"expertID_Pump"] = _expertID;
//    NSString *key = [NSString stringWithFormat:@"%@_Pump",_uuid];
//    [kDefaultsUser setObject:status forKey:key];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setObject:_expertID forKey:@"DoctorID"];
    [dic setObject:_orderID forKey:@"OrderID"];
    [dic setObject:_consultationID forKey:@"ConsultationID"];
    WS(ws);
    [[FPNetwork POST:@"InsertConsultingRecordsTraceV1" withParams:dic] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
            //回调
            if (self.price != 0) {
                [self pay];
            }else{
                [self AddExpertConsultationTrace:parameters];
            }
            //删除插入偷听的问题uuid状态：插入咨询
//            [kDefaultsUser removeObjectForKey:key];
        }else{
            [ProgressUtil dismiss];
            [self paySuccess:NO];
        }
        NSLog(@"%@",response.message);
    }];
}
//微信插入咨询
- (void)WXInsertConsultingRecordsTrace:(NSDictionary *)parameters{
    //    //删除成功支付的问题的uuid状态：支付成功
    //    //存储插入偷听的问题的uuid状态：插入咨询
    //    NSMutableDictionary *status = [NSMutableDictionary new];
    //    status[@"code"] = @2;
    //    status[@"orderID_Pump"] = _orderID;
    //    status[@"consultationID_Pump"] = _consultationID;
    //    status[@"expertID_Pump"] = _expertID;
    //    NSString *key = [NSString stringWithFormat:@"%@_Pump",_uuid];
    //    [kDefaultsUser setObject:status forKey:key];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setObject:_expertID forKey:@"DoctorID"];
    [dic setObject:_orderID forKey:@"OrderID"];
    [dic setObject:_consultationID forKey:@"ConsultationID"];
    WS(ws);
    [[FPNetwork POST:@"InsertConsultingRecordsTraceV1" withParams:dic] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
            //回调
                //发起微信支付
                [WXPayUtil payWithWXParames:ws.wxParams callback:^{
                    
                    //检查微信支付结果
                    [ProgressUtil show];
                    [ws checkWXPayResultWithOder:ws.orderID];
                }];
            //删除插入偷听的问题uuid状态：插入咨询
            //            [kDefaultsUser removeObjectForKey:key];
        }else{
            [ProgressUtil dismiss];
            [self paySuccess:NO];
        }
        NSLog(@"%@",response.message);
    }];
}

//新增咨询
- (void)AddExpertConsultationTrace:(NSDictionary *)parameters{
    //删除成功支付的问题的uuid状态：支付成功
    //存储插入偷听的问题的uuid状态：插入咨询
//    NSMutableDictionary *status = [NSMutableDictionary new];
//    status[@"code"] = @3;
//    status[@"orderID_Pump"] = _orderID;
//    status[@"consultationID_Pump"] = _consultationID;
//    status[@"expertID_Pump"] = _expertID;
//    NSString *key = [NSString stringWithFormat:@"%@_Pump",_uuid];
//    [kDefaultsUser setObject:status forKey:key];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setObject:@(kCurrentUser.userId) forKey:@"user_ID"];
    [dic setObject:_expertID forKey:@"expert_ID"];
    [dic setObject:_orderID forKey:@"OrderID"];
    [dic setObject:_consultationID forKey:@"consultationID"];
    [dic setObject:dic[@"ConsultCount"] forKey:@"consultationContent"];
    [[FPNetwork POST:@"AddExpertConsultationTraceV1" withParams:dic] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
            //回调
            if ([response.message isEqualToString:@"成功"]) {
                [self paySuccess:YES];
            }else{
                [self paySuccess:NO];
            }
            //删除插入偷听的问题uuid状态：插入咨询
//            [kDefaultsUser removeObjectForKey:key];
        }else{
//            [ProgressUtil dismiss];
            [self paySuccess:NO];
        }
        NSLog(@"%@",response.message);
    }];
}


- (void)paySuccess:(BOOL) success{
    [ProgressUtil dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(payComplete:)]) {
        [self.delegate payComplete:success];
    }
}

//微信支付
-(void)wxpayWithConsultationID:(NSNumber *)consultationID
                         price:(CGFloat)price
                          type:(NSString *)type
                consultContent:(NSString *)text
                      isPublic:(NSString *)isPublic
                        imgArr:(NSArray *)imgArr
                      doctorID:(NSString *)doctorID{
    
    NSInteger userID = kCurrentUser.userId;
    NSString *imgStr = @"";
    if (imgArr == nil || imgArr.count == 0) {
        isPublic = @"0";
    }else{
        for (NSString *urlStr in imgArr) {
            imgStr = [NSString stringWithFormat:@"%@,%@",imgStr,urlStr];
        }
    }
    if (imgStr.length > 0) {
        imgStr = [imgStr substringFromIndex:1];
    }
    NSDictionary* parames = @{@"token":kCurrentUser.token,@"userID":@(userID), @"type":type, @"id":consultationID,@"consultContent":text,@"isPublic":[isPublic isEqualToString:@"1"]?@"true":@"false",@"imgArr":imgStr,@"doctorID":doctorID};
    
    
    WS(ws);
    
    
    self.pay = PayTypeWX;
    //获取微信订单号
    [[FPNetwork GETtigerhuang007:@"createwxorderv3" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            [ProgressUtil dismiss];
            
            if(response.data){
                NSDictionary* responseDic = response.data;
                
                NSString* orderNO = [responseDic objectForKey:@"orderNO"];
                NSDictionary* wxParams = [responseDic objectForKey:@"wxParams"];
                
                NSLog(@"orderNO = %@,wxParams = %@",orderNO,wxParams);
                ws.wxParams = wxParams;
                ws.orderID = orderNO;
                [ws.delegate WXInsertConsultingRecordsTrace];
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

//检查微信支付结果
-(void)checkWXPayResultWithOder:(NSString *)orderNO{
    
    NSDictionary* parames = @{@"token":kCurrentUser.token, @"userID":@(kCurrentUser.userId), @"orderNo":orderNO};
    
    WS(ws);
    [[FPNetwork GETtigerhuang007:QUERRY_WX_ORDERSTATE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            if(response.data){
                NSDictionary* responseDic = response.data;
                NSString* payState = [responseDic objectForKey:@"state"];
                if([payState isEqualToString:@"SUCCESS"]){
                    NSLog(@"====支付成功======");
                    [ws paySuccess:YES];
                }else{
                    [ProgressUtil showError:response.message];
                }
            }
        }else{
            
            [ProgressUtil showError:response.message];
        }
    }];
}
@end
