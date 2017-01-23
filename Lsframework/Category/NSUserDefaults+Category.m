//
//  NSUserDefaults+Category.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)

-(void)saveValue:(id)value withKeyPath:(NSString *)keyPath{
    [kDefaultsUser setObject: value forKey:keyPath];
    [kDefaultsUser synchronize];
}

-(id)valueForkey:(NSString *)keyPath{
   id value = [kDefaultsUser objectForKey:keyPath];
    [kDefaultsUser synchronize];
    return value;
}

-(void)removeValueWithKey:(NSString *)keyPath{
    [kDefaultsUser removeObjectForKey:keyPath];
    [kDefaultsUser synchronize];
    
}

-(id)readValueForKey:(NSString *)keyPath{
    id value = [kDefaultsUser objectForKey:keyPath];
    [kDefaultsUser synchronize];
    return value;
    
}


@end
