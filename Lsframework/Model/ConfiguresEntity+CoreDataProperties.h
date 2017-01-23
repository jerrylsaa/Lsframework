//
//  ConfiguresEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ConfiguresEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfiguresEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *keyID;
@property (nullable, nonatomic, retain) NSString *key;
@property (nullable, nonatomic, retain) NSString *value;

@end

NS_ASSUME_NONNULL_END
