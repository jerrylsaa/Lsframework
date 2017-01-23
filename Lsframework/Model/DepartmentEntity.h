//
//  DepartmentEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DepartmentEntity : NSManagedObject

/**
 *  判断科室是否存在
 *
 *  @param hospatialID <#hospatialID description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)departIsExist:(NSInteger) hospatialID;

/**
 *  获取医院对应的科室
 *
 *  @return <#return value description#>
 */
+ (NSArray<NSString* >* )findDepartNameWithHospatialID:(NSInteger) hospatialID;

+ (NSInteger)findDepartID:(NSString*) departName;

@end

NS_ASSUME_NONNULL_END

#import "DepartmentEntity+CoreDataProperties.h"
