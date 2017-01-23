//
//  FoodService.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FoodService.h"
#import "MJExtension.h"

@implementation FoodService
+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"FoodID"]) {
        return @"ID";
    }
    if([propertyName isEqualToString:@"Name"]){
        return @"TITLE";
        return propertyName;
    }
    if([propertyName isEqualToString:@"CreateTime"]){
        return @"CREATE_TIME";
        return propertyName;
    }
    if([propertyName isEqualToString:@"ImageUrl"]){
        return @"ICON_URL";
        return propertyName;
    }
    else{
        return [propertyName mj_firstCharUpper];}
}


@end
