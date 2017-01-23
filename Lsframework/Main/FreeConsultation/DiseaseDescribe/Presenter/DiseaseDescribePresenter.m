//
//  DiseaseDescribePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiseaseDescribePresenter.h"
#import "UIImage+Category.h"

@implementation DiseaseDescribePresenter

-(NSMutableArray *)audioArray{
    if(!_audioArray){
        _audioArray=[NSMutableArray array];
    }
    return _audioArray;
}

-(void)commitSickDescirbe:(UploadPath *)uploadPath{
    NSMutableArray* formDataArray=[NSMutableArray array];

    if(uploadPath.urls.count != 0){
        if(!uploadPath.sickDescribeURL && !uploadPath.medicalURL){
        //只上传了图片
            self.uploadType = UploadPicture;
        }else{
            //上传图片和语音
            self.uploadType = UploadPictureAndAudio;
        }
    }else{
    //只上传了语音
        self.uploadType = UploadAudio;
    }
    
    
    //图片
    if(uploadPath.urls.count !=0){
        for(NSString* url in uploadPath.urls){
            FormData* formData=[FormData new];
            UIImage* image = [UIImage imageWithContentsOfFile:url];
            formData.data=[image resetSizeOfImageData:image maxSize:200];
            formData.fileName=@"file.png";
            formData.name=@"file";
            formData.mimeType=@"image/png";
            [formDataArray addObject:formData];
        }
    }
    
    if (uploadPath.sickDescribeURL){
    //病情描述语音
    FormData* formData1=[FormData new];
        
//    formData1.data=[NSData dataWithContentsOfURL:uploadPath.sickDescribeURL];
        formData1.data = [NSData dataWithContentsOfFile:self.sickAudioPath];
    formData1.fileName=@"file.3gpp";
    formData1.name=@"file";
    formData1.mimeType=@"audio/3gpp";
    [formDataArray addObject:formData1];
    }
    
    if (uploadPath.medicalURL) {
        //药物使用情况语音
        FormData* formData2=[FormData new];
//        formData2.data=[NSData dataWithContentsOfURL:uploadPath.medicalURL];
        formData2.data = [NSData dataWithContentsOfFile:self.drugAudioPath];

        formData2.fileName=@"file.3gpp";
        formData2.name=@"file";
        formData2.mimeType=@"audio/3gpp";
        [formDataArray addObject:formData2];
    }
    
    WS(ws);
    
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:formDataArray] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            NSDictionary* data=[response.data dictionary];
            NSMutableString* uploadPath=[data[@"Result"] getUploadPath];
            NSLog(@"uploadPath=%@",uploadPath);
            if(ws.uploadType == UploadPicture){
            //纯图片
                ws.imageUploadPath = uploadPath;
                
            }else if(ws.uploadType == UploadAudio){
            //纯音频
                NSArray* subStringArray = [uploadPath componentsSeparatedByString:@"|"];
                for(NSString* subString in subStringArray){
                    if([subString containsString:@"3gpp"]){
                        [ws.audioArray addObject:subString];
                    }
                }
            }else if(ws.uploadType == UploadPictureAndAudio){
            //图片和音频
                NSArray* subStringArray = [uploadPath componentsSeparatedByString:@"|"];
                for(NSString* subString in subStringArray){
                    if([subString containsString:@"3gpp"]){
                        [ws.audioArray addObject:subString];
                    }
                }
                //过滤图片
                NSString* audioString=[ws.audioArray firstObject];
                if(audioString && audioString.length!=0){
                    NSString* tempString=[NSString stringWithFormat:@"%@%@",@"|",audioString];
                    NSRange range=[uploadPath rangeOfString:tempString];
                    ws.imageUploadPath= [uploadPath substringToIndex:range.location];
                }
            }
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitDiseaseDescribeOnComplete:info:)]){
            [ws.delegate commitDiseaseDescribeOnComplete:response.success info:response.message];
        }
    }];
}

@end
