//
//  DiseaseDescribeViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiseaseDescribeViewController.h"
#import "DiseaseDescribePresenter.h"
#import "DiseaseView.h"
#import "DiseaseHeaderView.h"
//#import "DiseaseCollectionViewCell.h"
#import "SubmitDescribeSuccessViewController.h"
#import "ImageWidget.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Category.h"

#define diseaseTextKeyPath @"diseaseText"//病情描述keyPath
#define diseaseAudioKeyPath @"diseaseAudio"//病情语音描述
#define pictureKeyPath @"picture"//图片
#define drugTextKeyPath @"drugText"//治疗情况
#define drugAudionKeyPath @"drugAudio"//治疗情况语音



@interface DiseaseDescribeViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,DiseaseDescribePresenterDelegate>{
    UIScrollView* _scrollView;
    DiseaseHeaderView* _headerBgView;
    DiseaseView* _diseaseView;
    DiseaseHeaderView* _medHeaderBgView;
    DiseaseView* _medicalView;
    ImageWidget* _picCollectionView;
    UIView* _imageWidgetBgView;
    
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

@implementation DiseaseDescribeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* error= nil;
    [audioSession setActive:YES error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:audioSession];
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
    
    _diseaseView.tf.text = [NSString showContent:diseaseTextKeyPath];//病情描述
    //病情描述语音
    NSString* sickDescribePath = [NSString showContent:diseaseAudioKeyPath];
    if(sickDescribePath){
        _diseaseView.voicePop.hidden=NO;
        self.sickDescriberURL = [NSURL URLWithString:sickDescribePath];
    }
    
    //图片
    NSArray* picPathArray = [[NSUserDefaults standardUserDefaults] objectForKey:pictureKeyPath];
    _picCollectionView.urls = [NSMutableArray arrayWithArray:picPathArray];
    
    
    _medicalView.tf.text = [NSString showContent:drugTextKeyPath];//治疗情况
    //药物使用语音
    NSString* drugDescribePath = [NSString showContent:drugAudionKeyPath];
    if(drugDescribePath){
        _medicalView.voicePop.hidden = NO;
        self.medicalDescriberURL = [NSURL URLWithString:drugDescribePath];
    }
}

-(void)setupView{
    self.title=@"病情描述";
    self.presenter=[DiseaseDescribePresenter new];
    self.presenter.delegate=self;
    
    _scrollView=[UIScrollView new];
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    //    _scrollView.bounces=NO;
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.topSpaceToView(self.view,0).bottomSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0);
    
    [self setupHeaderView];
    [self setupSickDescribeView];
    [self setupCollectionView];
    [self setupMedicalHeaderView];
    [self setupMedicalView];
    [self setupCommitButton];
    
}
/**
 *  headerView
 */
- (void)setupHeaderView{
    NSString* title1=@"请您详细描述您宝贝的病情,";
    NSString* title2=@"以便得到医生更好的回答";
    _headerBgView=[DiseaseHeaderView new];
    [_scrollView addSubview:_headerBgView];
    _headerBgView.sd_layout.topSpaceToView(_scrollView,0).heightIs(80).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    _headerBgView.titleArray=@[title1,title2];
}

/**
 *  病情描述
 */
- (void)setupSickDescribeView{
    _diseaseView=[DiseaseView new];
    _diseaseView.placholder=@"例如：头痛一年多";
    _diseaseView.title = @"病情描述:";
    [_scrollView addSubview:_diseaseView];
    _diseaseView.sd_layout.topSpaceToView(_headerBgView,0).heightIs(130).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    WS(ws);
    [_diseaseView clickVoiceButtonOnCompletion:^(UIButton *bt, ButtonType buttonType) {
        if(buttonType==AudioRecordButton){
        //录音
            NSString* tempDir = NSTemporaryDirectory();
            NSString* soundFilePath=[tempDir stringByAppendingString:@"sickDescribe.3gpp"];
            ws.sickDescriberPath = soundFilePath;
            ws.sickDescriberURL=[NSURL fileURLWithPath:soundFilePath];
            
            [ws avAudioRecorderWithURL:ws.sickDescriberURL];
            
        }else if(buttonType==AudioPlayerButton){
        //播放
            [ws avAudioPlayerWithURL:ws.sickDescriberURL];
        }
    }];
}

