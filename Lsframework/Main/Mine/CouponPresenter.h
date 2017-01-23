//
//  CouponPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "CouponList.h"
@protocol CouponPresenterDelegate <NSObject>
@optional
-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message;


@end

@interface CouponPresenter : BasePresenter

@property(nonatomic,weak) id<CouponPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<CouponList* > * dataSource;



-(void)getCouPonList;

@end
