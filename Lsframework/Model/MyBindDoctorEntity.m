//
//  MyBindDoctorEntity.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyBindDoctorEntity.h"

@implementation MyBindDoctorEntity

+(ExpertAnswerEntity *)convertMybindDoctorToExperAnswerEntity:(MyBindDoctorEntity *)bindDoctorEntity
{
    ExpertAnswerEntity *expertEntity = [ExpertAnswerEntity new];
    expertEntity.doctorID = bindDoctorEntity.ID;
    expertEntity.doctorName = bindDoctorEntity.DoctorName;
    expertEntity.doctorTitle = bindDoctorEntity.DoctorTitle;
    expertEntity.imageUrl = bindDoctorEntity.ImageUrl;
    expertEntity.introduce = bindDoctorEntity.Introduce;
    expertEntity.domain = bindDoctorEntity.Domain;
    expertEntity.status = [bindDoctorEntity.Status integerValue];
    //    vc.expertEntity.price = bindDoctorEntity.
    expertEntity.hearCount = [bindDoctorEntity.HearCount integerValue];
    expertEntity.Notice = bindDoctorEntity.Notice;
    expertEntity.HospitalName = bindDoctorEntity.HospitalName;
    //    vc.expertEntity.DayUseCouponCount = bindDoctorEntity.
    //    vc.expertEntity.IsVacation =
    //    vc.expertEntity.IsDuty =
    //    vc.expertEntity.IsHospital = bindDoctorEntity.
    //    vc.expertEntity.HOSPITAL_ID = bindDoctorEntity.
    expertEntity.consultCount = bindDoctorEntity.ConsultationCount;
    expertEntity.anwerCount = bindDoctorEntity.AnswerCount;
    return expertEntity;
}

@end
