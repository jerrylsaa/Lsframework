//
//  MDoctorSettingPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DoctorCouponInfo.h"
@protocol MDoctorSettingPresenterDelegate <NSObject>
@optional

-(void)onCompletion:(BOOL)success info:(NSString*)message;
-(void)onGetExpertDoctorCompletion:(BOOL)success info:(NSString*)message;
-(void)onGetExpertConsumptionInfoCompletion:(BOOL)success info:(NSString*)message;


@end
@interface MDoctorSettingPresenter : BasePresenter

@property(nonatomic,weak) id<MDoctorSettingPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<DoctorCouponInfo* >* dataSource;
@property (nonatomic, strong) NSNumber *CouponCount;
@property (nonatomic, strong) NSNumber *CouponTotalMoney;

/**
 *  设置优惠券数量
 *
 *  @param ExpertID <#ExpertID description#>
 *  @param count    <#count description#>
 */
-(void)SetExpertDoctorCouponCountWithExpertID:(NSNumber*)ExpertID  Count:(NSNumber*)count;
/**
 *  设置休假状态
 *
 *  @param ExpertID <#ExpertID description#>
 *  @param count    <#count description#>
 */
-(void)SetExpertDoctorIsVacationWithExpertID:(NSNumber*)ExpertID  IsVacation:(NSNumber*)Vacation;
/**
 *  设置咨询价格
 *
 *  @param ExpertID <#ExpertID description#>
 *  @param count    <#count description#>
 */

-(void)SetExpertDoctorPriceWithExpertID:(NSNumber*)ExpertID  price:(NSNumber*)price;

/**
 *  获取专家休假状态，咨询价格
 *
 *  @param ExpertID <#ExpertID description#>
 */
-(void)GetExpertDoctorIsVacationAndCountWithExpertID:(NSNumber*)ExpertID;


-(void)GetExpertConsumptionInfoWithExpert_ID:(NSNumber*)ExpertID;

@end
