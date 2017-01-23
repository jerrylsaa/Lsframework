//
//  MyQuestionDetailPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyQuestionDetailPresenter.h"
#import "VoiceConverter.h"
#import "MyListenPayPresenter.h"
#import "ZHProgressView.h"
#import <SVProgressHUD.h>


@interface MyQuestionDetailPresenter ()<PayDelegate,ZHAVRecoderDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;

@property (nonatomic, strong) MyListenPayPresenter *listenPay;

@end

@implementation MyQuestionDetailPresenter

- (instancetype)init{
    if (self = [super init]) {
        _listenPay = [MyListenPayPresenter new];
        _listenPay.delegate = self;
        _player.delegate = self;
    }
    return self;
}


- (void)play:(playStart)block{
    NSArray* result = [_myReply.VoiceUrl componentsSeparatedByString:@"/"];
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
            //先转码，在播放
            NSLog(@"转码");
            NSString* downloadPath = [NSString getDownloadPath:_myReply.VoiceUrl];
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
                block(NO);
            }
        }
        BOOL success = [self playWith:audioURL];
        block(success);
    }else{
        //语音文件不存在，下载
        NSLog(@"文件不存在");
        [ProgressUtil show];
//        ZHProgressView *progress = ZHProgress;
//        [progress show];
        [[FPNetwork DOWNLOAD:_myReply.VoiceUrl downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
            
//            progress.progressValue = pregress.fractionCompleted;
            
        } withCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
            if(response.success){
                NSLog(@"url = %@",response.downloadPath);
                
                //先转码，在播放
                NSLog(@"转码");
                NSString* downloadPath = [NSString getDownloadPath:_myReply.VoiceUrl];
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
                    block(NO);
                }
            }else{
                //下载失败
                NSLog(@"下载失败");
                block(NO);
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
}
- (void)audioEndWith:(AudioType)audioType message:(NSString *)message{
        [_timer invalidate];
        _timer = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
            [self.delegate playFinished];
        }
}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    [_timer invalidate];
//    _timer = nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
//        [self.delegate playFinished];
//    }
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
//支付
- (void)payWithPayType:(NSString *) payType{
    [_listenPay payWithPayType:payType expertID:_myReply.Expert_ID consultationID:_myReply.uuid];
}

- (void)payComplete:(BOOL)success{
    if (self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:)]) {
        [self.delegate payCallBack:success];
    }
}
//加载问题详情
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block{
    WS(ws);
    [[FPNetwork POST:@"GetExpertConsultation" withParams:@{@"userid":@(kCurrentUser.userId),@"UUID":@(uuid)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSArray *array = [MyReply mj_objectArrayWithKeyValuesArray:response.data];
            ws.myReply = array.firstObject;
            ws.myReply.uuid = ((NSDictionary *)((NSArray *)response.data).firstObject)[@"uuiD"];
            block(YES,nil);
        }else{
            block(NO,nil);
        }
    }];
}

//加载追问问题
- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block{
    //GetExpertConsultationTraceList
    [[FPNetwork POST:@"GetExpertConsultationTraceListV2" withParams:@{@"userid":@(kCurrentUser.userId),@"ConsultationID":@(consultationID),@"PageIndex":@"1",@"PageSize":@"1000"}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            _dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
            block(YES,nil);
        }else{
            block(NO,nil);
        }
    }];
}

- (void)addExpertComment:(NSString *)comment Stars:(NSInteger )stars ConsultationID:(NSNumber *)consultationID ExpertID:(NSNumber *)expertID{
    WS(ws);
    [[FPNetwork POST:API_AddExpertComment withParams:@{@"StarLevel":@(stars),@"ConsultationID":consultationID,@"CommentConetent":comment,@"ExpertID":expertID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addExpertCommentSuccess)]) {
                [self.delegate addExpertCommentSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
}

- (void)GetExpertCommentListByConsultationID:(NSNumber *)uuid{
    WS(ws);
    [[FPNetwork POST:API_GetExpertCommentList withParams:@{@"ConsultationID":uuid,@"PageIndex":@1,@"PageSize":@1}] addCompleteHandler:^(FPResponse *response) {

        if (response.success == YES) {
            NSArray *array = [ExpertCommentListEntity mj_objectArrayWithKeyValuesArray:response.data];
            if (array.count!=0) {
                ws.myComment = array.firstObject;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getExpertCommentListSuccess)]) {
                [self.delegate getExpertCommentListSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
}



@end
