//
//  MHeplFeedbackView.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHeplFeedbackView.h"


@interface  MHeplFeedbackView(){
    //    UIImageView* _voicepop;
    ClickVoiceButtonBlock block;
}

@end


@implementation MHeplFeedbackView

-(instancetype)init{
    self= [super init];
    if(self){
        self.backgroundColor=UIColorFromRGB(0xf2f2f2);
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews{
   
    
    _tf=[ZHLeftViewTextField new];
    //    _tf.textAlignment=NSTextAlignmentCenter;
    _tf.title=@"具体描述:";
    _tf.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:_tf];
    _tf.sd_layout.leftSpaceToView(self,20).rightSpaceToView(self, 0).topSpaceToView(self,10).heightIs(20);
    
    UIView* line=[UIView new];
    line.backgroundColor=[UIColor whiteColor];
    [self addSubview:line];
    line.sd_layout.topSpaceToView(_tf,10).heightIs(10).leftSpaceToView(self,0).rightSpaceToView(self,0);

    //语音按钮
    _voiceBt=[UIButton new];
    [_voiceBt setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [_voiceBt addTarget:self action:@selector(voicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceBt];
    _voiceBt.tag=200;
    _voiceBt.sd_layout.topSpaceToView(line,15).heightIs(50).rightSpaceToView(self,20).widthEqualToHeight();
    
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
    bottomLine.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.3];
    [self addSubview:bottomLine];
    bottomLine.sd_layout.topSpaceToView(_voiceBt,10).heightIs(1).leftSpaceToView(self,0).rightSpaceToView(self,0);

}
/**
 *  点击事件
 *
 *  @param bt <#bt description#>
 */
- (void)voicAction:(UIButton*) bt{
    if(bt.tag==200){
        //录音
        block(bt,AudioRecordButton);
    }else if(bt.tag==201){
        //播放
        block(bt,AudioPlayerButton);
    }
}

#pragma mark - 公共方法
-(void)clickVoiceButtonOnCompletion:(ClickVoiceButtonBlock)voiceBtBlock{
    block = [voiceBtBlock copy];
}

-(void)setPlacholder:(NSString *)placholder{
    _placholder=placholder;
    _tf.placeholder=placholder;
}


@end
