    //
//  AwaitAnswerPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AwaitAnswerPresenter.h"
#import "UIImage+Category.h"
#import "MyAnserEntity.h"
#import "ZHProgressView.h"
#import "VoiceConverter.h"
#import "ZHProgressView.h"
#import "HEAParentQuestionEntity.h"

@interface AwaitAnswerPresenter ()<ZHAVRecoderDelegate>{
}

@property (nonatomic ,copy) NSString *uploadPath;
@property (nonatomic ,copy) NSString *consultationID;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic,assign) long myTime;
@property (nonatomic ,copy) NSString *WordContent;
@property (nonatomic,strong) FormData *readyData;
@property (nonatomic,strong) FormData *blockData;
@property (nonatomic,strong) ZHProgressView *progress;
@property (nonatomic)BOOL uploadFinish;
@property (nonatomic,assign) NSInteger currentUploadTag;
@property (nonatomic,assign) NSInteger failTry;

@end

@implementation AwaitAnswerPresenter


- (void)commitAwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent{
    WS(ws);
    _uploadTag =0;
    _currentUploadTag =0;
    _failTry =0;
    
    _uploadPath = uploadPath;
    _consultationID = consultationID;
    _myTime =myTime;
    _WordContent = WordContent;
    _readyData = [FormData new];
    _readyData.data = [NSData dataWithContentsOfFile:uploadPath];
    _readyData.fileName = @"file.amr";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    _readyData.hashCode = [NSString stringWithFormat:@"iOS%ld%@", kCurrentUser.userId,str];
//    _readyData.hashCode =@"iOS000000";
//    formData.name = @"file";
    _readyData.fileSize =@(_readyData.data.length);
//    formData.mimeType = @"audio/amr";
    
//    NSDictionary *parameters = @{@"fileType":@"voice"};
    _progress = ZHProgress;
    _progress.rect = self.rect;
    [_progress show];
//    FPNetwork* onlineRequest
    

    [[FPNetwork POSTready:UPLOAD_URLV1 withData:_readyData withParams:nil]addCompleteHandler:^(FPResponse *response) {
        if (response.status ==206&&response.data!=nil) {
            ws.myUploadV1 = [UploadV1Entity mj_objectWithKeyValues:response.data];
            _url =ws.myUploadV1.ServiceFilePath;
            
            NSDictionary *dic =response.data;
            ws.myUploadBlockInfos =[UploadV1BlockInfos mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"BlockInfos"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws uploadBlockInfos];
            });
            
        }else{
            [_progress finish];
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
    

}

- (void)commitOldAwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent{
    
    _uploadPath = uploadPath;
    _consultationID = consultationID;
    _myTime =myTime;
    _WordContent = WordContent;
    FormData * formData = [FormData new];
    formData.data = [NSData dataWithContentsOfFile:uploadPath];
    formData.fileName = @"file.amr";
    formData.name = @"file";
    formData.mimeType = @"audio/amr";
    
//    NSDictionary *parameters = @{@"fileType":@"voice"};
    ZHProgressView *progress = ZHProgress;
    progress.rect = self.rect;
    [progress show];

    WS(ws);
    
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addUploadHandler:^(NSProgress *pregress) {
        NSLog(@"progress = %g",pregress.fractionCompleted);
        //这是子线程
        progress.progressValue = pregress.fractionCompleted;
        if(pregress.fractionCompleted == 1){
            NSLog(@"上传完成");
        }

    } withCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            [ProgressUtil dismiss];
            NSDictionary* dic = [response.data dictionary];
            if ([dic.allKeys containsObject:@"Result"]){
                NSString* result = dic[@"Result"];
                NSArray* array = [result componentsSeparatedByString:@","];
                NSString* first = [array firstObject];
                NSArray* subArray = [first componentsSeparatedByString:@"|"];
                NSString * url = [subArray lastObject];
                _url = url;
//                [ProgressUtil showSuccess:@"上传成功"];
                NSLog(@"---上传成功－－－");

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self insert];
                });

            }else{
                [progress finish];
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadOnComplete:info:)]){
                    [ws.delegate uploadOnComplete:NO info:@"弱网络下建议语音长度60秒内，请重试"];
                }
            }
        }else{
            [progress finish];
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadOnComplete:info:)]){
                [ws.delegate uploadOnComplete:NO info:@"弱网络下建议语音长度60秒内，请重试"];
            }
            
        }
    }];
}

