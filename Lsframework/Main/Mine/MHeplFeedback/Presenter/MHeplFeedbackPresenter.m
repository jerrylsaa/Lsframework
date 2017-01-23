//
//  MHeplFeedbackPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHeplFeedbackPresenter.h"
#import "UIImage+Category.h"
#import "DefaultChildEntity.h"

@implementation MHeplFeedbackPresenter

- (void)requestWithDescriptionStr:(NSString *)description withVoicePathStr:(NSString *)voice withPhotoPathArary:(NSArray *)photoArray withPhoneNum:(NSString *)phone withVoiceCurrentTime:(NSInteger) currentTime {
    
//    [ProgressUtil show];
//    NSMutableArray *imageDataArray = [NSMutableArray array];
//    for (NSString *imagePath in photoArray) {
//        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//        FormData *formData = [FormData new];
//        formData.data = [image resetSizeOfImageData:image maxSize:200];
//        formData.fileName = @"file.png";
//        formData.name = @"file";
//        formData.mimeType = @"image/png";
//        [imageDataArray addObject:formData];
//    }
//    
//    // 判断录音时间
//    if (currentTime > 0) {
//        
//        //病情描述语音
//        FormData* formData1=[FormData new];
//        formData1.data=[NSData dataWithContentsOfFile:voice];
//        formData1.fileName=@"file.3gpp";
//        formData1.name=@"file";
//        formData1.mimeType=@"audio/3gpp";
//        [imageDataArray addObject:formData1];
//        
//    }
//    
    WS(ws);
//    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:imageDataArray] addCompleteHandler:^(FPResponse *response) {
//        
//        NSDictionary *data = [response.data dictionary];
//        NSLog(@"%@", response.data);
//        NSMutableString *uploadPath = [data[@"Result"] getUploadPath];
//        NSLog(@"uploadPath=%@",uploadPath);
    
        
        [[FPNetwork POST:API_ADD_HELP withParams:@{@"userid":@(kCurrentUser.userId),@"Content":description, @"Tel":phone, @"QQ":@(123)}] addCompleteHandler:^(FPResponse *response) {
            
            if (response.status ==200) {
                
                [ProgressUtil showSuccess:response.message];
                [ws.delegate sendMessage:@"上传成功"];
                
            }else if (response.status !=0){
                
                [ProgressUtil showError:response.message];
                
            }else {
                [ProgressUtil showError:@"网络不可用"];

            }
            
        }];
        
//    }];
    
}

@end
