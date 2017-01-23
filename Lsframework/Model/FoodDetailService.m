//
//  FoodDetailService.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FoodDetailService.h"
#import "MJExtension.h"
@implementation FoodDetailService
+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"TID"]) {
        return @"TYPE_ID";
    }
    if([propertyName isEqualToString:@"Type_ID"]){
        return @"ID";
        return propertyName;
    }
    if([propertyName isEqualToString:@"QuestDescript"]){
        return @"QUEST";
        return propertyName;
    }
    if([propertyName isEqualToString:@"Content1"]){
        return @"SEL1";
        return propertyName;
    }
    if([propertyName isEqualToString:@"Content2"]){
        return @"SEL2";
        return propertyName;
    }
    if([propertyName isEqualToString:@"Content3"]){
        return @"SEL3";
        return propertyName;
    }
    if([propertyName isEqualToString:@"Content4"]){
        return @"SEL4";
        return propertyName;
    }
    if([propertyName isEqualToString:@"Content5"]){
        return @"SEL5";
        return propertyName;
    }
    if([propertyName isEqualToString:@"value1"]){
        return @"VALUE1";
        return propertyName;
    }
    if([propertyName isEqualToString:@"value2"]){
        return @"VALUE2";
        return propertyName;
    }
    if([propertyName isEqualToString:@"value3"]){
        return @"VALUE3";
        return propertyName;
    }
    if([propertyName isEqualToString:@"value4"]){
        return @"VALUE4";
        return propertyName;
    }
    if([propertyName isEqualToString:@"value5"]){
        return @"VALUE5";
        return propertyName;
    }

    else{
        return [propertyName mj_firstCharUpper];}
}


@end
