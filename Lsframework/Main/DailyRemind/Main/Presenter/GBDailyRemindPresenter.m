//
//  GBDailyRemindPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBDailyRemindPresenter.h"

@interface GBDailyRemindPresenter (){
    NSInteger index;
    NSInteger remindDay;
}

@end

@implementation GBDailyRemindPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        index = 1;
    }
    return self;
}


-(void)loadDailyRemindWithDay:(NSInteger)day{
    index = 1;
    remindDay = day;
    
    NSDictionary* parames = @{@"RemindDay":@(day), @"PageIndex":@(index), @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_Get_Daily_Remind withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            NSLog(@"%@",response.data);
            ws.dataSource = [DailyRemindEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            ws.noMoreData = (response.totalCount <= kPageSize);
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadDailyRemindComplete:message:)]){
            [ws.delegate loadDailyRemindComplete:response.success message:response.message];
        }
    }];
    
}

-(void)loadMoreDailyRemind{
    index += 1;
    
    if(remindDay < 1){
        remindDay = 1;
    }
    
    NSDictionary* parames = @{@"RemindDay":@(remindDay), @"PageIndex":@(index), @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_Get_Daily_Remind withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            
            NSMutableArray* array = [DailyRemindEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(ws.dataSource.count != 0){
                [ws.dataSource addObjectsFromArray:array];
            }else{
                ws.dataSource = array;
            }
            
            
            ws.noMoreData = (response.totalCount <= kPageSize);
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadDailyRemindComplete:message:)]){
            [ws.delegate loadDailyRemindComplete:response.success message:response.message];
        }
    }];

}

@end
