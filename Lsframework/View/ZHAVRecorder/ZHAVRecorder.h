//
//  ZHAVRecorder.h
//  FamilyPlatForm
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSUInteger, AudioType) {
    AudioTypeRecorderSuccess,
    AudioTypeRecorderError,
    AudioTypePlayerComplete,
};

@protocol ZHAVRecoderDelegate <NSObject>

- (void)audioEndWith:(AudioType) audioType message:(NSString *)message;

- (void)secondRefresh:(long) second;

@end

@interface ZHAVRecorder : NSObject


//@property (nonatomic ,copy) NSString *sessionCategory;


/***/
@property(nonatomic,copy) NSString* fileName;

+ (ZHAVRecorder *)sharedRecorder;

@property (nonatomic ,weak) id<ZHAVRecoderDelegate> delegate;
@property (nonatomic ,assign) NSInteger second;
@property (nonatomic ,copy) NSString *audioPath;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) BOOL recording;

//开始录音
- (void)startRecord;
//停止录音
- (void)stopRecord;
//开始播放
- (BOOL)playerStart;
//停止播放
- (void)playerStop;
//中止
- (void)stop;



@end
