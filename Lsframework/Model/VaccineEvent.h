//
//  VaccineEvent.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VaccineEvent : NSObject
/**
 *{"Month":2,
 "PID":14,"
 InoculationTime":"2月龄",
 "VaccineName":"脊灰灭活疫苗",
 "Effect":"可替代口服脊灰减毒活疫苗，预防脊髓灰质炎。",
 "Part":"2岁以下婴幼儿首选股外侧肌（肌内注射），2岁以上可在上臂三角肌（肌内注射）",
 "Contraindication":"1.对新霉素、链霉素和多粘菌素B等过敏者。\\n\n2.以前接种IPV出现过敏者。\\n\n3.发热或急性疾病患者，应推迟种。\\n\n4.严禁血管内注射。\\n                                                       ","
 UnEffect":"1.注射部位的局部疼痛、发红、硬结。\\n\n2.一过性发热。\\n"}],
 "Message":"成功！"}
 
 */

@property(nonatomic,strong)NSNumber  *InoculationTime;
@property(nonatomic,copy)NSString  *VaccineName;
@property(nonatomic,copy)NSString  *Effect;
@property(nonatomic,copy)NSString  *Part;
@property(nonatomic,copy)NSString  *Contraindication;
@property(nonatomic,copy)NSString  *UnEffect;

@end
