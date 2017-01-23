//
//  PatientCaseDetailController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "PatientCaseCell.h"

@interface PatientCaseDetailController : BaseViewController

@property(nullable,nonatomic,retain) NSNumber* admissionRecordID;
@property(nullable,nonatomic,retain) PatientCaseEntity* patientCaseEntity;

@end
