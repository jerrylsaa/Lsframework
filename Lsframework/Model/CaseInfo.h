//
//  CaseInfo.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//  免费咨询数据model

#import <Foundation/Foundation.h>

@interface CaseInfo : NSObject

@property (nonatomic ,copy) NSString *babyName;

@property (nonatomic ,assign) BOOL isKnowDiseaseName;

@property (nonatomic ,copy) NSString *diseaseName;

@property (nonatomic ,copy) NSString *diseaseInfo;//病情信息

@property (nonatomic ,assign) BOOL isGotoHospital;//去否去过医院

@property (nonatomic ,copy) NSString *bellDate;//患病时间

@property (nonatomic ,assign) int isInspect;//是否检查

@property (nonatomic ,copy) NSString *descriptionDisease;//病情描述

@property (nonatomic ,copy) NSString *descriptionDiseaseAudio;//病情描述语音

@property (nonatomic ,copy) NSString *descriptionDiseaseImage;//病情描述图片

@property (nonatomic ,copy) NSString *drugAndInspect;//药品使用和其他治疗情况

@property (nonatomic ,copy) NSString *drugAndInspectAudio;

@property (nonatomic ,copy) NSString *inspectionData;//检查资料

@property (nonatomic ,copy) NSString *inspectionDataImage;

@property (nonatomic ,assign) int askDepart;

@property (nonatomic, copy) NSString*doctorId;

@property (nonatomic ,assign) BOOL isAskDoctor;

@end
