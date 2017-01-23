//
//  MHeplFeedbackView.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPTextField.h"
#import "ZHLeftViewTextField.h"

typedef NS_ENUM(NSInteger, ButtonType) {
    AudioRecordButton,//录音按钮
    AudioPlayerButton//播放按钮
};

typedef void (^ ClickVoiceButtonBlock) (UIButton* bt,ButtonType buttonType);



@interface MHeplFeedbackView : UIView

@property(nonatomic,retain) ZHLeftViewTextField* tf;

@property(nonatomic,copy) NSString* placholder;

@property(nonatomic,retain) UIButton* voiceBt;

@property(nonatomic,retain) UIButton* voicePop;

/**
 *  点击语音按钮回调
 *
 *  @param block <#block description#>
 */
- (void)clickVoiceButtonOnCompletion:(ClickVoiceButtonBlock) voiceBtBlock;



@end
