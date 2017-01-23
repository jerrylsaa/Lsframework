//
//  MineApplyFamilyDoctorEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineApplyFamilyDoctorEntity.h"
#import "MJExtension.h"

@implementation MineApplyFamilyDoctorEntity


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if ([propertyName isEqualToString:@"departName"]) {
        return @"Depart_Name";
    }
    
    if([propertyName isEqualToString:@"fdBabyName"]){
        return @"Baby_Name";
    }
    if([propertyName isEqualToString:@"fdprice"]){
        return @"ActualPrice";
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
