//
//  NationEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NationEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface NationEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mId;
@property (nullable, nonatomic, retain) NSString *dictionaryName;

@end

NS_ASSUME_NONNULL_END
