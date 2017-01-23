//
//  CirclePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CirclePresenter.h"


#define timeInterVal 0.5

@interface CirclePresenter (){
    NSInteger pageIndex;
}

@end

@implementation CirclePresenter


-(instancetype)init{
    self= [super init];
    if(self){
        pageIndex = 1;
    }
    return self;
}


-(void)loadCircleData{
    pageIndex = 1;
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId), @"PageIndex":@(pageIndex), @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_GET_VOICE_WORDSCONSULTATIONV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            if(ws.dataSource){
                [ws.dataSource removeAllObjects];
                ws.dataSource = nil;
            }

            ws.dataSource = [CircleEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadCompleteWith:info:)]){
            [ws.delegate loadCompleteWith:response.success info:response.message];
        }
    }];
    
}

-(void)loadMoreCircleData{
    pageIndex ++;
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId), @"PageIndex":@(pageIndex), @"PageSize":@(kPageSize)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_VOICE_WORDSCONSULTATIONV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            NSMutableArray* array = [CircleEntity mj_objectArrayWithKeyValuesArray:response.data];
            if(array.count != 0 ){
            
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                [ws.dataSource removeAllObjects];
                ws.dataSource = nil;
                ws.dataSource = result;

            }else{
                ws.noMoreData = YES;
            }
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadMoreCompleteWith:info:)]){
            [ws.delegate loadMoreCompleteWith:response.success info:response.message];
        }

        
    }];

}

-(void)payWithListenPrice:(CGFloat)price payType:(NSString *)payType{
    //获取订单号
    [self getTradeIDwithPrice:price withPayType:payType];
}

//获取订单号
-(void)getTradeIDwithPrice:(CGFloat)price withPayType:(NSString *)payType{
    
    NSString* bussiness = @"listenBiz";
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"Price":[NSNumber numberWithFloat:price],@"Business":bussiness,@"PayType":payType};
    
    WS(ws);
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil dismiss];
            NSDictionary* dic = [response.data firstObject];
            ws.orderID = dic[@"OrderID"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterVal * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if([payType isEqualToString:@"alipay"]){
                    //走支付宝支付
                    [ws payByAliPayWithorderID:ws.orderID price:price];
                }else if([payType isEqualToString:@"wxpay"]){
                    //走微信支付
                    
                }

            });
            
        }else{
            //获取订单号失败
            [ProgressUtil showError:response.message];
        }
        
    }];

}

/**
 支付宝支付

 @param price 支付价格
 */
- (void)payByAliPayWithorderID:(NSString*) orderID price:(CGFloat) price{
    //test
//    price = 0.01;
    
    self.payPrice = price;
    
    WS(ws);
    [AliPayUtil payWithTitle:@"旁听支付" withDetail:@"详情" withOrderNum:orderID withPrice:price callback:^(NSDictionary*dict){
        NSString* payStatus = dict[@"resultStatus"];
        if([payStatus isEqualToString:@"9000"]){
            NSLog(@"支付成功");
            [ProgressUtil showSuccess:@"付款成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterVal * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //走支付成功接口
                [ProgressUtil show];
                [ws paySuccessWithOrderID:orderID];
            });
            
        }else if([payStatus isEqualToString:@"6001"]){
            NSLog(@"用户中途取消支付");
            [ProgressUtil showInfo:@"用户取消支付"];
        }else if([payStatus isEqualToString:@"6002"]){
            NSLog(@"网络连接出错");
            [ProgressUtil showInfo:@"网络连接出错"];
        }else if([payStatus isEqualToString:@"4000"]){
            NSLog(@"订单支付失败");
            [ProgressUtil showInfo:@"订单支付失败"];
        }
        
    }];
    
}

//支付成功
-(void)paySuccessWithOrderID:(NSString *)orderID{
    NSDictionary* parmas = @{@"UserID":@(kCurrentUser.userId),@"OrderID":orderID};
    WS(ws);
    [[FPNetwork POST:API_PAYSUCCESS withParams:parmas] addCompleteHandler:^(FPResponse *response) {
        
        NSString* paySuccessKeyPath = [NSString stringWithFormat:@"paySuccess%@",ws.circleEntity.uuid];
        NSString* UUIDKeyPath = [NSString stringWithFormat:@"UUID%@",ws.circleEntity.uuid];

        
        if(response.success){
            
            NSNumber* consultationUUID = [kDefaultsUser readValueForKey:UUIDKeyPath];
            if(consultationUUID && [consultationUUID boolValue]){
                NSLog(@"清除上次支付失败标志");
                [kDefaultsUser removeValueWithKey:UUIDKeyPath];
                [kDefaultsUser removeValueWithKey:paySuccessKeyPath];
            }
            
            //支付成功，走插入偷听表
            [ws insertListenQuestion:ws.circleEntity price:self.payPrice orderID:orderID];

        }else{
            //支付成功---失败,保存订单ID，咨询ID(唯一标示)
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:UUIDKeyPath];
            //保存偷听订单号到本地
            [kDefaultsUser saveValue:orderID withKeyPath:paySuccessKeyPath];

            [ProgressUtil showError:response.message];
        }
    }];

}

