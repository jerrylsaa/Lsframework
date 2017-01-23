//
//  ArchivesRecordPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ArchivesRecordPresenter.h"
#import "NSString+Category.h"
#import "DefaultChildEntity.h"

@implementation ArchivesRecordPresenter

-(void)commitChildArchives:(ChildForm *)childForm{
    
    if (!childForm.childName || childForm.childName.length == 0 || [childForm.childName trimming].length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写姓名"];
        return;
    }
    
    if(childForm.childName.length > 5){
        [_delegate onCommitChildArchivesComplete:NO info:@"请输入少于5个字的名字"];
        return ;
    }
    
    if (childForm.childSex == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择性别"];
        return ;
    }
    
    NSString* childNation = nil;
    if (childForm.childNation == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请选择国籍"];
//        return;
        childNation = @"";
    }else{
        childNation = [NSString stringWithFormat:@"%ld",childForm.childNation];
    }
    
    NSString* nation = nil;
    if (childForm.nation == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请选择民族"];
//        return;
        nation = @"";
    }else{
        nation = [NSString stringWithFormat:@"%ld",childForm.nation];
    }
    
    if(childForm.birthWeight.length == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请输入体重"];
//        return;
        childForm.birthWeight = @"";
    }else{
        BOOL isNumber = [childForm.birthWeight regexNumber] || [childForm.birthWeight isPureNumber];
        if(!isNumber){
            [_delegate onCommitChildArchivesComplete:NO info:@"出生体重请输入数字"];
            return ;
        }
    }
    
    if (childForm.birthHeight.length == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请输入身高"];
//        return;
        childForm.birthHeight = @"";
    }else{
        BOOL isNumber = [childForm.birthHeight regexNumber] || [childForm.birthHeight isPureNumber];
        if(!isNumber){
            [_delegate onCommitChildArchivesComplete:NO info:@"出生身长请输入数字"];
            return ;
        }
    }
    
    if (!childForm.birthDate || childForm.birthDate.length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择出生日期"];
        return ;
    }else{
        NSTimeInterval birthTime = [NSDate compareDate:childForm.birthDate];
        NSInteger year = birthTime/(60*60*24*365);
        if(year >= 18){
            [_delegate onCommitChildArchivesComplete:NO info:@"请选择18岁以下的出生日期"];
            return ;
        }
    }
    
    if(childForm.birthHospital.length == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请输入出生医院"];
//        return;
        childForm.birthHospital = @"";
    }
    
    if (childForm.guargionRelation == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择监护人关系"];
        return ;
    }


    if (!childForm.guargionName || childForm.guargionName.length == 0 || [childForm.guargionName trimming].length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写监护人姓名"];
        return ;
    }
    
    if (childForm.childAddress.length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请输入家庭住址"];
        return;
    }
    
    if(childForm.childTEL.length == 0){
        [_delegate onCommitChildArchivesComplete:NO info:@"请输入联系电话"];
        return;
    }else if(![childForm.childTEL checkPhone] || [childForm.childTEL trimming].length == 0){
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写手机号码/输入正确格式"];
        return ;
    }
    
    if (!childForm.identityCode || childForm.identityCode.length == 0 ) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请输入宝宝身份证"];
//        return ;
        childForm.identityCode = @"";
    }
    if (!childForm.guargianID || childForm.guargianID.length == 0 ) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请填写监护人身份证"];
