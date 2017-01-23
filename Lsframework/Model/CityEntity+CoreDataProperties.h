//
//  CityEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CityEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *keyid;
@property (nullable, nonatomic, retain) NSNumber *provinceId;
@property (nullable, nonatomic, retain) NSString *ssqId;
@property (nullable, nonatomic, retain) NSString *ssqName;
@property (nullable, nonatomic, retain) NSString *provinceName;
@property (nullable, nonatomic, retain) ProvinceEntity *relationship;

@end

NS_ASSUME_NONNULL_END