/**
 *  collectionView
 */
- (void)setupCollectionView{
    [_diseaseView updateLayout];
    
    _imageWidgetBgView=[UIView new];
    _imageWidgetBgView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_imageWidgetBgView];
    _imageWidgetBgView.sd_layout.topSpaceToView(_diseaseView,0).minHeightIs(80).maxHeightIs(80).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);

    
    _picCollectionView = [[ImageWidget alloc] init];
    [_imageWidgetBgView addSubview:_picCollectionView];
    _picCollectionView.sd_layout.topSpaceToView(_imageWidgetBgView,0).minHeightIs(80).maxHeightIs(80).leftSpaceToView(_imageWidgetBgView,20).rightSpaceToView(_imageWidgetBgView,20);
}

- (void)setupMedicalHeaderView{
    NSString* title=@"药物使用或其他治疗情况";
    _medHeaderBgView=[DiseaseHeaderView new];
    [_scrollView addSubview:_medHeaderBgView];
    _medHeaderBgView.sd_layout.topSpaceToView(_imageWidgetBgView,0).heightIs(50).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    _medHeaderBgView.titleArray=@[title];

}
/**
 *  药物使用描述
 */
- (void)setupMedicalView{
    _medicalView=[DiseaseView new];
    _medicalView.placholder=@"例如：止疼片";
    _medicalView.title = @"治疗情况：";
    [_scrollView addSubview:_medicalView];
    _medicalView.sd_layout.topSpaceToView(_medHeaderBgView,0).heightIs(130).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    
    WS(ws);
    [_medicalView clickVoiceButtonOnCompletion:^(UIButton *bt, ButtonType buttonType) {
        if(buttonType==AudioRecordButton){
            //录音
            NSString* tempDir = NSTemporaryDirectory();
            NSString* soundFilePath=[tempDir stringByAppendingString:@"medical.3gpp"];//medical.caf
            ws.medicalDescriberPath = soundFilePath;
            
            ws.medicalDescriberURL=[NSURL fileURLWithPath:soundFilePath];
            
            [ws avAudioRecorderWithURL:ws.medicalDescriberURL];
            
        }else if(buttonType==AudioPlayerButton){
            //播放
            [ws avAudioPlayerWithURL:ws.medicalDescriberURL];
        }
    }];
    
}

/**
 *  提交按钮
 */
