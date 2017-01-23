//
//  ConsultationDoctorPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConsultationDoctorPresenter.h"
#import "DefaultChildEntity.h"

@implementation ConsultationDoctorPresenter

-(void)getMyFamilyDoctor{
    DefaultChildEntity * entity = [DefaultChildEntity defaultChild];
    if (entity) {
        WS(ws);
        [[FPNetwork POST:API_QUERY_FAMILY_DOCTOR withParams:@{@"BabyID":entity.babyID}] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                ws.familyDoctors = [FamilyDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
            }
            [_delegate onGetMyFamilyDoctor];
        }];
    }
   
}

@end
