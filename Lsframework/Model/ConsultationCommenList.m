//
//  ConsultationCommenList.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConsultationCommenList.h"

@implementation ConsultationCommenList

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"publicTime"]){
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

+(void)formatConsulationReplyListWithArray:(NSMutableArray *)array{
    for(ConsultationCommenList* comment in array){
        NSMutableArray* array = [NSMutableArray arrayWithArray:comment.ReplayList];
        comment.ReplyCommentList = array;
    }

}


@end
