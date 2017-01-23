//
//  CaseInfoViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "CaseInfoPresenter.h"
#import "DoctorList.h"


@interface CaseInfoViewController : BaseViewController

@property (nonatomic) CaseInfoType caseInfoType;

@property (nonatomic, copy) NSString * doctorId;

@property(nonatomic,retain) DoctorList* doctor;



@end
