//
//  TreatMentRecordPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TreatMentRecordPresenter.h"
#import "DefaultChildEntity.h"

@implementation TreatMentRecordPresenter

-(void)getTreatMentRecord{
    NSInteger babyID = [[DefaultChildEntity defaultChild].babyID integerValue];
    babyID = 363;//测试
    
    NSDictionary* parames = @{@"BabyID":@(babyID)};
    
    WS(ws);
    [[FPNetwork POST:API_QUERY_SEEING_DOCTORRECORD withParams:parames] addCompleteHandler:^(FPResponse *response) {
       
        if(response.success){
            ws.dataSource = [FDAppointManagerEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
    
}

@end
