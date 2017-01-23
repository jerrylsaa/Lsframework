//
//  MHealthServicePresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MHSOderDetailEntity.h"
#import "MHealthServiceOderListEntity.h"
#import "MHSOderAddressEntity.h"
#import "WXPayUtil.h"

@protocol MHealthServicePresenterDelegate <NSObject>
@optional
- (void)loadHealthServiceComplete:(BOOL) success message:(NSString* _Nullable) info;
- (void)loadHealthServiceDetailComplete:(BOOL) success message:(NSString* _Nullable) info;
- (void)createHealthServiceOderComplete:(BOOL) success message:(NSString* _Nullable) info;

//获取微信订单状态回调
- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString* _Nullable) message Url:(NSString * _Nullable)url;

- (void)cancelOderComplete:(BOOL) success message:(NSString* _Nullable) info;


@end
@interface MHealthServicePresenter : BasePresenter
@property(nullable,nonatomic,retain) NSArray<MHealthServiceOderListEntity* >* dataSource;

@property(nullable,nonatomic,retain) NSArray<MHSOderDetailEntity* >*detailDataSource;
@property(nullable,nonatomic,retain) NSMutableArray *detailArr;

@property(nullable,nonatomic,retain) MHSOderAddressEntity *addressDataSource;
@property(nullable,nonatomic,retain) NSMutableArray *addressArr;


@property(nullable,nonatomic,weak) id<MHealthServicePresenterDelegate> delegate;

- (void)loadMHealthSerivieOderList;

- (void)getWxPayParamsWithOderID:( NSNumber * _Nonnull )oderID;


- (void)cancelOderWithOderID:(NSNumber *)oderID;
@end
