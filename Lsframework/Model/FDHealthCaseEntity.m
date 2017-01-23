//
//  FDHealthCaseEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDHealthCaseEntity.h"
#import "MJExtension.h"

@implementation FDHealthCaseEntity

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if ([propertyName isEqualToString:@"keyID"]) {
        return @"id";
    }
    
    return [propertyName mj_firstCharUpper];
    
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{

    if (property.type.typeClass == [NSDate class]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}



@end
