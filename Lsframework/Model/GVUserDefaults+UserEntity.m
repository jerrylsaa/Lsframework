//
//  GVUserDefaults+UserEntity.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GVUserDefaults+UserEntity.h"
#import "MJExtension.h"

@implementation GVUserDefaults (UserEntity)

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"userId"]) {
        return @"ID";
    }
    return [propertyName mj_firstCharUpper];
}

-(BOOL)isLogin{
    if(!self.token){
        return NO;
    }
    return YES;
}


@end
