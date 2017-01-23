//
//  WXPayUtil.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "WXPayUtil.h"
#import "WXApi.h"

@implementation WXPayUtil

+ (instancetype)sharedManager
{
    static WXPayUtil *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+(void)payWithWXParames:(NSDictionary *)wxParames callback:(WXPayCallback)callback{
    
    [WXPayUtil sharedManager].callback = callback;
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [wxParames objectForKey:@"partnerid"];
    req.prepayId            = [wxParames objectForKey:@"prepayid"];
    req.nonceStr            = [wxParames objectForKey:@"noncestr"];
    req.timeStamp           = (int)[[wxParames objectForKey:@"timestamp"] integerValue];
    req.package             = [wxParames objectForKey:@"package"];
    req.sign                = [wxParames objectForKey:@"sign"];
    
    [WXApi sendReq:req];
    
    
    
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[wxParames objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );

    
    
    
}



@end
