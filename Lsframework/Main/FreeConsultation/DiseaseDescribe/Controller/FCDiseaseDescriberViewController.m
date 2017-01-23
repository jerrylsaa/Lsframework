//
//  FCDiseaseDescriberViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FCDiseaseDescriberViewController.h"
#import "ImageWidget.h"
#import "DiseaseDescribePresenter.h"
#import "SubmitDescribeSuccessViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Category.h"
#import "DiseaseHeaderView.h"
#import "DiseaseView.h"
#import "JMFoundation.h"

#define diseaseTextKeyPath @"diseaseText"//病情描述keyPath
#define diseaseAudioKeyPath @"diseaseAudio"//病情语音描述
#define pictureKeyPath @"picture"//图片
#define drugTextKeyPath @"drugText"//治疗情况
#define drugAudionKeyPath @"drugAudio"//治疗情况语音


@interface FCDiseaseDescriberViewController()<UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,DiseaseDescribePresenterDelegate>{
    UIScrollView* _scroll;
    UIView* _containerView;
    
    DiseaseHeaderView* _titlebgView;
    
    UIView* _diseaseDescriberbgView;
    UILabel* _diseasePlaceholdLabel;
    UITextView* _diseaseTextView;
    
    DiseaseView* _diseaseRecordbgView;
   
    ImageWidget* _picCollectionView;
    UIView* _imageWidgetBgView;

    DiseaseHeaderView* _drugTitlebgView;
    
    UIView* _drugDescriberbgView;
    UILabel* _drugPlaceholdLabel;
    UITextView* _drugTextView;

    DiseaseView* _drugRecordbgView;

    BOOL _commitSuccess;//是否提交成功
}

@property(nonatomic,retain)DiseaseDescribePresenter* presenter;
@property(nonatomic,copy) NSString* sickDescriberPath;
@property(nonatomic,retain) NSString* medicalDescriberPath;

@property(nonatomic,retain) NSURL* sickDescriberURL;
@property(nonatomic,retain) NSURL* medicalDescriberURL;
@property(nonatomic,retain) AVAudioRecorder* audioRecorder;
@property(nonatomic,retain) AVAudioPlayer* audioPlayer;


@end

@implementation FCDiseaseDescriberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
//    NSError* error= nil;
//    [audioSession setActive:YES error:&error];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:audioSession];
    
    self.presenter=[DiseaseDescribePresenter new];
    self.presenter.delegate=self;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(_commitSuccess){
        [self saveToLocal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.showCommitSucessInfo) return ;
    
    _diseasePlaceholdLabel.hidden = YES;
    _diseaseTextView.text = [NSString showContent:diseaseTextKeyPath];//病情描述
    
    [_diseaseTextView updateLayout];
    CGFloat width = _diseaseTextView.width;
    CGFloat diseaseHeight = [JMFoundation calLabelHeight:_diseaseTextView.font andStr:_diseaseTextView.text withWidth:width];
    
    CGFloat textHeight = diseaseHeight;
    if(diseaseHeight > 90){
        textHeight = 90;
    }else if(diseaseHeight < 35){
        textHeight = 35;
    }
    _diseaseTextView.sd_layout.heightIs(textHeight);
    [_diseaseTextView updateLayout];
    [_diseaseRecordbgView updateLayout];

    
    
    //病情描述语音
//    NSString* sickDescribePath = [NSString showContent:diseaseAudioKeyPath];
//    if(sickDescribePath){
//        _diseaseRecordbgView.voicePop.hidden=NO;
//        self.sickDescriberURL = [NSURL URLWithString:sickDescribePath];
//    }
    
    //图片
//    NSArray* picPathArray = [[NSUserDefaults standardUserDefaults] objectForKey:pictureKeyPath];
//    _picCollectionView.urls = [NSMutableArray arrayWithArray:picPathArray];
//    
    _drugTextView.text = [NSString showContent:drugTextKeyPath];//治疗情况
    _drugPlaceholdLabel.hidden = _drugTextView.text.length != 0;

    [_drugTextView updateLayout];
    CGFloat drugWidth = _drugTextView.width;
    CGFloat drugHeight = [JMFoundation calLabelHeight:_drugTextView.font andStr:_drugTextView.text withWidth:drugWidth];
    CGFloat drugTextHeight = drugHeight;
    if(drugHeight > 90){
        drugTextHeight = 90;
    }else if(drugHeight < 35){
        drugTextHeight = 35;
    }
    _drugTextView.sd_layout.heightIs(drugTextHeight);
    [_drugTextView updateLayout];
    [_drugRecordbgView updateLayout];
    

    
    
    //药物使用语音
//    NSString* drugDescribePath = [NSString showContent:drugAudionKeyPath];
//    if(drugDescribePath){
//        _drugRecordbgView.voicePop.hidden = NO;
//        self.medicalDescriberURL = [NSURL URLWithString:drugDescribePath];
//    }
}


