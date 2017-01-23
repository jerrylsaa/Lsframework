//
//  PersonFilePresenter.m
//  FamilyPlatForm
//
//  Created by MAC on 16/5/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PersonFilePresenter.h"
#import "FPNetwork.h"
#import "DefaultChildEntity.h"
#import "MenuEntity.h"


@implementation PersonFilePresenter

- (instancetype)init{
    self = [super init];
    if (self) {
        _child = [ChildForm new];
        _contentArray = [NSMutableArray array];
        [self initTextArray];
    }
    return self;
}


- (void)initTextArray{
    _textArray = [NSMutableArray array];
    NSArray *array_1 = @[@"姓名",@"性别",@"国籍",@"民族",@"出生体重",@"出生身长",@"出生日期",@"出生医院",@"监护人身份",@"监护人",@"家庭住址",@"联系电话",@"宝宝身份证",@"监护人身份证"];
    [_textArray addObject:array_1];
    NSArray *array_2 = @[@"孕周",@"受孕情况",@"胎产次",@"胎数",@"分娩方式"];
    [_textArray addObject:array_2];
    NSArray *array_3 = @[@"先兆流产",@"妊娠合并症",@"急性感染",@"应用药物",@"接触有害物质",@"异常孕产史",@"其他"];
    [_textArray addObject:array_3];
    NSArray *array_4 = @[@"家庭遗传史",@"父亲生育年龄",@"父亲文化程度",@"父亲曾患疾病",@"母亲生育年龄",@"母亲文化程度",@"母亲曾患疾病"];
    [_textArray addObject:array_4];
    NSArray *array_5 = @[@"抬头",@"翻身",@"坐稳",@"俯爬",@"手膝爬",@"独站",@"独行",@"上楼梯/台阶",@"跑步",@"双脚跳",@"单脚站立",@"单脚跳",@"伸手够物",@"拇食指对捏",@"有意识叫爸爸/妈妈",@"说3个物品的名字",@"说2-3个字的短语",@"说自己的名字"];
    [_textArray addObject:array_5];
}

