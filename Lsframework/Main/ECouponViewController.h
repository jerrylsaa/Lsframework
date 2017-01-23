//
//  ECouponViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol ECouponViewControllerDelegate <NSObject>
-(void)GetCouponID:(NSNumber*)couPID;

-(void)wxPayByUseCouponID:(NSNumber *)couponId ;

-(void)payFreeByCouponID:(NSNumber*)couPID;

@end

@interface ECouponViewController : BaseViewController
@property  (nonatomic,weak)id<ECouponViewControllerDelegate>  delegate;
@property (nonatomic,strong)NSNumber *doctorID;

@end
