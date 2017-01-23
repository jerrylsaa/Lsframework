//
//  ChildEntity.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChildEntity.h"
#import "MJExtension.h"

@implementation ChildEntity


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if (propertyName.length == 0) return propertyName;
    
    if (propertyName.length == 2) return [propertyName uppercaseString];
    
    if ([propertyName isEqualToString:@"GUARGIAN_NAME"]) {
        return @"GUARGIAN_NAME";
    }
    
    if ([propertyName isEqualToString:@"Brithday"]) {
        return @"Brithday";
    }
    
    if([propertyName isEqualToString:@"childID"]) return @"Child_ID";
    
    if([propertyName isEqualToString:@"child_Img"])return @"CHILD_IMG";
    
    
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<propertyName.length; i++) {
        unichar c = [propertyName characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            if (i == 0) {
                cStringLower = [cStringLower uppercaseString];
            }
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:[cStringLower uppercaseString]];
        }
    }
    return string;
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
//    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
//        return @"";
//    }
    
    return oldValue;
}

@end