- (void)loadChildFormBy:(NSInteger)babyId complete:(CompleteHander)block{
    
    
    
    WS(ws);
    [[FPNetwork POST:API_PHONE_GET_BABY_EMR_INFO withParams:@{@"babyID":@(babyId)}] addCompleteHandler:^(FPResponse *response) {
        NSDictionary* dic = response.data[0];
    
        ChildForm *child = [ChildForm new];
        child.childID = babyId;
        child.childName = [self transStr:dic[@"CHILD_NAME"]];
        child.childSex = (dic[@"CHILD_SEX"] && ![dic[@"CHILD_SEX"] isKindOfClass:[NSNull class]])?[dic[@"CHILD_SEX"] integerValue ]:1;
        child.childNation = (dic[@"CHILD_NATION"] && ![dic[@"CHILD_NATION"] isKindOfClass:[NSNull class]])?[dic[@"CHILD_NATION"] integerValue ]:0;
        child.nation = (dic[@"NATION"] && ![dic[@"NATION"] isKindOfClass:[NSNull class]])?[dic[@"NATION"] integerValue]:0;
        child.birthWeight = [self transStr:dic[@"BIRTH_WEIGHT"]];
        child.birthHeight = [self transStr:dic[@"BIRTH_HEIGHT"]];
        child.birthDate = [self transStr:dic[@"BIRTH_DATE"]];
        child.birthHospital = [self transStr:dic[@"BIRTHHOSPITAL"]];
        child.guargionRelation = (dic[@"GUARGIAN_RELATION"] && ![dic[@"GUARGIAN_RELATION"] isKindOfClass:[NSNull class]])?[dic[@"GUARGIAN_RELATION"] integerValue]:0;
        child.guargionName = [self transStr:dic[@"GUARGIAN_NAME"]];
        child.childAddress = [self transStr:dic[@"CHILD_ADDRESS"]];
        child.childTEL = [self transStr:dic[@"CHILD_TEL"]];
        child.gestationalAge = [self transStr:dic[@"GESTATIONAL_AGE"]];
        child.pregnancy = (dic[@"PREGNANCY_MODE"] && ![dic[@"PREGNANCY_MODE"] isKindOfClass:[NSNull class]])?[dic[@"PREGNANCY_MODE"] integerValue]:0;
        child.pregnancyMark = @"";
        child.tireNum = (dic[@"TIRE_SINGLE_DOUBLE"] && ![dic[@"TIRE_SINGLE_DOUBLE"] isKindOfClass:[NSNull class]])?[dic[@"TIRE_SINGLE_DOUBLE"] integerValue]:0;
        child.whichTire = [self transStr:dic[@"TIRE_NUMBER"]];
        child.childBirth = (dic[@"BIRTH_WAY"] && ![dic[@"BIRTH_WAY"] isKindOfClass:[NSNull class]])?[dic[@"BIRTH_WAY"] integerValue]:0;
        child.abortion = (dic[@"XZLC"] && ![dic[@"XZLC"] isKindOfClass:[NSNull class]])?[dic[@"XZLC"] integerValue]:0;
//        child.abortionMark
        child.gestation = (dic[@"RSHBZ"] && ![dic[@"RSHBZ"] isKindOfClass:[NSNull class]])?[dic[@"RSHBZ"] integerValue]:0;
        child.gestationMark = [self transStr:dic[@"RSHBZ2"]];
        child.infection = (dic[@"JXGR"] && ![dic[@"JXGR"] isKindOfClass:[NSNull class]])?[dic[@"JXGR"] integerValue]:0;
        child.infectionMark = [self transStr:dic[@"JXGR2"]];
        child.drugs = (dic[@"YYYW"] && ![dic[@"YYYW"] isKindOfClass:[NSNull class]])?[dic[@"YYYW"] integerValue]:0;
        child.drugsMark = [self transStr:dic[@"YYYW2"]];
        child.hazardous = (dic[@"JCYHWZ"] && ![dic[@"JCYHWZ"] isKindOfClass:[NSNull class]])?[dic[@"JCYHWZ"] integerValue]:0;
        child.hazardousMark = [self transStr:dic[@"JCYHWZ2"]];
        child.abnormalPregnancy = (dic[@"JWYCYCS"] && ![dic[@"JWYCYCS"] isKindOfClass:[NSNull class]])?[dic[@"JWYCYCS"] integerValue]:0;
        child.abnormalPregnancyMark = [self transStr:dic[@"JWYCYCS2"]];
        child.otherMark = [self transStr:dic[@"MYQQT"]];
        child.history = (dic[@"JZYCS1"] && ![dic[@"JZYCS1"] isKindOfClass:[NSNull class]])?[dic[@"JZYCS1"] integerValue]:0;
        child.historyMark = [self transStr:dic[@"JZYCS2"]];
        child.fatherBearAge = (dic[@"FQSYNL"] && ![dic[@"FQSYNL"] isKindOfClass:[NSNull class]])?[dic[@"FQSYNL"] integerValue]:0;
        child.fatherEducation = (dic[@"FQWHCD"] && ![dic[@"FQWHCD"] isKindOfClass:[NSNull class]])?[dic[@"FQWHCD"] integerValue]:0;
        child.fatherEverDisease = (dic[@"FQCHJB1"] && ![dic[@"FQCHJB1"] isKindOfClass:[NSNull class]])?[dic[@"FQCHJB1"] integerValue]:0;
        child.fatherEverDiseaseMark = [self transStr:dic[@"FQCHJB2"]];
        child.motherBearAge = (dic[@"MQSYNL"] && ![dic[@"MQSYNL"] isKindOfClass:[NSNull class]])?[dic[@"MQSYNL"] integerValue]:0;
        child.motherEducation = (dic[@"MQWHCD"] && ![dic[@"MQWHCD"] isKindOfClass:[NSNull class]])?[dic[@"MQWHCD"] integerValue]:0;
        child.motherEverDisease = (dic[@"MQCHJB1"] && ![dic[@"MQCHJB1"] isKindOfClass:[NSNull class]])?[dic[@"MQCHJB1"] integerValue]:0;
        child.motherEverDiseaseMark = [self transStr:dic[@"MQCHJB2"]];
        child.rise = [self transStr:dic[@"TT"]];
        child.turnOver = [self transStr:dic[@"FS"]];
        child.sit = [self transStr:dic[@"ZW"]];
        child.overLookClimb = [self transStr:dic[@"FP"]];
        child.handClimb = [self transStr:dic[@"SXP"]];
        child.stand = [self transStr:dic[@"DZ"]];
        child.walk = [self transStr:dic[@"DX"]];
        child.upStairs = [self transStr:dic[@"PLT"]];
        child.run = [self transStr:dic[@"P"]];
        child.twoFootJump = [self transStr:dic[@"SJT"]];
        child.stand = [self transStr:dic[@"DZ"]];
        child.oneFootJump = [self transStr:dic[@"DJT"]];
        child.standOneFoot = [self transStr:dic[@"DJZL"]];
        child.reach = [self transStr:dic[@"SSGW"]];
        child.pinch = [self transStr:dic[@"MSZDN"]];
        child.callFather = [self transStr:dic[@"JBM"]];
        child.sayGoods = [self transStr:dic[@"SWP"]];
        child.sayPhrase = [self transStr:dic[@"ESDY"]];
        child.sayOwnName = [self transStr:dic[@"ZJMZ"]];
        child.identityCode =[self transStr:dic[@"IDentity_Code"]];
        child.guargianID =[self transStr:dic[@"Guargian_ID"]];
        //胎产次
        NSString *str = (dic[@"BIRTH_HISTORY"] && ![dic[@"BIRTH_HISTORY"] isKindOfClass:[NSNull class]])?dic[@"BIRTH_HISTORY"]:@"_";
        if (str.length == 3) {
            child.fetusNum = [str substringToIndex:1];
            child.birthNum = [str substringFromIndex:2];
        }else{
            child.fetusNum = @"";
            child.birthNum = @"";
        }
        
//        NSDictionary *newDic = @{
//                                 
//                                
//                                 @"reach":dic[@"SSGW"]?dic[@"SSGW"]:@"",
//                                 @"pinch":dic[@"MSZDN"]?dic[@"MSZDN"]:@"",
//                                 @"callFather":dic[@"JBM"]?dic[@"JBM"]:@"",
//                                 @"sayGoods":dic[@"SWP"]?dic[@"SWP"]:@"",
//                                 @"sayPhrase":dic[@"ESDY"]?dic[@"ESDY"]:@"",
////                                 @"sayOwnName":dic[@"ZJMZ"]?dic[@"ZJMZ"]:@""
//                                 @"childName":dic[@"CHILD_NAME"]?dic[@"CHILD_NAME"]:@"",
//                                 @"childSex":dic[@"CHILD_SEX"]?dic[@"CHILD_SEX"]:@"",
//                                 @"childNation":dic[@"CHILD_NATION"]?dic[@"CHILD_NATION"]:@"",
//                                 @"nation":dic[@"NATION"]?dic[@"NATION"]:@"",
//                                 
//                                 @"birthWeight":dic[@"BIRTH_WEIGHT"]?dic[@"BIRTH_WEIGHT"]:@"",
//                                 @"birthHeight":dic[@"BIRTH_HEIGHT"]?dic[@"BIRTH_HEIGHT"]:@"",
//                                 @"birthDate":dic[@"BIRTH_DATE"]?dic[@"BIRTH_DATE"]:@"",
//                                 @"birthHospital":dic[@"BIRTHHOSPITAL"]?dic[@"BIRTHHOSPITAL"]:@"",
//                                 
//                                 @"guargionRelation":dic[@"GUARGIAN_RELATION"]?dic[@"GUARGIAN_RELATION"]:@"",
//                                 @"guargionName":dic[@"GUARGIAN_NAME"]?dic[@"GUARGIAN_NAME"]:@"",
//                                 @"childAddress":dic[@"CHILD_ADDRESS"]?dic[@"CHILD_ADDRESS"]:@"",
//                                 @"childTEL":dic[@"CHILD_TEL"]?dic[@"CHILD_TEL"]:@"",
//                                 @"gestationalAge":dic[@"GESTATIONAL_AGE"]?dic[@"GESTATIONAL_AGE"]:@"",
//                                 @"pregnancy":dic[@"PREGNANCY_MODE"]?dic[@"PREGNANCY_MODE"]:@"",
//                                 @"tireNum":dic[@"TIRE_SINGLE_DOUBLE"]?dic[@"TIRE_SINGLE_DOUBLE"]:@"",
//                                 @"whichTire":dic[@"TIRE_NUMBER"]?dic[@"TIRE_NUMBER"]:@"",
//                                 @"childBirth":dic[@"BIRTH_WAY"]?dic[@"BIRTH_WAY"]:@"",
//                                 @"abortion":dic[@"XZLC"]?dic[@"XZLC"]:@"",
//                                 @"gestation":dic[@"RSHBZ"]?dic[@"RSHBZ"]:@"",
//                                 @"gestationMark":dic[@"RSHBZ2"]?dic[@"RSHBZ2"]:@"",
//                                 @"infection":dic[@"JXGR"]?dic[@"JXGR"]:@"",
//                                 @"infectionMark":dic[@"JXGR2"]?dic[@"JXGR2"]:@"",
//                                 @"drugs":dic[@"YYYW"]?dic[@"YYYW"]:@"",
//                                 @"drugsMark":dic[@"YYYW2"]?dic[@"YYYW2"]:@"",
//                                 @"hazardous":dic[@"JCYHWZ"]?dic[@"JCYHWZ"]:@"",
//                                 @"hazardousMark":dic[@"JCYHWZ2"]?dic[@"JCYHWZ2"]:@"",
//                                 @"abnormalPregnancy":dic[@"JWYCYCS"]?dic[@"JWYCYCS"]:@"",
//                                 @"abnormalPregnancyMark":dic[@"JWYCYCS2"]?dic[@"JWYCYCS2"]:@"",
//                                 
//                                 @"otherMark":dic[@"MYQQT"]?dic[@"MYQQT"]:@"",
//                                 @"history":dic[@"JZYCS1"]?dic[@"JZYCS1"]:@"",
//                                 @"historyMark":dic[@"JZYCS2"]?dic[@"JZYCS2"]:@"",
//                                 
//                                 @"fatherBearAge":dic[@"FQSYNL"]?dic[@"FQSYNL"]:@"",
//                                 @"fatherEducation":dic[@"FQWHCD"]?dic[@"FQWHCD"]:@"",
//                                 @"fatherEverDisease":dic[@"FQCHJB1"]?dic[@"FQCHJB1"]:@"",
//                                 @"fatherEverDiseaseMark":dic[@"FQCHJB2"]?dic[@"FQCHJB2"]:@"",
//                                 
//                                 @"motherBearAge":dic[@"MQSYNL"]?dic[@"MQSYNL"]:@"",
//                                 @"motherEducation":dic[@"MQWHCD"]?dic[@"MQWHCD"]:@"",
//                                 @"motherEverDisease":dic[@"MQCHJB1"]?dic[@"MQCHJB1"]:@"",
//                                 @"motherEverDiseaseMark":dic[@"MQCHJB2"]?dic[@"MQCHJB2"]:@"",
//                                 @"rise":dic[@"TT"]?dic[@"TT"]:@"",
//                                 @"turnOver":dic[@"FS"]?dic[@"FS"]:@"",
//                                 @"sit":dic[@"ZW"]?dic[@"ZW"]:@"",
//                                 @"overLookClimb":dic[@"FP"]?dic[@"FP"]:@"",
//                                 @"handClimb":dic[@"SXP"]?dic[@"SXP"]:@"",
//                                 @"stand":dic[@"DZ"]?dic[@"DZ"]:@"",
//                                 @"walk":dic[@"DX"]?dic[@"DX"]:@"",
//                                 @"upStairs":dic[@"PLT"]?dic[@"PLT"]:@"",
//                                 @"run":dic[@"P"]?dic[@"P"]:@"",
//                                 @"twoFootJump":dic[@"SJT"]?dic[@"SJT"]:@"",
//                                 @"standOneFoot":dic[@"DJZL"]?dic[@"DJZL"]:@"",
//                                 @"oneFootJump":dic[@"DJT"]?dic[@"DJT"]:@"",
//                                 };
//        NSArray *modelArray = [ChildForm mj_objectArrayWithKeyValuesArray:@[newDic]];
        ws.child = child;
        block(response.success);
    }];
}

