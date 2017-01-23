//
//  FDAppointManagerEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDAppointManagerEntity.h"

#import "MJExtension.h"

@implementation FDAppointManagerEntity

+ (NSString*)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"keyID"]){
        return @"id";
    }
    if([propertyName isEqualToString:@"departName"]){
        return @"Depart_Name";
    }
    
    if([propertyName isEqualToString:@"profession"]){
        return @"Dictionary_Name";
    }
    
    if([propertyName isEqualToString:@"depart"]){
        return @"DepartName";
    }
    
    return [propertyName mj_firstCharUpper];


}

@end
