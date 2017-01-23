//
//  FamilyHistoryPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FamilyHistoryPresenter.h"

@implementation FamilyHistoryPresenter

-(void)commitFamilyHistory:(ChildForm *)childForm{
    NSString* history = nil;
    if(childForm.history==0){
        history=@"";
    }else{
        history=[NSString stringWithFormat:@"%ld",childForm.history-1];
    }
    if(childForm.historyMark.length==0) childForm.historyMark=@"";
    
    /*  父亲*/
    //父亲生育年龄
    if(self.fatherAge.length==0){
        self.fatherAge=@"";
    }else{
        if(![self checkAgeIsVaild:self.fatherAge]) return ;
//        childForm.fatherBearAge = [self.fatherAge integerValue];
    }
    //父亲学历
    NSString* fatherEdu=nil;
    if(childForm.fatherEducation==0){
//        [self.delegate onCommitComplete:NO info:@"请选择父亲文化程度"];
//        return ;
        fatherEdu=@"";
    }else{
        fatherEdu=[NSString stringWithFormat:@"%ld",childForm.fatherEducation];
    }
    if(childForm.fatherEverDiseaseMark.length==0) childForm.fatherEverDiseaseMark=@"";

    /*  母亲*/
    //母亲生育年龄
    if(self.motherAge.length==0){
        self.motherAge=@"";
    }else{
        if(![self checkAgeIsVaild:self.motherAge]) return ;
//        childForm.motherBearAge = [self.motherAge integerValue];
 
    }
    //母亲学历
    NSString* motherEdu=nil;
    if(childForm.motherEducation==0){
//        [self.delegate onCommitComplete:NO info:@"请选择母亲文化程度"];
//        return ;
        motherEdu=@"";
    }else{
        motherEdu=[NSString stringWithFormat:@"%ld",childForm.motherEducation];

    }
    if(childForm.motherEverDiseaseMark.length==0) childForm.motherEverDiseaseMark=@"";
    
    NSDictionary* parames = @{@"Child_ID":@(childForm.childID),
                              @"Family_History":history,
                              @"Family_History_Mark":childForm.historyMark,
                              @"Father_BearingAge":self.fatherAge,
                              @"Father_Education":fatherEdu,
                              @"Father_EverDisease":@(childForm.fatherEverDisease),
                              @"Father_EverDisease_Mark":childForm.fatherEverDiseaseMark,
                              @"Mother_BearingAge":self.motherAge,
                              @"Mother_Education":motherEdu,
                              @"Mother_EverDisease":@(childForm.motherEverDisease),
                              @"Mother_EverDisease_Mark":childForm.motherEverDiseaseMark};
    
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_HISTORY withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitComplete:info:)]){
            [ws.delegate onCommitComplete:response.success info:response.message];
        }
    }];
    
}




#pragma mark - 

- (BOOL)checkAgeIsVaild:(NSString*) ageString{
    NSString* inputAge=[ageString isEqualToString:self.fatherAge]? @"请输入父亲的生育年龄": @"请输入母亲的生育年龄";
    NSString* inputValidAge=[ageString isEqualToString:self.fatherAge]? @"请输入父亲合法的年龄": @"请输入母亲合法的年龄";

    BOOL isValid = NO ;
    if(ageString.length==0 || [ageString trimming].length==0){
        [self.delegate onCommitComplete:NO info:inputAge];
    }else{
        if(![ageString isPureNumber]){
            [self.delegate onCommitComplete:NO info:inputValidAge];
        }else{
            NSUInteger age = [ageString integerValue];
            if(age==0){
                [self.delegate onCommitComplete:NO info:inputValidAge];
            }else{
                isValid = YES;
            }
        }
    }
    return isValid;
}

-(void)commitFamilyHistory:(ChildForm *)childForm block:(Complete)block{
    NSString* history = nil;
    if(childForm.history==0){
        history=@"";
    }else{
        history=[NSString stringWithFormat:@"%ld",childForm.history-1];
    }
    if(childForm.historyMark.length==0) childForm.historyMark=@"";
    
    /*  父亲*/
    //父亲生育年龄
    if(self.fatherAge.length==0){
        self.fatherAge=@"";
    }else{
        if(![self checkAgeIsVaild:self.fatherAge]) return ;
//                childForm.fatherBearAge = [self.fatherAge integerValue];
    }
    //父亲学历
    NSString* fatherEdu=nil;
    if(childForm.fatherEducation==0){
        //        [self.delegate onCommitComplete:NO info:@"请选择父亲文化程度"];
        //        return ;
        fatherEdu=@"";
    }else{
        fatherEdu=[NSString stringWithFormat:@"%ld",childForm.fatherEducation];
    }
    if(childForm.fatherEverDiseaseMark.length==0) childForm.fatherEverDiseaseMark=@"";
    
    /*  母亲*/
    //母亲生育年龄
    if(self.motherAge.length==0){
        self.motherAge=@"";
    }else{
        if(![self checkAgeIsVaild:self.motherAge]) return ;
        //        childForm.motherBearAge = [self.motherAge integerValue];
        
    }
    //母亲学历
    NSString* motherEdu=nil;
    if(childForm.motherEducation==0){
        //        [self.delegate onCommitComplete:NO info:@"请选择母亲文化程度"];
        //        return ;
        motherEdu=@"";
    }else{
        motherEdu=[NSString stringWithFormat:@"%ld",childForm.motherEducation];
        
    }
    if(childForm.motherEverDiseaseMark.length==0) childForm.motherEverDiseaseMark=@"";
    
    block(YES,nil);
    
}


@end
