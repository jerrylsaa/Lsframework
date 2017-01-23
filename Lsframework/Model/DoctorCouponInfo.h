//
//  DoctorCouponInfo.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorCouponInfo : NSObject
/**
 *      {
 "DayUseCouponCount": 10,
 "IsVacation": 0
 }

 */
@property (nonatomic, strong) NSNumber *DayUseCouponCount;
@property (nonatomic, strong) NSNumber *IsVacation;
@property (nonatomic, strong) NSNumber *Price;



@end
