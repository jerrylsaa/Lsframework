//
//  MinePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePresenter.h"
#import "Package.h"
#import "GBChildEntity.h"
#import "DefaultChildEntity.h"
#import "BabayArchList.h"
#import "VaccineEvent.h"

@protocol MinePresenterDelegate <NSObject>

@optional
- (void)onComplete:(BOOL) success info:(NSString*) message;
-(void)onChangeChildAvaterCompleted:(NSString*)path;
-(void)onGetChildInfoComplete:(BOOL)success info:(NSString*)info;

-(void)onGetgetExperIDComplete:(BOOL)success info:(NSString*)message;

- (void)onGetShareCouponNumberComplete:(BOOL)success info:(NSString*)message Coupon:(NSString *)coupon;

/*****/
- (void)loadAllBabyComplete:(BOOL) success info:(NSString* _Nonnull) message;
- (void)loadVaccienComplete:(BOOL) success info:(NSString* _Nonnull) message;

- (void)setDefaultBabyCompletion:(BOOL) success info:(NSString*_Nonnull) info;
- (void)onGetChildinfoCompletion:(BOOL) success info:(NSString*_Nonnull) info;



@end

@interface MinePresenter : BasePresenter

@property(nullable,nonatomic,weak) id<MinePresenterDelegate> delegate;

@property(nullable,nonatomic,retain) NSArray<Package* >* dataSource;

@property (nullable,nonatomic, strong) GBChildEntity * GBchildEntity;

@property(nullable,nonatomic,retain) NSArray<GBChildEntity* >* GBChilSource;

/***/
@property(nullable,nonatomic,retain) NSMutableArray<BabayArchList*> * babyDataSource;
@property(nullable,nonatomic,retain) NSMutableArray<VaccineEvent*> * VaccineSource;

@property(nonatomic)NSInteger responseStatus ;

/**
 *  获取我的医疗服务套餐
 */
- (void)getMyServicePackage;


-(void)changeChildAvaterWithPath:(NSString*)path;




- (void)getExperIDByUserID;

//获取分享优惠券码
- (void)getShareCouponNumber;



/****/

/**
    加载所有宝宝
 */
- (void)loadAllBaby;


/**
    获取疫苗提醒

 @param day <#day description#>
 */
- (void)getVaccineEventWithmonth:(NSString*)Month;

/**
 *  设置默认宝宝
 */
- (void)setDefaultBaby:(BabayArchList*) baby;
-(void)getChildInfo;
@end
