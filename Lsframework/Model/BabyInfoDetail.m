//
//  BabyInfoDetail.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BabyInfoDetail.h"
#import "MJExtension.h"

@implementation BabyInfoDetail

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{

    if([propertyName isEqualToString:@"familyDoctor"]){
      NSString* string = [[propertyName lowercaseString] uppercaseString];

        return string;
    }

    NSMutableString* multableStr = [NSMutableString string];
    for(NSUInteger i=0; i<propertyName.length; ++i){
        unichar c = [propertyName characterAtIndex:i];
        NSString* cString = [NSString stringWithFormat:@"%c",c];
        NSString* cStringUpper = [cString uppercaseString];
        if([cStringUpper isEqualToString:cString]){
            [multableStr appendString:@"_"];
            [multableStr appendString:cStringUpper];
        }else{
            
            [multableStr appendString:cStringUpper];
        }
        
    }
    return multableStr;
    
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