#pragma mark - 加载子视图
- (void)setupView{
    self.title = @"病情描述";
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _containerView = [UIView new];
    [_scroll addSubview:_containerView];
    _containerView.sd_layout.topSpaceToView(_scroll,0).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    
    [self setupTitleLabel];
    [self setupDiseaseDescriberView];
//    [self setupDiseaseRecordAudioView];
    
//    [self setupCollectionView];
    
    [self setupDrugTitlebgView];
    [self setupDrugDescriberView];
//    [self setupDrugRecordAudioView];
    
    [self setupCommitButton];
}

- (void)setupTitleLabel{
    NSString* title1=@"请您详细描述您宝贝的病情,";
    NSString* title2=@"以便得到医生更好的回答";
    _titlebgView=[DiseaseHeaderView new];
    [_containerView addSubview:_titlebgView];
    _titlebgView.sd_layout.topSpaceToView(_containerView,0).heightIs(80).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    _titlebgView.titleArray=@[title1,title2];

}

- (void)setupDiseaseDescriberView{
    _diseaseDescriberbgView = [UIView new];
    _diseaseDescriberbgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:_diseaseDescriberbgView];
    
    //标题
    UILabel* title = [UILabel new];
    title.textColor = UIColorFromRGB(0x666666);
    title.font = [UIFont systemFontOfSize:20];
    title.text = @"病情描述：";
    [_diseaseDescriberbgView addSubview:title];
    
    //textView
    _diseaseTextView = [UITextView new];
    _diseaseTextView.textColor = title.textColor;
    _diseaseTextView.font = [UIFont systemFontOfSize:18];
    _diseaseTextView.delegate = self;
    _diseaseTextView.tag= 101;
    _diseaseTextView.backgroundColor = [UIColor clearColor];
    [_diseaseDescriberbgView addSubview:_diseaseTextView];
    
    _diseasePlaceholdLabel = [UILabel new];
    _diseasePlaceholdLabel.textColor = [UIColor lightGrayColor];
    _diseasePlaceholdLabel.font = _diseaseTextView.font;
    _diseasePlaceholdLabel.text = @"例如：头痛一年多";
    [_diseaseDescriberbgView addSubview:_diseasePlaceholdLabel];
    
    //分割线
    UIView* line = [UIView new];
    line.backgroundColor = RGB(211, 211, 211);
    [_diseaseDescriberbgView addSubview:line];

    
    title.sd_layout.topSpaceToView(_diseaseDescriberbgView,15).autoHeightRatio(0).leftSpaceToView(_diseaseDescriberbgView,20);
    [title setSingleLineAutoResizeWithMaxWidth:200];
    _diseaseTextView.sd_layout.leftSpaceToView(title,5).rightSpaceToView(_diseaseDescriberbgView,0).topSpaceToView(_diseaseDescriberbgView,8).heightIs(35);
    _diseasePlaceholdLabel.sd_layout.leftEqualToView(_diseaseTextView).rightSpaceToView(_diseaseDescriberbgView,0).centerYEqualToView(title).autoHeightRatio(0);
    
    
    line.sd_layout.topSpaceToView(_diseaseTextView,15).heightIs(1).leftSpaceToView(_diseaseDescriberbgView,0).rightSpaceToView(_diseaseDescriberbgView,0);

    
    _diseaseDescriberbgView.sd_layout.topSpaceToView(_titlebgView,0).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    [_diseaseDescriberbgView setupAutoHeightWithBottomView:line bottomMargin:0];
}

