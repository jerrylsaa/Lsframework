//
//  ZHAVRecorder.m
//  FamilyPlatForm
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHAVRecorder.h"

@interface ZHAVRecorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic ,strong) AVAudioRecorder *recorder;
@property (nonatomic ,strong) AVAudioSession *session;
@property (nonatomic ,strong) AVAudioPlayer *player;
//@property (nonatomic ,strong) AVPlayer *avPlayer;
//@property (nonatomic ,strong) AVPlayerItem *item;

@end

@implementation ZHAVRecorder


+ (ZHAVRecorder *)sharedRecorder
{
    static ZHAVRecorder *sharedRecorderInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedRecorderInstance = [[self alloc] init];
    });
    return sharedRecorderInstance;
}


- (void)startRecord{
    
    [self initRecorder];
    
    if (!_session) {
        [self initSession];
    }
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [_session setActive:YES error:nil];
    [_recorder prepareToRecord];
    
    [_recorder record];
    _recording = YES;
    [self timeStart];
}

- (void)stopRecord{
    [_recorder stop];
    [_timer invalidate];
    _timer = nil;
    _second = 0;
    [_session setActive:NO error:nil];
    _recording = NO;
    _recorder = nil;
    _recorder.delegate = nil;
}

- (BOOL)playerStart{
    if (!_session) {
        [self initSession];
    }
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_audioPath] error:nil];
    _player.delegate = self;
    
    if (_session) {
        [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_session setActive:YES error:nil];
    }
    _second = 0;
    [self timeStart];
    [_player prepareToPlay];
    return [_player play];
}

- (void)playerStop{
    if (_player) {
        [_player stop];
        _player = nil;
    }
    [_timer invalidate];
    _timer = nil;
    _second = 0;
    
}

- (void)stop{
    _recorder = nil;
    [_timer invalidate];
    _timer = nil;
    _second = 0;
    _recorder = nil;
    _recorder.delegate = nil;
}

- (void)initRecorder{

    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                                                      [NSNumber numberWithInt: AVAudioQualityMax],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];

    NSTimeInterval timeTnterval = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)timeTnterval];
    _fileName = str;
    _audioPath = [NSString GetPathByFileName:str ofType:@"wav"];

    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_audioPath] settings:recordSettings error:nil];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;

    
}

- (void)initSession{
    _session = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:_session];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)handleInterruption:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
}
- (void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [_session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:_session];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioEndWith:message:)]) {
        [self.delegate audioEndWith:AudioTypeRecorderSuccess message:@"录音完成"];
    }
    if (_session) {
        [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_session setActive:YES error:nil];
    }
    [_timer invalidate];
    _timer = nil;
    _second = 0;
    _recording = NO;
    _recorder = nil;
    _recorder.delegate = nil;
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioEndWith:message:)]) {
        [self.delegate audioEndWith:AudioTypeRecorderError message:@"录音失败"];
    }
    if (_session) {
        [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_session setActive:YES error:nil];
    }
    [_timer invalidate];
    _timer = nil;
    _second = 0;
    _recording = NO;
    _recorder = nil;
    _recorder.delegate = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioEndWith:message:)]) {
        [self.delegate audioEndWith:AudioTypePlayerComplete message:@"播放完成"];
    }
    _player = nil;
    [_timer invalidate];
    _timer = nil;
    _second = 0;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioEndWith:message:)]) {
        [self.delegate audioEndWith:AudioTypePlayerComplete message:@"播放错误"];
    }
    _player = nil;
    [_timer invalidate];
    _timer = nil;
    _second = 0;
}


#pragma mark private
- (void)timeStart{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
}
- (void)timeAdd{
    _second ++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondRefresh:)]) {
        [self.delegate secondRefresh:_second];
    }
}



@end
