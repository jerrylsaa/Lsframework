//
//  VaccineViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@interface VaccineViewController : BaseViewController

/**
 *  "ID": 1,
 "Time": 180,          //时间
 "Name": "水痘疫苗",      //疫苗名称
 "Effect": "预防水痘",     //作用
 "Contraindication": "对新霉素全身超敏反应者、鸡蛋过敏者、妊娠期妇女禁用，严重急性感染、发热暂缓接种",   //接种禁忌症
 "PossibleReactions": "可出现一过性发热或轻微皮疹，局部红肿等",
 //可能发生的反应
 "Program": "1-12岁的健康儿童接种1剂；13岁及以上的个体接种2剂，间隔6-10周"
 //免疫程序
 
 */

@property(nonatomic,copy)NSString  *time;
@property(nonatomic,copy)NSString  *Name;
@property(nonatomic,copy)NSString  *Effect;
@property(nonatomic,copy)NSString  *Contraindication;
@property(nonatomic,copy)NSString  *PossibleReactions;
@property(nonatomic,copy)NSString  *Program;

@end
