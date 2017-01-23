//
//  AppointDoctor.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointDoctor : NSObject

/*
 
 "RowID":1,
 "BespeakTime":"2016-05-06 16:20:00",
 "CHILD_NAME":"靖传淇",
 "UserName":"儿童医院医生",
 "HName":"儿童医院",
 "Dictionary_Name":"主任",
 "UserImg":null,
 "Depart_Name":"内科综合",
 "Field":"1",
 "PatientNum":0,
 "FollowUp":0,
 "StarNum":10,
 "BespeakMode1":null,
 "BespeakMode":0,
 "BespeakAddress":"就诊地址"

 
 */

@property(nonatomic) NSInteger rowID;
@property(nonatomic,retain) NSDate* bespeakTime;//
@property(nonatomic,copy) NSString* childName;
@property(nonatomic,copy) NSString* userName;//
@property(nonatomic,copy) NSString* hName;//医院名字
@property(nonatomic,copy) NSString* dictionaryName;
@property(nonatomic,copy) NSString* userImg;//医生头像
@property(nonatomic,copy) NSString* departName;//
@property(nonatomic,copy) NSString* field;//领域
@property(nonatomic) NSInteger patientNum;
@property(nonatomic) NSInteger followUp;
@property(nonatomic) CGFloat starNum;
@property(nonatomic) NSInteger bespeakMode1;
@property(nonatomic) NSInteger bespeakMode;//预约方式
@property(nonatomic,copy) NSString* bespeakAddress;


/***/
@property(nonatomic,copy) NSString* doctorName;//医生姓名
@property(nonatomic,copy) NSString* appointmentTime;
@property(nonatomic,copy) NSString* hospitalName;
@property(nonatomic,copy) NSString* doctorTitle;
@property(nonatomic,copy) NSString* appointmentDate;
@property(nonatomic,copy) NSString* createTime;









@end
