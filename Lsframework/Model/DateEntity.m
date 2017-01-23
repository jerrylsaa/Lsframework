//
//  DateEntity.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DateEntity.h"

@implementation DateEntity

// Insert code here to add functionality to your managed object subclass
+ (NSArray *)findDateWithYear:(NSString *)year andMonth:(NSString *)month{
    NSArray *yearArray = [DateEntity MR_findAll];
    NSMutableArray *monthArray = [NSMutableArray array];
    for (DateEntity *entity in yearArray) {
        if ([entity.month isEqualToString:month]) {
            [monthArray addObject:entity];
        }
    }
    return monthArray;
}

@end
