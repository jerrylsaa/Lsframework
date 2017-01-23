//
//  BSHospitalCheckDetailedInformationViewController.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "HospitalFileList.h"

@interface BSHospitalCheckDetailedInformationViewController : BaseViewController

@property (nonatomic, strong) HospitalFileList *model;

@property (nonatomic, copy  ) NSString         *detailType;

@end
