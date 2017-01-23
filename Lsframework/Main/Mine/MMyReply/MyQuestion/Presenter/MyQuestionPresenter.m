//
//  MyQuestionPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyQuestionPresenter.h"
#import "FPNetWork.h"
#import "MyReply.h"
#import "MJExtension.h"

@interface MyQuestionPresenter ()



@end

@implementation MyQuestionPresenter

- (instancetype)init{
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
        _pageIndex = 1;
    }
    return self;
}

- (void)loadQuestionData{

    NSDictionary *parameters = @{@"userid":@(kCurrentUser.userId),@"PageIndex":@(_pageIndex),@"PageSize":@10};
    [[FPNetwork POST:API_GET_MY_EXPERT_CONSULTATION_LISTV1 withParams:parameters] addCompleteHandler:^(FPResponse *response) {
//        NSLog(@"---%@",response.data);
        if (response.success == true) {
            NSArray *array = [MyReply mj_objectArrayWithKeyValuesArray:response.data];
            if (_pageIndex == 1) {
                [_dataSource removeAllObjects];
            }
            [_dataSource addObjectsFromArray:array];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataComplete:message:)]) {
                if (response.success == TRUE && [(NSArray *)response.data count] == 0) {
                    [self.delegate loadDataComplete:false message:nil];
                }else{
                    [self.delegate loadDataComplete:true message:nil];
                }
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataComplete:message:)]) {
                [self.delegate loadDataComplete:true message:@"question"];
                }
        }
    }];
}

- (void)loadMoreData{
    _pageIndex ++;
    [self loadQuestionData];
}

@end
