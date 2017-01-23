//
//  ConsultationDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "FamilyDoctorEntity.h"

@protocol ConsultationDoctorPresenterDelegate <NSObject>

-(void)onGetMyFamilyDoctor;

@end

@interface ConsultationDoctorPresenter : BasePresenter

@property (weak, nonatomic) id<ConsultationDoctorPresenterDelegate>delegate;

@property (strong, nonatomic)NSMutableArray<FamilyDoctorEntity*> * familyDoctors;

-(void)getMyFamilyDoctor;

@end
