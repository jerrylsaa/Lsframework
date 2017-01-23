//
//  CityEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProvinceEntity;

NS_ASSUME_NONNULL_BEGIN

@interface CityEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 *  获取城市ID
 *
 *  @param city <#city description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)findCityID:(NSString*) city;


+ (void)saveCityToLocal:(NSString*) cityName;

+ (CityEntity*)getCityFromLocal;

+ (BOOL)cityIsExist;

+ (NSArray<CityEntity*> *)findAll;

/**
 *  保存城市到本地数据库
 */
+ (void)saveCityToDatabase;

@end

NS_ASSUME_NONNULL_END

#import "CityEntity+CoreDataProperties.h"
