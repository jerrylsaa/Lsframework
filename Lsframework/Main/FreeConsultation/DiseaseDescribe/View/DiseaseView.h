//
//  DiseaseView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/3/29.
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

@interface DiseaseView : UIView

@property(nonatomic,retain) ZHLeftViewTextField* tf;

@property(nonatomic,copy) NSString* title;

@property(nonatomic,copy) NSString* placholder;

@property(nonatomic,retain) UIButton* voiceBt;

@property(nonatomic,retain) UIButton* voicePop;

@property(nonatomic,retain) UILabel* titleLabel;

/**
 *  点击语音按钮回调
 *
 *  @param block <#block description#>
 */
- (void)clickVoiceButtonOnCompletion:(ClickVoiceButtonBlock) voiceBtBlock;



@end
