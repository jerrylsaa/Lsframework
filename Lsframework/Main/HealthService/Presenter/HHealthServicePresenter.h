//
//  HHealthServicePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "HealthServiceProduct.h"
#import "HealthServiceDetailData.h"
#import "HealthServiceDetailAttributes.h"
#import "HealthServiceDetailStocks.h"
#import "MHealthServiceOderListEntity.h"
#import "MHSOderAddressEntity.h"
@protocol HHealthServicePresenterDelegate <NSObject>
@optional
- (void)loadHealthServiceComplete:(BOOL) success message:(NSString* _Nullable) info;
- (void)loadHealthServiceDetailComplete:(BOOL) success message:(NSString* _Nullable) info;
- (void)createHealthServiceOderComplete:(BOOL) success message:(NSString* _Nullable) info;
- (void)onLoadMyUserInfoComplete:(BOOL) success message:(NSString* _Nullable) info;


@end


@interface HHealthServicePresenter : BasePresenter

@property(nullable,nonatomic,retain) NSArray<HealthServiceProduct* >* dataSource;

@property(nullable,nonatomic,retain) HealthServiceDetailData *detailDataSource;

@property(nullable,nonatomic,retain) NSArray<HealthServiceDetailAttributes* >* attributesDataSource;

@property(nullable,nonatomic,retain) NSArray<HealthServiceDetailStocks* >* stocksDataSource;


@property(nullable,nonatomic,retain) MHealthServiceOderListEntity *oderDetailDataSource;

@property(nullable,nonatomic,retain) MHSOderAddressEntity *oderAddressDataSource;


@property(nullable,nonatomic,weak) id<HHealthServicePresenterDelegate> delegate;


@property(nullable,nonatomic,retain) MHSOderAddressEntity *myUserInfoAddress;


- (void)loadHealthService;


- (void)loadHealthServiceDetail:(NSNumber * _Nonnull)goodID;


- (void)createGoodsOrderWithName:(NSString *_Nonnull)name Phone:(NSString *_Nonnull)phone Address:(NSString *_Nonnull)address Email:(NSString *_Nullable)email StocksID:(NSNumber *_Nonnull)stocksID StocksNum:(NSNumber *_Nonnull)stocksNum;


- (void)loadMyUserInfo;

@end