//        return ;
        childForm.guargianID = @"";
    }
    
    
 
    
    
    NSDictionary * params = @{
                              @"UserID": @(kCurrentUser.userId),
                              @"Child_Name":childForm.childName,
                              @"Child_Sex": @(childForm.childSex),
                              @"Child_Nation": childNation,
                              @"Nation":nation,
                              @"Guargian_Name": childForm.guargionName,
                              @"Guargian_Relation": @(childForm.guargionRelation),
//                              @"Guargian_ID": childForm.guargianID,
                              @"Child_TEL": childForm.childTEL,
                              @"Child_Address": childForm.childAddress,
                              @"Birth_Date": childForm.birthDate,
                              @"Birth_Weight": childForm.birthWeight,
                              @"Birth_Height": childForm.birthHeight,
//                              @"Birth_Way": @(childForm.birthWay),
                              @"Birth_Hospital": childForm.birthHospital,
                              @"IDentity_Code":childForm.identityCode,
                              @"Guargian_ID":childForm.guargianID
                              };
    WS(ws);
    WO(childForm)
    [[FPNetwork POST:API_PHONE_ADD_BABY_EMR withParams:params] addCompleteHandler:^(FPResponse *response) {
        NSDictionary* dic = response.data;
        NSNumber* number = dic[@"ResultID"];
        childFormWeak.childID = [number integerValue];
        [ws.delegate onCommitChildArchivesComplete:response.isSuccess info:response.message];
    }];



}


- (void)updateChildArchives:(ChildForm *)childForm{
    if (!childForm.childName || childForm.childName.length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写姓名"];
        return;
    }
    
    if (childForm.childSex == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择性别"];
        return ;
    }
    
    NSString* childNation = nil;
    if (childForm.childNation == 0) {
        childNation = @"";
    }else{
        childNation = [NSString stringWithFormat:@"%ld",childForm.childNation];
    }
    
    NSString* nation = nil;
    if (childForm.nation == 0) {
        nation = @"";
    }else{
        nation = [NSString stringWithFormat:@"%ld",childForm.nation];
    }
    
    if (!childForm.birthDate || childForm.birthDate.length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择出生日期"];
        return ;
    }else{
        NSTimeInterval birthTime = [NSDate compareDate:childForm.birthDate];
        NSInteger year = birthTime/(60*60*24*365);
        if(year >= 18){
            [_delegate onCommitChildArchivesComplete:NO info:@"请选择18岁以下的出生日期"];
            return ;
        }
    }
    
    if (childForm.guargionRelation == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请选择监护人关系"];
        return ;
    }
    
    
    if (!childForm.guargionName || childForm.guargionName.length == 0) {
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写监护人姓名"];
        return ;
    }
    
    
    if(childForm.childTEL.length == 0){
        childForm.childTEL = @"";
    }else if(![childForm.childTEL checkPhone]){
        [_delegate onCommitChildArchivesComplete:NO info:@"请填写手机号码/输入正确格式"];
        return ;
    }
    
    if (childForm.childAddress.length == 0) {
        childForm.childAddress = @"";
    }
    
    if(childForm.birthWeight.length == 0) {
        childForm.birthWeight = @"";
    }else{
        BOOL isNumber = [childForm.birthWeight regexNumber] || [childForm.birthWeight isPureNumber];
        if(!isNumber){
            [_delegate onCommitChildArchivesComplete:NO info:@"出生体重请输入数字"];
            return ;
        }
    }
    
    if (childForm.birthHeight.length == 0) {
        childForm.birthHeight = @"";
    }else{
        BOOL isNumber = [childForm.birthHeight regexNumber] || [childForm.birthHeight isPureNumber];
        if(!isNumber){
            [_delegate onCommitChildArchivesComplete:NO info:@"出生身长请输入数字"];
            return ;
        }
    }
    if (!childForm.guargianID || childForm.guargianID.length == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请填写监护人身份证"];
//        return;
        childForm.guargianID = @"";
    }
    if (!childForm.identityCode || childForm.identityCode.length == 0) {
//        [_delegate onCommitChildArchivesComplete:NO info:@"请填写宝宝身份证"];
//        return;
        childForm.identityCode = @"";
    }
    
    if(childForm.birthHospital.length == 0) {
        childForm.birthHospital = @"";
    }
    
    NSDictionary* parames = @{@"UserID": @(kCurrentUser.userId),
                              @"Child_ID":@(childForm.childID),
                              @"Child_Name":childForm.childName,
                              @"Child_Sex": @(childForm.childSex),
                              @"Child_Nation": childNation,
                              @"Nation":nation,
                              @"Guargian_Name": childForm.guargionName,
                              @"Guargian_Relation": @(childForm.guargionRelation),
                              @"Child_TEL": childForm.childTEL,
                              @"Child_Address": childForm.childAddress,
                              @"Birth_Date": childForm.birthDate,
                              @"Birth_Weight": childForm.birthWeight,
                              @"Birth_Height": childForm.birthHeight,
                              @"Birth_Hospital": childForm.birthHospital,
                              @"IDentity_Code":childForm.identityCode,
                              @"Guargian_ID":childForm.guargianID
                              };
    WS(ws);
    [[FPNetwork POST:API_PHONE_EDIT_BABY_EMR withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitChildArchivesComplete:info:)]){
            [ws.delegate onCommitChildArchivesComplete:response.isSuccess info:response.message];
        }
    }];


}



