//
//  HospitalEntity.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CityEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface HospitalEntity : NSManagedObject

/**
 *  获取医院对应的ID
 *
 *  @param hospatialName <#hospatialName description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)findHospatialIDWithName:(NSString*) hospatialName;

/**
 *  获取该城市所有的医院
 *
 *  @param cityID <#cityID description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray<NSString*>*)findHospatialName:(NSString*) cityID;

+ (BOOL)hospistalIsExist:(NSString*) cityName;




@end

NS_ASSUME_NONNULL_END

#import "HospitalEntity+CoreDataProperties.h"
