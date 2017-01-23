//
//  AVRecorderPlayerManager.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AVRecorderPlayerManager.h"

@interface AVRecorderPlayerManager (){
    CompletionPlayer _block;
}

@end

@implementation AVRecorderPlayerManager

+(instancetype)sharedManager{
    
    static AVRecorderPlayerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AVRecorderPlayerManager new];
    });
    return manager;
}

-(void)playerAudio:(NSURL *)voiceURL completionHandler:(CompletionPlayer)completionPlayer{
    NSError* error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:voiceURL error:&error];
    _player.delegate = self;
    _player.volume = 1.0;
    [_player prepareToPlay];
    [_player play];
    
    _block = [completionPlayer copy];
}

-(void)pause{
    if(_player.playing){
        [_player pause];
        _player = nil;
    }
}

-(void)play{
    [_player play];
}
- (void)stop{
    [_player stop];
}

#pragma mark - 代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _block(_player);
}



@end
