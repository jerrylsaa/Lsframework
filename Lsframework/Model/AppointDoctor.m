//
//  AppointDoctor.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppointDoctor.h"
#import "MJExtension.h"

@implementation AppointDoctor

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
//    if([propertyName isEqualToString:@"childName"]){
//        return @"CHILD_NAME";
//    }
//    
//    if([propertyName isEqualToString:@"dictionaryName"]){
//        return @"Dictionary_Name";
//    }
//
//    if([propertyName isEqualToString:@"departName"]){
//        return @"Depart_Name";
//    }
    
    if([propertyName isEqualToString:@"rowID"]){
        return @"RowID";
    }

    return propertyName;
}


-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
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
