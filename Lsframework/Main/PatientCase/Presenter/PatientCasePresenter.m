//
//  PatientCasePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCasePresenter.h"

@interface PatientCasePresenter (){
    NSInteger index;

}

@end

@implementation PatientCasePresenter

-(instancetype)init{
    self= [super init];
    if(self){
        index = 1;
    }
    return self;
}

-(void)loadPatientCase{
    index = 1;
    
    NSDictionary* parames = @{@"PageIndex":@(index), @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_Get_AdmissionRecordListV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            
            ws.dataSource = [PatientCaseEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            ws.noMoreData = (response.totalCount <= kPageSize);
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadPatientCaseComplete:message:)]){
            [ws.delegate loadPatientCaseComplete:response.success message:response.message];
        }
    }];

}

-(void)loadMorePatientCase{
    index += 1;
    
    NSDictionary* parames = @{@"PageIndex":@(index), @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_Get_AdmissionRecordListV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            
            NSMutableArray* array = [PatientCaseEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(ws.dataSource.count != 0){
                [ws.dataSource addObjectsFromArray:array];
            }else{
                ws.dataSource = array;
            }
            
            if(array.count == 0){
                ws.noMoreData = YES;
            }
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadPatientCaseComplete:message:)]){
            [ws.delegate loadPatientCaseComplete:response.success message:response.message];
        }
        
    }];

}


@end