//插入偷听表
-(void)insertListenQuestion:(CircleEntity *)circleEntity price:(CGFloat)price orderID:(NSString *)orderID{
    NSString* expertID = (circleEntity.expertID)? [NSString stringWithFormat:@"%@",circleEntity.expertID]: @"";
    NSString* consultationID = (circleEntity.uuid)? [NSString stringWithFormat:@"%@",circleEntity.uuid]: @"";
    
    NSString* actionName = API_INSERTLISTENQUESTION;
    NSString* userID = @"User_ID";
    if(circleEntity.isFree && [circleEntity.isFree intValue] == 1){
        //限时免费
        actionName = API_INSERT_LISTEN_QUESTION_RECORDS;
        userID = @"UserID";
    }
    
    NSDictionary *parameter = @{@"Expert_ID":expertID,@"ConsultationID":consultationID,userID:@(kCurrentUser.userId),@"Price":@(price),@"OrderID":orderID};
    WS(ws);
    [[FPNetwork POST:actionName withParams:parameter] addCompleteHandler:^(FPResponse *response) {
        
        NSString* insertListenKeyPath = [NSString stringWithFormat:@"insertListen%@",ws.circleEntity.uuid];
        NSString* UUIDKeyPath = [NSString stringWithFormat:@"UUID%@",ws.circleEntity.uuid];
        
        if (response.success) {
            
            NSNumber* consultationUUID = [kDefaultsUser readValueForKey:UUIDKeyPath];
            if(consultationUUID && [consultationUUID boolValue]){
                NSLog(@"清除上次插入偷听表失败标志");
                [kDefaultsUser removeValueWithKey:UUIDKeyPath];
                [kDefaultsUser removeValueWithKey:insertListenKeyPath];
            }
            
            //判断之前是不是有下过这个文件，有就删除
            NSArray* result = [ws.circleEntity.voiceUrl componentsSeparatedByString:@"/"];
            if([NSString fileIsExist:[result lastObject]]){
                //文件存在，移除对应文件
                NSString* downloadPath = [NSString getDownloadPath:ws.circleEntity.voiceUrl];
                if([NSString deleteFileWithPath:downloadPath]){
                    NSLog(@"下载文件删除成功");
                }
            }
            
            //插入偷听表成功，下载音频文件
            [ws downloadAudioFile:ws.circleEntity.voiceUrl];
        }else{
            //插入偷听表失败，但是用户已经支付成功了，下次跳过支付直接插入偷听表，这里要保存支付订单号
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:UUIDKeyPath];
            //保存偷听订单号到本地
            [kDefaultsUser saveValue:orderID withKeyPath:insertListenKeyPath];

            
            [ProgressUtil showError:response.message];
        }
    }];

}

//下载音频
-(void)downloadAudioFile:(NSString *)audioURL{
    WS(ws);
    [[FPNetwork DOWNLOAD:audioURL downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
        
        NSLog(@"progress = %.2f",pregress.fractionCompleted);
        
    } withCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil dismiss];
            //下载成功，开始转码，amr转成系统支持的wav格式
            [ws convertAmrToWav:audioURL];
        }else{
            //下载失败
            NSArray* result = [audioURL componentsSeparatedByString:@"/"];
            if([NSString fileIsExist:[result lastObject]]){
                //文件存在，移除对应文件
                NSString* downloadPath = [NSString getDownloadPath:audioURL];
                if([NSString deleteFileWithPath:downloadPath]){
                    NSLog(@"下载文件删除成功");
                }
            }
            
            //下次跳过插入偷听表，直接从下载开始
            
            [ProgressUtil showError:response.message];
        }
    }];

}

//开始转码
-(void)convertAmrToWav:(NSString *)audioSourceURL{
    NSString* downloadPath = [NSString getDownloadPath:audioSourceURL];
    NSArray* result = [audioSourceURL componentsSeparatedByString:@"/"];
    
    //文件名不带后缀
    NSString* fileName = [NSString getFileName:[result lastObject]];
    
    NSString* convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
    
    //amr格式转wav格式
    if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
        
        NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
        
        WS(ws);
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(payCompleteWithAudioURL:)]){
            [ws.delegate payCompleteWithAudioURL:audioURL];
        }
        
    }else{
        //转码失败,删除对应的amr文件
        if([NSString fileIsExist:[result lastObject]]){
            if([NSString deleteFileWithPath:downloadPath]){
                NSLog(@"文件删除成功");
            }
        }

        [ProgressUtil showError:@"音频转码失败"];
    }

}

//微信支付
-(void)wxpayWithConsultationID:(NSNumber *)consultationID price:(CGFloat)price type:(NSString *)type{
    
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parames = @{@"token":kCurrentUser.token,@"userID":@(userID), @"type":type, @"id":consultationID};
    
    
    WS(ws);
    //获取微信订单号
    [[FPNetwork GETtigerhuang007:GREATE_WX_ORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            [ProgressUtil dismiss];
            
            if(response.data){
                NSDictionary* responseDic = response.data;
                
                NSString* orderNO = [responseDic objectForKey:@"orderNO"];
                NSDictionary* wxParams = [responseDic objectForKey:@"wxParams"];
                
                NSLog(@"orderNO = %@,wxParams = %@",orderNO,wxParams);
                
                //发起微信支付
                [WXPayUtil payWithWXParames:wxParams callback:^{

                    //检查微信支付结果
                    [ProgressUtil show];
                    [ws checkWXPayResultWithOder:orderNO];


                }];
                
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
                NSString* voiceurl = [responseDic objectForKey:@"voiceUrl"];
                
                NSLog(@"payState = %@---voiceurl = %@",payState,voiceurl );
                if([payState isEqualToString:@"SUCCESS"]){
                    NSLog(@"====支付成功======");
                    [ProgressUtil showSuccess:response.message];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterVal * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        //判断之前是不是有下过这个文件，有就删除
                        NSArray* result = [voiceurl componentsSeparatedByString:@"/"];
                        if([NSString fileIsExist:[result lastObject]]){
                            //文件存在，移除对应文件
                            NSString* downloadPath = [NSString getDownloadPath:voiceurl];
                            if([NSString deleteFileWithPath:downloadPath]){
                                NSLog(@"下载文件删除成功");
                            }
                        }
                        //下载音频文件
                        [ProgressUtil show];
                        [ws downloadAudioFile:voiceurl];
                    });
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
