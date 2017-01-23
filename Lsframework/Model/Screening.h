//
//  Screening.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//  筛查
/*
 {
 "uuid":358,
 "userID":1546,
 "ExactAge":"6月28天",
 "CorrectAge":"0天",
 "Weight":"",
 "WeightEval":"0",
 "BodyHeight":"",
 "BodyHeightEval":"0",
 "HeadGirth":"",
 "HeadGirthEval":"0",
 "Measuringmethod":2,
 "BreastFeed":"0",
 "Formula":"",
 "FeedBehavious":"0",
 "SolidFood":"0",
 "FoodCondition":"0",
 "Sleep":"0",
 "YiNai":"0",
 "CryAndScream":"0",
 "Shit":"0",
 "ShitCondition":"0",
 "IllNessCondition":1233,
 "illconditionDes":"",
 "VitamineD":"3",
 "VitamineDCondition":"",
 "ferralia":"",
 "Calcium":"",
 "Others":"",
 "Temperature":"",
 "Breath":" ",
 "MentalState":553,
 "FaceColor":1017,
 "Skin":189,
 "Neck":197,
 "Eye":0,
 "EyeCondition":"",
 "Ear":0,
 "EarCondition":"",
 "Mouth":774,
 "Chest":1120,
 "Lung":199,
 "Heart":201,
 "Stomach":0,
 "SpLimbs":0,
 "SpLimbsCondition":"",
 "Anop":0,
 "AnopCondition":"",
 "VisionScreen":"0",
 "HearScreen":"0",
 "DietyaryAnaly":"0",
 "BodyAnaly":"undefined",
 "Cruorin":"",
 "Allergen":"0",
 "BoneDensity":"0",
 "BrainEvoked":"",
 "TypeB":"",
 "MRI":"",
 "ColourSonography":"",
 "HipB":"",
 "HipX":"",
 "ExamOthers":"",
 "Result":"",
 "YWZL":"",
 "ZKHZ":"",
 "ReTraining":"",
 "QTother":"",
 "OrderDate":"/Date(1475107200000)/",
 "ExamDate":"/Date(1469750400000)/",
 "DoctorSign":"儿童医院医生",
 "HospitalID":1,
 "DoctorID":7,
 "HeartRate":"",
 "AllergenCondtion":"",
 "StomachUnNormal":"1130",
 "SUnNormalCondition":"",
 "EyeUnNormal":"1295",
 "EarUnNormal":"1300",
 "AnopUnNormal":"1399",
 "SpLimbsUnNormal":"1369",
 "Medea":"0",
 "MedeaUnNormal":"0",
 "MedeaCondition":"",
 "Wedea":"0",
 "WedeaUnNormal":"0",
 "WedeaCondition":"",
 "MentalStateCondition":"",
 "FaceColorCondition":"",
 "SkinCondition":"",
 "NeckCondition":"",
 "MouthCondition":"",
 "ChestCondition":"",
 "LungCondition":"",
 "HeartCondition":"",
 "BregmaCondition":"",
 "BregmaConditionTwo":"",
 "HeadCondition":"2",
 "DD":"0",
 "PRWR":"0",
 "KBXW":"0",
 "PQBZ":"0",
 "GP":"0",
 "BTZH":"0",
 "CFYY":"0",
 "BPWX":"0",
 "PX":"0",
 "DZWS":"0",
 "CDXX":"0",
 "MXDY":"0",
 "KJ":"0",
 "TBAJ":"0",
 "TBFZ":"0",
 "ZDJT":"0",
 "MSQJFY":"",
 "QT":"",
 "InsertTime":"2016-07-29 11:51:29",
 "DevelopmentImg":null,
 "StaticPage":null,
 "Xray":""
 }
 */

#import <Foundation/Foundation.h>

@interface Screening : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *orderDate;//预约日期
@property (nonatomic, copy) NSString *examDate;//检查日期
@property (nonatomic, strong) NSNumber *hospitalID;
@property (nonatomic, strong) NSNumber *doctorID;
@property (nonatomic, copy) NSString *staticPage;//静态页/H5
@property (nonatomic, copy) NSString *insertTime;//上传日期？？？

//------------------- 现 况 ----------------------------------------------
@property (nonatomic, copy) NSString *exactAge;//失足年龄                                                         
@property (nonatomic, copy) NSString *correctAge;//矫正年龄                                                       
@property (nonatomic, strong) NSNumber *measuringmethod;//测量方式
@property (nonatomic, copy) NSString *breastFeed;//母乳喂养
@property (nonatomic, copy) NSString *formula;//配方奶喂养
@property (nonatomic, copy) NSString *feedBehavious;//喂养行为
@property (nonatomic, copy) NSString *solidFood;//辅食添加                                                        
@property (nonatomic, copy) NSString *foodCondition;//辅食添加描述                                                
@property (nonatomic, copy) NSString *sleep;//睡眠                                                               
@property (nonatomic, copy) NSString *yiNai;//溢奶
@property (nonatomic, copy) NSString *cryAndScream;//哭闹
@property (nonatomic, copy) NSString *shit;//大便                                                                
@property (nonatomic, copy) NSString *shitCondition;//大便情况                                                    
@property (nonatomic, strong) NSNumber *illNessCondition;//两次随访间情况                                          
@property (nonatomic, copy) NSString *illconditionDes;//两次随访间情况描述                                          
@property (nonatomic, copy) NSString *vitamineD;//维生素D/AD                                                      
@property (nonatomic, copy) NSString *vitamineDCondition;//维生素D/AD描述                                          
@property (nonatomic, copy) NSString *ferralia;//铁剂
@property (nonatomic, copy) NSString *calcium;//钙剂
@property (nonatomic, copy) NSString *others;//其他

