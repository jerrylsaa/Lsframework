//
//  DiscoverPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiscoverPresenter.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"
#import "DefaultChildEntity.h"

@implementation DiscoverPresenter

- (void)getPhotoGraphUrls{
    WS(ws);
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST:API_GET_USERPHOTOSBYUSERID withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            NSDictionary* dic = [response.data firstObject];
            NSLog(@"%@",dic);
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetPhotoUrlCompletion: info: dataDictionary:)]){
                [ws.delegate onGetPhotoUrlCompletion:YES info:response.message dataDictionary:dic];
            }
            
        }else if (response.status ==0){
            
            [ProgressUtil showError:@"网络不可用"];
            
        }else{
            
            [ProgressUtil showInfo:response.message];
        }
        
        
    }];
}

- (void)uploadPhoto:(UIImage *)image{
    [ProgressUtil show];

    WS(ws);
    FormData * formData = [FormData new];
    formData.data = [image resetSizeOfImageData:image maxSize:200];
    
    formData.fileName = @"file.png";
    formData.name = @"file";
    formData.mimeType = @"image/png";
    
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
        [ProgressUtil dismiss];

        if (response.success) {
            
            NSDictionary *data = [response.data dictionary];
            NSLog(@"%@", response.data);
            NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
            NSLog(@"======%@",uploadPathArr);
                    if (uploadPathArr[0]) {
                        NSString *photoUrl =[NSString string];
                        photoUrl =uploadPathArr[0];
            
                        if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadPhotoDataOnCompletion:info:urlPhotoPath:)]){
                                    [ws.delegate uploadPhotoDataOnCompletion:response.success info:response.message urlPhotoPath:photoUrl];
                        }else if (ws.delegate && [ws.delegate respondsToSelector:@selector(uploadLogPhotoDataOnCompletion:info:urlPhotoPath:)]){
                            [ws.delegate uploadLogPhotoDataOnCompletion:response.success info:response.message urlPhotoPath:photoUrl];                        }else{
                            [ProgressUtil showError:@"请重试"];
                            }
                    }
            
            
        }else {
            
            [ProgressUtil showError:@"请重试"];
        }
        
    }];
    
}

- (void)getQuestNumber{
    WS(ws);
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"dayNum":@(30)};
    [[FPNetwork POST:API_SelectTaskCountByDayNum withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            if (response.data!=nil) {
                NSInteger questNum =[response.data integerValue];
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetQuestNumberCompletion: info: questNumber:)]){
                    [ws.delegate onGetQuestNumberCompletion:YES info:response.message questNumber:questNum];
                }
                
            }
            
        }else if (response.status ==0){
            [ProgressUtil showError:@"网络不可用"];
            
        }else{
            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用"];

            }
            
        }
        
        
    }];
}

- (void)loadQuestList{
    [ProgressUtil show];
    WS(ws);
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"dayNum":@(30)};
    [[FPNetwork POST:API_SelectTaskListByDayNum withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            ws.questDataSource = [DIscoverQuestEntity mj_objectArrayWithKeyValuesArray:response.data];
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetQuestCompletion: info:)]){
            [ws.delegate onGetQuestCompletion:response.success info:response.message];
        }
        [ProgressUtil dismiss];
            
        }else if (response.status ==0){
            [ProgressUtil dismiss];

            [ProgressUtil showError:@"网络不可用"];
            
        }else{
            [ProgressUtil dismiss];

            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用"];
                
            }
            
        }
        
        
    }];

}

- (void)uploadPhotoUrl:(NSString *)url photoNum:(NSInteger)number{
    [ProgressUtil show];
    WS(ws);
    NSString *photoName =[NSString stringWithFormat:@"PhotoUrl%d",(number-1000)];
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),photoName:url};
    [[FPNetwork POST:API_INSERTUSERPHOTO withParams:parames] addCompleteHandler:^(FPResponse *response) {
        [ProgressUtil dismiss];

        if(response.status ==200){
            
            
            
        }else if (response.status ==0){
            [ProgressUtil showError:@"网络不可用,请重新选择照片上传"];
            
        }else{
            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重新选择照片上传"];
                
            }
        }

        
    }];

}

- (void)getHealthcareLogList{
    WS(ws);
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"dayNum":@([self getChildBirth])};
    [[FPNetwork POST:API_SelectHealthcareLogListByDayNum withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.status ==200){
            
            ws.logDataSource = [DiscoverHealthLogEntity mj_objectArrayWithKeyValuesArray:response.data];
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetLogListCompletion: info:)]){
                [ws.delegate onGetLogListCompletion:response.success info:response.message];
            }
            
        }else if (response.status ==0){
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }else{
            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
                
            }
        }
        
        
    }];
}

- (void)updateHealthLog:(NSString *)photoUrl LogId:(float)logid LogContent:(NSString *)content{
    [ProgressUtil show];
    WS(ws);
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"LogID":@(logid),@"logContent":content,@"photourl":photoUrl,@"logStatus":@(1)};
    [[FPNetwork POST:API_UpdateHealthcareLog withParams:parames] addCompleteHandler:^(FPResponse *response) {
        [ProgressUtil dismiss];
        
        if(response.status ==200){
            
            if ([ws.delegate respondsToSelector:@selector(onUpdateLogCompletion: info:)]) {
                [ws.delegate onUpdateLogCompletion:YES info:response.message];
            }else {
            
                [ProgressUtil showError:@"请重试"];
            }
            
        }else if (response.status ==0){
            [ProgressUtil showError:@"网络不可用,请重新选择照片上传"];
            
        }else{
            if (response.message!=nil) {
                [ProgressUtil showInfo:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重新选择照片上传"];
                
            }
        }
        
        
    }];
}

- (NSInteger )getChildBirth{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy MM dd"];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[DefaultChildEntity defaultChild].birthDate];
    
    
    
    NSUInteger day=((NSUInteger)time)/(3600*24);
    
    
    return day;
}

@end
