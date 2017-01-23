//
//  ProvinceEntity.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceEntity : NSManagedObject

+(NSArray<ProvinceEntity *> *)findAll;
+(NSArray<NSString *> *)findAllName;

/**
 *  获取省id
 *
 *  @param provinceName <#provinceName description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)findProvinceID:(NSString*) provinceName;

/**
 *  保存省到本地数据库
 */
+ (void)saveProvinceToDatabase;



@end

NS_ASSUME_NONNULL_END

#import "ProvinceEntity+CoreDataProperties.h"
