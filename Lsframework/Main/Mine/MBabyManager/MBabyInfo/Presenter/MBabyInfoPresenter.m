//
//  MBabyInfoPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MBabyInfoPresenter.h"

@implementation MBabyInfoPresenter


-(void)getBabyInfo:(NSInteger) babyID{
    
//    NSInteger babyID = baby.childID;
    NSDictionary* parames = @{@"BabyID":@(babyID)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_BABY_INFO withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
           BabyInfoDetail* babyInfo = [BabyInfoDetail mj_objectWithKeyValues:response.data];
            ws.babyInfo = babyInfo;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
}

-(void)deleteConnectBaby{
    NSInteger userID = kCurrentUser.userId;
    NSInteger babyID = self.babyInfo.childId;
    
    NSDictionary* parames = @{@"BabyID":@(babyID),@"UserID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_DELETE_BABYLINK withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(deleteOnCompletion:info:)]){
            [ws.delegate deleteOnCompletion:response.success info:response.message];
        }
    }];
}

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




@end
