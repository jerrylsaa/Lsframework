//
//  RelatedAnswerEntity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelatedAnswerEntity : NSObject
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,strong) NSNumber *isAnser;
@property (nonatomic,strong) NSNumber *uuid;
@property (nonatomic,strong) NSNumber *TraceID;
@property (nonatomic,copy) NSString *ConsultationContent;
@property (nonatomic,copy) NSString *VoiceUrl;
@property (nonatomic,strong) NSNumber *HearCount;
@property (nonatomic,strong) NSNumber *ConsultationStatus;
@property (nonatomic,strong) NSNumber *ExpertPrice;
@property (nonatomic,copy) NSString *DoctorName;
@property (nonatomic,copy) NSString *Introduce;
@property (nonatomic,copy) NSString *ImageUrl;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,strong) NSNumber *VoiceTime;
@property (nonatomic,copy) NSString *Image1;
@property (nonatomic,copy) NSString *Image2;
@property (nonatomic,copy) NSString *Image3;
@property (nonatomic,copy) NSString *Image4;
@property (nonatomic,copy) NSString *Image5;
@property (nonatomic,copy) NSString *Image6;

@property (nonatomic,strong) NSNumber *IsOpenImage;
@property (nonatomic,copy) NSString *WordContent;
@property (nonatomic,assign) NSInteger traceNO;
@property (nonatomic,copy) NSString *UserImage;
@end
