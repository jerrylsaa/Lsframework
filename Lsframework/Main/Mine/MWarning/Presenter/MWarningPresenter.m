//
//  MWarningPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWarningPresenter.h"
@interface MWarningPresenter(){
    NSInteger _page;

}
@end
@implementation MWarningPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
        
    }
    return self;
}

- (void)loadMyWarningList{
    _page = 1;
    
    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_MESSAGEALERTLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            if (response.data!=nil) {
                ws.dataSource = [MWarningEntity mj_objectArrayWithKeyValuesArray:response.data];
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
                [ws.delegate onCompletion:ws.dataSource.count info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];

}
- (void)loadMoreWarningList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_MESSAGEALERTLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [MWarningEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(MoreOnCompletion:info:)]){
            [ws.delegate MoreOnCompletion:response.success info:response.message];
        }
        
    }];
}
@end
