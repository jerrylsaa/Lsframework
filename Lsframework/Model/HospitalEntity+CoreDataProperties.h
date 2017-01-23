//
//  HospitalEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HospitalEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface HospitalEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *keyid;
@property (nullable, nonatomic, retain) NSString *hName;
@property (nullable, nonatomic, retain) NSNumber *cityId;

@end

NS_ASSUME_NONNULL_END