-(void)commitChildArchives:(ChildForm *)childForm complete:(Complete)block{
    
    if (!childForm.childName || childForm.childName.length == 0 || [childForm.childName trimming].length == 0) {
        block(NO,@"请填写姓名");
        return;
    }
    
    if(childForm.childName.length > 5){
        block(NO,@"请输入少于5个字的名字");
        return ;
    }
    
    if (childForm.childSex == 0) {
        block(NO,@"请选择性别");
        return ;
    }
    
    if (childForm.childNation == 0) {
//        block(NO,@"请选择国籍");
//        return;
    }
    
    
    if (childForm.nation == 0) {
//        block(NO,@"请选择民族");
//        return;
    }
    
    if(childForm.birthWeight.length == 0) {
//        block(NO,@"请输入体重");
//        return;
        childForm.birthWeight = @"";
    }else{
        BOOL isNumber = [childForm.birthWeight regexNumber] || [childForm.birthWeight isPureNumber];
        if(!isNumber){
            block(NO,@"出生体重请输入数字");
            return ;
        }
    }
    
    if (childForm.birthHeight.length == 0) {
//        block(NO,@"请输入身长");
//        return;
        childForm.birthHeight = @"";
    }else{
        BOOL isNumber = [childForm.birthHeight regexNumber] || [childForm.birthHeight isPureNumber];
        if(!isNumber){
            block(NO,@"出生身长请输入数字");
            return ;
        }
    }
    
    if (!childForm.birthDate || childForm.birthDate.length == 0) {
        block(NO,@"请选择出生日期");
        return ;
    }else{
        NSTimeInterval birthTime = [NSDate compareDate:childForm.birthDate];
        NSInteger year = birthTime/(60*60*24*365);
        if(year >= 18){
            block(NO,@"请选择18岁以下的出生日期");
            return ;
        }
    }
    
    if(childForm.birthHospital.length == 0) {
//        block(NO,@"请输入出生医院");
//        return;
        childForm.birthHospital = @"";
    }
    
    if (childForm.guargionRelation == 0) {
        block(NO,@"请选择监护人关系");
        return ;
    }
    
    
    if (!childForm.guargionName || childForm.guargionName.length == 0 || [childForm.guargionName trimming].length == 0) {
        block(NO,@"请填写监护人姓名");
        return ;
    }
    
    if (childForm.childAddress.length == 0) {
        block(NO,@"请输入家庭住址");
        return;
    }
    
    if(childForm.childTEL.length == 0){
        block(NO,@"请输入联系电话");
        return;
    }else if(![childForm.childTEL checkPhone] || [childForm.childTEL trimming].length == 0){
        block(NO,@"请填写手机号码/输入正确格式");
        return ;
    }
    //身份证不能纯数字键盘
    
    if (!childForm.identityCode || childForm.identityCode.length == 0 || [childForm.identityCode trimming].length == 0) {
//        block(NO,@"请输入宝宝身份证");
//        return ;
        childForm.identityCode = @"";
    }
    
    if (!childForm.guargianID || childForm.guargianID.length == 0 || [childForm.guargianID trimming].length == 0) {
//        block(NO,@"请填写监护人身份证");
//        return ;
        childForm.guargianID = @"";
    }
    
    block(YES,nil);

}


@end
