//
//  AVRecorderPlayerManager.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^CompletionPlayer)(AVAudioPlayer* player);


@interface AVRecorderPlayerManager : NSObject<AVAudioPlayerDelegate>

@property(nonatomic,retain) AVAudioPlayer* player;

+ (instancetype)sharedManager;


- (void)playerAudio:(NSURL*) voiceURL completionHandler:(CompletionPlayer) completionPlayer;

/**
 *  暂停
 */
- (void)pause;

/**
 *  播放
 */
- (void)play;

/**
 *  停止
 */
- (void)stop;
@end
