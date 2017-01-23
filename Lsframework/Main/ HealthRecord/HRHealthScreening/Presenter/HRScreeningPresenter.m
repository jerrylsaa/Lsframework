//
//  HRScreeningPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HRScreeningPresenter.h"
#import "MenuEntity.h"

@interface HRScreeningPresenter ()

@end

@implementation HRScreeningPresenter

- (void)dealWithTheData{
    //生成满数据字典，根据年龄段和性别分别生成数组，通过数组和字典生成新的字典，赋值给子控制器
    //现况
    NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
    allDic[@"实足年龄"] = [self findRealNameByMenuID:_screening.exactAge];
    allDic[@"矫正年龄"] = [self findRealNameByMenuID:_screening.correctAge];
    allDic[@"测量方式"] = [self measuringmethod:_screening.measuringmethod];
    allDic[@"母乳喂养"] = [self breastFeed:_screening.breastFeed];
    allDic[@"配方奶喂养"] = [self formula: _screening.formula];
    allDic[@"辅食添加"] = [self solidFood:_screening.solidFood condition:_screening.foodCondition];
    allDic[@"睡眠"] = [self sleep:_screening.sleep];
    allDic[@"溢奶"] = [self yiNai:_screening.yiNai];
    allDic[@"哭闹"] = [self cryAndScream:_screening.cryAndScream];
    allDic[@"大便情况"] = [self shit:_screening.shit condition:_screening.shitCondition];
    allDic[@"两次随访间患病情况"] = [self illNessCondition:_screening.illNessCondition des:_screening.illconditionDes];
    allDic[@"维生素D/AD"] = [self vitamineD:_screening.vitamineD condition:_screening.vitamineDCondition];
    allDic[@"铁剂"] = [self ferralia:_screening.ferralia];
    allDic[@"钙剂"] = [self ferralia:_screening.calcium];
    allDic[@"其他"] = [self nilAndNull:_screening.others];
    allDic[@"喂养行为"] = [self feedBehavious:_screening.feedBehavious];
    //体格检查
    allDic[@"体重"] =  [self weight:_screening.weight condition:_screening.weightEval];
    allDic[@"身长"] = [self bodyHeight:_screening.bodyHeight condition:_screening.bodyHeightEval];
    allDic[@"头围"] = [self bodyHeight:_screening.headGirth condition:_screening.headGirthEval];
    allDic[@"体温"] = [self temperature:_screening.temperature condition:@"°C"];
    allDic[@"呼吸"] = [self temperature:_screening.breath condition:@"次/分"];
    allDic[@"心率"] = [self temperature:_screening.heartRate condition:@"次/分"];
    allDic[@"精神状态"] = [self mentalState:_screening.mentalState condition:_screening.mentalStateCondition];
    allDic[@"面色"] = [self mentalState:_screening.faceColor condition:_screening.faceColorCondition];
    allDic[@"前卤"] = [self headCondition:_screening.headCondition bregmaCondition:_screening.bregmaCondition bregmaConditionTwo:_screening.bregmaConditionTwo];
    allDic[@"皮肤"] = [self mentalState:_screening.skin condition:_screening.skinCondition];
    allDic[@"淋巴结"] = [self mentalState:_screening.neck condition:_screening.neckCondition];
    allDic[@"眼外观"] = [self unNormalState:_screening.eye menuID:_screening.eyeUnNormal condition:_screening.eyeCondition];
    allDic[@"耳外观"] = [self unNormalState:_screening.ear menuID:_screening.earUnNormal condition:_screening.earCondition];
    allDic[@"口腔"] = [self mentalState:_screening.mouth condition:_screening.mouthCondition];
    allDic[@"胸廓"] = [self mentalState:_screening.chest condition:_screening.chestCondition];
    allDic[@"肺部"] = [self mentalState:_screening.lung condition:_screening.lungCondition];
    allDic[@"心脏"] = [self mentalState:_screening.heart condition:_screening.heartCondition];
    allDic[@"腹部"] = [self unNormalState:_screening.stomach menuID:_screening.stomachUnNormal condition:_screening.sUnNormalCondition];
    allDic[@"脊柱四肢"] = [self unNormalState:_screening.spLimbs menuID:_screening.spLimbsUnNormal condition:_screening.spLimbsCondition];
    allDic[@"肛门会阴"] = [self unNormalState:_screening.anop menuID:_screening.anopUnNormal condition:_screening.anopCondition];
    allDic[@"(男)外生殖器"] = [self edeaState:_screening.medea menuID:_screening.medeaUnNormal condition:_screening.medeaCondition];
    allDic[@"(女)外生殖器"] = [self edeaState:_screening.wedea menuID:_screening.wedeaUnNormal condition:_screening.wedeaCondition];
    //辅助检查
    allDic[@"视力检查"] = [self select:[self nilAndNull:_screening.visionScreen] Menu:@[@"通过",@"异常",@"进一步检查",@"拒检"]];
    allDic[@"听力检查"] = [self select:[self nilAndNull:_screening.hearScreen] Menu:@[@"通过",@"可疑",@"异常",@"拒检"]];
    allDic[@"血红蛋白"] = [NSString stringWithFormat:@"%@ (g/L)",[self nilAndNull:_screening.cruorin]];
    allDic[@"过敏源检测"] = [self allergen:_screening.allergen condition:_screening.allergenCondition];
    allDic[@"骨密度"] = [self select:[self nilAndNull:_screening.boneDensity] Menu:@[@"0-3%骨强度重度低下",@"3-10%骨强度中度低下",@"10-25%骨强度轻度低下",@">25%骨强度正常"]];
    allDic[@"脑干诱发电位"] = [self nilAndNull:_screening.brainEvoked];
    allDic[@"头颅B超"] = [self nilAndNull:_screening.typeB];
    allDic[@"头颅MRI"] = [self nilAndNull:_screening.mRI];
    allDic[@"心脏彩超"] = [self nilAndNull:_screening.colourSonography];
    allDic[@"髋关节B超"] = [self nilAndNull:_screening.hipB];
    allDic[@"其他"] = [self nilAndNull:_screening.examOthers];
    allDic[@"X线片"] = [self nilAndNull:_screening.xray];
    allDic[@"髋关节X线片/B超"] = [self nilAndNull:_screening.hipX];
    //指导处理
    allDic[@"评估/诊断结果"] = [self nilAndNull:_screening.result];
    allDic[@"指导处理"] = @"";
    allDic[@"专科会诊"] = [self nilAndNull:_screening.zKHZ];
    allDic[@"其 他"] = [self nilAndNull:_screening.qTother];
    allDic[@"康复训练"] = [self nilAndNull:_screening.reTraining];
    
    _sourceDic = allDic;
}

