//
//  MyListenPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyListenPresenter.h"
#import "MyListen.h"

@implementation MyListenPresenter

- (instancetype)init{
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
        _pageIndex = 1;
    }
    return self;
}

- (void)loadListenData:(MyListenComplete)block{
    
    NSDictionary *parameters = @{@"User_ID":@(kCurrentUser.userId),@"PageIndex":@(_pageIndex),@"PageSize":@10};
   
    [[FPNetwork POST:API_QUERY_LISTEN_QUESTIONV1 withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == true) {
            if (response.data != nil && [(NSArray *)response.data count] == 0) {
                block(FALSE,nil);
            }else{
                NSArray *array = [MyListen mj_objectArrayWithKeyValuesArray:response.data];
                if (_pageIndex == 1) {
                    [_dataSource removeAllObjects];
                }
                [_dataSource addObjectsFromArray:array];
                block(TRUE,response.message);
            }
        }else{
            block(FALSE,@"listen");
        }
    }];
}

- (void)loadMoreData:(MyListenComplete)block{
    _pageIndex ++;
    [self loadListenData:^(BOOL success, NSString *message) {
        block(success,message);
        
    }];
}


@end
