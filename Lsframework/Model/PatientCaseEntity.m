//
//  PatientCaseEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseEntity.h"

@implementation PatientCaseEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
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
