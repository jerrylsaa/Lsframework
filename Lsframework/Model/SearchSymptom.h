//
//  SearchSymptom.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/4.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchSymptom : NSObject
/**
 *  {
 "RowID": 2,
 "ConsultationType": 0,
 "DiseaseTitle": "麻痹",
 "TitleHref": "http://zzk.xywy.com/2633_gaishu.html",
 "Image": "http://xs3.op.xywy.com/api.iu1.xywy.com/jib/20160509/04c148b4d31fd39fde7db29730342fbd59022.jpg",
 "TitleIntroduce": "广义的麻痹是指机体的细胞、组织和器官的机能衰退，对刺激不发生反应的状态。狭义的麻...",
 "DiseaseName1": "格子状角膜营养不良",
 "DiseaseName2": "颅骨巨细胞瘤",
 "DiseaseName3": "小儿热性惊厥",
 "DiseaseName4": "老年人高钾血症",
 "DiseaseName5": "急性全自主神经失调症",
 "DiseaseIntro1": "格子状角膜营养不良(la...",
 "DiseaseIntro2": "颅骨巨细胞瘤以蝶骨和颞骨...",
 "DiseaseIntro3": "热性惊厥(febrile...",
 "DiseaseIntro4": "高钾血症是指血清钾&gt;...",
 "DiseaseIntro5": "急性全自主神经失调症(a...",
 "DiseaseHref1": "http://3g.jib.xywy.com/il_sii_5691.htm",
 "DiseaseHref2": "http://3g.jib.xywy.com/il_sii_6355.htm",
 "DiseaseHref3": "http://3g.jib.xywy.com/il_sii_7604.htm",
 "DiseaseHref4": "http://3g.jib.xywy.com/il_sii_6149.htm",
 "DiseaseHref5": "http://3g.jib.xywy.com/il_sii_5835.htm",
 "MoreUrl": "http://3g.jib.xywy.com/zzk"
 }
 */
@property (nonatomic, strong) NSNumber *RowID;
@property (nonatomic, copy) NSString *DiseaseTitle;
@property (nonatomic, copy) NSString *TitleHref;
@property (nonatomic, copy) NSString *Image;
@property (nonatomic, copy) NSString *TitleIntroduce;
@property (nonatomic, copy) NSString *DiseaseName1;
@property (nonatomic, copy) NSString *DiseaseName2;
@property (nonatomic, copy) NSString *DiseaseName3;
@property (nonatomic, copy) NSString *DiseaseName4;
@property (nonatomic, copy) NSString *DiseaseName5;


@property (nonatomic, copy) NSString *DiseaseIntro1;
@property (nonatomic, copy) NSString *DiseaseIntro2;
@property (nonatomic, copy) NSString *DiseaseIntro3;
@property (nonatomic, copy) NSString *DiseaseIntro4;
@property (nonatomic, copy) NSString *DiseaseIntro5;

@property (nonatomic, copy) NSString *DiseaseHref1;
@property (nonatomic, copy) NSString *DiseaseHref2;
@property (nonatomic, copy) NSString *DiseaseHref3;
@property (nonatomic, copy) NSString *DiseaseHref4;
@property (nonatomic, copy) NSString *DiseaseHref5;

@property (nonatomic, copy) NSString *MoreUrl;


@end
