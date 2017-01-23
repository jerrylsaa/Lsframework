//
//  PatientCaseEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface PatientCaseEntity : NSObject

/*
 "RowID":1,
 "AdmissionRecordID":1,
 "DepartName":"耳鼻喉病房",
 "DiseaseName":"急性化脓性扁桃体炎",
 "AdmissionSituation":"咽痛、发热6小时。查体：T 36.5℃，精神好，呼吸平稳，咽部粘膜急性充血，双侧扁桃体Ⅱ度肿大，表面急性充血，有散在脓性分泌物，咽后壁散在少许淋巴滤泡增生，无渗出。颈软，双肺呼吸音清，心音有力，律齐，腹平软。2016-10-02血常规示白细胞计数26.56×109／L，红细胞4.1×1012／L，血红蛋白120.0g/L，血小板455.0×109／L，淋巴细胞16.3%，中性粒细胞77.9%，中性粒细胞绝对值20.69×109／L，嗜酸粒细胞计数0.19×109／L；2016-10-02CRP：4.95mg/L（样本号：99）",
 "CreateTime":1477557662,
 "Click":null,
 "CommentCount":7
 
 */

@property(nullable,nonatomic,retain) NSNumber* rowID;
@property(nullable,nonatomic,retain) NSNumber* admissionRecordID;
@property(nullable,nonatomic,copy) NSString* departName;
@property(nullable,nonatomic,copy) NSString* diseaseName;
@property(nullable,nonatomic,copy) NSString* admissionSituation;
//@property(nullable,nonatomic,retain) NSDate* createTime;
@property(nullable,nonatomic,retain) NSString* createTime;
@property(nullable,nonatomic,retain) NSNumber* click;
@property(nullable,nonatomic,retain) NSNumber* commentCount;

@end
