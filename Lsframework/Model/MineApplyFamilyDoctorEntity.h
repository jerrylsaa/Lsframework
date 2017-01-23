//
//  MineApplyFamilyDoctorEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineApplyFamilyDoctorEntity : NSObject

@property (nullable, nonatomic, retain) NSDate *applyTime;
@property (nullable, nonatomic, retain) NSString *babyName;//在线申请患者姓名
@property (nullable, nonatomic, retain) NSString *departName;
@property (nullable, nonatomic, retain) NSString *doctorName;
@property (nullable, nonatomic, retain) NSString *duties;
@property (nullable, nonatomic, retain) NSString *field;
@property (nullable, nonatomic, retain) NSString *hName;
@property (nullable, nonatomic, retain) NSNumber *orderState;
@property (nullable, nonatomic, retain) NSDate *paymentTime;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *toExamineTime;
@property (nullable, nonatomic, retain) NSString *userImg;
@property (nullable, nonatomic, retain) NSString *userName;

@property (nullable, nonatomic, retain) NSNumber *actualPrice;//套餐价格

@property(nonatomic) NSInteger starNum;//
@property(nonatomic) NSInteger patientNum;//
@property(nonatomic) NSInteger followUp;//




@property (nullable, nonatomic, retain) NSString *fdBabyName;
@property(nonatomic) NSInteger fdprice;//家庭医生套餐价格

@property(nullable,nonatomic,copy) NSString* chargeStandard;//在线申请价格套餐


@end