- (void)setupDiseaseRecordAudioView{
    _diseaseRecordbgView=[DiseaseView new];
    [_containerView addSubview:_diseaseRecordbgView];
    _diseaseRecordbgView.sd_layout.topSpaceToView(_diseaseDescriberbgView,0).heightIs(80).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    
    WS(ws);
    [_diseaseRecordbgView clickVoiceButtonOnCompletion:^(UIButton *bt, ButtonType buttonType) {
        if(buttonType==AudioRecordButton){
            //录音
            ws.sickDescriberURL=[NSURL fileURLWithPath:ws.sickDescriberPath];
            
            [ws avAudioRecorderWithURL:ws.sickDescriberURL];
        }else if(buttonType==AudioPlayerButton){
            //播放
            [ws avAudioPlayerWithURL:ws.sickDescriberURL];
        }
    }];
}

- (void)setupCollectionView{
//    [_diseaseRecordbgView updateLayout];
    
    _imageWidgetBgView=[UIView new];
    _imageWidgetBgView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:_imageWidgetBgView];
    
    _picCollectionView = [[ImageWidget alloc] init];
    [_imageWidgetBgView addSubview:_picCollectionView];
    
    
    _picCollectionView.sd_layout.topSpaceToView(_imageWidgetBgView,0).minHeightIs(80).maxHeightIs(80).leftSpaceToView(_imageWidgetBgView,20).rightSpaceToView(_imageWidgetBgView,20);
    _imageWidgetBgView.sd_layout.topSpaceToView(_diseaseRecordbgView,0).heightIs(80).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
}

- (void)setupDrugTitlebgView{
    NSString* title=@"药物使用或其他治疗情况";
    _drugTitlebgView=[DiseaseHeaderView new];
    [_containerView addSubview:_drugTitlebgView];
//    _drugTitlebgView.sd_layout.topSpaceToView(_imageWidgetBgView,0).heightIs(50).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    _drugTitlebgView.titleArray=@[title];
    
    
    _drugTitlebgView.sd_layout.topSpaceToView(_diseaseDescriberbgView,0).heightIs(50).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
}

- (void)setupDrugDescriberView{
    _drugDescriberbgView = [UIView new];
    _drugDescriberbgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:_drugDescriberbgView];
    
    //标题
    UILabel* title = [UILabel new];
    title.textColor = UIColorFromRGB(0x666666);
    title.font = [UIFont systemFontOfSize:20];
    title.text = @"治疗情况：";
    [_drugDescriberbgView addSubview:title];
    
    //textView
    _drugTextView = [UITextView new];
    _drugTextView.textColor = title.textColor;
    _drugTextView.font = [UIFont systemFontOfSize:18];
    _drugTextView.delegate = self;
    _drugTextView.tag= 102;
    _drugTextView.backgroundColor = [UIColor clearColor];
    [_drugDescriberbgView addSubview:_drugTextView];
    
    _drugPlaceholdLabel = [UILabel new];
    _drugPlaceholdLabel.textColor = [UIColor lightGrayColor];
    _drugPlaceholdLabel.font = _diseaseTextView.font;
    _drugPlaceholdLabel.text = @"例如：止疼片";
    [_drugDescriberbgView addSubview:_drugPlaceholdLabel];
    
    //分割线
    UIView* line = [UIView new];
    line.backgroundColor = RGB(211, 211, 211);
    [_drugDescriberbgView addSubview:line];
    
    
    title.sd_layout.topSpaceToView(_drugDescriberbgView,15).autoHeightRatio(0).leftSpaceToView(_drugDescriberbgView,20);
    [title setSingleLineAutoResizeWithMaxWidth:200];
    _drugTextView.sd_layout.leftSpaceToView(title,5).rightSpaceToView(_drugDescriberbgView,0).topSpaceToView(_drugDescriberbgView,8).heightIs(35);
    _drugPlaceholdLabel.sd_layout.leftEqualToView(_drugTextView).rightSpaceToView(_drugDescriberbgView,0).centerYEqualToView(title).autoHeightRatio(0);
    
    
    line.sd_layout.topSpaceToView(_drugTextView,15).heightIs(1).leftSpaceToView(_drugDescriberbgView,0).rightSpaceToView(_drugDescriberbgView,0);
    
    
    _drugDescriberbgView.sd_layout.topSpaceToView(_drugTitlebgView,0).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    [_drugDescriberbgView setupAutoHeightWithBottomView:line bottomMargin:0];

}

