//
//  ReplyAnswerPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ReplyAnswerPresenter.h"
#import "VoiceConverter.h"
#import "ZHProgressView.h"
#import "HEAParentQuestionEntity.h"


@interface ReplyAnswerPresenter ()<ZHAVRecoderDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;

@end

@implementation ReplyAnswerPresenter

- (instancetype)init{
    if (self = [super init]) {
        _player.delegate = self;
    }
    return self;
}

- (void)play:(playStart)block{
    NSArray* result = [_url componentsSeparatedByString:@"/"];
    //语音文件存在
    if([NSString fileIsExist:[result lastObject]]){
        NSLog(@"文件已存在");
        //判断是否需要转码
        NSURL* audioURL = nil;
        if([NSString isNotNeedConvertAmrToWav:[result lastObject]]){
            //不需要转码，直接播放
            NSLog(@"文件已转码");
            audioURL = [NSString getAudioURL:[result lastObject]];
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
                
            }else{
                NSLog(@"转码失败");
            }
        }
        //播放
        BOOL success = [self playWith:audioURL];
        block(success);
    }else{
        //语音文件不存在，下载
        NSLog(@"文件不存在");
        [ProgressUtil show];
//        ZHProgressView *progress = ZHProgress;
//        [progress show];
        [[FPNetwork DOWNLOAD:_url downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
            NSLog(@"progress = %g",pregress.fractionCompleted);
//            progress.progressValue = pregress.fractionCompleted;
        } withCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
            if(response.success){
                NSLog(@"url = %@",response.downloadPath);
                
                //先转码，再播放
                NSLog(@"转码");
                NSString* downloadPath = [NSString getDownloadPath:_url];
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
    if (success == YES) {
        _second = 0;
        [self timerStart];
    }
    return success;
}

- (void)stop{
    [_player playerStop];
    _player.delegate = nil;
    [_timer invalidate];
    _timer = nil;
    _second = 0;
}
- (void)audioEndWith:(AudioType)audioType message:(NSString *)message{
        if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
            [self.delegate playFinished];
        }
        [_timer invalidate];
        _timer = nil;
}
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
//        [self.delegate playFinished];
//    }
//    [_timer invalidate];
//    _timer = nil;
//}
- (void)timerStart{
   _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
    _second = 0;
}
- (void)timeAdd{
    _second ++;
    NSString *time;
    if (_second >= 60) {
        NSString *min;
        NSString *sec;
        if (_second/60 >= 10) {
            min = [NSString stringWithFormat:@"%ld",_second/60];
        }else{
            min = [NSString stringWithFormat:@"0%ld",_second/60];
        }
        if (_second%60 >= 10) {
            sec = [NSString stringWithFormat:@"%ld",_second%60];
        }else{
            sec = [NSString stringWithFormat:@"0%ld",_second%60];
        }
        time = [NSString stringWithFormat:@"%@:%@",min,sec];
    }else{
        NSString *sec;
        if (_second%60 >= 10) {
            sec = [NSString stringWithFormat:@"%ld",_second%60];
        }else{
            sec = [NSString stringWithFormat:@"0%ld",_second%60];
        }
        time = [NSString stringWithFormat:@"00:%@",sec];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(second:)]) {
        [self.delegate second:time];
    }
}
-(void)getData:(GetDataSource)data
{
    WS(ws);
    [[FPNetwork POST:API_GetdocfullanwerconsultationV1 withParams:@{@"UUID":_uuid,@"UserID":@(kCurrentUser.userId),@"Type":@0}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success == YES) {
            ws.dataSource = [MyAnserEntity mj_objectArrayWithKeyValuesArray:response.data];
            NSLog(@"ws.dataSource - is- %@",ws.dataSource);
            data(ws.dataSource);
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
            
        }
    }];
    
}
////加载问题详情
//- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block{
//    WS(ws);
//    [[FPNetwork POST:@"GetExpertConsultation" withParams:@{@"userid":@(kCurrentUser.userId),@"UUID":@(uuid)}] addCompleteHandler:^(FPResponse *response) {
//        if (response.success == YES) {
//            NSArray *array = [MyAnserEntity mj_objectArrayWithKeyValuesArray:response.data];
//            ws.myAnswer = array.firstObject;
//            ws.myAnswer.uuid = [NSString stringWithFormat:@"%d",uuid];
//            ws.url = ws.myAnswer.voiceUrl;
//            block(YES,nil);
//        }else{
//            block(NO,nil);
//        }
//    }];
//}
////加载追问问题
//- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block{
//    //GetExpertConsultationTraceList
//    [[FPNetwork POST:@"GetExpertConsultationTraceList" withParams:@{@"userid":@(kCurrentUser.userId),@"ConsultationID":@(consultationID),@"PageIndex":@"1",@"PageSize":@"1000"}] addCompleteHandler:^(FPResponse *response) {
//        if (response.success == YES) {
//            _dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
//            block(YES,nil);
//        }else{
//            block(NO,nil);
//        }
//    }];
//}

@end
