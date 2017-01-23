//
//  VaccineRemindInfoPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineRemindInfoPresenter.h"
#import "VaccineDetail.h"

@implementation VaccineRemindInfoPresenter


- (void)GetVaccineDetailByID:(NSString *)vaccineID complete:(LoadHandel)block{
    [[FPNetwork POST:@"GetVaccineDetailByID" withParams:@{@"VaccineID":vaccineID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            if (((NSArray *)response.data).count > 0) {
                NSArray *array = [self dealWithArray:response.data];
                _dataSource = [VaccineDetail mj_objectArrayWithKeyValuesArray:array];
                block(YES);
            }else{
                [ProgressUtil showInfo:@"暂时没有相关数据"];
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

- (NSArray *)dealWithArray:(NSArray *)array{
    NSMutableArray *newArray = [NSMutableArray array];
    NSArray *titleArray = @[@"接种效果",@"接种部位",@"接种禁忌",@"不良反应"];
    NSArray *valueArray = @[@"Effect",@"Part",@"Contraindication",@"UnEffect"];
    NSDictionary *subDic = [NSDictionary dictionaryWithDictionary:array.firstObject];
    _titleText = subDic[@"VaccineName"];
    for (int i = 0; i < titleArray.count; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:titleArray[i] forKey:@"titleText"];
        NSString *text = subDic[valueArray[i]];
        [dic setObject:[text stringByReplacingOccurrencesOfString:@"\\n" withString:@""] forKey:@"detailText"];
        [newArray addObject:dic];
    }
    return newArray;
}
/*
 "Data":[
 {
 "VaccineName":"这是一个疫苗1",
 "Effect":"效果",
 "Part":"部位",
 "Contraindication":"禁忌",
 "UnEffect":"不良反应"
 }
 ]
 */
@end
