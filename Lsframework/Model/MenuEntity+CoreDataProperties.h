//
//  MenuEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
/*
 createDate = 1452580919;
 dictionaryName = "\U4e2d\U56fd";dictionaryName
 menuId = 59;menuId
 parentId = 18;
 */

#import "MenuEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *menuId;
@property (nullable, nonatomic, retain) NSString *dictionaryName;
@property (nullable, nonatomic, retain) NSNumber *parentId;
@property (nullable, nonatomic, retain) NSNumber *createDate;

@end

NS_ASSUME_NONNULL_END