- (void)upload{
    ChildForm *child = self.child;
    
    if (!_child.childName || _child.childName.length == 0 || [_child.childName trimming].length == 0) {
        [ProgressUtil showInfo:@"请输入姓名"];
        return;
    }
    
    if(_child.childName.length > 5){
        [ProgressUtil showInfo:@"请输入少于5个字的名字"];
        return ;
    }
    
    if (_child.childSex == 0) {
        [ProgressUtil showInfo:@"请选择性别"];
        return ;
    }
    
    NSString* childNation = nil;
    if (_child.childNation == 0) {
//        [ProgressUtil showInfo:@"请选择国籍"];
//        return;
    }else{
        childNation = [NSString stringWithFormat:@"%ld",_child.childNation];
    }
    
    NSString* nation = nil;
    if (_child.nation == 0) {
//        [ProgressUtil showInfo:@"请选择民族"];
//        return;
    }else{
        nation = [NSString stringWithFormat:@"%ld",_child.nation];
    }
    
    if(_child.birthWeight.length == 0 || [_child.birthWeight isEqualToString:@"0"]) {
//        [ProgressUtil showInfo:@"请输入体重"];
//        return;
        _child.birthWeight = @"";
    }else{
        BOOL isNumber = [_child.birthWeight regexNumber] || [_child.birthWeight isPureNumber];
        if(!isNumber){
            [ProgressUtil showInfo:@"出生体重请输入数字"];
            return ;
        }
    }
    
    if (_child.birthHeight.length == 0 || [_child.birthHeight isEqualToString:@"0"]) {
//        [ProgressUtil showInfo:@"请输入身高"];
//        return;
        _child.birthHeight = @"";
    }else{
        BOOL isNumber = [_child.birthHeight regexNumber] || [_child.birthHeight isPureNumber];
        if(!isNumber){
            [ProgressUtil showInfo:@"出生身长请输入数字"];
            return ;
        }
    }
    
    if (!_child.birthDate || _child.birthDate.length == 0) {
        [ProgressUtil showInfo:@"请选择出生日期"];
        return ;
    }else{
        NSTimeInterval birthTime = [NSDate compareDate:_child.birthDate];
        NSInteger year = birthTime/(60*60*24*365);
        if(year >= 18){
            [ProgressUtil showInfo:@"请选择18岁以下的出生日期"];
            return ;
        }
    }
    
    if(_child.birthHospital.length == 0) {
//        [ProgressUtil showInfo:@"请输入出生医院"];
//        return;
        _child.birthHospital = @"";
    }
    
    if (_child.guargionRelation == 0) {
        [ProgressUtil showInfo:@"请选择监护人关系"];
        return ;
    }
    
    
    if (!_child.guargionName || _child.guargionName.length == 0 || [_child.guargionName trimming].length == 0) {
        [ProgressUtil showInfo:@"请填写监护人姓名"];
        return ;
    }
    
    if (_child.childAddress.length == 0) {
        [ProgressUtil showInfo:@"请输入家庭住址"];
        return;
    }
    
    if(_child.childTEL.length == 0){
        [ProgressUtil showInfo:@"请输入联系电话"];
        return;
    }else if(![_child.childTEL checkPhone] || [_child.childTEL trimming].length == 0){
        [ProgressUtil showInfo:@"请填写手机号码/输入正确格式"];
        return ;
    }

    
    NSDictionary *dic = @{@"UserID":@(kCurrentUser.userId),
                          @"Child_ID":@(child.childID),
                          @"Child_Name":child.childName.length!=0 ? child.childName:@"",
                          @"Child_Sex":child.childSex!=0 ? @(child.childSex) : @1,
                          @"Child_Nation":child.childNation!=0 ? @(child.childNation) : @"",
                          @"Nation":child.nation!=0 ? @(child.nation) : @"",
                          @"Guargian_Name":child.guargionName.length!=0 ? child.guargionName : @"",
                          @"Guargian_Relation":child.guargionRelation!=0 ? @(child.guargionRelation) : @"",
                          @"Child_TEL":child.childTEL.length!=0 ? child.childTEL : @"",
                          @"Child_Address":child.childAddress.length!=0 ? child.childAddress : @"",
                          @"IDentity_Code":(child.identityCode.length!=0?child.identityCode:@""),
                          @"Guargian_ID":(child.guargianID.length!=0?child.guargianID:@""),
                          @"Birth_Date":child.birthDate.length!=0 ? child.birthDate : @"",
                          @"Birth_Weight":child.birthWeight.length!=0 ? child.birthWeight : @"",
                          @"Birth_Height":child.birthHeight.length!=0 ? child.birthHeight :@"",
                          @"Birth_Hospital":child.birthHospital.length!=0 ? child.birthHospital : @"",
                          @"Gestational_Age":child.gestationalAge.length!=0 ? child.gestationalAge : @"",
                          @"Fetus_Num":child.fetusNum.length!=0 ? child.fetusNum : @"",
                          @"Birth_Num":child.birthNum.length!=0 ? child.birthNum : @"",
                          @"Pregnancy":child.pregnancy!=0 ? @(child.pregnancy) : @"",
                          @"Pregnancy_Mark":child.pregnancyMark.length!=0 ? child.pregnancyMark : @"",
                          @"Tire_Num":child.tireNum!=0 ? @(child.tireNum) : @"",
                          @"Which_Tire":child.whichTire.length!=0 ? child.whichTire : @"",
                          @"Child_Birth":child.childBirth!=0 ? @(child.childBirth) : @"",
                          @"Abortion":@(child.abortion),
                          @"Abortion_Mark":@"",
                          @"Pregnancy_Complications":child.gestation!=0 ? @(child.gestation) : @"",
                          @"Pregnancy_Complications_Mark":child.gestationMark.length!=0 ? child.gestationMark : @"",
                          @"Acute_Infection":child.infection!=0 ? @(child.infection) : @"",
                          @"Acute_Infection_Mark":child.infectionMark.length!=0 ? child.infectionMark : @"",
                          @"Applied_Drugs":@(child.drugs),
                          @"Applied_Drugs_Mark":child.drugsMark.length != 0 ? child.drugsMark : @"",
                          @"Hazardous_Substances":child.hazardous!=0 ? @(child.hazardous) : @"",
                          @"Hazardous_Substances_Mark":child.hazardousMark.length!=0 ? child.hazardousMark : @"",
                          @"Abnormal_Pregnancy":child.abnormalPregnancy!=0 ? @(child.abnormalPregnancy) : @"",
                          @"Abnormal_Pregnancy_Mark":child.abnormalPregnancyMark.length!=0 ? child.abnormalPregnancyMark : @"",
                          @"Pregnancy_Other":child.otherMark.length!=0 ? child.otherMark : @"",
                          @"Family_History":child.history!=0 ? @(child.history) : @"",
                          @"Family_History_Mark":child.historyMark.length!=0 ? child.historyMark : @"",
                          @"Father_BearingAge":child.fatherBearAge!=0 ? @(child.fatherBearAge) : @"",
                          @"Father_Education":child.fatherEducation!=0 ? @(child.fatherEducation) : @"",
                          @"Father_EverDisease":@(child.fatherEverDisease),
                          @"Father_EverDisease_Mark":child.fatherEverDiseaseMark.length!=0 ? child.fatherEverDiseaseMark : @"",
                          @"Mother_BearingAge":child.motherBearAge!=0 ? @(child.motherBearAge) : @"",
                          @"Mother_Education":child.motherEducation!=0 ? @(child.motherEducation) : @"",
                          @"Mother_EverDisease":@(child.motherEverDisease),
                          @"Mother_EverDisease_Mark":child.motherEverDiseaseMark.length!=0 ? child.motherEverDiseaseMark : @"",
                          @"Rise":(child.rise.length!=0 || [child.rise integerValue] != 0) ? child.rise : @"",
                          @"Turn_Over":(child.turnOver.length!=0 || [child.turnOver integerValue] != 0) ? child.turnOver : @"",
                          @"Sit_Steadily":(child.sit.length!=0 || [child.sit integerValue] != 0) ? child.sit : @"",
                          @"Overlooking_Climb":(child.overLookClimb.length!=0 || [child.overLookClimb integerValue] != 0) ? child.overLookClimb : @"",
                          @"Handknee_Climb":(child.handClimb.length!=0 || [child.handClimb integerValue] != 0) ? child.handClimb : @"",
                          @"Stand_Alone":(child.stand.length!=0 || [child.stand integerValue] != 0) ? child.stand : @"",
                          @"Walk_Alone":(child.walk.length!=0 || [child.walk integerValue] != 0) ? child.walk : @"",
                          @"Up_Stairs":(child.upStairs.length!=0 || [child.upStairs integerValue] != 0) ? child.upStairs : @"",
                          @"Run":(child.run.length!=0 || [child.run integerValue] != 0) ? child.run : @"",
                          @"Jump_TwoFoot":(child.twoFootJump.length!=0 || [child.standOneFoot integerValue] != 0) ? child.standOneFoot : @"",
                          @"Stand_OneFoot":(child.standOneFoot.length!=0 || [child.run integerValue] != 0) ? child.run : @"",
                          @"Jump_OneFoot":(child.oneFootJump.length!=0 || [child.oneFootJump integerValue] != 0) ? child.oneFootJump : @"",
                          @"Reaching_Object":(child.reach.length!=0 || [child.reach integerValue] != 0) ? child.reach : @"",
                          @"Pinch":(child.pinch.length!=0 || [child.pinch integerValue] != 0) ? child.pinch : @"",
                          @"Call_BaMa":(child.callFather.length!=0 || [child.callFather integerValue] != 0) ? child.callFather : @"",
                          @"Say_Goods":(child.sayGoods.length!=0 || [child.sayGoods integerValue] != 0) ? child.sayGoods : @"",
                          @"Say_Phrase":(child.sayPhrase.length!=0 || [child.sayPhrase integerValue] != 0) ? child.sayPhrase : @"",
                          @"Call_OwnName":(child.sayOwnName.length!=0 || [child.sayOwnName integerValue] != 0) ? child.sayOwnName : @"",
                          };
    WS(ws);
    [[FPNetwork POST:API_PHONE_EDIT_ALL_BABY_EMR withParams:dic] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(saveCompletion:info:)]){
            [ws.delegate saveCompletion:response.success info:response.message];
        }
    }];
    
}

