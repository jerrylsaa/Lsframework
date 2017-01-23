//
//  ExpertAnswerEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertAnswerEntity : NSObject

/*
 
 "DoctorID":1,
 "DoctorName":"赵冬梅",
 "ImageUrl":null,
 "Introduce":"济南儿童医院主任医师，山东儿童保健顶尖专家",
 "Domain":"小儿孤独症早期判断，儿童健康发育指导",
 "Status":1,
 "Price":100.12

 
 */

@property(nonatomic,retain) NSNumber* doctorID;
@property(nonatomic,copy) NSString* doctorName;
@property(nonatomic,copy) NSString* doctorTitle;//职称
@property(nonatomic,copy) NSString* imageUrl;
@property(nonatomic,copy) NSString* introduce;
@property(nonatomic,copy) NSString* domain;
@property(nonatomic) NSInteger status;
@property(nonatomic) CGFloat price;
@property(nonatomic) NSInteger hearCount;//提问次数
@property(nonatomic,copy) NSString* Notice;
@property(nonatomic,copy) NSString *HospitalName;
@property(nonatomic,retain) NSNumber* DayUseCouponCount;
@property(nonatomic,retain) NSNumber* IsVacation;
@property(nonatomic,retain) NSNumber* IsDuty;
@property(nonatomic,retain) NSNumber *IsHospital;
@property(nonatomic,retain) NSNumber *HOSPITAL_ID;
@property(nonatomic,retain) NSNumber *consultCount;
@property(nonatomic,retain) NSNumber *anwerCount;
@property(nonatomic,retain) NSNumber *AvgTime;// 提问次数
@end
