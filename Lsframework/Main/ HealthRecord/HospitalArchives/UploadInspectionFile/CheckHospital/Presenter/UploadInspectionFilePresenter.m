//
//  UploadInspectionFilePresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UploadInspectionFilePresenter.h"
#import "UIImage+Category.h"
#import "DefaultChildEntity.h"

@implementation UploadInspectionFilePresenter


- (void)requestWithHospitalID:(NSInteger)hospitalID withTimeStr:(NSString *)time withProjectID:(NSInteger)projectID withOther:(NSString *)other withPhotoArary:(NSArray *)photoArray {
    
    NSMutableArray *imageDataArray = [NSMutableArray array];
    
    for (UIImage *image in photoArray) {
        
        NSLog(@"%@", image);
        NSLog(@"%@",[UIImage imageNamed:@"ac_address"]);
        FormData * formData = [FormData new];
        formData.data = [image resetSizeOfImageData:image maxSize:200];
//        formData.data = UIImagePNGRepresentation(image);
        formData.fileName = @"file.png";
        formData.name = @"file";
        formData.mimeType = @"image/png";
        [imageDataArray addObject:formData];
        
    }
    NSLog(@"%ld", imageDataArray.count);
    WS(ws);
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:imageDataArray] addCompleteHandler:^(FPResponse *response) {
        
        NSDictionary *data = [response.data dictionary];
        NSLog(@"%@", response.data);
        NSMutableString *uploadPath = [data[@"Result"] getUploadPath];
        NSLog(@"uploadPath=%@",uploadPath);
        
        
        [[FPNetwork POST:ADD_ARCHIVES withParams:@{@"UserID":@(kCurrentUser.userId), @"BabyID":@([[DefaultChildEntity defaultChild].babyID integerValue]), @"HospitalID":@(hospitalID),@"InspectTime":time,@"PacsItem":@(projectID),@"PacsContent":other,@"PacsTitle":@"",@"Url":uploadPath}] addCompleteHandler:^(FPResponse *response) {
            
            if (response.success) {
                
                [ProgressUtil showSuccess:response.message];
                [ws.delegate sendMessage:@"上传成功"];
                
            }else {
                
                [ProgressUtil showError:response.message];
                
            }
            
        }];
        
    }];
    
}

- (void)requestWithHospitalID:(NSInteger)hospitalID withTimeStr:(NSString *)time withComplained:(NSString *)ComplainedStr withOther:(NSString *)other withPhotoArary:(NSArray *)photoArray {
    
    NSMutableArray *imageDataArray = [NSMutableArray array];
    
    for (UIImage *image in photoArray) {
        
        NSLog(@"%@", image);
        NSLog(@"%@",[UIImage imageNamed:@"ac_address"]);
        FormData * formData = [FormData new];
        formData.data = [image resetSizeOfImageData:image maxSize:500];
        //        formData.data = UIImagePNGRepresentation(image);
        formData.fileName = @"file.png";
        formData.name = @"file";
        formData.mimeType = @"image/png";
        [imageDataArray addObject:formData];
        
    }
    NSLog(@"%ld", imageDataArray.count);
    
    WS(ws);
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:imageDataArray] addCompleteHandler:^(FPResponse *response) {
        
        NSDictionary *data = [response.data dictionary];
        NSLog(@"%@", response.data);
        NSMutableString *uploadPath = [data[@"Result"] getUploadPath];
        NSLog(@"uploadPath=%@",uploadPath);
        
        NSString *myInspectTimeStr = [[NSDate date] format2String:@"yyyy-MM-dd"];
        NSLog(@"%@", myInspectTimeStr);
        [[FPNetwork POST:ADD_EMR_ARCHIVES withParams:@{@"UserID":@(kCurrentUser.userId), @"BabyID":@([[DefaultChildEntity defaultChild].babyID integerValue]), @"HospitalID":@(hospitalID),@"ConsultationDate":time,@"ChiefComplaint":ComplainedStr,@"EMRContent":other, @"InspectTime":myInspectTimeStr,@"Url":uploadPath}] addCompleteHandler:^(FPResponse *response) {
            
            if (response.success) {
                
                [ProgressUtil showSuccess:response.message];
                [ws.delegate sendMessage:@"上传成功"];
                
            }else {
                
                [ProgressUtil showError:response.message];
                
            }
            
        }];
        
    }];
    
}


@end
