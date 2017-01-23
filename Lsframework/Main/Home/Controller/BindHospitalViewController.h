//
//  BindHospitalViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "BindHospitalEntity.h"

@interface BindHospitalViewController : BaseViewController
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *expertID;
@property (nonatomic, strong) BindHospitalEntity *hospitalEntity;

@end
