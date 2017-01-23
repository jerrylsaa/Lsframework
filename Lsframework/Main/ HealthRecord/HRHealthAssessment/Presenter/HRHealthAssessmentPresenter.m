//
//  HRHealthAssessmentPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HRHealthAssessmentPresenter.h"
#define kHRPageSize 20

@implementation HRHealthAssessmentPresenter

- (void)loadAssessment:(LoadHandler)block{
    
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    DefaultChildEntity *entity = entityArray.lastObject;
    if ([entity.babyID intValue] == 0) {
        block(NO,@"O_o");
    }else{
        [[FPNetwork POST:API_GET_CHILD_SCREENING withParams:@{@"userid":entity.babyID}] addCompleteHandler:^(FPResponse *response) {
            if (response.success == YES) {
                if (response.data == nil || ((NSArray *)response.data).count == 0) {
                    block(NO,@"无报告");
                }else{
                self.dataSource = [Screening mj_objectArrayWithKeyValuesArray:response.data];
                }
            }
            block(response.success,response.message);
        }];
    }
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
