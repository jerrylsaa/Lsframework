//
//  MyAnswerPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyAnswerPresenter.h"
#import "FPNetWork.h"
#import "MyAnserEntity.h"
#import "MJExtension.h"


@implementation MyAnswerPresenter
- (instancetype)init{
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
        _pageIndex = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAnswer) name:@"answer" object:nil];
    }
    return self;
}

- (void)loadMyAnswerData{
    if (_doctorID == nil) {
        _doctorID = @"";
    }
    NSDictionary *parameters = @{@"DoctorID":_doctorID,@"PageIndex":@(_pageIndex),@"PageSize":@10};
    [[FPNetwork POST:API_GET_ExpertConsultationByDoctorID withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == true) {
            NSArray *array = [MyAnserEntity mj_objectArrayWithKeyValuesArray:response.data];
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
    [self loadMyAnswerData];
}

- (void)refreshAnswer{
    _pageIndex = 1;
    [self loadMyAnswerData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answer" object:nil];
}

@end
