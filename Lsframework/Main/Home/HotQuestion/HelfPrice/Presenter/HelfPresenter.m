//
//  HelfPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HelfPresenter.h"
#import "UIImage+Category.h"

@implementation HelfPresenter


//- (void)uploadPhoto:(NSMutableArray *)photoArray complete:(UploadComplete)block{
//    WS(ws);
//    [ProgressUtil showWithStatus:@"上传图片中..."];
//    NSMutableArray *photoUrlArr =[NSMutableArray array];
//    NSMutableArray *formDataArray = [NSMutableArray array];
//    if (photoArray.count!=0) {
//        for (UIImage *image in photoArray) {
//            FormData * formData = [FormData new];
//            formData.data = [image resetSizeOfImageData:image maxSize:200];
//            //        formData.data = UIImagePNGRepresentation(image);
//            formData.fileName = @"file.png";
//            formData.name = @"file";
//            formData.mimeType = @"image/png";
//            [formDataArray addObject:formData];
//        }
//        
//        [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:formDataArray] addCompleteHandler:^(FPResponse *response) {
//                if (response.success) {
////                    [ProgressUtil showSuccess:@"上传成功"];
//                    NSDictionary *data = [response.data dictionary];
//                    NSLog(@"response.data %@",response.data);
//                    NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
//                    NSLog(@"uploadArr %@",uploadPathArr);
//                    block(YES,uploadPathArr);
//                }else{
//                    [ProgressUtil showError:@"上传失败"];
//                }
//            }];
//    }
//}
- (void)uploadPhoto:(NSMutableArray *)photoArray complete:(UploadComplete)block
{
    WS(ws);
    [ProgressUtil showWithStatus:@"上传图片中..."];
    NSMutableArray *photoUrlArr =[NSMutableArray array];
    NSMutableArray *formDataArray = [NSMutableArray array];
    if (photoArray.count!=0) {
        for (UIImage *image in photoArray) {
            FormData * formData = [FormData new];
            formData.data = [image resetSizeOfImageData:image maxSize:200];
            //        formData.data = UIImagePNGRepresentation(image);
            formData.fileName = @"file.png";
            formData.name = @"file";
            formData.mimeType = @"image/png";
            
            [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
//                  [ProgressUtil showSuccess:@"上传成功"];
                    NSDictionary *data = [response.data dictionary];
                    NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
                    if (uploadPathArr[0]) {
                        [formDataArray addObject:uploadPathArr[0]];
                        if (formDataArray.count == photoArray.count) {
                            block(YES,formDataArray);
                        }
                    }
                    
                }else{
                    [ProgressUtil showError:@"上传失败"];
                }
            }];
        }
    }
}



@end
