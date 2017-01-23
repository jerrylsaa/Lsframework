//
//  CollectDoctor.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectDoctor : NSObject

/*
 "UserName":"赵冬梅",
 "CollectionTime":1462342520,
 "Dictionary_Name":"主任",      //职称
 "Depart_Name":"儿童保健所",  //科室
 "Field":"儿童保健",    //领域
 "PatientNum":365,   //患者数量
 "FollowUp":500,  //随访人数
 "StarNum":10,
 "FamilyDoctor":1,  //签约患者
 "UserImg":"/attach_upload/Pic/zhaodongmei.png"}
 
 */

@property(nonatomic,copy) NSString* userName;//
@property(nonatomic,retain) NSDate* collectionTime;
@property(nonatomic,copy) NSString* dictionaryName;
@property(nonatomic,copy) NSString* departName;
@property(nonatomic,copy) NSString* field;
@property(nonatomic,retain) NSNumber* patientNum;
@property(nonatomic,retain) NSNumber* followUp;
@property(nonatomic,retain) NSNumber* starNum;
@property(nonatomic,retain) NSNumber* familyDoctor;
@property(nonatomic,copy) NSString* userImg;

@end
