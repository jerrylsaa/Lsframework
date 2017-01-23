//
//  MessageEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *detail;

@end

NS_ASSUME_NONNULL_END