#pragma mark Private
- (NSString *)nilAndNull:(id )object{
    if ([object isKindOfClass:[NSNull class]] || object == nil) {
        return @"";
    }
    if ([object isKindOfClass:[NSNumber class]] && [object isEqual:@0]) {
        return @"";
    }
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"0"]) {
        return @"";
    }
    NSString *str;
    if ([object isKindOfClass:[NSNumber class]]) {
        str = [NSString stringWithFormat:@"%@",object];
    }else{
        str = (NSString *)object;
    }
    return str;
}
- (NSString *)select:(NSString *)select Menu:(NSArray *)array{
    NSInteger index = [select integerValue] - 1;
    if (index >= 0 && index <= array.count - 1) {
        return [array objectAtIndex:index];
    }
    return @"";
}
//查询数据库
- (NSString *)findRealNameByMenuID:(id)object{
    if ([object isKindOfClass:[NSNull class]] || object == nil) {
        return @"";
    }
    NSString *menuID;
    if ([object isKindOfClass:[NSNumber class]]) {
        menuID = [NSString stringWithFormat:@"%@",object];
    }else{
        menuID = (NSString *)object;
    }
    
    NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:menuID];
    if (array.count > 0) {
        MenuEntity *entity = array[0];
        return entity.dictionaryName;
    }else{
        return menuID;
    }
    return @"";
}
//测量方式
- (NSString *)measuringmethod:(NSNumber *)measuringmethod{
    if ([[self nilAndNull:measuringmethod] isEqualToString:@""]) {
        return @"";
    }
    if ([measuringmethod isEqual:@1]) {
        return @"站位";
    }else if ([measuringmethod isEqual:@2]){
        return @"卧位";
    }
    return @"";
}
//母乳喂养
- (NSString *)breastFeed:(NSString *)breastFeed{
    breastFeed = [self nilAndNull:breastFeed];
    breastFeed = [self select:breastFeed Menu:@[@"8次及以下 (次/天)",@"9-12次 (次/天)",@"12次及以上 (次/天)",@"按需喂养"]];
    return breastFeed;
}
//配方奶喂养
- (NSString *)formula:(NSString *)formula{
    if (formula == nil || [formula isKindOfClass:[NSNumber class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@ (ml/日)",formula];
}
//辅食添加
- (NSString *)solidFood:(NSString *)solidFood condition:(NSString *)condition{
    if (solidFood == nil || [solidFood isKindOfClass:[NSNull class]] || [solidFood isEqualToString:@"0"]) {
        solidFood = @"";
    }
    if (condition == nil || [condition isKindOfClass:[NSNull class]] || [condition isEqualToString:@"0"]) {
        condition = @"";
    }
    NSString *str = [NSString stringWithFormat:@"%@      %@",solidFood,condition];
    return str;
}
//睡眠
- (NSString *)sleep:(NSString *)sleep{
    sleep = [self nilAndNull:sleep];
    return [self select:sleep Menu:@[@"好",@"中",@"差"]];
}
//溢奶
- (NSString *)yiNai:(NSString *)yiNai{
    yiNai = [self nilAndNull:yiNai];
    yiNai = [self select:yiNai Menu:@[@"一次或以下 (次/天)",@"2-3次 (次/天)",@"4次及以上 (次/天)"]];
    return yiNai;
}
//哭闹
- (NSString *)cryAndScream:(NSString *)cryAndScream{
    cryAndScream = [self nilAndNull:cryAndScream];
    cryAndScream = [self select:cryAndScream Menu:@[@"2次以下 (次/日)",@"3-4次 (次/日)",@"5-6次 (次/日)",@"7次以上 (次/日)"]];
    return cryAndScream;
}
//大便情况
- (NSString *)shit:(NSString *)shit condition:(NSString *)condition{
    shit = [self nilAndNull:shit];
    condition = [self nilAndNull:condition];
    shit = [self select:shit Menu:@[@"干硬",@"松软",@"稀便"]];
    condition = [self select:condition Menu:@[@"一天多次",@"每天1次",@"每两天1次",@"三天1次或者更久"]];
    return [NSString stringWithFormat:@"%@      %@",shit,condition];
}
//两次随访间患病情况
- (NSString *)illNessCondition:(NSNumber *)condition des:(NSString *)description{
    description = [self nilAndNull:description];
    NSString *ness = [self findRealNameByMenuID:condition];
    if ([ness isEqualToString:@"其他"]) {
        return [NSString stringWithFormat:@"%@      %@",ness,description];
    }else{
        return ness;
    }
}
//维生素D/AD
- (NSString *)vitamineD:(NSString *)vitamineD condition:(NSString *)condition{
    if (vitamineD && [vitamineD integerValue]){
        vitamineD = [NSString stringWithFormat:@"%ld",[vitamineD integerValue] + 1];
    }
    
    vitamineD = [self nilAndNull:vitamineD];
    condition = [self nilAndNull:condition];
    vitamineD = [self select:vitamineD Menu:@[@"400-500IU/d",@"500-800IU/d",@"800-1000IU/d",@"未常规补充",@"其他"]];
    if ([vitamineD isEqualToString:@"其他"]) {
        return [NSString stringWithFormat:@"%@      %@",vitamineD,condition];
    }else{
        return vitamineD;
    }
}
//铁剂、钙剂
- (NSString *)ferralia:(NSString *)ferralia{
    ferralia = [self nilAndNull:ferralia];
    if ([ferralia isEqualToString:@""]) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@ (mg/d)",ferralia];
    }
}
//喂养行为
- (NSString *)feedBehavious:(NSString *)feedBehavious{
    feedBehavious = [self nilAndNull:feedBehavious];
    feedBehavious = [self select:feedBehavious Menu:@[@"无特殊",@"胃口差",@"对某种食物特别偏好",@"不良进食习惯",@"父母过度关心",@"害怕进食",@"潜在疾病心态"]];
    return feedBehavious;
}
//体重
- (NSString *)weight:(NSString *)weight condition:(NSString *)condition{
    weight = [self nilAndNull:weight];
    condition = [self nilAndNull:condition];
    condition = [self select:condition Menu:@[@"上",@"中上",@"中+",@"中",@"中-",@"中下",@"下"]];
    if ([weight isEqualToString:@""]) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@kg     评价结果:%@",weight,condition];
    }
}
//身长
- (NSString *)bodyHeight:(NSString *)bodyHeight condition:(NSString *)condition{
    bodyHeight = [self nilAndNull:bodyHeight];
    condition = [self nilAndNull:condition];
    condition = [self select:condition Menu:@[@"上",@"中上",@"中+",@"中",@"中-",@"中下",@"下"]];
    if ([bodyHeight isEqualToString:@""]) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@cm     评价结果:%@",bodyHeight,condition];
    }
}
//体温、呼吸、心率等
- (NSString *)temperature:(NSString *)temperature condition:(NSString *)condition{
    temperature = [self nilAndNull:temperature];
    if ([temperature isEqualToString:@""]) {
        return temperature;
    }else{
        return [NSString stringWithFormat:@"%@ (%@)",temperature,condition];
    }
}
//精神状态/面色/口/胸/肺/心
- (NSString *)mentalState:(NSNumber *)mentalState condition:(NSString *)condition{
    NSString *name = [self findRealNameByMenuID:mentalState];
    condition = [self nilAndNull:condition];
    if (name == nil) {
        return @"";
    }else if ([name isEqualToString:@"其他"]){
        return [NSString stringWithFormat:@"%@      %@",name,condition];
    }else{
        return name;
    }
    return @"";
}
//前卤
- (NSString *)headCondition:(NSString *)headCondition bregmaCondition:(NSString *)bregmaCondition bregmaConditionTwo:(NSString *)bregmaConditionTwo{
    headCondition = [self nilAndNull:headCondition];
    bregmaCondition = [self nilAndNull:bregmaCondition];
    bregmaConditionTwo = [self nilAndNull:bregmaConditionTwo];
    headCondition = [self select:headCondition Menu:@[@"闭合",@"未闭合"]];
    if ([headCondition isEqualToString:@""]) {
        return @"";
    }else if ([headCondition isEqualToString:@"闭合"]){
        return @"闭合";
    }else if ([headCondition isEqualToString:@"未闭合"]){
        return [NSString stringWithFormat:@"未闭合      %@ cm * %@ cm",bregmaCondition,bregmaConditionTwo];
    }
    return @"";
}
//眼耳腹脊柱肛门
- (NSString *)unNormalState:(NSNumber *)state menuID:(NSString *)menuID condition:(NSString *) condition{
    if (state == nil || [state isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([state isEqual:@0]) {
        return @"未见异常";
    }else if ([state isEqual:@1]){
        //异常
        if (menuID == nil || [menuID isKindOfClass:[NSNull class]]) {
            return @"异常";
        }else{
            NSString *name = [self findRealNameByMenuID:menuID];
            if (name == nil) {
                return @"异常";
            }else{
                condition = [self nilAndNull:condition];
                return [NSString stringWithFormat:@"异常      %@      %@",name,condition];
            }
        }
    }else{
        return @"";
    }
    return @"";
}
//外生殖器
- (NSString *)edeaState:(NSString *)state menuID:(NSString *)menuID condition:(NSString *) condition{
    if (state == nil || [state isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([state isEqualToString:@"0"]) {
        return @"未见异常";
    }else if ([state isEqualToString:@"1"]){
        //异常
        if (menuID == nil || [menuID isKindOfClass:[NSNull class]]) {
            return @"异常";
        }else{
            NSString *name = [self findRealNameByMenuID:menuID];
            if (name == nil) {
                return @"异常";
            }else{
                condition = [self nilAndNull:condition];
                return [NSString stringWithFormat:@"异常      %@      %@",name,condition];
            }
        }
    }else if ([state isEqualToString:@"2"]){
        return @"幼稚";
    }
    return @"";
}
//过敏源检测
- (NSString *)allergen:(NSString *)allergen condition:(NSString *)condition{
    allergen = [self nilAndNull:allergen];
    allergen = [self select:allergen Menu:@[@"牛奶",@"蛋类",@"坚果",@"花生",@"鱼",@"虾",@"花粉",@"柳絮",@"虫螨",@"其他"]];
    if ([allergen isEqualToString:@""]) {
        return @"";
    }else if ([allergen isEqualToString:@"其他"]){
        return [NSString stringWithFormat:@"%@      %@",allergen,condition];
    }else{
        return allergen;
    }
    return @"";
}


@end
