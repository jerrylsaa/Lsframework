//
//  SplashPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SplashPresenter.h"

#import "NationEntity.h"
#import "NationalityEntity.h"
#import "ProvinceEntity.h"
#import "CityEntity.h"
#import "MenuEntity.h"
#import "HospitalEntity.h"
#import "DepartmentEntity.h"
#import "DateEntity.h"


@implementation SplashPresenter

-(void)initCommonData{
    [DateEntity MR_truncateAll];
    
    //将省市导入数据库
    if([[CityEntity findAll] count] == 0){
        [CityEntity saveCityToDatabase];
    }
    if([[ProvinceEntity findAll] count] == 0){
        [ProvinceEntity saveProvinceToDatabase];
    }
    
    self.request = [DataTaskManager new];
    NSMutableArray* requestArray = [NSMutableArray array];
    __weak typeof(self.request) weakSync = self.request;
    
    
    //获取菜单字典
//    [MenuEntity MR_truncateAll];
    //获取所有菜单实体，取得所有时间戳，取最大上传
    //首次上传取 2016-01-01 10:00:00 +0000
    NSArray *menuArray = [MenuEntity findAllTimestamp];
    NSString *timeStamp;
    if (menuArray.count > 0) {
        NSTimeInterval time = [[menuArray firstObject] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        timeStamp = [self formatterDate:date];
    }else{
        timeStamp = @"2016-01-01 10:00:00 +0000";
    }
    
    NSDictionary *paratemers = @{@"Timestamp":timeStamp};
    WS(ws);
    
    FPNetwork* menun = [[FPNetwork POST:API_PHONE_QUERY_DATA_DICTIONARY withParams:paratemers] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
       
        [weakSync countDown];
        
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
//            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//                [MenuEntity mj_objectArrayWithKeyValuesArray:newArray context:localContext];
//            }];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onInitCommonDataComplete)]){
            [ws.delegate onInitCommonDataComplete];
        }
    }];
    [requestArray addObject:menun];
    
    
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    FPNetwork* configue = [[FPNetwork POST:API_GET_CONFIGURES withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        [weakSync countDown];
        NSArray* configureArray = nil;
        if(response.success){
            NSArray* array = response.data;
            
            if(array.count != 0){
                if([ConfiguresEntity isHasConfiguresEntity]){
                    [ConfiguresEntity deleteConfiguresEntity];
                }
                configureArray = array;
                
            }else{
                //添加默认配置
                configureArray = [ConfiguresEntity importDefaultConfigure];
            }
        }else{
            //门诊预约和专家咨询配置添加默认值
            configureArray = [ConfiguresEntity importDefaultConfigure];
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            [ConfiguresEntity mj_objectArrayWithKeyValuesArray:configureArray context:localContext];
        }];

        
    }];
    [requestArray addObject:configue];
    
    [self.request requestWithDataTasks:requestArray withComplete:^{
    }];
    
    
    
//    [[FPNetwork POST:API_PHONE_QUERY_DATA_DICTIONARY withParams:paratemers] addCompleteHandler:^(FPResponse *response) {
//        NSArray *dataArray = response.data;
//        if(dataArray.count != 0){
//            //处理不对应的key
//            NSMutableArray *newArray = [NSMutableArray array];
//            for (NSDictionary *dic in dataArray) {
//                /*
//                 createDate = 1452580919;
//                 dictionaryName = "\U4e2d\U56fd";
//                 menuId = 59;
//                 parentId = 18;
//                 
//                 {"ID":1429,
//                 "Dictionary_Name":"尘螨",
//                 "Parent_ID":410,
//                 "CreateDate":1457512508}
//                 
//                 */
//                NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
//                [newDic setObject:[dic objectForKey:@"ID"] forKey:@"menuId"];
//                [newDic setObject:[dic objectForKey:@"Dictionary_Name"] forKey:@"dictionaryName"];
//                [newDic setObject:[dic objectForKey:@"Parent_ID"] forKey:@"parentId"];
//                [newDic setObject:[dic objectForKey:@"CreateDate"] forKey:@"createDate"];
//                [newArray addObject:newDic];
//            }
//            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//                [MenuEntity mj_objectArrayWithKeyValuesArray:newArray context:localContext];
//            }];
//        }
//        
//        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onInitCommonDataComplete)]){
//            [ws.delegate onInitCommonDataComplete];
//        }
//    }];
}


- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    return [formatter stringFromDate:date];
}


@end
