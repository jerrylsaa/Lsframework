//
//  MyReply.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
/*
 {
 RowID": 1,
 "uuiD": 4,
 "User_ID": 105,
 "Expert_ID": 1,
 "ConsultationContent": "小孩子怎么带最好呢？",
 "VoiceUrl": null,
 "HearCount": 0,
 "ConsultationStatus": 0,
 "ExpertPrice": 9,
 "IsTop": 0,
 "CreateUser": "105",
 "CreateTime": "2016-06-22 20:36:54",
 "DoctorName": "赵冬梅",
 "Introduce": "济南儿童医院主任医师，山东儿童保健顶尖专家",
 "ImageUrl": "http://etjk360.dzjk.com/attach_upload/Pic/fengbing.png" }
 */

#import <Foundation/Foundation.h>

@interface MyReply : NSObject

@property (nonatomic, strong) NSNumber *RowID;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *User_ID;
@property (nonatomic, strong) NSNumber *Expert_ID;
@property (nonatomic, copy) NSString *ConsultationContent;
@property (nonatomic, copy) NSString *VoiceUrl;
@property (nonatomic, strong) NSNumber *HearCount;
@property (nonatomic, strong) NSNumber *ConsultationStatus;
@property (nonatomic, strong) NSNumber *ExpertPrice;
@property (nonatomic, strong) NSNumber *IsTop;
@property (nonatomic, copy) NSString *CreateUser;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *DoctorName;
@property (nonatomic, copy) NSString *Introduce;
@property (nonatomic, copy) NSString *ImageUrl;
@property (nonatomic, assign) long VoiceTime;
@property (nonatomic, copy) NSString *Image1;
@property (nonatomic, copy) NSString *Image2;
@property (nonatomic, copy) NSString *Image3;
@property (nonatomic, copy) NSString *Image4;
@property (nonatomic, copy) NSString *Image5;
@property (nonatomic, copy) NSString *Image6;

@property (nonatomic,retain) NSNumber *IsOpenImage;
@property (nonatomic, copy) NSString *DoctorTitle;
@property (nonatomic, copy) NSString *HospitalName;
@property (nonatomic, copy) NSString *DepartName;
@property (nonatomic, copy) NSString *Domain;


@end
