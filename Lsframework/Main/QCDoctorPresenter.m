//
//  QCDoctorPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "QCDoctorPresenter.h"

#define kPageSize 30

@interface QCDoctorPresenter (){
    int pageIndex;
    
}

@end

@implementation QCDoctorPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        pageIndex=1;
    }
    return self;
}


-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

-(void)requestData{
    NSDictionary* params = @{@"Province":@"", @"City":@"", @"Hospital":@"", @"Department":@"", @"PageIndex":@1, @"PageSize":@(kPageSize)};
    
    WS(ws);
    __block BOOL success = YES;
    [[FPNetwork POST:API_PHONE_QueryDoctor withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray* dataArray = response.data;
            for(NSDictionary* dic in dataArray){
                DoctorList* doctor = [DoctorList mj_objectWithKeyValues:dic];
                [ws.dataSource addObject:doctor];
            }
        }else{
            success = NO;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(clickQCDoctorListOnCompletion:info:)]){
            [ws.delegate clickQCDoctorListOnCompletion:success info:response.message];
        }
    }];

}


-(void)refreshData{
    pageIndex = 1;
    NSDictionary* params = @{@"Province":@"", @"City":@"", @"Hospital":@"", @"Department":@"", @"PageIndex":@1, @"PageSize":@(kPageSize)};
    
    WS(ws);
    __block BOOL success = YES;
    [self.dataSource removeAllObjects];
    
    [[FPNetwork POST:API_PHONE_QueryDoctor withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray* dataArray = response.data;
            for(NSDictionary* dic in dataArray){
                DoctorList* doctor = [DoctorList mj_objectWithKeyValues:dic];
                [ws.dataSource addObject:doctor];
            }
        }else{
            success = NO;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(refreshDataOnCompletion:info:)]){
            [ws.delegate refreshDataOnCompletion:success info:response.message];
        }
    }];
}

-(void)loadMoreData{
    ++pageIndex;
    NSDictionary* params = @{@"Province":@"", @"City":@"", @"Hospital":@"", @"Department":@"", @"PageIndex":@(pageIndex), @"PageSize":@(kPageSize)};
    
    WS(ws);
    __block BOOL success = YES;
    __block BOOL moreData = YES;
    [[FPNetwork POST:API_PHONE_QueryDoctor withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray* dataArray = response.data;
            if(dataArray.count !=0){
                for(NSDictionary* dic in dataArray){
                    DoctorList* doctor = [DoctorList mj_objectWithKeyValues:dic];
                    [ws.dataSource addObject:doctor];
                }
             }else{
                moreData = NO;
            }
        }else{
            success = NO;
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadMoreDataOnCompletion:hasMoreData:info:)]){
            [ws.delegate loadMoreDataOnCompletion:success hasMoreData:moreData info:response.message];
        }
    }];

}



@end
