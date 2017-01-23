//
//  ProvinceEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProvinceEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *keyid;
@property (nullable, nonatomic, retain) NSString *ssqId;
@property (nullable, nonatomic, retain) NSString *ssqName;

@end

NS_ASSUME_NONNULL_END