//------------------- 体 格 检 查 ----------------------------------------------
@property (nonatomic, copy) NSString *weight;//体重
@property (nonatomic, copy) NSString *weightEval;//体重评价
@property (nonatomic, copy) NSString *bodyHeight;//身长
@property (nonatomic, copy) NSString *bodyHeightEval;//身长评价
@property (nonatomic, copy) NSString *headGirth;//头围
@property (nonatomic, copy) NSString *headGirthEval;//头围评价
@property (nonatomic, copy) NSString *temperature;//体温
@property (nonatomic, copy) NSString *breath;//呼吸
@property (nonatomic, copy) NSString *heartRate;//心率
@property (nonatomic, strong) NSNumber *mentalState;//精神状态
@property (nonatomic, copy) NSString *mentalStateCondition;//精神状态描述
@property (nonatomic, strong) NSNumber *faceColor;//面色
@property (nonatomic, copy) NSString *faceColorCondition;//面色描述
@property (nonatomic, copy) NSString *headCondition;//前卤是否闭合
@property (nonatomic, copy) NSString *bregmaCondition;//前卤描述
@property (nonatomic, copy) NSString *bregmaConditionTwo;//前卤宽度(cm)
@property (nonatomic, strong) NSNumber *skin;//皮肤
@property (nonatomic, copy) NSString *skinCondition;//皮肤描述
@property (nonatomic, strong) NSNumber *neck;//淋巴结
@property (nonatomic, copy) NSString *neckCondition;//淋巴结描述
@property (nonatomic, copy) NSString *eyeUnNormal;//眼外观异常
@property (nonatomic, strong) NSNumber *eye;//眼外观
@property (nonatomic, copy) NSString *eyeCondition;//眼外观描述
@property (nonatomic, copy) NSString *earUnNormal;//耳外观异常
@property (nonatomic, strong) NSNumber *ear;//耳外观
@property (nonatomic, copy) NSString *earCondition;//耳外观描述
@property (nonatomic, strong) NSNumber *mouth;//口腔
@property (nonatomic, copy) NSString *mouthCondition;//口腔描述
@property (nonatomic, strong) NSNumber *chest;//胸廓
@property (nonatomic, copy) NSString *chestCondition;//胸廓描述
@property (nonatomic, strong) NSNumber *lung;//肺部
@property (nonatomic, copy) NSString *lungCondition;//肺部描述
@property (nonatomic, strong) NSNumber *heart;//心脏
@property (nonatomic, copy) NSString *heartCondition;//心脏描述
@property (nonatomic, copy) NSString *stomachUnNormal;//腹部异常
@property (nonatomic, strong) NSNumber *stomach;//腹部
@property (nonatomic, copy) NSString *sUnNormalCondition;//腹部异常描述
@property (nonatomic, copy) NSString *spLimbsUnNormal;//脊柱四肢异常
@property (nonatomic, strong) NSNumber *spLimbs;//脊柱四肢
@property (nonatomic, copy) NSString *spLimbsCondition;//脊柱四肢异常描述
@property (nonatomic, copy) NSString *anopUnNormal;//肛门会阴异常
@property (nonatomic, strong) NSNumber *anop;//肛门会阴
@property (nonatomic, copy) NSString *anopCondition;//肛门会阴描述
@property (nonatomic, copy) NSString *medeaUnNormal;//外生殖器异常(男)
@property (nonatomic, copy) NSString *medea;//外生殖器(男)
@property (nonatomic, copy) NSString *medeaCondition;//外生殖器描述(男)
@property (nonatomic, copy) NSString *wedeaUnNormal;//外生殖器异常(女)
@property (nonatomic, copy) NSString *wedea;//外生殖器(女)
@property (nonatomic, copy) NSString *wedeaCondition;//外生殖器描述(女)

//------------------- 辅 助 检 查 ----------------------------------------------
@property (nonatomic ,copy) NSString *visionScreen;//视力筛查
@property (nonatomic ,copy) NSString *hearScreen;//听力筛查
@property (nonatomic ,copy) NSString *cruorin;//血红蛋白
@property (nonatomic ,copy) NSString *allergen;//过敏源检测
@property (nonatomic ,copy) NSString *allergenCondition;//过敏源描述
@property (nonatomic ,copy) NSString *boneDensity;//骨密度
@property (nonatomic ,copy) NSString *brainEvoked;//脑干诱发电位
@property (nonatomic ,copy) NSString *typeB;//头颅B超
@property (nonatomic ,copy) NSString *mRI;//头颅MRI
@property (nonatomic ,copy) NSString *colourSonography;//心脏彩超
@property (nonatomic ,copy) NSString *hipB;//髋关节B超
@property (nonatomic ,copy) NSString *examOthers;//其他
@property (nonatomic ,copy) NSString *xray;//X射线
@property (nonatomic ,copy) NSString *hipX;//髋关节X线片

//------------------- 指 导 处 理 ----------------------------------------------
@property (nonatomic, copy) NSString *result;//评价结果
@property (nonatomic, copy) NSString *what;//指导处理
@property (nonatomic, copy) NSString *zKHZ;//专科会诊
@property (nonatomic, copy) NSString *qTother;//其他
@property (nonatomic, copy) NSString *reTraining;//康复训练

@end
