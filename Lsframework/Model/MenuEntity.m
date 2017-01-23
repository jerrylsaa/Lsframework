//
//  MenuEntity.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MenuEntity.h"

@implementation MenuEntity

+(NSArray<NSNumber *> *)findAllTimestamp{
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    NSArray* sortArray = @[sort];
    
    NSArray* result = [[MenuEntity MR_findAll] sortedArrayUsingDescriptors:sortArray];
    
    NSMutableArray * array = [NSMutableArray new];
    for (MenuEntity * entity in result){
        [array addObject:entity.createDate];
    }
    return array;
}

+(NSArray<MenuEntity *> *)findMenuEntity:(NSInteger)parentID{
    
    NSArray* result = [MenuEntity MR_findByAttribute:@"parentId" withValue:@(parentID)];
    
    return result;
}

+(NSInteger)findMenuEntityID:(NSString *)name{
    NSArray* result = [MenuEntity MR_findByAttribute:@"dictionaryName" withValue:name];
   MenuEntity* menu = [result firstObject];
    return [menu.menuId integerValue];
}

+(NSString *)findMenuName:(NSInteger)menuID{

    NSArray* result = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuID)];
    MenuEntity* menu = [result firstObject];
    
    return menu.dictionaryName;
}
+(NSInteger)findParentID:(NSString *)name{
    NSArray* result = [MenuEntity MR_findByAttribute:@"dictionaryName" withValue:name];
    MenuEntity* menu = [result firstObject];
    return [menu.parentId integerValue];
}


@end