- (void)commit44AwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent{
    
    _uploadPath = uploadPath;
    _consultationID = consultationID;
    _myTime =myTime;
    _WordContent = WordContent;
    FormData * formData = [FormData new];
    formData.data = [NSData dataWithContentsOfFile:uploadPath];
    formData.fileName = @"file.amr";
    formData.name = @"file";
    formData.mimeType = @"audio/amr";
    
    //    NSDictionary *parameters = @{@"fileType":@"voice"};
    ZHProgressView *progress = ZHProgress;
    progress.rect = self.rect;
    [progress show];
    
    WS(ws);
    
    [[FPNetwork POST44:UPLOAD_URL44 withParams:nil withFormDatas:@[formData]] addUploadHandler:^(NSProgress *pregress) {
        NSLog(@"progress = %g",pregress.fractionCompleted);
        //这是子线程
        progress.progressValue = pregress.fractionCompleted;
        if(pregress.fractionCompleted == 1){
            NSLog(@"上传完成");
        }
        
    } withCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            [ProgressUtil dismiss];
            NSDictionary* dic = response.data;
            if ([dic.allKeys containsObject:@"ServiceFilePath"]){
                NSString* result = dic[@"ServiceFilePath"];
                
                _url = result;
                //                [ProgressUtil showSuccess:@"上传成功"];
                NSLog(@"---上传成功－－－");
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self insert];
                });
                
            }else{
                [progress finish];
                [ws commitOldAwaitAnswerVoiceWithPath:_uploadPath ConsultationID:_consultationID Time:_myTime WordContent:_WordContent];
            }
        }else{
            [progress finish];
            [ws commitOldAwaitAnswerVoiceWithPath:_uploadPath ConsultationID:_consultationID Time:_myTime WordContent:_WordContent];
            
        }
    }];
}



- (void)uploadBlockInfos{
    WS(ws);
    _blockData =[FormData new];
    _blockData.fileName =_readyData.fileName;
    _blockData.fileSize =_readyData.fileSize;
    _blockData.hashCode =_readyData.hashCode;
    if (ws.progress.timer ==nil) {
        ws.progress = ZHProgress;
        ws.progress.rect = ws.rect;
        [ws.progress show];
    }
    
    
    UploadV1BlockInfos *info =ws.myUploadBlockInfos[_uploadTag];
    
    ws.progress.progressValue =[info.StartIndex floatValue]/[_blockData.fileSize floatValue];
    
    _blockData.fileIndex =@(_uploadTag+1);
    _blockData.startIndex =info.StartIndex;
    _blockData.endIndex =info.EndIndex;
    NSLog(@"%@ --%@",info.StartIndex,info.EndIndex);
    _blockData.data =[[NSData dataWithData:_readyData.data] subdataWithRange:NSMakeRange([info.StartIndex longValue], [info.EndIndex longValue]-[info.StartIndex longValue])];
    if (_uploadTag ==ws.myUploadBlockInfos.count) {
        [ws getFinishInfo];
    }else{
    
    [[FPNetwork POST:UPLOAD_URLV1 withParams:nil withBlockFormDatas:@[_blockData]]addCompleteHandler:^(FPResponse *response) {
        if (response.status ==206) {
            
            _uploadTag++;
            
            ws.progress.progressValue =[info.EndIndex floatValue]/[_blockData.fileSize floatValue];
            if (_uploadTag ==ws.myUploadBlockInfos.count) {
                [ws getFinishInfo];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws uploadBlockInfos];
                });
            }
            
        }else{
            
            if (_currentUploadTag!=_uploadTag) {
                _currentUploadTag =_uploadTag;
                _failTry =0;
            }
            _failTry++;
            if (_failTry==4) {
                [_progress finish];
                [ws commitOldAwaitAnswerVoiceWithPath:_uploadPath ConsultationID:_consultationID Time:_myTime WordContent:_WordContent];
                
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws uploadBlockInfos];
                });
            }
        }
        
    }];
    }
}


- (void)getFinishInfo{
    WS(ws);
    [[FPNetwork POSTfinish:UPLOAD_URLV1 withData:_readyData withParams:nil] addCompleteHandler:^(FPResponse *response) {
        if (response.status ==200) {
            _uploadTag =0;
            [ws insert];
        }else{
            
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
}

- (void)insert{
    
    if (_url) {
        
        NSDictionary *parameters = @{@"ConsultationID":_consultationID,@"VoiceUrl":_url,@"ConsultationStatus":@1,@"VoiceTime":@(_myTime),@"WordContent":_WordContent};
        [ProgressUtil show];
        WS(ws);
        NSString *action = API_Update_ExpertConsultation;
        if (self.answerType == 1) {
            action = @"SetExpertConsultationTraceVoice";
            parameters = @{@"uuid":[NSString stringWithFormat:@"%@",_TraceID],
                           @"expert_ID":[NSString stringWithFormat:@"%@",kCurrentUser.expertID],
                           @"voiceUrl":[NSString stringWithFormat:@"%@",_url],
                           @"voiceTime":[NSString stringWithFormat:@"%@",@(_myTime)],
                           @"consultationStatus":@(1),
                           @"WordContent":_WordContent};
        }
        [[FPNetwork POST:action withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
            if(response.success){
                NSLog(@"====更新成功");
//                [ProgressUtil showSuccess:@"更新成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"answer" object:nil];
            }
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitAwaitAnswerOnComplete:info:)]){
                [ws.delegate commitAwaitAnswerOnComplete:response.success info:response.message?response.message:@"网络不可用,请重试"];
            }

            
        }];
    }else{
        [ProgressUtil showError:@"上传语音成功，更新语音地址失败"];
    }
}

