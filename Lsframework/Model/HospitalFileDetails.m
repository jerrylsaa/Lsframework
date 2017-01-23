//
//  HospitalFileDetails.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalFileDetails.h"
#import "MJExtension.h"

@implementation HospitalFileDetails

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}

@end
