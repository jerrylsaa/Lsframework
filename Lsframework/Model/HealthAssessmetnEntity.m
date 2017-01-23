//
//  HealthAssessmetnEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthAssessmetnEntity.h"
#import "MJExtension.h"



@implementation HealthAssessmetnEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{

    if([propertyName isEqualToString:@"keyID"]){
        return @"ID";
    }
    
    if([propertyName isEqualToString:@"childName"]){
        return @"child_name";
    }
    
    if([propertyName isEqualToString:@"childSex"]){
        return @"child_sex";
    }
    
    if([propertyName isEqualToString:@"birthDate"]){
        return @"BIRTH_DATE";
    }
    
    return [propertyName mj_firstCharUpper];
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class] && ![oldValue isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}


@end
