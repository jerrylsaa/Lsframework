//
//  PatientCaseDetailEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseDetailEntity.h"

@implementation PatientCaseDetailEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    return [propertyName mj_firstCharUpper];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class] && ![oldValue isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}

+(NSMutableArray<NSDictionary *> *)formatModelWithArray:(NSMutableArray *)dataSource{

    //        _titleDataSource = @[@"入院情况",@"入院诊断",@"诊疗经过",@"出院情况",@"出院诊断",@"治疗结果",@"出院医嘱"];

    PatientCaseDetailEntity* entity = [dataSource firstObject];
    
    
    //入院情况
    NSString* admissionSituation = entity.admissionSituation;
    if(!admissionSituation.length || admissionSituation.length == 0){
        admissionSituation = @"";
    }
    NSDictionary* dic1 = @{@"title":@"入院情况", @"content":admissionSituation};
    
    //入院诊断
    NSString* admissionDiagnosis = entity.admissionDiagnosis;
    if(!admissionDiagnosis.length || admissionDiagnosis.length == 0){
        admissionDiagnosis = @"";
    }
    NSDictionary* dic2 = @{@"title":@"入院诊断", @"content":admissionDiagnosis};

    //诊疗经过
    NSString* diagnosisTreatment = entity.diagnosisTreatment;
    if(!diagnosisTreatment.length || diagnosisTreatment.length == 0){
        admissionDiagnosis = @"";
    }
    NSDictionary* dic3 = @{@"title":@"诊疗经过", @"content":diagnosisTreatment};
    
    //出院情况
    NSString* leaveHospital = entity.leaveHospital;
    if(!leaveHospital.length || leaveHospital.length == 0){
        leaveHospital = @"";
    }
    NSDictionary* dic4 = @{@"title":@"出院情况", @"content":leaveHospital};
    
    //出院诊断
    NSString* leaveDiagnosis = entity.leaveDiagnosis;
    if(!leaveDiagnosis.length || leaveDiagnosis.length == 0){
        leaveDiagnosis = @"";
    }
    NSDictionary* dic5 = @{@"title":@"出院诊断", @"content":leaveDiagnosis};
    
    //治疗结果
    NSString* treatmentResult = entity.treatmentResult;
    if(!treatmentResult.length || treatmentResult.length == 0){
        treatmentResult = @"";
    }
    NSDictionary* dic6 = @{@"title":@"治疗结果", @"content":treatmentResult};
    
    //出院医嘱
    NSString* leaveCharge = entity.leaveCharge;
    if(!leaveCharge.length || leaveCharge.length == 0){
        leaveCharge = @"";
    }
    NSDictionary* dic7 = @{@"title":@"出院医嘱", @"content":leaveCharge};
    
    
    return [NSMutableArray arrayWithArray:@[dic1,dic2,dic3,dic4,dic5,dic6,dic7]];
}


@end
