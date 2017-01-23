//
//  FoodDetailService.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodDetailService : NSObject
/**
 *  {
 "ID": 1,
 "QUEST": "进食过程中只顾看电视、玩玩具或讲故事，而非进餐",
 "SEL1": "从不",
 "SEL2": "很少",
 "SEL3": "有时",
 "SEL4": "经常",
 "SEL5": "总是",
 "VALUE1": 0,
 "VALUE2": 1,
 "VALUE3": 2,
 "VALUE4": 3,
 "VALUE5": 4,
 "TYPE_ID": 1,
 "RESULT": "家长树立良好的榜样，进食时不做其他事情。不良进食习惯只要有所改善，立即给与鼓励和表扬。必要时与医生讨论儿童的不良进食习惯，寻求解决方案。"
 },

 */

@property (nonatomic ,strong) NSNumber *Type_ID;
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
@property (nonatomic ,strong) NSNumber *TID;
@property (nonatomic ,copy) NSString *RESULT;




@end
