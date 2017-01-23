//
//  MoreFunction.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreFunction.h"
#import "MJExtension.h"

@implementation MoreFunction
+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"Menu_url"]) {
        return @"ICON_URL";
    } else if ([propertyName isEqualToString:@"title"]) {
        return @"TITLE";
    }else if ([propertyName isEqualToString:@"ceratTime"]) {
        return @"CREATE_TIME";
    }else if ([propertyName isEqualToString:@"URL"]) {
        return @"CONTENT_URL";
    }else{
        return [propertyName  mj_firstCharUpper];
    
    }
}


@end
