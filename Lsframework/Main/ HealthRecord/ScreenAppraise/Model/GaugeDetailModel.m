//
//  GaugeDetailModel.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/5/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GaugeDetailModel.h"
#import "MJExtension.h"
@implementation GaugeDetailModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }

    return oldValue;
}
@end
