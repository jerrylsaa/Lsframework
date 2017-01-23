//
//  FamilyDoctorEntity.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FamilyDoctorEntity.h"
#import "MJExtension.h"

@implementation FamilyDoctorEntity


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if([propertyName isEqualToString:@"profession"]){
        return @"Dictionary_Name";
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
