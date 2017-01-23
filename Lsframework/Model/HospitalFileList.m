//
//  HospitalFileList.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalFileList.h"
#import "MJExtension.h"

@implementation HospitalFileList

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}


@end
