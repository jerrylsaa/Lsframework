//
//  BehaviourGuide.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BehaviourGuide : NSObject


@property(nonatomic, assign)NSInteger createTime;//时间

@property(nonatomic, copy)NSString *doctorName;//医生姓名
@property(nonatomic, copy)NSString *departName;//科室名称
@property(nonatomic, copy)NSString *descriptionDisease;//所患疾病
@property(nonatomic, copy)NSString *dictionaryName;//医生职称

@property(nonatomic, strong)NSString *userImg;//医生头像

@property(nonatomic,strong)NSNumber *doctorID;

@end
