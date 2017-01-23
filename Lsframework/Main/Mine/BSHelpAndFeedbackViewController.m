//
//  BSHelpAndFeedbackViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHelpAndFeedbackViewController.h"
#import "ImageWidget.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "MHeplFeedbackPresenter.h"

@interface BSHelpAndFeedbackViewController ()<UITextViewDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, uploadFileDelegate>
{
    NSString *_audioPath;
}

@property (weak, nonatomic  ) IBOutlet UILabel            *describeTVPlaceholderLabel;
@property (weak, nonatomic  ) IBOutlet UITextView         *describeTV;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *describeTVHeight;
@property (weak, nonatomic  ) IBOutlet UIButton           *voiceBtn;
@property (weak, nonatomic  ) IBOutlet UIButton           *voicepopBtn;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *voicepopWidth;
@property (weak, nonatomic  ) IBOutlet UITextField        *phoneNumTF;
@property (weak, nonatomic  ) IBOutlet UIButton           *submitBtn;
@property (weak, nonatomic  ) IBOutlet ImageWidget        *imageWidget;
@property (weak, nonatomic  ) IBOutlet UILabel            *voiceLabel;
@property (nonatomic, strong) AVAudioRecorder        *recorder;
@property (nonatomic, strong) AVAudioPlayer          *audioPlay;

@property (nonatomic, strong) MHeplFeedbackPresenter *presenter;

@end

@implementation BSHelpAndFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    self.title = @"帮助与反馈";
    _describeTV.delegate = self;
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTF.text = kCurrentUser.phone;
    _phoneNumTF.delegate = self;
    [_phoneNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self setupVoice];
    
}

- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn == _voicepopBtn) {
        
        if (!btn.isSelected) {
            btn.selected = YES;
            [self playAudio];
        }else {
            btn.selected = NO;
            [self.audioPlay stop];
        }
        
    } else if (btn == _submitBtn) {
        
        if ([_describeTV.text trimming].length == 0) {
            [SVProgressHUD showErrorWithStatus:@"信息不能为空，请重新输入"];
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:2.0f];
        }else {
//            [SVProgressHUD showWithStatus:@"后台字段对不上！" maskType:SVProgressHUDMaskTypeGradient];
//            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:2.0f];
            
            self.presenter = [[MHeplFeedbackPresenter alloc] init];
            self.presenter.delegate = self;
//            [self.presenter requestWithDescriptionStr:_describeTV.text withVoicePathStr:_audioPath withPhotoPathArary:_imageWidget.urls withPhoneNum:_phoneNumTF.text withVoiceCurrentTime:_voicepopBtn.tag];
            [self.presenter requestWithDescriptionStr:_describeTV.text withVoicePathStr:nil withPhotoPathArary:nil withPhoneNum:_phoneNumTF.text withVoiceCurrentTime:0];
        }
    }
}

- (void)sendMessage:(NSString *)message {
    
    NSLog(@"%@", message);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dismissHUD {
    
    [ProgressUtil dismiss];
    
}

- (void)setupVoice {
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    [_voiceBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [_voiceBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
}

// 最上面具体描述输入框
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        _describeTVPlaceholderLabel.hidden = NO;
    }else {
        _describeTVPlaceholderLabel.hidden = YES;
    }
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    _describeTVHeight.constant = newSize.height;
    
}

- (void)touchDown:(UIButton *)btn {
    
    if (TARGET_IPHONE_SIMULATOR) {
        
        [ProgressUtil showInfo:@"请用真机测试录音功能！"];
        [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:2.0f];
        
    } else {
        
        _voicepopBtn.hidden = YES;
        _voiceLabel.hidden = NO;
        [self beginRecod];
        
    }
}

- (void)touchUpInside:(UIButton *)btn {
    
    if (self.recorder.currentTime <= 60) {
        _voicepopWidth.constant = 80 + (kScreenWidth / 2 - 80) * (self.recorder.currentTime / 60);
    } else {
        _voicepopWidth.constant = kScreenWidth / 2;
    }
    
    _voicepopBtn.tag = self.recorder.currentTime;
    _voicepopBtn.hidden = NO;
    _voiceLabel.hidden = YES;
    [self.recorder stop];
    
}

- (void)touchCancel:(UIButton *)btn {
    _voicepopBtn.hidden = NO;
    _voiceLabel.hidden = YES;
    [self.recorder stop];
    
}

// 限制输入内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

// 限制输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
}

- (void)beginRecod {
    
    [_recorder deleteRecording];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_audioPath error:nil];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    if(session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _audioPath = [NSString stringWithFormat:@"%@/123.3gpp",docDir];
    
    NSNumber *rate = [NSNumber numberWithFloat:44100.0];
    NSNumber *formatID = [NSNumber numberWithInt:kAudioFormatAppleLossless];
    NSNumber *channel = [NSNumber numberWithInt:1];
    NSNumber *quality = [NSNumber numberWithInt:AVAudioQualityMax];
    
    NSDictionary *recordSettings= [[NSDictionary alloc] initWithObjectsAndKeys:rate, AVSampleRateKey, formatID, AVFormatIDKey,channel, AVNumberOfChannelsKey,quality, AVEncoderAudioQualityKey,nil];
    
    NSError *error = nil;
    //必须真机上测试,模拟器上可能会崩溃
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_audioPath]
                                                settings:recordSettings
                                                   error:&error];
    
    // 打开音量检测
    _recorder.meteringEnabled = YES;
    
    // 创建文件准备录音
    [_recorder prepareToRecord];

    [_recorder record];
    
}

- (void)playAudio {
    //初始化播放器对象
    self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_audioPath] error:nil];
    //设置声音的大小
    self.audioPlay.volume = 1;//范围为（0到1）；
    //设置循环次数，如果为负数，就是无限循环
    self.audioPlay.numberOfLoops = 0;
    //设置播放进度
    self.audioPlay.currentTime = 0;
    //准备播放
    [self.audioPlay prepareToPlay];
    [self.audioPlay play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-帮助反馈页面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-帮助反馈页面"];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
