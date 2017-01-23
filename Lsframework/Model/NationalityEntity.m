//
//  NationalityEntity.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NationalityEntity.h"
#import "MJExtension.h"

@implementation NationalityEntity

// Insert code here to add functionality to your managed object subclass

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"mId"]) {
        return @"ID";
    }
    if (propertyName.length == 0) return propertyName;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<propertyName.length; i++) {
        unichar c = [propertyName characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            if (i == 0) {
                cStringLower = [cStringLower uppercaseString];
            }
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:[cStringLower uppercaseString]];
        }
    }
    return string;
}

+(NSArray<NationalityEntity *> *)findAll{
    return [NationalityEntity MR_findAll];
}

+(NSArray<NSString *> *)findAllName{
    NSMutableArray * array = [NSMutableArray new];
    for (NationalityEntity * entity in [NationalityEntity findAll]){
        [array addObject:entity.dictionaryName];
    }
    return array;
}

@end
