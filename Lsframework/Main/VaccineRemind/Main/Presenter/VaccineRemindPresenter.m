//
//  VaccineRemindPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineRemindPresenter.h"

@implementation VaccineRemindPresenter


-(void)loadVaccinePlaneByChildBirth:(NSString *)childBirth{
    
    NSDictionary* parames = @{@"month":childBirth};
    WS(ws);
    [[FPNetwork POST:API_GetVaccinePlane withParams:parames] addCompleteHandler:^(FPResponse *response) {
       
        if(response.success){
            ws.dataSource = [VaccinePlaneEntity mj_objectArrayWithKeyValuesArray:response.data];
            [VaccinePlaneEntity handleDataSource:ws.dataSource];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadVaccinePlaneComplete:info:)]){
            [ws.delegate loadVaccinePlaneComplete:response.success info:response.message];
        }
        
    }];
}

@end
