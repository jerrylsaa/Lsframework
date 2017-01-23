//
//  FollowUpMainPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FollowUpMainPresenter.h"
#import "FPNetwork.h"
#import "DateEntity.h"
#import "DefaultChildEntity.h"

@implementation FollowUpMainPresenter

- (void)loadFolloeUpHistoryByMonth:(NSInteger) month complete:(DateData)block;{
    
    NSArray *array = [DefaultChildEntity MR_findAll];
    if (array.count == 0) {
        return;
    }
    DefaultChildEntity *entity = array.lastObject;
    NSDictionary *parameters = @{@"babyid":entity.babyID};
    [[FPNetwork POST:API_GET_SCREENNING_RECORD withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            //根据年月日存入数据库
            NSMutableArray *newArray = [NSMutableArray array];
            NSMutableArray *sortArray = [NSMutableArray array];
            NSArray *data = response.data;
            
            for (NSDictionary *dic in data) {
                NSString *dateStr = dic[@"CreateTime"];
                NSRange monthRange = {5,2};
                NSRange dayRange = {8,2};
                NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                [newDic setObject:[dateStr substringToIndex:4] forKey:@"year"];
                [newDic setObject:[dateStr substringWithRange:monthRange] forKey:@"month"];
                [newDic setObject:[dateStr substringWithRange:dayRange] forKey:@"day"];
                [newArray addObject:newDic];
            }
            NSSet *newSet = [NSSet setWithArray:newArray];
            for (NSDictionary *dic in newSet) {
                [sortArray addObject:dic];
            }
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)  {
             [DateEntity mj_objectArrayWithKeyValuesArray:sortArray context:localContext];
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                block(contextDidSave,nil);
            }];
            
        }else{
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}

@end
