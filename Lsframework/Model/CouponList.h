//
//  CouponList.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  {
 "ClaimID": 10,
 "UserID": 4,
 "CouponID": 1,
 "Money": 20,
 "Describe": "咨询专家优惠券",
 "CouponType": 1,
 "ClaimStatus": 0,
 "CreateTime": 1471341689
 }
 
 */

@interface CouponList : NSObject
@property (nonatomic, strong) NSNumber *ClaimID;
@property (nonatomic, strong) NSNumber *UserID;
@property (nonatomic, strong) NSNumber *CouponID;
@property (nonatomic, assign) NSInteger  Money;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, strong) NSNumber *CouponType;
@property (nonatomic, strong) NSNumber *ClaimStatus;
@property (nonatomic, strong) NSNumber *CreateTime;

@end
