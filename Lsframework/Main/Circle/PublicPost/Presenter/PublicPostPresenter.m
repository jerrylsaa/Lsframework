//
//  PublicPostPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PublicPostPresenter.h"

@implementation PublicPostPresenter

//-(void)publicPost:(NSMutableArray *)imageDataSorce title:(NSString *)title consultation:(NSString *)consultation{
//    NSMutableArray* formDataArray=[NSMutableArray array];
//    for(int i = 0; i < imageDataSorce.count ; i++){
//        FormData* formData = [FormData new];
//        UIImage* image = [imageDataSorce objectAtIndex:i];
//        NSLog(@"image is- %@",image);
//        formData.data = [image resetSizeOfImageData:image maxSize:500];
//        formData.fileName=@"file.png";
//        formData.name=@"file";
//        formData.mimeType=@"image/png";
//        
//        NSLog(@"formdata - is %@",formData);
//        
//        [formDataArray addObject:formData];
//    }
//    WS(ws);
//    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:formDataArray] addCompleteHandler:^(FPResponse *response) {
//        if(response.success){
//            [ProgressUtil dismiss];
//            NSDictionary* data=[response.data dictionary];
//            NSLog(@"data is %@", data);
//            NSMutableString* uploadPath=[data[@"Result"] getUploadPath];
//            NSLog(@"uploadPath=%@\n",uploadPath);
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ProgressUtil show];
//                [ws commitConsultation:uploadPath title:title consultation:consultation];
//            });
//            
//        }else{
//            [ProgressUtil showError:response.message];
//        }
//    }];
//}
-(void)publicPost:(NSMutableArray *)imageDataSorce title:(NSString *)title consultation:(NSString *)consultation
{
    WS(ws);
    [ProgressUtil showWithStatus:@"上传图片中..."];
    NSMutableArray *photoUrlArr =[NSMutableArray array];
    if (imageDataSorce.count!=0) {
        
        for (UIImage *image in imageDataSorce) {
            
            FormData * formData = [FormData new];
            formData.data = [image resetSizeOfImageData:image maxSize:200];
            //        formData.data = UIImagePNGRepresentation(image);
            
            formData.fileName = @"file.png";
            formData.name = @"file";
            formData.mimeType = @"image/png";
            
            [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    
                    NSDictionary *data = [response.data dictionary];
                    
                    NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
                    
                    if (uploadPathArr[0]) {
                        [photoUrlArr addObject:uploadPathArr[0]];
                        if (photoUrlArr.count ==imageDataSorce.count) {
                            
                            if (ws.delegate ) {
                                [ws.delegate data:photoUrlArr title:title twoTitle:consultation];
                            }
                            
                        }
                    }
                    
                    
                }
                
            }];
            
            
        }
    }else {
        NSLog(@"数组为0");
        
    }
}
- (void)loadArr:(NSMutableArray*)uploadArrPath title:(NSString*) title consultation:(NSString*) consultation
{
    NSDictionary *parames;
    
    if (uploadArrPath.count != 0) {
        if (uploadArrPath.count == 1) {
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1", nil];
            
        }else if (uploadArrPath.count ==2){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2", nil];
            
        }else if (uploadArrPath.count == 3){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3", nil];
        }else if (uploadArrPath.count == 4){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4", nil];
            
        }else if (uploadArrPath.count == 5){
           parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5", nil];
            
        }else if (uploadArrPath.count == 6){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5",uploadArrPath[5],@"Image6", nil];
        }
        
        WS(ws);
        [[FPNetwork POST:API_ADD_WORDS_CONSULTATION withParams:parames] addCompleteHandler:^(FPResponse *response) {
            if(response.success){
                [ProgressUtil dismiss];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(publicPostOnCompletion)]){
                    [ws.delegate publicPostOnCompletion];
                }
                
                
            }else{
                [ProgressUtil showError:response.message];
            }
        }];
    }
    
    
}
- (void)commitConsultation:(NSString*)uploadPath title:(NSString*) title consultation:(NSString*) consultation{
    
    NSString* image1Path;
    NSString* image2Path;
    NSString* image3Path;
    
    NSString *image4Path;
    NSString* image5Path;
    NSString* image6Path;
    
    if(uploadPath && uploadPath.length != 0){
        if(![uploadPath containsString:@"|"]){
            //只有一个图片
            image1Path = uploadPath;
            image2Path = @"";
            image3Path = @"";
        }else{
            //多张图
            NSArray* uploadArray = [uploadPath componentsSeparatedByString:@"|"];
            if(uploadArray.count == 2){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray lastObject];
                image3Path = @"";
            }else if(uploadArray.count == 3){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray objectAtIndex:1];
                image3Path = [uploadArray lastObject];
            }else if(uploadArray.count == 4){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray objectAtIndex:1];
                image3Path = [uploadArray objectAtIndex:2];
                image4Path = [uploadArray lastObject];
                
            }else if(uploadArray.count == 5){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray objectAtIndex:1];
                image3Path = [uploadArray objectAtIndex:2];
                image4Path = [uploadArray objectAtIndex:3];
                image5Path = [uploadArray lastObject];
                
            }else if(uploadArray.count == 6){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray objectAtIndex:1];
                image3Path = [uploadArray objectAtIndex:2];
                image4Path = [uploadArray objectAtIndex:3];
                image5Path = [uploadArray objectAtIndex:4];
                image6Path = [uploadArray lastObject];
                
            }
        }
    }else{
        image1Path = @"";
        image2Path = @"";
        image3Path = @"";
        image4Path = @"";
        image5Path = @"";
        image6Path = @"";
    }
    
    
//    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"Title":title, @"ConsultationContent":consultation,@"Image1":image1Path,@"Image2":image2Path, @"Image3":image3Path,@"Image4":image4Path,@"Image5":image5Path,@"Image6":image6Path};
    NSDictionary *parames = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",@(kCurrentUser.userId),@"UserID",consultation,@"ConsultationContent",image1Path,@"Image1",image2Path,@"Image2",image3Path,@"Image3",image4Path,@"Image4",image5Path,@"Image5",image6Path,@"Image6", nil];
    WS(ws);
    [[FPNetwork POST:API_ADD_WORDS_CONSULTATION withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil dismiss];
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(publicPostOnCompletion)]){
                [ws.delegate publicPostOnCompletion];
            }
            
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
    
    
}



@end
