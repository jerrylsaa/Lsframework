//
//  MyBindDoctorEntity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertAnswerEntity.h"


@interface MyBindDoctorEntity : NSObject
@property (nonatomic,retain) NSNumber *ID;
@property (nonatomic,retain) NSNumber *Status;
@property (nonatomic,retain) NSNumber *IsDelete;
@property (nonatomic,retain) NSNumber *HearCount;
@property (nonatomic,retain) NSNumber *Sort;
@property (nonatomic,retain) NSNumber *AnswerCount;
@property (nonatomic,retain) NSNumber *ConsultationCount;

@property (nonatomic,copy) NSString *DoctorName;
@property (nonatomic,copy) NSString *ImageUrl;
@property (nonatomic,copy) NSString *Domain;
@property (nonatomic,copy) NSString *DoctorTitle;
@property (nonatomic,copy) NSString *Notice;
@property (nonatomic,copy) NSString *HospitalName;
@property (nonatomic,copy) NSString *DepartName;
@property (nonatomic,copy) NSString *Introduce;

+(ExpertAnswerEntity *)convertMybindDoctorToExperAnswerEntity:(MyBindDoctorEntity*)bindDoctorEntity;

@end
