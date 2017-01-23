//
//  DetailQuestion.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailQuestion : NSObject

@property (nonatomic, assign) NSInteger IsFree;
@property (nonatomic, assign) NSInteger IsListen;
@property (nonatomic, assign) NSInteger uuiD;
@property (nonatomic, assign) NSInteger User_ID;
@property (nonatomic, assign) NSInteger Expert_ID;
@property (nonatomic, copy) NSString *ConsultationContent;
@property (nonatomic, copy) NSString *VoiceUrl;
@property (nonatomic, assign) NSInteger HearCount;
@property (nonatomic, assign) NSInteger ConsultationStatus;
@property (nonatomic, assign) float ExpertPrice;
@property (nonatomic, assign) NSInteger IsTop;
@property (nonatomic, copy) NSString *CreateUser;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *ImageUrl;
@property (nonatomic, assign) NSInteger VoiceTime;
@property (nonatomic, copy) NSString *Image1;
@property (nonatomic, copy) NSString *Image2;
@property (nonatomic, copy) NSString *Image3;
@property (nonatomic, copy) NSString *Image4;
@property (nonatomic, copy) NSString *Image5;
@property (nonatomic, copy) NSString *Image6;
@property (nonatomic, assign) BOOL IsOpenImage;
@property (nonatomic, assign) NSInteger IsUrgent;
@property (nonatomic, assign) NSInteger PraiseCount;
@property (nonatomic, assign) NSInteger isPraise;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *UserImg;
@property (nonatomic, copy) NSString *WordContent;
@property (nonatomic, copy) NSString *DoctorTitle;
@property (nonatomic, copy) NSString *HospitalName;
@property (nonatomic, copy) NSString *DepartName;
@property (nonatomic, copy) NSString *Domain;
@property (nonatomic, copy) NSString *DoctorName;
@property (nonatomic, copy) NSNumber *OutTime;
@end
