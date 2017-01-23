//
//  Package.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "Package.h"
#import "MJExtension.h"

@implementation Package


+ (NSString*)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"basePackageInfo"]){
        return @"Base_PackageInfo";
    }
    
    if([propertyName isEqualToString:@"fapackagePrice"]){
        return @"Package_Price";
    }

    if([propertyName isEqualToString:@"fapackageName"]){
        return @"Package_Name";
    }
    
    if([propertyName isEqualToString:@"fapackageID"]){
        return @"id";
    }

    
    return [propertyName mj_firstCharUpper];

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