- (void)setupDrugRecordAudioView{
    
    _drugRecordbgView=[DiseaseView new];
    [_containerView addSubview:_drugRecordbgView];
    _drugRecordbgView.sd_layout.topSpaceToView(_drugDescriberbgView,0).heightIs(80).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    
    WS(ws);
    [_drugRecordbgView clickVoiceButtonOnCompletion:^(UIButton *bt, ButtonType buttonType) {
        if(buttonType==AudioRecordButton){
            //录音
            ws.medicalDescriberURL=[NSURL fileURLWithPath:ws.medicalDescriberPath];
            
            [ws avAudioRecorderWithURL:ws.medicalDescriberURL];
        }else if(buttonType==AudioPlayerButton){
            //播放
            [ws avAudioPlayerWithURL:ws.medicalDescriberURL];
        }
    }];
}

- (void)setupCommitButton{
    UIButton* commitbt=[UIButton new];
    [commitbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [commitbt setTitle:@"提交" forState:UIControlStateNormal];
    [commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:commitbt];
//    commitbt.sd_layout.topSpaceToView(_drugRecordbgView,15).heightIs(40).leftSpaceToView(_containerView,25).rightSpaceToView(_containerView,25);
    
    commitbt.sd_layout.topSpaceToView(_drugDescriberbgView,15).heightIs(40).leftSpaceToView(_containerView,25).rightSpaceToView(_containerView,25);

    
    [_containerView setupAutoHeightWithBottomView:commitbt bottomMargin:20];
    [_scroll setupAutoContentSizeWithBottomView:_containerView bottomMargin:0];
}

#pragma mark - 点击事件
/**
 *  提交按钮
 */
- (void)commitAction{
    NSString* result = [_diseaseTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(result.length == 0){
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写病情描述" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;
        
    }
    
//    if(_picCollectionView.urls.count == 0 && !self.sickDescriberURL && !self.medicalDescriberURL){
//        //病情文字描述
//        self.caseInfo.descriptionDisease = _diseaseTextView.text;
//        //病情语音描述
//        self.caseInfo.descriptionDiseaseAudio = @"";
//        //图片
//        self.caseInfo.descriptionDiseaseImage = @"";
//        //药物文字描述
//        if(_drugTextView.text.length != 0){
//            self.caseInfo.drugAndInspect=_drugTextView.text;
//        }else{
//            self.caseInfo.drugAndInspect = @"";
//        }
//        //药物语音描述
//        self.caseInfo.drugAndInspectAudio = @"";
//        
//        _commitSuccess = YES;
//        
//        [kdefaultCenter postNotificationName:Notification_ShowCommitInfo object:nil userInfo:@{@"showInfo":@1}];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        return ;
//    }
    
    
    //病情文字描述
    self.caseInfo.descriptionDisease = _diseaseTextView.text;
    //药物文字描述
    if(_drugTextView.text.length != 0){
        self.caseInfo.drugAndInspect=_drugTextView.text;
    }else{
        self.caseInfo.drugAndInspect = @"";
    }
    _commitSuccess = YES;
    
    [kdefaultCenter postNotificationName:Notification_ShowCommitInfo object:nil userInfo:@{@"showInfo":@1}];
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
//    [ProgressUtil show];
//    
//    UploadPath* uploadPath=[UploadPath new];
//    uploadPath.urls=_picCollectionView.urls;
//    uploadPath.sickDescribeURL=self.sickDescriberURL;
//    uploadPath.medicalURL=self.medicalDescriberURL;
//    self.presenter.sickAudioPath = self.sickDescriberPath;
//    self.presenter.drugAudioPath = self.medicalDescriberPath;
//    [self.presenter commitSickDescirbe:uploadPath];
}

- (void)backItemAction:(id)sender{
    [kdefaultCenter postNotificationName:Notification_ShowCommitInfo object:nil userInfo:@{@"showInfo":@0}];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 代理

/**
 *  录音完成回调
 *
 *  @param recorder <#recorder description#>
 *  @param flag     <#flag description#>
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if(flag){
        if([recorder.url isEqual:self.sickDescriberURL]){
            if(!_diseaseRecordbgView.voicePop.hidden) return ;
            _diseaseRecordbgView.voicePop.hidden=NO;
            _diseaseRecordbgView.titleLabel.text = @"按住说话";
        }else if([recorder.url isEqual:self.medicalDescriberURL]){
            if(!_drugRecordbgView.voicePop.hidden) return ;
            _drugRecordbgView.voicePop.hidden=NO;
            _drugRecordbgView.titleLabel.text = @"按住说话";

        }
    }
}

/**
 *  播放完成回调
 *
 *  @param player <#player description#>
 *  @param flag   <#flag description#>
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成－%d",flag);
}

/**
 *  提交病情描述回调
 *
 *  @param success <#success description#>
 *  @param info    <#info description#>
 */
-(void)commitDiseaseDescribeOnComplete:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        //
        self.caseInfo.descriptionDisease = _diseaseTextView.text;
        
        if(self.presenter.audioArray.count == 0){
            self.caseInfo.descriptionDiseaseImage = @"";
            self.caseInfo.drugAndInspectAudio = @"";
        }else{
            self.caseInfo.descriptionDiseaseAudio=[self.presenter.audioArray firstObject];//病情描述
            if(self.presenter.audioArray.count != 1){
                self.caseInfo.drugAndInspectAudio=[self.presenter.audioArray lastObject];//药物描述
            }else{
                self.caseInfo.drugAndInspectAudio = @"";
            }
        }
        
        if(self.presenter.imageUploadPath.length !=0){
            self.caseInfo.descriptionDiseaseImage=self.presenter.imageUploadPath;//图片
        }else{
            self.caseInfo.descriptionDiseaseImage = @"";
        }
        
        if(_drugTextView.text.length != 0){
            self.caseInfo.drugAndInspect=_drugTextView.text;
        }else{
            self.caseInfo.drugAndInspect = @"";
        }
        
        _commitSuccess = YES;
        
        [kdefaultCenter postNotificationName:Notification_ShowCommitInfo object:nil userInfo:@{@"showInfo":@1}];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:info];
    }
}

