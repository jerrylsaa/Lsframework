//
//  DepartmentEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DepartmentEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepartmentEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *departName;
@property (nullable, nonatomic, retain) NSString *departPY;
@property (nullable, nonatomic, retain) NSNumber *hospitalId;
@property (nullable, nonatomic, retain) NSNumber *keyId;

@end

NS_ASSUME_NONNULL_END
