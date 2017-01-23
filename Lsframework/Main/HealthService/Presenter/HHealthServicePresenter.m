//
//  HHealthServicePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HHealthServicePresenter.h"

@interface HHealthServicePresenter ()

@end

@implementation HHealthServicePresenter


-(void)loadHealthService{

    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:API_GetGoodsList withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                ws.dataSource = [HealthServiceProduct mj_objectArrayWithKeyValuesArray:response.data];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadHealthServiceComplete:message:)]){
                    [ws.delegate loadHealthServiceComplete:response.success message:response.message];
                }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];

        }
        
    }];

}

- (void)loadHealthServiceDetail:(NSNumber * _Nonnull)goodID{
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"GoodsID":goodID};
    WS(ws);
    [[FPNetwork POST:API_getgoodsdetails withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                NSDictionary *dic =response.data;
                
                ws.detailDataSource = [HealthServiceDetailData mj_objectWithKeyValues:[dic objectForKey:@"Goods"] context:nil];
                ws.attributesDataSource = [HealthServiceDetailAttributes mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"Attributes"]];
                ws.stocksDataSource = [HealthServiceDetailStocks mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"Stocks"]];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadHealthServiceDetailComplete:message:)]){
                    [ws.delegate loadHealthServiceDetailComplete:response.success message:response.message];
                }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
    
}

- (void)createGoodsOrderWithName:(NSString *_Nonnull)name Phone:(NSString *_Nonnull)phone Address:(NSString *_Nonnull)address Email:(NSString *_Nullable)email StocksID:(NSNumber *_Nonnull)stocksID StocksNum:(NSNumber *_Nonnull)stocksNum{
    NSDictionary* parames =[NSDictionary dictionary];
    if (email==nil) {
        parames = @{@"UserID":@(kCurrentUser.userId),@"Name":name,@"PHONE":phone,@"ADDRESS":address,@"StockIDS":stocksID,@"StockNums":stocksNum};
    }else{
        parames = @{@"UserID":@(kCurrentUser.userId),@"Name":name,@"PHONE":phone,@"ADDRESS":address,@"StockIDS":stocksID,@"StockNums":stocksNum,@"EMAIL":email};
    }
    WS(ws);
    [[FPNetwork POST:API_CreateGoodsOrder withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                
                NSDictionary *dic =response.data;
                if (dic!=nil) {
                    
                    
                    ws.oderDetailDataSource = [MHealthServiceOderListEntity mj_objectWithKeyValues:dic];
                    
                        
                        NSData *JSONData = [((NSString *)[dic objectForKey:@"USER_CONTACT"]) dataUsingEncoding:NSUTF8StringEncoding];
                        NSJSONSerialization *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                        
                        ws.oderAddressDataSource =[MHSOderAddressEntity mj_objectWithKeyValues:responseJSON];
                    
                        
                    
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(createHealthServiceOderComplete:message:)]){
                    [ws.delegate createHealthServiceOderComplete:response.success message:response.message];
                    }
                }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
}

- (void)loadMyUserInfo{
    NSDictionary* parames =@{@"UserID":@(kCurrentUser.userId)};
    
    WS(ws);
    [[FPNetwork POST:@"GetUserInfo" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                
                    
                    ws.myUserInfoAddress =[MHSOderAddressEntity mj_objectWithKeyValues:response.data];
                    
                
                    
                    
                    if(ws.delegate && [ws.delegate respondsToSelector:@selector(onLoadMyUserInfoComplete:message:)]){
                        [ws.delegate onLoadMyUserInfoComplete:response.success message:response.message];
                    
                    }
            }else{
                    if(ws.delegate && [ws.delegate respondsToSelector:@selector(onLoadMyUserInfoComplete:message:)]){
                            [ws.delegate onLoadMyUserInfoComplete:NO message:response.message];
                    }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

@end
