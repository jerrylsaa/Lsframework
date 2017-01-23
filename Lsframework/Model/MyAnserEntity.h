//
//  MyAnserEntity.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAnserEntity : NSObject
/**
 "ConsultationContent": "小孩子怎么带最好呢？",
 "VoiceUrl": null,
 "HearCount": 0,
 "ConsultationStatus": 0,
 "ExpertPrice": 100.12,
 "DoctorName": "赵冬梅",
 "Introduce": "济南儿童医院主任医师，山东儿童保健顶尖专家"
 */
@property(nonatomic,copy) NSString* consultationContent;
@property(nonatomic,copy) NSString* voiceUrl;
@property(nonatomic) NSInteger hearCount;
@property(nonatomic) NSInteger consultationStatus;
@property(nonatomic) CGFloat expertPrice;
@property(nonatomic,copy) NSString* doctorName;
@property(nonatomic,copy) NSString* doctorTitle;
@property(nonatomic,copy) NSString* introduce;
@property(nonatomic,copy) NSString* imageUrl;
@property(nonatomic,copy) NSString* createTime;
@property(nonatomic,copy) NSString* userName;
@property(nonatomic,copy) NSString* uuid;
@property (nonatomic, copy) NSString *Image1;
@property (nonatomic, copy) NSString *Image2;
@property (nonatomic, copy) NSString *Image3;
@property (nonatomic, copy) NSString *Image4;
@property (nonatomic, copy) NSString *Image5;
@property (nonatomic, copy) NSString *Image6;

@property (nonatomic,retain) NSNumber *IsOpenImage;
@property (nonatomic, assign) NSInteger User_ID;
@property (nonatomic, assign) NSInteger Expert_ID;
@property (nonatomic, assign) NSInteger answerType;
@property (nonatomic, assign) NSInteger TraceID;
@property (nonatomic, copy) NSString *WordContent;  //文字补充
@property(nonatomic,copy)NSNumber *VoiceTime; //时间

//


@end