- (NSString *)transStr:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}
//入口处的加载
- (void)loadMenuData:(CompleteHander)block{
    //获取菜单字典
//    [MenuEntity MR_truncateAll];
    //获取所有菜单实体，取得所有时间戳，取最大上传
    //首次上传取 2016-01-01 10:00:00 +0000
    NSArray *menuArray = [MenuEntity findAllTimestamp];
    NSString *timeStamp;
    if (menuArray.count > 0) {
//        NSTimeInterval time = [[menuArray firstObject] doubleValue];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        timeStamp = [self formatterDate:date];
        block(YES);
        return;
    }else{
        timeStamp = @"2016-01-01 10:00:00 +0000";
    }
    
    NSDictionary *paratemers = @{@"Timestamp":timeStamp};
     [ProgressUtil showWithStatus:@"加载菜单数据中..."];
    [[FPNetwork POST:API_PHONE_QUERY_DATA_DICTIONARY withParams:paratemers] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"");
        if (response.success == YES) {
            NSArray *dataArray = response.data;
            if(dataArray.count != 0){
                //处理不对应的key
                NSMutableArray *newArray = [NSMutableArray array];
                for (NSDictionary *dic in dataArray) {
                    /*
                     createDate = 1452580919;
                     dictionaryName = "\U4e2d\U56fd";
                     menuId = 59;
                     parentId = 18;
                     
                     {"ID":1429,
                     "Dictionary_Name":"尘螨",
                     "Parent_ID":410,
                     "CreateDate":1457512508}
                     
                     */
                    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                    [newDic setObject:[dic objectForKey:@"ID"] forKey:@"menuId"];
                    [newDic setObject:[dic objectForKey:@"Dictionary_Name"] forKey:@"dictionaryName"];
                    [newDic setObject:[dic objectForKey:@"Parent_ID"] forKey:@"parentId"];
                    [newDic setObject:[dic objectForKey:@"CreateDate"] forKey:@"createDate"];
                    [newArray addObject:newDic];
                }
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    [MenuEntity mj_objectArrayWithKeyValuesArray:newArray context:localContext];
                }completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    if (contextDidSave == YES) {
                        block(YES);
                    }else{
                        block(NO);
                    }
                }];
            }else{
                block(NO);
            }
        }else{
            block(NO);
        }
    }];
}

- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    return [formatter stringFromDate:date];
}

@end
