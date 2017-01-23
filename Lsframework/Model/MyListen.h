//
//  MyListen.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
/*
 {
 "RowID": 1,
 "ListenID": 2,
 "Expert_ID": 1,
 "ConsultationID": 3,
 "User_ID": 11,
 "ConsultationContent": "如何看到好大夫",
 "VoiceUrl": null,
 "HearCount": 0,
 "ConsultationStatus": 0,
 "ExpertPrice": 9,
 "DoctorName": "赵冬梅",
 "Introduce": "济南儿童医院主任医师，山东儿童保健顶尖专家",
 "CreateTime": null,
 "ImageUrl": "http://etjk360.dzjk.com/attach_upload/Pic/fengbing.png"
 }
 */

#import <Foundation/Foundation.h>

@interface MyListen : NSObject


@property (nonatomic ,strong) NSNumber *ListenID;
@property (nonatomic ,strong) NSNumber *Expert_ID;
@property (nonatomic ,strong) NSNumber *ConsultationID;
@property (nonatomic ,strong) NSNumber *User_ID;
@property (nonatomic ,copy) NSString *ConsultationContent;
@property (nonatomic ,copy) NSString *VoiceUrl;
@property (nonatomic ,strong) NSNumber *HearCount;
@property (nonatomic ,strong) NSNumber *ConsultationStatus;
@property (nonatomic ,strong) NSNumber *ExpertPrice;
@property (nonatomic ,copy) NSString *DoctorName;
@property (nonatomic ,copy) NSString *Introduce;
@property (nonatomic ,copy) NSString *CreateTime;
@property (nonatomic ,copy) NSString *ImageUrl;
@property (nonatomic ,assign) long VoiceTime;
@property (nonatomic, copy) NSString *Image1;
@property (nonatomic, copy) NSString *Image2;
@property (nonatomic, copy) NSString *Image3;
@property (nonatomic,retain) NSNumber *IsOpenImage;


@end