/**
 *  textView代理
 *
 *  @param textView <#textView description#>
 */
-(void)textViewDidChange:(UITextView *)textView{
    
    if(textView.tag == 101){
    //病情
        if ([textView.text isEqualToString:@""]) {
            _diseasePlaceholdLabel.hidden = NO;
        }else {
            _diseasePlaceholdLabel.hidden = YES;
        }
        CGFloat width = CGRectGetWidth(textView.frame);
        CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
        
        CGFloat textHeight = newSize.height;
        if(newSize.height > 90){
            textHeight = 90;
        }
        textView.sd_layout.heightIs(textHeight);
        [textView updateLayout];
        [_diseaseRecordbgView updateLayout];
    }else if (textView.tag == 102){
        //药物
        if ([textView.text isEqualToString:@""]) {
            _drugPlaceholdLabel.hidden = NO;
        }else {
            _drugPlaceholdLabel.hidden = YES;
        }
        CGFloat width = CGRectGetWidth(textView.frame);
        CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
        
        CGFloat textHeight = newSize.height;
        if(newSize.height > 90){
            textHeight = 90;
        }
        textView.sd_layout.heightIs(textHeight);
        [textView updateLayout];
        [_drugRecordbgView updateLayout];

    }
    
}

#pragma mark - 懒加载
/**
 *  病情录音的本地路径
 *
 *  @return <#return value description#>
 */
-(NSString *)sickDescriberPath{
    if(!_sickDescriberPath){
        NSString* tempDir = NSTemporaryDirectory();
        _sickDescriberPath=[tempDir stringByAppendingString:@"sickDescribe.3gpp"];
    }
    return _sickDescriberPath;
}
/**
 *  药物录音的本地路径
 *
 *  @return <#return value description#>
 */
-(NSString *)medicalDescriberPath{
    if(!_medicalDescriberPath){
        NSString* tempDir = NSTemporaryDirectory();
        _medicalDescriberPath=[tempDir stringByAppendingString:@"medical.3gpp"];//medical.caf
    }
    return _medicalDescriberPath;
}
#pragma mark - 私有方法

/**
 *  保存到本地
 */
