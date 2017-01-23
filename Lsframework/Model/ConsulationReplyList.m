//
//  ConsulationReplyList.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConsulationReplyList.h"

@implementation ConsulationReplyList

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"replyTime"]){
        return @"CreateTime";
    }
    return propertyName;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class] && ![oldValue isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}

+(void)formatChildImageWithArray:(NSMutableArray *)array{
    for(ConsulationReplyList* reply in array){
        
        reply.UserPic = reply.CHILD_IMG;
    }

}



@end
