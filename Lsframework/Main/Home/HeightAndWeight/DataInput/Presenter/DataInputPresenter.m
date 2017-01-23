//
//  DataInputPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DataInputPresenter.h"
#import "DefaultChildEntity.h"
#import "DataValue.h"

@implementation DataInputPresenter

- (void)GetBabyBodyDataByBabyID:(NSString *)type{
    
    NSNumber *babyid = [DefaultChildEntity defaultChild].babyID;
    [[FPNetwork POST:@"GetBabyBodyDataByBabyID" withParams:@{@"UserID":@(kCurrentUser.userId),@"babyID":babyid,@"type":type}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            _dataArray = [DataValue mj_objectArrayWithKeyValuesArray:response.data];
            _dataDic = [self dealWithArray:_dataArray];
        }
        [self.delegate complete:response.success message:response.message];
    }];
}

- (NSDictionary *)dealWithArray:(NSArray *)array{
    
    NSMutableDictionary *mutiDic = [NSMutableDictionary dictionary];
    DataValue *lastValue;
    NSMutableArray *checkArray = [NSMutableArray array];
    for (DataValue *value in array) {
        if (!lastValue) {
            lastValue = value;
        }else{
            if ([lastValue.Month isEqual:value.Month]) {
                [checkArray removeLastObject];
            }
            lastValue = value;
            
        }
        [checkArray addObject:value];
    }
    for (DataValue *value in checkArray) {
        NSInteger month = [value.Month integerValue];
        NSInteger section = month/12;
        if (section != 0 && month%12 == 0) {
            section --;
        }
        if ([mutiDic objectForKey:[NSNumber numberWithInteger:section]]) {
            NSMutableArray *mutiArray = [NSMutableArray arrayWithArray:(NSArray *)[mutiDic objectForKey:[NSNumber numberWithInteger:section]]];
            [mutiArray addObject:value];
            [mutiDic setObject:mutiArray forKey:[NSNumber numberWithInteger:section]];
        }else{
            NSMutableArray *mutiArray = [NSMutableArray array];
            [mutiArray addObject:value];
            [mutiDic setObject:mutiArray forKey:[NSNumber numberWithInteger:section]];
        }
    }
    return mutiDic;
}


- (void)UpdateBabyBodyData:(NSString *)dataValue id:(NSNumber *)rowId type:(NSString *)type block:(UpdateHandler)block{
    [ProgressUtil show];
    [[FPNetwork POST:UPDATE_BABY_BODY_DATA withParams:@{@"ID":rowId,@"babyID":[DefaultChildEntity defaultChild].babyID,@"type":type,@"dataValue":dataValue}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            [ProgressUtil dismiss];
            block(YES);
        }else{
            [ProgressUtil showError:@"修改失败"];
        }
    }];
}

- (void)InsertBabyBodyDataMonth:(NSString *)dataValue type:(NSString *)type month:(NSString *)month block:(UpdateHandler)block{
    [ProgressUtil show];
    [[FPNetwork POST:INSERT_BABY_BODY_DATA_MONTH withParams:@{@"UserID":@(kCurrentUser.userId),@"month":month,@"babyID":[DefaultChildEntity defaultChild].babyID,@"type":type,@"data":dataValue}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            [ProgressUtil dismiss];
            if ([response.data boolValue] == YES) {
                block(YES);
            }else{
                [ProgressUtil showError:@"修改失败"];
            }
        }else{
            [ProgressUtil showError:@"修改失败"];
        }
    }];
}



@end
