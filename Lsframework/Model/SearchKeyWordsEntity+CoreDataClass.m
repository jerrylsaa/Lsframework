//
//  SearchKeyWordsEntity+CoreDataClass.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SearchKeyWordsEntity+CoreDataClass.h"

//最多20条
#define kKeyWordNum 20

@implementation SearchKeyWordsEntity

+(void)saveToDataBaseWithKeyWords:(NSString *)keyWord{

    NSArray* dataSource = [SearchKeyWordsEntity findAllKeyWordsEntity];
    
    //只保存最新20个关键词
    if(dataSource.count > kKeyWordNum){
        for(int i = (kKeyWordNum - 1); i < dataSource.count; i++){
            SearchKeyWordsEntity* entity = [dataSource objectAtIndex:i];
            [SearchKeyWordsEntity deleteKeyWords:entity.words];
        }
    }
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        SearchKeyWordsEntity* localEntity = [SearchKeyWordsEntity MR_createEntityInContext:localContext];
        localEntity.words = keyWord;
        
        if(dataSource.count == 0){
            
            localEntity.rowID = [NSNumber numberWithInteger:0];
            
        }else {
            SearchKeyWordsEntity* keyWordsEntity = [dataSource firstObject];
            NSInteger rowID = [keyWordsEntity.rowID integerValue];
            rowID += 1;
            localEntity.rowID = [NSNumber numberWithInteger:rowID];
        }
 
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if(contextDidSave){
            WSLog(@"关键词保存成功");
        }else{
            WSLog(@"关键词保存失败＝%@",error.localizedDescription);
        }

    }];
    
}

+(NSMutableArray<NSString *> *)findAllSerachKeyWords{
    NSArray* array = [SearchKeyWordsEntity findAllKeyWordsEntity];
    
    NSMutableArray* dataSource = [NSMutableArray array];
    
    //最多获取20个关键词
    if(array.count > kKeyWordNum){
        for(int i = 0; i < kKeyWordNum; i++){
            SearchKeyWordsEntity* entity = [array objectAtIndex:i];
            [dataSource addObject:entity.words];
        }
    }else{
        for(SearchKeyWordsEntity* entity in array) {
            [dataSource addObject:entity.words];
        }
    }
    return dataSource;
}

+(BOOL)hasKeyWords{
    return [SearchKeyWordsEntity MR_findAll].count > 0;
}

+(void)deleteKeyWords:(NSString *)keyWords{
   NSArray * array = [SearchKeyWordsEntity MR_findByAttribute:@"words" withValue:keyWords];
   SearchKeyWordsEntity* keyWordsEntity = [array firstObject];
   
    [keyWordsEntity MR_deleteEntity];
    
}

+(BOOL)hasKeyWordsEntity:(NSString *)keyWords{
    NSArray * array = [SearchKeyWordsEntity MR_findByAttribute:@"words" withValue:keyWords];
    return array.count > 0 ;
}

#pragma mark - 私有方法
+ (NSArray<SearchKeyWordsEntity*> *)findAllKeyWordsEntity{
    NSArray* array = [SearchKeyWordsEntity MR_findAll];
    
    NSSortDescriptor* rowID = [NSSortDescriptor sortDescriptorWithKey:@"rowID" ascending:NO];
    
    NSArray* sortArray = [NSArray arrayWithObjects:rowID, nil];
    
    return [array sortedArrayUsingDescriptors:sortArray];
    
}

@end
