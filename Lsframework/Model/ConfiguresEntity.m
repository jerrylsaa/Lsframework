//
//  ConfiguresEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConfiguresEntity.h"
#import "MJExtension.h"

@implementation ConfiguresEntity

// Insert code here to add functionality to your managed object subclass

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{

    if([propertyName isEqualToString:@"keyID"]){
        return @"ID";
    }
    return [propertyName mj_firstCharUpper];
}

+(BOOL)isHasConfiguresEntity{

    return [ConfiguresEntity MR_countOfEntities] > 0 ;
}

+(void)deleteConfiguresEntity{
    [ConfiguresEntity MR_truncateAll];
}

+(NSString *)findConfigureValueWithKey:(NSString *)key{

    NSArray<ConfiguresEntity*> * array = [ConfiguresEntity MR_findByAttribute:@"key" withValue:key];
    ConfiguresEntity* configure = [array firstObject];
    
    return configure.value;
}

+(NSArray<NSDictionary *> *)importDefaultConfigure{

    if([ConfiguresEntity isHasConfiguresEntity]){
        [ConfiguresEntity deleteConfiguresEntity];
    }
    
    NSDictionary* configure1 = @{@"ID":@1,@"Key":@"openzjzx",@"Value":@"true"};
    NSDictionary* configure2 =  @{@"ID":@2,@"Key":@"openmzyy",@"Value":@"true"};
    NSDictionary* configure3 = @{@"ID":@3,@"Key":@"openmzyyurl1",@"Value":@"http%3a%2f%2fetjk365.dzjk.com%3a8084%2fMobileHtml%2fgzh%2fkeshiNav.html"};
    NSDictionary* configure4 =  @{@"ID":@4,@"Key":@"openmzyyurl2",@"Value":@"http%3a%2f%2fetjk365.dzjk.com%3a8084%2fMobileHtml%2fgzh%2fyuyue1.html"};
    NSDictionary* configure5 =  @{@"ID":@36,@"Key":@"UploadConfig",@"Value":@1};
    
    NSArray* defaultConfigure = @[configure1,configure2,configure3,configure4,configure5];
    
    return defaultConfigure;
}



@end
