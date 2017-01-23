//
//  AliPayUtil.m
//  FamilyPlatForm
//
//  Created by tom on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AliPayUtil.h"
#import "AppConfig.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"

@interface AliPayUtil()



@end

@implementation AliPayUtil

+ (instancetype)sharedManager
{
    static AliPayUtil *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+(void)payWithTitle:(NSString *)title withDetail:(NSString *)detail withOrderNum:(NSString*)orderNum withPrice:(CGFloat)price callback:(AlipayCallback)callback{
    [AliPayUtil sharedManager].callback = callback;
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = kAlipayParner;
    NSString *seller = kAlipaySeller;
    NSString *privateKey = kAlipayPrivateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
//    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.outTradeNO = orderNum; //订单ID（由商家自行制定）
    order.subject = title; //商品标题
    order.body = detail; //商品描述
//    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@价格=%f",price);
    order.totalFee = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL =  kAlipayNotifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = kAlipayAppScheme;
    

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"pay reslut = %@",resultDic);
            if ([AliPayUtil sharedManager].callback) {
                [AliPayUtil sharedManager].callback(resultDic);
            }
        }];
    }
}

+(void)payWithTitle:(NSString *)title withDetail:(NSString *)detail withOrderNum:(NSString*)orderNum withPrice:(CGFloat)price  healthServiceCallback:(AlipayCallback)callback{    [AliPayUtil sharedManager].callback = callback;
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = kAlipayParner;
    NSString *seller = kAlipaySeller;
    NSString *privateKey = kAlipayPrivateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    //    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.outTradeNO = orderNum; //订单ID（由商家自行制定）
    order.subject = title; //商品标题
    order.body = detail; //商品描述
    //    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@价格=%f",price);
    order.totalFee = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL =  kAlipayHealthServiceNotifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = kAlipayAppScheme;
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"pay reslut = %@",resultDic);
            if ([AliPayUtil sharedManager].callback) {
                [AliPayUtil sharedManager].callback(resultDic);
            }
        }];
    }
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
