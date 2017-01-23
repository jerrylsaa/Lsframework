//
//  FDAppointManagerEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 "id":4,
 "BespeakTime":"16:20:00",
 "BespeakDate":"2016-05-04",
 "BespeakLinkPhone":null,
 "BespeakAddress":"就诊地址",
 "UserName":"曹操",
 "HospitalName":"儿童医院",
 "Depart_Name":"内科综合",
 "Position":"主任",
 "AcademicTitle":"主任医师",
 "Field":null,
 "UserImg":null,
 "BespeakType":"普通门诊",
 "BespeakTime1":1462350000,
 "DoctorName":"儿童医院医生",
 "BespeakMode":null,
 
 */
@interface FDAppointManagerEntity : NSObject

@property(nonatomic) NSInteger keyID;
@property(nonatomic,copy) NSString* bespeakTime;
@property(nonatomic,copy) NSString* bespeakDate;
@property(nonatomic,copy) NSString* bespeakLinkPhone;
@property(nonatomic,copy) NSString* bespeakAddress;
@property(nonatomic,copy) NSString* userName;
@property(nonatomic,copy) NSString* hospitalName;
@property(nonatomic,copy) NSString* departName;
@property(nonatomic,copy) NSString* position;
@property(nonatomic,copy) NSString* academicTitle;
@property(nonatomic,copy) NSString* field;
@property(nonatomic,copy) NSString* userImg;
@property(nonatomic,copy) NSString* bespeakType;
@property(nonatomic,retain) NSDate* bespeakDateTime;
@property(nonatomic,copy) NSString* doctorName;
@property(nonatomic) NSInteger bespeakMode;
@property(nonatomic) NSInteger isAlreadySeeingTheDoctor;


/** 新增字段*/
@property(nonatomic,copy) NSString* profession;
@property(nonatomic,retain) NSString* depart;//科室

@end