//加载问题详情
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block{
    WS(ws);
    [[FPNetwork POST:@"GetExpertConsultation" withParams:@{@"userid":@(kCurrentUser.userId),@"UUID":@(uuid)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSArray *array = [MyAnserEntity mj_objectArrayWithKeyValuesArray:response.data];
            ws.myAnswer = array.firstObject;
            ws.myAnswer.uuid = [NSString stringWithFormat:@"%ld",(long)uuid];
            ws.url = ws.myAnswer.voiceUrl;
            block(YES,nil);
        }else{
            block(NO,nil);
        }
    }];
}
- (void)play:(playStart)block{

    NSArray* result = [_urls componentsSeparatedByString:@"/"];
    //语音文件存在
    if([NSString fileIsExist:[result lastObject]]){
        NSLog(@"文件已存在");
        //判断是否需要转码
        NSURL* audioURL = nil;
        if([NSString isNotNeedConvertAmrToWav:[result lastObject]]){
            //不需要转码，直接播放
            NSLog(@"文件已转码");
            audioURL = [NSString getAudioURL:[result lastObject]];
            BOOL success = [self playWith:audioURL];
            block(success);
        }else{
            //先转码，再播放
            NSLog(@"转码");
            NSString* downloadPath = [NSString getDownloadPath:_url];
            //文件名不带后缀
            NSString* fileName = [NSString getFileName:[result lastObject]];
            
            NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
            
            if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
                NSLog(@"转码成功");
                NSLog(@"p = %@",[NSURL URLWithString:[NSString GetPathByFileName:fileName ofType:@"wav"]]);
                //                        [[AVRecorderPlayerManager sharedManager] playerAudio:[NSURL URLWithString:[NSString GetPathByFileName:fileName ofType:@"wav"]]];
                
                audioURL = [NSString getAudioURL:[result lastObject]];
                BOOL success = [self playWith:audioURL];
                block(success);
            }else{
                NSLog(@"转码失败");
            }
        }
        //播放
//        BOOL success = [self playWith:audioURL];
//        block(success);
    }else{
        //语音文件不存在，下载
        NSLog(@"文件不存在");
        [ProgressUtil show];
        //        ZHProgressView *progress = ZHProgress;
        //        [progress show];
        [[FPNetwork DOWNLOAD:_urls downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
            NSLog(@"progress = %g",pregress.fractionCompleted);
            //            progress.progressValue = pregress.fractionCompleted;
        } withCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
            if(response.success){
                NSLog(@"url = %@",response.downloadPath);
                
                //先转码，再播放
                NSLog(@"转码");
                NSString* downloadPath = [NSString getDownloadPath:_urls];
                //文件名不带后缀
                NSString* fileName = [NSString getFileName:[result lastObject]];
                NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
                if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
                    NSLog(@"转码成功");
                    NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
                    BOOL success = [self playWith:audioURL];
                    block(success);
                }else{
                    NSLog(@"转码失败");
                }
            }else{
                //下载失败
                NSLog(@"下载失败");
            }
        }];
    }
}

- (BOOL)playWith:(NSURL *) url{
    //播放
    _player.audioPath = url.absoluteString;
    BOOL success = [_player playerStart];
//    if (success == YES) {
//        _second = 0;
//        [self timerStart];
//    }
    return success;
}
- (void)stop{
    [_player playerStop];
//    _player.delegate = nil;
//    [_timer invalidate];
//    _timer = nil;
//    _second = 0;
}

-(void)loadVoiceUrl:(LoadVoiceFile)file
{
    NSArray* result = [_urls componentsSeparatedByString:@"/"];
    [[FPNetwork DOWNLOAD:_urls downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
        NSLog(@"progress = %g",pregress.fractionCompleted);
        //            progress.progressValue = pregress.fractionCompleted;
    } withCompleteHandler:^(FPResponse *response) {
        [ProgressUtil dismiss];
        if(response.success){
            NSLog(@"url = %@",response.downloadPath);
            
            //先转码，再播放
            NSLog(@"转码");
            NSString* downloadPath = [NSString getDownloadPath:_urls];
            //文件名不带后缀
            NSString* fileName = [NSString getFileName:[result lastObject]];
            file(fileName,downloadPath);
//            NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
//            if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
//                NSLog(@"转码成功");
//                NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
//                BOOL success = [self playWith:audioURL];
//                block(success);
//            }else{
//                NSLog(@"转码失败");
//            }
        }else{
            //下载失败
            NSLog(@"loadvoice下载失败");
        }
    }];
    
}

//- (void)audioEndWith:(AudioType)audioType message:(NSString *)message{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
//        [self.delegate playFinished];
//    }
//    [_timer invalidate];
//    _timer = nil;
//}

//-(UIViewController *)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
//}

@end
