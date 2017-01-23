//
//  VoiceEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VoiceEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSData *data;

@end

NS_ASSUME_NONNULL_END
