//
//  ConfiguresEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfiguresEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (BOOL)isHasConfiguresEntity;

+ (void)deleteConfiguresEntity;

+(NSString*)findConfigureValueWithKey:(NSString*) key;

+ (NSArray<NSDictionary*> *)importDefaultConfigure;

@end

NS_ASSUME_NONNULL_END

#import "ConfiguresEntity+CoreDataProperties.h"
