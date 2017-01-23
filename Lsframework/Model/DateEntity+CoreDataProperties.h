//
//  DateEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DateEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, retain) NSString *month;
@property (nullable, nonatomic, retain) NSString *day;

@end

NS_ASSUME_NONNULL_END
