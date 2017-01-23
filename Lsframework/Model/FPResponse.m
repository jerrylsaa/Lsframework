//
//  FPResponse.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPResponse.h"
#import "MJExtension.h"

@implementation FPResponse


-(BOOL)isSuccess{
    return self.status == 200;
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    //第一个大写
    return [propertyName mj_firstCharUpper];
}

@end
