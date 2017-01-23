//
//  GestationPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//  

#import "GestationPresenter.h"


@implementation GestationPresenter

-(void)commitGestation:(ChildForm *)childForm{
//API_PHONE_ADD_PREGNANCY
    NSString* abortion = nil;
    if(childForm.abortion==0){
        abortion=@"";
    }else{
        abortion=[NSString stringWithFormat:@"%ld",childForm.abortion];
    }
    if(childForm.abortionMark.length==0){
        childForm.abortionMark=@"";
    }
    NSString* gestation = nil;
    if(childForm.gestation==0){
        gestation=@"";
    }else{
        gestation=[NSString stringWithFormat:@"%ld",childForm.gestation];
    }
    if(childForm.gestationMark.length==0) childForm.gestationMark=@"";
    
    NSString* infection = nil;
    if(childForm.infection==0){
        infection=@"";
    }else{
        infection=[NSString stringWithFormat:@"%ld",childForm.infection];
    }
    if(childForm.infectionMark.length==0){
        childForm.infectionMark=@"";
    }
    if(childForm.drugsMark.length==0) childForm.drugsMark=@"";
    
    NSString* hazardous = nil;
    if(childForm.hazardous==0){
        hazardous=@"";
    }else{
        hazardous=[NSString stringWithFormat:@"%ld",childForm.hazardous];
    }
    if(childForm.hazardousMark.length==0) childForm.hazardousMark=@"";
    
    NSString* abnormalPregnancy = nil;
    if(childForm.abnormalPregnancy==0){
        abnormalPregnancy=@"";
    }else{
        abnormalPregnancy=[NSString stringWithFormat:@"%ld",childForm.abnormalPregnancy];
    }
    if(childForm.abnormalPregnancyMark.length==0) childForm.abnormalPregnancyMark=@"";
    
    if(childForm.otherMark.length==0) childForm.otherMark=@"";

    NSDictionary* params = @{@"Child_ID":@(childForm.childID),
                          @"Abortion":abortion,
                          @"Abortion_Mark":childForm.abortionMark,
                          @"Pregnancy_Complications":gestation,
                          @"Pregnancy_Complications_Mark":childForm.gestationMark,
                          @"Acute_Infection":infection,
                          @"Acute_Infection_Mark":childForm.infectionMark,
                          @"Applied_Drugs":@(childForm.drugs),
                          @"Applied_Drugs_Mark":childForm.drugsMark,
                          @"Hazardous_Substances":hazardous,
                          @"Hazardous_Substances_Mark":childForm.hazardousMark,
                          @"Abnormal_Pregnancy":abnormalPregnancy,
                          @"Abnormal_Pregnancy_Mark":childForm.abnormalPregnancyMark,
                          @"Pregnancy_Other":childForm.otherMark};
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_PREGNANCY withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitComplete:info:)]){
            [ws.delegate onCommitComplete:response.success info:response.message];
        }
    }];
}

-(void)commitGestation:(ChildForm *)childForm block:(Complete)block{
    //API_PHONE_ADD_PREGNANCY
    NSString* abortion = nil;
    if(childForm.abortion==0){
        abortion=@"";
    }else{
        abortion=[NSString stringWithFormat:@"%ld",childForm.abortion];
    }
    if(childForm.abortionMark.length==0) childForm.abortionMark=@"";
    
    NSString* gestation = nil;
    if(childForm.gestation==0){
        gestation=@"";
    }else{
        gestation=[NSString stringWithFormat:@"%ld",childForm.gestation];
    }
    if(childForm.gestationMark.length==0) childForm.gestationMark=@"";
    
    NSString* infection = nil;
    if(childForm.infection==0){
        infection=@"";
    }else{
        infection=[NSString stringWithFormat:@"%ld",childForm.infection];
    }
    if(childForm.infectionMark.length==0) childForm.infectionMark=@"";
    if(childForm.drugsMark.length==0){
        childForm.drugsMark=@"";
    }
    
    NSString* hazardous = nil;
    if(childForm.hazardous==0){
        hazardous=@"";
    }else{
        hazardous=[NSString stringWithFormat:@"%ld",childForm.hazardous];
    }
    if(childForm.hazardousMark.length==0) childForm.hazardousMark=@"";
    
    NSString* abnormalPregnancy = nil;
    if(childForm.abnormalPregnancy==0){
        abnormalPregnancy=@"";
    }else{
        abnormalPregnancy=[NSString stringWithFormat:@"%ld",childForm.abnormalPregnancy];
    }
    if(childForm.abnormalPregnancyMark.length==0) childForm.abnormalPregnancyMark=@"";
    
    if(childForm.otherMark.length==0) childForm.otherMark=@"";
    
    block(YES,nil);
}

@end
