//
//  BookTimeEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookTimeEntity.h"
#import "MJExtension.h"

@implementation BookTimeEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"keyID"]){
        return @"ID";
    }
    
    return [propertyName mj_firstCharUpper];
}


@end
