//
//  FamilyDoctorEntity.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyDoctorEntity : NSObject

@property (nonatomic, copy) NSString* departName;// = "\U5185\U79d1";
@property (nonatomic, copy) NSString* doctorID;
@property (nonatomic, copy) NSDate* packageEndTime;
@property (nonatomic, copy) NSString* packageName;// = "\U4e00\U7ea7\U5bb6\U5ead\U533b\U751f";
@property (nonatomic, copy) NSDate* packageStarTime;// = 1451577600;
@property (nonatomic, copy) NSString* userImg;// = "<null>";
@property (nonatomic, copy) NSString* userName;// = "\U513f\U7ae5\U533b\U9662\U533b\U751f";
@property (nonatomic, copy) NSString* userSex;// = 2;

/** 新增字段*/
@property(nonatomic,copy) NSString* field;
@property(nonatomic) NSInteger starNum;//星星数量
@property(nonatomic) NSInteger followUp;//随访
@property(nonatomic) NSInteger patientNum;//患者
@property(nonatomic) NSInteger orderState;//申请状态
@property(nonatomic,copy) NSString* profession;//职称
@property(nonatomic,retain) NSNumber* onLineState;//在线状态


@end
