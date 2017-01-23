//
//  SearchKeyWordsEntity+CoreDataClass.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchKeyWordsEntity : NSManagedObject


/**
 保存关键字到本地数据库

 @param keyWord <#keyWord description#>
 */
+ (void)saveToDataBaseWithKeyWords:(NSString* _Nonnull) keyWord;


/**
 获取所有关键词

 @return <#return value description#>
 */
+ (NSMutableArray<NSString* >*)findAllSerachKeyWords;


/**
 是否有关键词

 @return <#return value description#>
 */
+(BOOL)hasKeyWords;


/**
 删除关键词

 @param keyWords <#keyWords description#>
 */
+(void)deleteKeyWords:(NSString* _Nonnull) keyWords;


/**
 是否有某个关键词

 @param keyWords <#keyWords description#>

 @return <#return value description#>
 */
+(BOOL)hasKeyWordsEntity:(NSString* _Nonnull) keyWords;

@end

NS_ASSUME_NONNULL_END

#import "SearchKeyWordsEntity+CoreDataProperties.h"
