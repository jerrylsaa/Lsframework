//
//  ContinuinglyPicturesPresenter.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ContinuinglyPicturesPresenter.h"
#import "UIImage+Category.h"

@implementation ContinuinglyPicturesPresenter
{
    NSString *myType;
}

- (void)requestWithImages:(NSArray *)photoArray withID:(NSInteger)ID {
    
    [ProgressUtil show];
    
    NSLog(@"%@,%ld", photoArray, ID);
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    myType = [user objectForKey:@"bsArchivesType"];
    
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
        
        NSString *postStr = [NSString string];
        NSDictionary *paramsDict = [NSDictionary dictionary];
        if ([myType isEqualToString:@"0"]) {
            postStr = API_CONTINUE_UPLOAD_INSPECTION_IMAGE;
            paramsDict = @{@"LisID":@(ID),@"LisUrl":uploadPath};
        } else if ([myType isEqualToString:@"1"]) {
            postStr = API_CONTINUE_UPLOAD_EMR_IMAGE;
            paramsDict = @{@"EmrID":@(ID),@"EmrUrl":uploadPath};
        }
        
        [[FPNetwork POST:postStr withParams:paramsDict] addCompleteHandler:^(FPResponse *response) {
            
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
