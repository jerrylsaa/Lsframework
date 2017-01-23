//
//  MenuEntity.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuEntity : NSManagedObject

+(NSArray<NSNumber *> *)findAllTimestamp;

/**
 *  获取下拉菜单
 *
 *  @param parentID <#parentID description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray<MenuEntity* > *)findMenuEntity:(NSInteger) parentID;

/**
 *  获取下拉菜单id
 *
 *  @param name 下拉菜单
 *
 *  @return 下拉菜单id
 */
+ (NSInteger)findMenuEntityID:(NSString*) name;

/**
 *  获取下拉菜单
 *
 *  @param menuID 下拉菜单id
 *
 *  @return 下拉菜单
 */
+ (NSString*)findMenuName:(NSInteger) menuID;

+(NSInteger)findParentID:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#import "MenuEntity+CoreDataProperties.h"
