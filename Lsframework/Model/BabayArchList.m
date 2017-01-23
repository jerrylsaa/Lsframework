//
//  BabayArchList.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BabayArchList.h"
#import "MJExtension.h"

@implementation BabayArchList

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if([propertyName isEqualToString:@"childID"]){
        return @"Child_ID";
    }
    
    if([propertyName isEqualToString:@"childName"]){
        return @"Child_Name";
    }

    
    if([propertyName isEqualToString:@"childImg"]){
        return @"CHILD_IMG";
    }
    
    if([propertyName isEqualToString:@"height"]){
        return @"BIRTH_HEIGHT";
    }

    if([propertyName isEqualToString:@"weight"]){
        return @"BIRTH_WEIGHT";
    }
    
    if([propertyName isEqualToString:@"birthDate"]){
        return @"Birth_Date";
    }
    

    return [propertyName mj_firstCharUpper];
    
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class] && ![oldValue isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    return oldValue;
}





@end
