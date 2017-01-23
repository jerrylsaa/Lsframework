//
//  CouponListPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "CouponList.h"
@protocol CouponListPresenterDelegate <NSObject>
@optional
-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message;

/**
 *  获取的价格后回调
 */
-(void)GetConsultationCouponPriceCompletion:(BOOL)success info:(NSString*)message;
@end

@interface CouponListPresenter : BasePresenter
@property(nonatomic,assign) NSInteger  Status;
@property(nonatomic,assign) float   price;
@property(nonatomic,weak) id<CouponListPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray<CouponList* > * CouponListSource;



-(void)getCouPonList;

-(void)GetConsultationConsumptionCouponPriceWithCouponID:(NSNumber*)coupid  Expert_ID:(NSNumber*)expertID;

@end
