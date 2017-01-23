//
//  GBArchivesRecordPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBArchivesRecordPresenter.h"
#import "NSString+Category.h"
#import "DefaultChildEntity.h"

@implementation GBArchivesRecordPresenter


//上传基本信息
-(void)commitChildArchives:(ChildForm *)childForm{
    
    
    if (!childForm.childName || childForm.childName.length == 0 || [childForm.childName trimming].length == 0) {
        [_delegate onCommitGBChildArchivesComplete:NO info:@"请填写姓名"];
        return;
    }
    
    if(childForm.childName.length > 5){
        [_delegate onCommitGBChildArchivesComplete:NO info:@"请输入少于5个字的名字"];
        return ;
    }
    
    if (childForm.childSex == 0) {
        [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择性别"];
        return ;
    }
    
    
    if(childForm.birthWeight.length == 0) {
        //        [_delegate onCommitChildArchivesComplete:NO info:@"请输入体重"];
        //        return;
        childForm.birthWeight = @"";
    }else{
        BOOL isNumber = [childForm.birthWeight regexNumber] || [childForm.birthWeight isPureNumber];
        if(!isNumber){
            [_delegate onCommitGBChildArchivesComplete:NO info:@"出生体重请输入数字"];
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
            [_delegate onCommitGBChildArchivesComplete:NO info:@"出生身长请输入数字"];
            return ;
        }
    }
    
    if (!childForm.birthDate || childForm.birthDate.length == 0) {
        [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择出生日期"];
        return ;
    }else{
        NSTimeInterval birthTime = [NSDate compareDate:childForm.birthDate];
        NSInteger year = birthTime/(60*60*24*365);
        if(year >= 18){
            [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择18岁以下的出生日期"];
            return ;
        }
    }
    /**
     *  UserID，Child_Name，Child_Sex，Birth_Date，Birth_Weight，Birth_Height，
     Birth_Weight，Birth_Height 这二个不是必须
     */
    NSDictionary * params = @{
                              @"UserID": @(kCurrentUser.userId),
                              @"Child_Name":childForm.childName,
                              @"Child_Sex": @(childForm.childSex),
                              @"Birth_Date": childForm.birthDate,
                              @"Birth_Weight": childForm.birthWeight,
                              @"Birth_Height": childForm.birthHeight,
                              };
    WS(ws);
    WO(childForm)
    [[FPNetwork POST:API_PHONE_ADD_BABY_EMRv1 withParams:params] addCompleteHandler:^(FPResponse *response) {
        NSDictionary* dic = response.data;
        NSNumber* number = dic[@"ResultID"];
        childFormWeak.childID = [number integerValue];
        [ws.delegate onCommitGBChildArchivesComplete:response.isSuccess info:response.message];
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
    
    
    if(childForm.birthWeight.length == 0) {
        //        [_delegate onCommitChildArchivesComplete:NO info:@"请输入体重"];
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
        //        [_delegate onCommitChildArchivesComplete:NO info:@"请输入身高"];
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
    block(YES,nil);

}


//上传头像

-(void)updateChildAvaterWithImage:(UIImage *)image andChildID:(NSNumber *)childID{
    
    
    NSMutableArray* formDataArray=[NSMutableArray array];
    
    FormData* formData = [FormData new];
    formData.data = [image resetSizeOfImageData:image maxSize:500];
    formData.fileName=@"file.png";
    formData.name=@"file";
    formData.mimeType=@"image/png";
    [formDataArray addObject:formData];
    
    WS(ws);
    [ProgressUtil showWithStatus:@"正在上传照片..."];
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:formDataArray] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil showSuccess:@"上传成功"];
            NSDictionary* data=[response.data dictionary];
            NSMutableString* uploadPath=[data[@"Result"] getUploadPath];
            NSLog(@"uploadPath=%@",uploadPath);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressUtil show];
                [ws updateChildInfo:uploadPath andChildID:childID];
            });
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
    
    
}


/**
 更新孩子头像
 
 @param photoPath <#photoPath description#>
 */
- (void)updateChildInfo:(NSString*) photoPath andChildID:(NSNumber*) childID{
    
    NSDictionary* parames = @{@"BabyID":childID, @"HeadPortraitUrl":photoPath};
    WS(ws);
    [[FPNetwork POST:API_ADD_BABYHEADER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(updateChildAvater:info:)]){
                [ws.delegate updateChildAvater:response.success info:response.message];
            }
        }
    }];
}

- (void)updateChildArchives:(ChildForm *)childForm{
    
//    if (!childForm.childName || childForm.childName.length == 0) {
//        [_delegate onCommitGBChildArchivesComplete:NO info:@"请填写姓名"];
//        return;
//    }
//    
//    if (childForm.childSex == 0) {
//        [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择性别"];
//        return ;
//    }
//    
//    
//    if (!childForm.birthDate || childForm.birthDate.length == 0) {
//        [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择出生日期"];
//        return ;
//    }else{
//        NSTimeInterval birthTime = [NSDate compareDate:childForm.birthDate];
//        NSInteger year = birthTime/(60*60*24*365);
//        if(year >= 18){
//            [_delegate onCommitGBChildArchivesComplete:NO info:@"请选择18岁以下的出生日期"];
//            return ;
//        }
//    }
//    if(childForm.birthWeight.length == 0) {
//        childForm.birthWeight = @"";
//    }else{
//        BOOL isNumber = [childForm.birthWeight regexNumber] || [childForm.birthWeight isPureNumber];
//        if(!isNumber){
//            [_delegate onCommitGBChildArchivesComplete:NO info:@"出生体重请输入数字"];
//            return ;
//        }
//    }
//    
//    if (childForm.birthHeight.length == 0) {
//        childForm.birthHeight = @"";
//    }else{
//        BOOL isNumber = [childForm.birthHeight regexNumber] || [childForm.birthHeight isPureNumber];
//        if(!isNumber){
//            [_delegate onCommitGBChildArchivesComplete:NO info:@"出生身长请输入数字"];
//            return ;
//        }
//    }
    
    NSDictionary* parames = @{@"UserID": @(kCurrentUser.userId),
                              @"Child_ID":@(childForm.childID),
                              @"Child_Name":childForm.childName,
                              @"Child_Sex": @(childForm.childSex),
                              @"Birth_Date": childForm.birthDate,
                              @"Birth_Weight": childForm.birthWeight,
                              @"Birth_Height": childForm.birthHeight,
                              };
    WS(ws);
    [[FPNetwork POST:API_PHONE_EDIT_BABY_EMR withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitGBChildArchivesComplete:info:)]){
            [ws.delegate onCommitGBChildArchivesComplete:response.isSuccess info:response.message];
        }
    }];
    
    
}

-(void)deleteConnectBabyWithBabyID:(NSNumber*)baby{
    NSInteger userID = kCurrentUser.userId;
    NSInteger babyID = [baby  integerValue];
    
    NSDictionary* parames = @{@"BabyID":@(babyID),@"UserID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_DELETE_BABYLINK withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(deleteOnCompletion:info:)]){
            [ws.delegate deleteOnCompletion:response.success info:response.message];
        }
    }];
}




@end
