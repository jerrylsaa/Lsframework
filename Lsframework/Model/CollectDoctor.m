//
//  CollectDoctor.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CollectDoctor.h"
#import "MJExtension.h"

@implementation CollectDoctor

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{

    if([propertyName isEqualToString:@"dictionaryName"]){
        return @"Dictionary_Name";
    }
    
    if([propertyName isEqualToString:@"departName"]){
        return @"Depart_Name";
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