- (void)setupCommitButton{
    UIButton* commitbt=[UIButton new];
    [commitbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [commitbt setTitle:@"提交" forState:UIControlStateNormal];
    [commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:commitbt];
    commitbt.sd_layout.topSpaceToView(_medicalView,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    [_scrollView setupAutoContentSizeWithBottomView:commitbt bottomMargin:15];
    
}



#pragma mark - 点击事件
/**
 *  提交按钮
 */
- (void)commitAction{
    NSString* result = [_diseaseView.tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(result.length == 0){
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写病情描述" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;

    }
    
    if(_picCollectionView.urls.count == 0 && !self.sickDescriberURL && !self.medicalDescriberURL){
        //病情文字描述
        self.caseInfo.descriptionDisease = _diseaseView.tf.text;
        //病情语音描述
        self.caseInfo.descriptionDiseaseAudio = @"";
        //图片
        self.caseInfo.descriptionDiseaseImage = @"";
        //药物文字描述
        if(_medicalView.tf.text.length != 0){
            self.caseInfo.drugAndInspect=_medicalView.tf.text;
        }else{
            self.caseInfo.drugAndInspect = @"";
        }
        //药物语音描述
        self.caseInfo.drugAndInspectAudio = @"";
        
        _commitSuccess = YES;
        
        [kdefaultCenter postNotificationName:Notification_ShowCommitInfo object:nil userInfo:@{@"showInfo":@1}];
        
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    
    
    [ProgressUtil show];
    
    UploadPath* uploadPath=[UploadPath new];
    uploadPath.urls=_picCollectionView.urls;
    uploadPath.sickDescribeURL=self.sickDescriberURL;
    uploadPath.medicalURL=self.medicalDescriberURL;
    
    [self.presenter commitSickDescirbe:uploadPath];
    
    
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
            if(!_diseaseView.voicePop.hidden) return ;
            _diseaseView.voicePop.hidden=NO;
        }else if([recorder.url isEqual:self.medicalDescriberURL]){
            if(!_medicalView.voicePop.hidden) return ;
            _medicalView.voicePop.hidden=NO;
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
        self.caseInfo.descriptionDisease = _diseaseView.tf.text;
        
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
        
        if(_medicalView.tf.text.length != 0){
            self.caseInfo.drugAndInspect=_medicalView.tf.text;
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

#pragma mark - 私有方法

/**
 *  录音
 */
- (void)avAudioRecorderWithURL:(NSURL*) url{
    WS(ws);
    if([self canRecorder]){
        if(ws.audioRecorder.recording){
            //停止录音
            [ws.audioRecorder stop];
            ws.audioRecorder=nil;
            NSError* error = nil;
            [[AVAudioSession sharedInstance] setActive:NO error:&error];
        }else{
            [ProgressUtil showSuccess:@"按住录音，松开结束"];
            
            //开始录音
            NSError* categoryError=nil;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&categoryError];
            
            NSNumber* rate = [NSNumber numberWithFloat:44100.0];
            NSNumber* formatID = [NSNumber numberWithInt:kAudioFormatAppleLossless];
            NSNumber* channel = [NSNumber numberWithInt:1];
            NSNumber* quality = [NSNumber numberWithInt:AVAudioQualityMax];
            
            NSDictionary* recordSettings= [[NSDictionary alloc] initWithObjectsAndKeys:rate, AVSampleRateKey, formatID, AVFormatIDKey,channel, AVNumberOfChannelsKey,quality, AVEncoderAudioQualityKey,nil];
            
            NSError* error = nil;
            ws.audioRecorder=[[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
            ws.audioRecorder.delegate=ws;
            [ws.audioRecorder prepareToRecord];
            [ws.audioRecorder record];
        }
    }

}

/**
 *  播放录音
 */
- (void)avAudioPlayerWithURL:(NSURL*) url{
    WS(ws);
    if(ws.audioPlayer.playing){
        [ws.audioPlayer pause];
        ws.audioPlayer=nil;
    }else{
        NSError* sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];//解决录音完成以后，播放声音小的问题
        
        NSError* error=nil;
        ws.audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        ws.audioPlayer.delegate=ws;
        ws.audioPlayer.volume=1.0;
        [ws.audioPlayer prepareToPlay];
        [ws.audioPlayer play];
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

/**
 *  保存图片到本地
 */
- (void)savePictureAndAudioToLocal{
    
}

/**
 *  保存到本地
 */
- (void)saveToLocal{
    //保存病情描述
//    if([NSString showContent:diseaseTextKeyPath])
    [_diseaseView.tf.text saveText:diseaseTextKeyPath];
    //病情描述语音
    if(self.sickDescriberURL){
        [self.sickDescriberPath saveText:diseaseAudioKeyPath];
    }else{
        [NSString clearText:diseaseAudioKeyPath];
    }
    
    //图片
    if(_picCollectionView.urls.count != 0){
        NSMutableArray* picPathArray = [NSMutableArray arrayWithCapacity:_picCollectionView.urls.count];
        
        for(NSString* url in _picCollectionView.urls){
            UIImage* image = [UIImage imageWithContentsOfFile:url];
            NSString* imageURL = [image saveToLocal];
            [picPathArray addObject:imageURL];
        }
        [[NSUserDefaults standardUserDefaults] setObject:picPathArray forKey:pictureKeyPath];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:pictureKeyPath];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    //治疗情况
    if(_medicalView.tf.text.length != 0){
        [_medicalView.tf.text saveText:drugTextKeyPath];
    }else{
        [NSString clearText:drugTextKeyPath];
    }
    //治疗语音
    if(self.medicalDescriberURL){
        [self.medicalDescriberPath saveText:drugAudionKeyPath];
    }else{
        [NSString clearText:drugAudionKeyPath];
    }
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
