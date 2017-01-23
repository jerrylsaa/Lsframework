//
//  HealthServiceInfo.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthServiceInfo : NSObject
/**
 "ID": 8,
 "TID": 1,
 "QuestDescript": "从客户端新增的问题？",
 "Content1": "选项1",
 "value1": 1,
 "Content2": "选项2",
 "value2": 2,
 "Content3": "选项3",
 "value3": 3,
 "Content4": "选项4",
 "value4": 4,
 "Content5": "选项5",
 "value5": 5
 */
@property (nonatomic ,strong) NSNumber *ID;
@property (nonatomic ,strong) NSNumber *TID;
@property (nonatomic ,copy) NSString *QuestDescript;
@property (nonatomic ,copy) NSString *Content1;
@property (nonatomic ,copy) NSString *Content2;
@property (nonatomic ,copy) NSString *Content3;
@property (nonatomic ,copy) NSString *Content4;
@property (nonatomic ,copy) NSString *Content5;
@property (nonatomic ,strong) NSNumber *value1;
@property (nonatomic ,strong) NSNumber *value2;
@property (nonatomic ,strong) NSNumber *value3;
@property (nonatomic ,strong) NSNumber *value4;
@property (nonatomic ,strong) NSNumber *value5;
@property (nonatomic ,copy) NSString *QuestTitle;
@end
