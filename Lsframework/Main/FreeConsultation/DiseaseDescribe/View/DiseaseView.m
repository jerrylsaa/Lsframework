//
//  DiseaseView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiseaseView.h"

@interface DiseaseView (){
//    UIImageView* _voicepop;
    ClickVoiceButtonBlock block;
    
    
}

@end

@implementation DiseaseView

-(instancetype)init{
    self= [super init];
    if(self){
        self.backgroundColor=UIColorFromRGB(0xf2f2f2);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = UIColorFromRGB(0x666666);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"按住说话";
    [self addSubview:_titleLabel];

    
    
    //语音按钮
    _voiceBt=[UIButton new];
    [_voiceBt setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self addSubview:_voiceBt];
    _voiceBt.tag=200;
    _voiceBt.sd_layout.topSpaceToView(self,15).heightIs(50).rightSpaceToView(self,20).widthEqualToHeight();
    
    [_voiceBt addTarget:self action:@selector(recordAudioAction:) forControlEvents:UIControlEventTouchDown];
    [_voiceBt addTarget:self action:@selector(recordAudioAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //气泡
    _voicePop=[UIButton new];
    [_voicePop setBackgroundImage:[UIImage imageNamed:@"voicpop"] forState:UIControlStateNormal];
    [_voicePop setBackgroundImage:[UIImage imageNamed:@"voicpop"] forState:UIControlStateHighlighted];
    [self addSubview:_voicePop];
    _voicePop.sd_layout.topEqualToView(_voiceBt).bottomSpaceToView(self,15).rightSpaceToView(_voiceBt,20).widthIs(140);
    _voicePop.tag=201;
    _voicePop.hidden=YES;
    [_voicePop addTarget:self action:@selector(voicAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView* bottomLine=[UIView new];
    bottomLine.backgroundColor=RGB(211, 211, 211);
    [self addSubview:bottomLine];
    bottomLine.sd_layout.bottomSpaceToView(self,0).heightIs(1).leftSpaceToView(self,0).rightSpaceToView(self,0);
    
    _titleLabel.sd_layout.centerYEqualToView(_voiceBt).autoHeightRatio(0).leftSpaceToView(self,20);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

}


/**
 *  录音
 *
 *  @param bt <#bt description#>
 */
- (void)recordAudioAction:(UIButton*) bt{
    
    if(!_voicePop.hidden)_voicePop.hidden = YES;

    _titleLabel.text = @"正在录音";
    
    //录音
    block(bt,AudioRecordButton);
    
}

/**
 *  按下录音
 */
- (void)audioDownAction:(UIButton*) bt{
    NSLog(@"==");
}

/**
 *  松开结束
 */
- (void)audioUpAction:(UIButton*) bt{
    NSLog(@"***");
}

/**
 *  播放录音
 *
 *  @param bt <#bt description#>
 */
- (void)voicAction:(UIButton*) bt{
    //播放
    block(bt,AudioPlayerButton);
}




#pragma mark - 公共方法
-(void)clickVoiceButtonOnCompletion:(ClickVoiceButtonBlock)voiceBtBlock{
    block = [voiceBtBlock copy];
}


@end
