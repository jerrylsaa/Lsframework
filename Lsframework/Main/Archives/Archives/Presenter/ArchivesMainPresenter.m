//
//  ArchivesMainPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ArchivesMainPresenter.h"
#import "MenuEntity.h"

@implementation ArchivesMainPresenter

//入口处的加载
- (void)loadMenuData:(CompleteHander)block{
    //获取菜单字典
//    [MenuEntity MR_truncateAll];
    //获取所有菜单实体，取得所有时间戳，取最大上传
    //首次上传取 2016-01-01 10:00:00 +0000
    NSArray *menuArray = [MenuEntity findAllTimestamp];
    NSString *timeStamp;
    if (menuArray.count > 0) {
//        NSTimeInterval time = [[menuArray firstObject] doubleValue];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        timeStamp = [self formatterDate:date];
        block(YES);
        return;
    }else{
        timeStamp = @"2016-01-01 10:00:00 +0000";
    }
    
    NSDictionary *paratemers = @{@"Timestamp":timeStamp};
    [ProgressUtil showWithStatus:@"菜单加载中..."];
    [[FPNetwork POST:API_PHONE_QUERY_DATA_DICTIONARY withParams:paratemers] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSArray *dataArray = response.data;
            if(dataArray.count != 0){
                //处理不对应的key
                NSMutableArray *newArray = [NSMutableArray array];
                for (NSDictionary *dic in dataArray) {
                    /*
                     createDate = 1452580919;
                     dictionaryName = "\U4e2d\U56fd";
                     menuId = 59;
                     parentId = 18;
                     
                     {"ID":1429,
                     "Dictionary_Name":"尘螨",
                     "Parent_ID":410,
                     "CreateDate":1457512508}
                     
                     */
                    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                    [newDic setObject:[dic objectForKey:@"ID"] forKey:@"menuId"];
                    [newDic setObject:[dic objectForKey:@"Dictionary_Name"] forKey:@"dictionaryName"];
                    [newDic setObject:[dic objectForKey:@"Parent_ID"] forKey:@"parentId"];
                    [newDic setObject:[dic objectForKey:@"CreateDate"] forKey:@"createDate"];
                    [newArray addObject:newDic];
                }
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    [MenuEntity mj_objectArrayWithKeyValuesArray:newArray context:localContext];
                }completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    if (contextDidSave == YES) {
                        block(YES);
                    }else{
                        block(NO);
                    }
                }];
            }else{
                block(NO);
            }
        }else{
            block(NO);
        }
    }];
}

- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    return [formatter stringFromDate:date];
}

@end
