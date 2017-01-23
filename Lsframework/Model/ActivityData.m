//
//  ActivityData.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ActivityData.h"
#import "MJExtension.h"

@implementation ActivityData
+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"Activity_ID"]) {
        return @"ID";
    }
    if([propertyName isEqualToString:@"Activity_iconUrl"]){
        return @"IconUrl";
        return propertyName;
    }
        else{
        return [propertyName mj_firstCharUpper];}
}


@end
