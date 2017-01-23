//
//  MyAnserEntity.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyAnserEntity.h"
#import "MJExtension.h"

@implementation MyAnserEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"answerType"]) {
        return @"type";
    }
    if([propertyName isEqualToString:@"uuid"]){
        return @"uuid";
        return propertyName;
    }else{
        return [propertyName mj_firstCharUpper];}
}



@end
