//
//  MDoctorAppointPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorAppointPresenter.h"
#define kPagesSize 4

@interface MDoctorAppointPresenter ()

@property (nonatomic ,assign)int page;


@end

@implementation MDoctorAppointPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
    }
    return self;
}


-(void)getAppointDoctorData{
    NSInteger userID = kCurrentUser.userId;
    NSDictionary* parames = @{@"UserID":@(userID),@"PageSize":@(kPagesSize),@"PageIndex":@1};
    WS(ws);
    [[FPNetwork POST:API_QUERY_BOOKING_ORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [AppointDoctor mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
}

-(void)refreshAppointDoctorData{
    _page = 1;
    NSInteger userID = kCurrentUser.userId;
    NSDictionary* parames = @{@"UserID":@(userID),@"PageSize":@(kPagesSize),@"PageIndex":@1};
    WS(ws);
    [[FPNetwork POST:API_QUERY_BOOKING_ORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [AppointDoctor mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(refreshOnCompletion:info:)]){
            [ws.delegate refreshOnCompletion:response.success info:response.message];
        }
    }];

}


-(void)loadMoreAppointDoctorData{
    
    _page ++;

    
    NSInteger userID = kCurrentUser.userId;
    NSDictionary* parames = @{@"UserID":@(userID),@"PageSize":@(kPagesSize),@"PageIndex":[NSNumber numberWithInteger:_page]};
    WS(ws);
    [[FPNetwork POST:API_QUERY_BOOKING_ORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray*  array = [AppointDoctor mj_objectArrayWithKeyValuesArray:response.data];
            NSMutableArray* result = [NSMutableArray arrayWithArray:[ws.dataSource copy]];

            if(array.count == 0){
                //没有更多数据了
                ws.noMoreData = YES;
            }else{
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }

            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadMoreOnCompletion:info:)]){
            [ws.delegate loadMoreOnCompletion:response.success info:response.message];
        }
    }];

}


@end
