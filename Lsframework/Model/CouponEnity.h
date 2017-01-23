//
//  CouponEnity.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponEnity : NSObject
/**
 *  {
 "couponID": 1,
 "Money": 20,
 "Describe": "咨询专家优惠券",
 "CouponType": 1,
 "IsClaim": 0
 },

 */

@property (nonatomic, strong) NSNumber *couponID;
@property (nonatomic, assign) NSInteger  Money;
@property (nonatomic, strong) NSString *Describe;
@property (nonatomic, strong) NSNumber *CouponType;
@property (nonatomic, strong) NSNumber *IsClaim;

@end
