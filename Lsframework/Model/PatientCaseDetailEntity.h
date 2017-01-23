//
//  PatientCaseDetailEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "PatientCaseEntity.h"

@interface PatientCaseDetailEntity : NSObject

@property(nullable,nonatomic,copy) NSString* departName;
@property(nullable,nonatomic,copy) NSString* diseaseName;
@property(nullable,nonatomic,copy) NSString* admissionSituation;//入院情况
@property(nullable,nonatomic,copy) NSString* admissionDiagnosis;//入院诊断
@property(nullable,nonatomic,copy) NSString* diagnosisTreatment;//诊断经过
@property(nullable,nonatomic,copy) NSString* leaveHospital;//出院情况
@property(nullable,nonatomic,copy) NSString* leaveDiagnosis;//出院诊断
@property(nullable,nonatomic,copy) NSString* treatmentResult;//治疗结果
@property(nullable,nonatomic,copy) NSString* leaveCharge;//出院医嘱

@property(nullable,nonatomic,retain) NSDate* createTime;
@property(nullable,nonatomic,retain) NSNumber* click;
@property(nullable,nonatomic,retain) NSNumber* commentCount;

+(NSMutableArray<NSDictionary*> * _Nullable)formatModelWithArray:(NSMutableArray * _Nullable) dataSource;


@end
