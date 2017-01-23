//
//  HEAParentQuestionEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HEAParentQuestionEntity.h"
#import "MJExtension.h"

@implementation HEAParentQuestionEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if([propertyName isEqualToString:@"uuID"]){
        return @"uuiD";
    }
    if([propertyName isEqualToString:@"userImageURL"]){
        return @"UserImg";
    }

    if([propertyName isEqualToString:@"userID"]){
        return @"User_ID";
    }
    
    if([propertyName isEqualToString:@"expertID"]){
        return @"Expert_ID";
    }
    if ([propertyName isEqualToString:@"isPraise"]) {
        return @"isPraise";
    }
    
    return [propertyName mj_firstCharUpper];
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

//+(NSArray<HEAParentQuestionEntity *> *)sortArray:(NSArray *)array{
//    
//    for(HEAParentQuestionEntity* q in array){
//        //格式化问题提出的时间
////        NSString* questionTime = [NSDate getDateCompare:q.createTime];
//        q.questionTime = q.createTime;
//        
//        //test,将是否已经偷听置为1，代表已经偷听过了
////        q.isListen = 0;
//        
////        //test置顶操作
////        if(q.userID == 38){
////            q.isTop = 1;
////        }
//    }
//    
//    
//    //排序
////    NSSortDescriptor* isTop = [NSSortDescriptor sortDescriptorWithKey:@"isTop" ascending:NO];
////    NSSortDescriptor* hearCount = [NSSortDescriptor sortDescriptorWithKey:@"hearCount" ascending:NO];
////    NSArray* desc = [NSArray arrayWithObjects:isTop,hearCount, nil];
////    NSArray* result = [array sortedArrayUsingDescriptors:desc];
//    
//    
//    
//    return array;
//}


@end
