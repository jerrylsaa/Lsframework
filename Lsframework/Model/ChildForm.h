//
//  ChildForm.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildForm : NSObject

@property (nonatomic, copy) NSString* childName;

@property (nonatomic) NSUInteger childSex;

@property (nonatomic) NSUInteger childNation;

@property (nonatomic) NSUInteger nation;

@property (nonatomic, strong) NSString * identityCode;

@property (nonatomic, strong) NSString * guargionName;

@property (nonatomic) NSInteger guargionRelation;//1父2母3其他

@property (nonatomic, strong) NSString * guargianID;

@property (nonatomic, strong) NSString * childTEL;

@property (nonatomic, strong) NSString * childAddress;

@property (nonatomic, strong) NSString * birthDate;

@property (nonatomic, strong) NSString * birthWeight;

@property (nonatomic, strong) NSString * birthHeight;

@property (nonatomic) NSInteger birthWay; //出生方式：1顺产2剖腹产

@property (nonatomic, strong) NSString * birthHospital;

/** 新生儿及围产期*/
@property(nonatomic,assign) NSUInteger childID;//儿童档案ID
@property(nonatomic,copy) NSString* gestationalAge;//孕周
@property(nonatomic,copy) NSString* fetusNum;//第几胎
@property(nonatomic,copy) NSString* birthNum;//第几产
@property(nonatomic,assign) NSUInteger pregnancy;//受孕情况，1自然，2人工，3试管
@property(nonatomic,copy) NSString* pregnancyMark;//体外助孕备注
@property(nonatomic,assign) NSUInteger tireNum;//胎数，1单胎，2双胎，3三胎
@property(nonatomic,copy) NSString* whichTire;//该胎第几个生
@property(nonatomic,assign) NSUInteger childBirth;//分娩方式，1顺产，2破腹产，3难产

/** 母亲孕期情况*/
@property(nonatomic,assign) NSUInteger abortion;//流产，0无，1有
@property(nonatomic,copy) NSString* abortionMark;//流产备注

@property(nonatomic,assign) NSUInteger gestation;//妊娠
@property(nonatomic,copy) NSString* gestationMark;

@property(nonatomic,assign) NSUInteger infection;//急性感染
@property(nonatomic,copy) NSString* infectionMark;

@property(nonatomic,assign) NSUInteger drugs;//应用药物
@property(nonatomic,copy) NSString* drugsMark;

@property(nonatomic,assign) NSUInteger hazardous;//接触有害物质
@property(nonatomic,copy) NSString* hazardousMark;

@property(nonatomic,assign) NSUInteger abnormalPregnancy;//异常孕产
@property(nonatomic,copy) NSString* abnormalPregnancyMark;

@property(nonatomic,copy) NSString* otherMark;//其他备注

/** 家庭遗传史*/
@property(nonatomic,assign) NSUInteger history;//遗传史，0无，1有
@property(nonatomic,copy) NSString* historyMark;//遗传史备注

@property(nonatomic,assign) NSUInteger fatherBearAge;//父亲生育年龄
@property(nonatomic,assign) NSUInteger fatherEducation;//父亲学历,小学1，初中2，高中3，专科4，本科5，硕士6，博士及以上7，其他8）

@property(nonatomic,assign) NSUInteger fatherEverDisease;//父亲曾患疾病
@property(nonatomic,copy) NSString* fatherEverDiseaseMark;

@property(nonatomic,assign) NSUInteger motherBearAge;//母亲生育年龄
@property(nonatomic,assign) NSUInteger motherEducation;//母亲学历,小学1，初中2，高中3，专科4，本科5，硕士6，博士及以上7，其他8）

@property(nonatomic,assign) NSUInteger motherEverDisease;//母亲曾患疾病
@property(nonatomic,copy) NSString* motherEverDiseaseMark;

/** 发育情况*/
@property(nonatomic,copy) NSString* rise;//抬头，大于0的整数，可为空
@property(nonatomic,copy) NSString* turnOver;//翻身
@property(nonatomic,copy) NSString* sit;//坐稳
@property(nonatomic,copy) NSString* overLookClimb;//俯爬
@property(nonatomic,copy) NSString* handClimb;//手膝爬
@property(nonatomic,copy) NSString* stand;//独站
@property(nonatomic,copy) NSString* walk;//独行
@property(nonatomic,copy) NSString* upStairs;//爬楼梯
@property(nonatomic,copy) NSString* run;//跑步
@property(nonatomic,copy) NSString* twoFootJump;//双脚跳
@property(nonatomic,copy) NSString* standOneFoot;//单脚站立
@property(nonatomic,copy) NSString* oneFootJump;//单脚跳
@property(nonatomic,copy) NSString* reach;//伸手够物
@property(nonatomic,copy) NSString* pinch;//拇食指对捏
@property(nonatomic,copy) NSString* callFather;//有意思叫爸爸
@property(nonatomic,copy) NSString* sayGoods;//说物品
@property(nonatomic,copy) NSString* sayPhrase;//说短语
@property(nonatomic,copy) NSString* sayOwnName;//叫自己的名字

@property(nonatomic,copy) UIImage* childImage;





@end
