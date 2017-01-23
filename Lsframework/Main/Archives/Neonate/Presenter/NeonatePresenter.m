//
//  NeonatePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NeonatePresenter.h"

@interface NeonatePresenter (){
    NSInteger _taiNum;
    
}
@end

@implementation NeonatePresenter

-(void)commitNeonate:(ChildForm *)childForm{
    //孕周
    if(childForm.gestationalAge.length==0){
        childForm.gestationalAge=@"";
    }else{
        NSUInteger age=[childForm.gestationalAge integerValue];
        if(age<=26 || age>=52){
            [self.delegate onCommitComplete:NO info:@"孕周请输入大于26，并且小于52的整数"];
            return ;
        }
    }
    
    //胎产次
    if(childForm.fetusNum.length==0){
        childForm.fetusNum=@"";
    }else{
        NSString* text = childForm.fetusNum;
        NSString* info = @"第几胎请输入1~20之间的整数";
        NSUInteger number=[text integerValue];
        if(number == 0 || number > 20){
            [self.delegate onCommitComplete:NO info:info];
            return ;
        }
    }
    
    if(childForm.birthNum.length==0){
        childForm.birthNum=@"";
    }else{
        NSString* text = childForm.birthNum;
        NSString* info = @"第几产请输入大于0的整数";
        NSUInteger number=[text integerValue];
        if(number == 0){
            [self.delegate onCommitComplete:NO info:info];
            return ;
        }else if(number > [childForm.fetusNum integerValue]){
            NSString* message = [NSString stringWithFormat:@"第几产请输入小于或等于%ld的整数",[childForm.fetusNum integerValue]];
            [self.delegate onCommitComplete:NO info:message];
            return ;
        }
    }
    
    //受孕情况
    NSString* souYun = nil;
    if(childForm.pregnancy==0){
        //字符串
        souYun=@"1";
    }else{
        souYun=[NSString stringWithFormat:@"%ld",childForm.pregnancy];
    }
    if(childForm.pregnancyMark.length==0){
        childForm.pregnancyMark=@"";
    }

    //胎数
    NSString* tire = nil;
    if(childForm.tireNum == 0){
        tire = @"";
    }else{
        tire=[NSString stringWithFormat:@"%ld",childForm.tireNum];

        if(childForm.tireNum != 1166){
        //多胎
            NSString* text = childForm.whichTire;
            NSString* info = @"第几个出生请输入大于0的整数";
            NSInteger taiShu = [self getTaiShu:childForm.tireNum];
            NSUInteger number=[text integerValue];
            if(number == 0){
                [self.delegate onCommitComplete:NO info:info];
                return ;
            }else if(number > taiShu){
                NSString* message = [NSString stringWithFormat:@"第几个出生请输入小于或等于%ld的整数",taiShu];
                [self.delegate onCommitComplete:NO info:message];
                return ;
            }
        }
    }
    
    //分娩方式
    NSString* fenMian = nil;
    if(childForm.childBirth==0){
        //字符串
        fenMian=@"";
    }else{
        fenMian=[NSString stringWithFormat:@"%ld",childForm.childBirth];
    }
    
//    NSLog(@"孕周－%@-第几胎-%@--第几产%@--受孕－－%@--备注-%@--胎数-%@--第几个生%@--分娩方式－%@",childForm.gestationalAge,childForm.fetusNum,childForm.birthNum,souYun,childForm.pregnancyMark,tire,childForm.whichTire,fenMian);
    
    NSDictionary* parames = @{@"Child_ID":@(childForm.childID),
                              @"Gestational_Age":childForm.gestationalAge,
                              @"Fetus_Num":childForm.fetusNum,
                              @"Birth_Num":childForm.birthNum,
                              @"Pregnancy":souYun,
                              @"Pregnancy_Mark":@"",//受孕情况无备注信息
                              @"Tire_Num":@(childForm.tireNum),
                              @"Which_Tire":childForm.whichTire,
                              @"Child_Birth":fenMian
                              };
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_BIRTHCONDITION withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitComplete:info:)]){
            [ws.delegate onCommitComplete:response.success info:response.message];
        }
    }];
    
    
    
    
}

-(void)commitNeonate:(ChildForm *)childForm block:(Complete)block{

    //孕周
    if(childForm.gestationalAge.length==0){
        childForm.gestationalAge=@"";
    }else{
        NSUInteger age=[childForm.gestationalAge integerValue];
        if(age<=26 || age>=52){
            [self.delegate onCommitComplete:NO info:@"孕周请输入大于26，并且小于52的整数"];
            return ;
        }
    }
    
    //胎产次
    if(childForm.fetusNum.length==0){
        childForm.fetusNum=@"";
    }else{
        NSString* text = childForm.fetusNum;
        NSString* info = @"第几胎请输入1~20之间的整数";
        NSUInteger number=[text integerValue];
        if(number == 0 || number > 20){
            [self.delegate onCommitComplete:NO info:info];
            return ;
        }
    }
    
    if(childForm.birthNum.length==0){
        childForm.birthNum=@"";
    }else{
        NSString* text = childForm.birthNum;
        NSString* info = @"第几产请输入大于0的整数";
        NSUInteger number=[text integerValue];
        if(number == 0){
            [self.delegate onCommitComplete:NO info:info];
            return ;
        }else if(number > [childForm.fetusNum integerValue]){
            NSString* message = [NSString stringWithFormat:@"第几产请输入小于或等于%ld的整数",[childForm.fetusNum integerValue]];
            [self.delegate onCommitComplete:NO info:message];
            return ;
        }
    }
    
    //受孕情况
    NSString* souYun = nil;
    if(childForm.pregnancy==0){
        //字符串
        souYun=@"1";
    }else{
        souYun=[NSString stringWithFormat:@"%ld",childForm.pregnancy];
    }
//    if(childForm.pregnancyMark.length==0){
//        childForm.pregnancyMark=@"";
//    }
    
    
    //胎数
    NSString* tire = nil;
    if(childForm.tireNum == 0){
        tire = @"";
    }else{
        tire=[NSString stringWithFormat:@"%ld",childForm.tireNum];
        
        if(childForm.tireNum != 1166){
            //多胎
            NSString* text = childForm.whichTire;
            NSString* info = @"第几个出生请输入大于0的整数";
            NSInteger taiShu = [self getTaiShu:childForm.tireNum];
            NSUInteger number=[text integerValue];
            if(number == 0){
                [self.delegate onCommitComplete:NO info:info];
                return ;
            }else if(number > taiShu){
                NSString* message = [NSString stringWithFormat:@"第几个出生请输入小于或等于%ld的整数",taiShu];
                [self.delegate onCommitComplete:NO info:message];
                return ;
            }
        }
    }
    block(YES,nil);
}






#pragma mark -
/**
 *  获取胎数
 *
 *  @param taiID <#taiID description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)getTaiShu:(NSInteger) taiID{
    NSInteger result = 0;
    if(taiID == 1167){
        result = 2;
    }else if(taiID == 1168){
        result = 3;
    }else if(taiID == 1169){
        result = 4;
    }
    return result;
}


@end
