//
//  EvaluationDetail.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "EvaluationDetail.h"

#import "MJExtension.h"

@implementation EvaluationDetail

+ (NSString*)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if([propertyName isEqualToString:@"departName"]){
        return @"Depart_Name";
    }
    
    
    return [propertyName mj_firstCharUpper];
    
}



@end
