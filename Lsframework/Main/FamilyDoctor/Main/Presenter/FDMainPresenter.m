//
//  FDMainPresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDMainPresenter.h"
#import "DefaultChildEntity.h"

@implementation FDMainPresenter

- (void)getFamilyDoctor{
    
    if(![DefaultChildEntity defaultChild].babyID){
        self.hasFamilyDoctor = NO;
        [self.delegate onCompletion:YES info:nil];
        return ;
    }
    
    
    NSInteger babyID = [[DefaultChildEntity defaultChild].babyID integerValue];
    
    NSDictionary* parames = @{@"BabyID":@(babyID)};
    WS(ws);
    [[FPNetwork POST:API_QUERY_FAMILY_DOCTOR withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [FamilyDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
            if(ws.dataSource.count !=0 ){
                ws.hasFamilyDoctor = YES;
            }
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
}

@end