- (void)saveToLocal{
    //保存病情描述
    //    if([NSString showContent:diseaseTextKeyPath])
    [_diseaseTextView.text saveText:diseaseTextKeyPath];
    //病情描述语音
//    if(self.sickDescriberURL){
//        [self.sickDescriberPath saveText:diseaseAudioKeyPath];
//    }else{
//        [NSString clearText:diseaseAudioKeyPath];
//    }
    
    //图片
//    if(_picCollectionView.urls.count != 0){
//        NSMutableArray* picPathArray = [NSMutableArray arrayWithCapacity:_picCollectionView.urls.count];
//        
//        for(NSString* url in _picCollectionView.urls){
//            UIImage* image = [UIImage imageWithContentsOfFile:url];
//            NSString* imageURL = [image saveToLocal];
//            [picPathArray addObject:imageURL];
//        }
//        [[NSUserDefaults standardUserDefaults] setObject:picPathArray forKey:pictureKeyPath];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }else{
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:pictureKeyPath];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    }
    
    //治疗情况
    if(_drugTextView.text.length != 0){
        [_drugTextView.text saveText:drugTextKeyPath];
    }else{
        [NSString clearText:drugTextKeyPath];
    }
    //治疗语音
//    if(self.medicalDescriberURL){
//        [self.medicalDescriberPath saveText:drugAudionKeyPath];
//    }else{
//        [NSString clearText:drugAudionKeyPath];
//    }
}

/**
 *  录音
 */
- (void)avAudioRecorderWithURL:(NSURL*) url{
    if([self canRecorder]){
        if(self.audioRecorder.recording){
            //停止录音
            [self.audioRecorder stop];
            self.audioRecorder=nil;
            NSError* error = nil;
            [[AVAudioSession sharedInstance] setActive:NO error:&error];
        }else{
//            [ProgressUtil showSuccess:@"长按录音，松开结束"];
            
            //开始录音
            NSError* categoryError=nil;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&categoryError];
            
            NSNumber* rate = [NSNumber numberWithFloat:44100.0];
            NSNumber* formatID = [NSNumber numberWithInt:kAudioFormatAppleLossless];
            NSNumber* channel = [NSNumber numberWithInt:1];
            NSNumber* quality = [NSNumber numberWithInt:AVAudioQualityMax];
            
            NSDictionary* recordSettings= [[NSDictionary alloc] initWithObjectsAndKeys:rate, AVSampleRateKey, formatID, AVFormatIDKey,channel, AVNumberOfChannelsKey,quality, AVEncoderAudioQualityKey,nil];
            
            NSError* error = nil;
            self.audioRecorder=[[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
            self.audioRecorder.delegate=self;
            [self.audioRecorder prepareToRecord];
            [self.audioRecorder record];
        }
    }
    
}

/**
 *  播放录音
 */
- (void)avAudioPlayerWithURL:(NSURL*) url{
    if(self.audioPlayer.playing){
        [self.audioPlayer pause];
        self.audioPlayer=nil;
    }else{
        NSError* sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];//解决录音完成以后，播放声音小的问题
        
        NSError* error=nil;
        self.audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.delegate=self;
        self.audioPlayer.volume=1.0;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}

/**
 *  是否可以录音
 *
 *  @return <#return value description#>
 */
- (BOOL)canRecorder{
    
    __block BOOL bcanRecorder = YES;
    AVAudioSession* audioSession=[AVAudioSession sharedInstance];
    if([audioSession respondsToSelector:@selector(requestRecordPermission:)]){
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^ (BOOL granted){
            if(granted){
                bcanRecorder=YES;
            }else{
                bcanRecorder=NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView* alert= [[UIAlertView alloc] initWithTitle:nil message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
                    [alert show];
                });
            }
        }];
    }
    
    return bcanRecorder;
}


#pragma mark - 监听通知
/**
 *  处理音频打断通知
 *
 *  @param notification <#notification description#>
 */
- (void)handleInterruption:(NSNotification*) notification{
    NSDictionary* userInfoDic= notification.userInfo;
    NSLog(@"handleInterrupt--userInfo:%@",userInfoDic);
    NSNumber* interruptionType = [userInfoDic valueForKey:AVAudioSessionInterruptionTypeKey];
    if([interruptionType integerValue] == AVAudioSessionInterruptionTypeBegan){
        NSLog(@"interrupt started");
        [self.audioPlayer pause];
    }else if([interruptionType integerValue] == AVAudioSessionInterruptionTypeEnded){
        NSLog(@"interrupt end");
        
        NSNumber* interruptOptions= [userInfoDic valueForKey:AVAudioSessionInterruptionOptionKey];
        if([interruptOptions integerValue] == AVAudioSessionInterruptionOptionShouldResume){
            [self.audioPlayer play];
            
        }
        
    }
}

#pragma mark - dealloc

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
}



@end
