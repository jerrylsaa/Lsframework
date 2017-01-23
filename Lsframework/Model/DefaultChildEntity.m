//
//  DefaultChildEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DefaultChildEntity.h"
#import "MJExtension.h"

@implementation DefaultChildEntity

// Insert code here to add functionality to your managed object subclass


+(DefaultChildEntity *)defaultChild{
    
    return [DefaultChildEntity MR_findFirst];
    
}

+(void)deleteDefaultChild{
    [DefaultChildEntity MR_truncateAll];
}

+(BOOL)isHasDefaultChild{
    return [DefaultChildEntity MR_countOfEntities] > 0;
}





+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if (propertyName.length == 0) return propertyName;
    
    if (propertyName.length == 2) return [propertyName uppercaseString];
    
    if([propertyName isEqualToString:@"babyID"]){
        
        return @"ID";
        
    }
    
    if([propertyName isEqualToString:@"childImg"]){
        return @"CHILD_IMG";
    }
    if ([propertyName isEqualToString:@"GUARGIAN_NAME"]) {
        return @"userName";
    }
    
    
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
    
    
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        
        return @"";
        
    }
    
    
    
    return oldValue;
    
}



@end
