//
//  AwaitAnswerViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AwaitAnswerViewController.h"
#import "MyAnswerTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MyAnswerPresenter.h"
#import "ZHAVRecorder.h"
#import "UIImage+Category.h"
#import "AwaitAnswerPresenter.h"
#import "MyAnswerPresenter.h"
#import "VoiceConverter.h"
#import "SFPhotoBrowser.h"
#import "MyReplyViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZHProgressView.h"
#import "LCTextView.h"
#import "ConfiguresEntity.h"

#import "MyAnswerViewController.h"

#define _avRecorder [ZHAVRecorder sharedRecorder]

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-10*2-2*kImageXspace)/3

typedef NS_ENUM(NSUInteger, RecordState) {
    RecordStateNormal,
    RecordStateRecording,
    RecordStateComplete,
};

typedef NS_ENUM(NSUInteger, VoiceFileState) {
    VoiceFileOld,
    VoiceFileNew,
};

#define doctorVoicePath @"voice"//医生语音
@interface AwaitAnswerViewController ()<ZHAVRecoderDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,AwaitAnswerPresenterDelegate,MyAnswerPresenterDelegate,
    PhotoBrowerDelegate,UIActionSheetDelegate>{
    NSString* _amrPath;
    long _myTime;
}

//@property(nonatomic,retain) UIImageView* usericon;
//@property(nonatomic,retain) UILabel* myName;
@property(nonatomic,retain) UILabel* questionLabel;
@property(nonatomic,retain) UILabel* timeLabel;
@property(nonatomic,retain) UILabel* listenLable;

@property(nonatomic,strong) UIImageView* doctorIcon;
@property(nonatomic,strong) UIButton* voicebt;
@property(nonatomic,strong) UILabel* times;
@property(nonatomic,strong) UIButton* rerecordbt;
@property(nonatomic,strong) UILabel* characterlb;  //文字补充
@property(nonatomic,strong) LCTextView* textView; //

@property(nonatomic,strong) UIButton* soundsbt;
@property(nonatomic,strong) UILabel* soundslb;
@property(nonatomic,strong) UIButton* commit;

@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic ,assign) RecordState recordState;
@property (nonatomic ,assign) BOOL playing;



@property(nonatomic,strong)AwaitAnswerPresenter  *presenter;

@property(nonatomic,strong)MyAnswerPresenter  *MyAnswerPresenter;

@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView1;
@property (nonatomic, strong) UIImageView *midImageView1;
@property (nonatomic, strong) UIImageView *rightImageView1;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@property(nonatomic)CGRect progressRect;

@property(nonatomic,assign)VoiceFileState voiceFileState;

@property(nonatomic,assign)BOOL isLocalFile;


@end

@implementation AwaitAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待回答";
    
    NSLog(@"image4 is== %@",_MyAnswerEntity.Image4);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)uploadOnComplete:(BOOL)success info:(NSString *)info{
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:info delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(void)setupView{
    _avRecorder.delegate = self;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:[NSString stringWithFormat:@"%@avRecorderPath",_MyAnswerEntity.uuid]] ) {
        _avRecorder.audioPath =[defaults objectForKey:[NSString stringWithFormat:@"%@avRecorderPath",_MyAnswerEntity.uuid]];
        
        [self.soundsbt  setBackgroundImage:[UIImage imageNamed:@"microphone_noclick"] forState:UIControlStateNormal];
        self.soundslb.text = @"录音完成";
        self.soundsbt.enabled = NO;
        self.voicebt.enabled = YES;
        
        NSNumber *time =[defaults objectForKey:[NSString stringWithFormat:@"%@avRecorderTime",_MyAnswerEntity.uuid]];
        _myTime =[time longValue];
        [self refreshLabelText:_myTime];
        
    }
    
    self.presenter = [AwaitAnswerPresenter new];
    self.presenter.delegate = self;
    self.presenter.answerType = self.MyAnswerEntity.answerType;
    self.presenter.doctorID = @(self.MyAnswerEntity.Expert_ID);
    self.presenter.urls = _MyAnswerEntity.voiceUrl;
    NSLog(@"_MyAnswerEntity.voiceUrl--%@",_MyAnswerEntity.voiceUrl);
    self.MyAnswerPresenter = [MyAnswerPresenter  new];
    self.MyAnswerPresenter.delegate = self;
    
    [self  initRightBarWithTitle:@"分享"];
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    UIView   *_containerView = [UIView new];
    _containerView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scrollView addSubview:_containerView];
    
    
    _questionLabel = [UILabel new];
    _questionLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _questionLabel.text = _MyAnswerEntity.consultationContent;
    _questionLabel.font = [UIFont systemFontOfSize:16];
    [_containerView addSubview:_questionLabel];
    
    
    _haveImageBgView =[[UIView alloc]init];
    _haveImageBgView.backgroundColor = [UIColor clearColor];
    [_containerView addSubview:_haveImageBgView];
    
    _leftImageView =[[UIImageView alloc]init];
    
    _leftImageView.contentMode =UIViewContentModeScaleAspectFill;
    _leftImageView.tag =1001;
    _leftImageView.layer.cornerRadius= 8;
    [_leftImageView.layer setBorderWidth:2];
    [_leftImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
    _leftImageView.clipsToBounds =YES;
    _leftImageView.userInteractionEnabled =YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_leftImageView addGestureRecognizer:leftTap];
    [_haveImageBgView addSubview:_leftImageView];
    
    _midImageView =[[UIImageView alloc]init];
    _midImageView.tag =1002;
    _midImageView.contentMode =UIViewContentModeScaleAspectFill;
    _midImageView.layer.cornerRadius= 8;
    [_midImageView.layer setBorderWidth:2];
    [_midImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
    _midImageView.clipsToBounds =YES;
    _midImageView.userInteractionEnabled =YES;
    UITapGestureRecognizer *midTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_midImageView addGestureRecognizer:midTap];
    [_haveImageBgView addSubview:_midImageView];
    
    _rightImageView =[[UIImageView alloc]init];
    _rightImageView.tag =1003;
    _rightImageView.contentMode =UIViewContentModeScaleAspectFill;
    _rightImageView.layer.cornerRadius= 8;
    [_rightImageView.layer setBorderWidth:2];
    [_rightImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
    _rightImageView.clipsToBounds =YES;
    _rightImageView.userInteractionEnabled =YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_rightImageView addGestureRecognizer:rightTap];
    [_haveImageBgView addSubview:_rightImageView];
    
    _leftImageView1 = [self newImageWithTag:1004];
    [_haveImageBgView addSubview:_leftImageView1];
    
    _midImageView1 = [self newImageWithTag:1005];
    [_haveImageBgView addSubview:_midImageView1];
    
    _rightImageView1 = [self newImageWithTag:1006];
    [_haveImageBgView addSubview:_rightImageView1];
    
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
//    NSString* AwaitAnswerDetailTime = [NSDate getDateCompare:_MyAnswerEntity.createTime];
//    _timeLabel.text =AwaitAnswerDetailTime;
    _timeLabel.text =  _MyAnswerEntity.createTime;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.numberOfLines = 0;
    [_containerView addSubview:_timeLabel];
    
    _listenLable = [UILabel new];
    _listenLable.textColor = _timeLabel.textColor;
    _listenLable.font = _timeLabel.font;
    _listenLable.text = [NSString  stringWithFormat:@"听过：%ld",(long)_MyAnswerEntity.hearCount];
    _listenLable.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_listenLable];
    
    
    UIView   *FootView = [UIView new];
    FootView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:FootView];
    
    self.doctorIcon = [UIImageView new];
    self.doctorIcon.layer.masksToBounds = YES;
    self.doctorIcon.layer.cornerRadius = 20;
    [self.doctorIcon  sd_setImageWithURL:[NSURL  URLWithString:_MyAnswerEntity.imageUrl] placeholderImage:[UIImage  imageNamed:@"HEADoctorIcon"]];
    [FootView addSubview:self.doctorIcon ];
    // 播放录音
    self.voicebt = [UIButton  new];
    [self.voicebt  setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
    self.voicebt.tag = 100;
    [self.voicebt  addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.voiceFileState = VoiceFileOld;
    if (self.WaitAnswer == 1) {
        self.voicebt.enabled = NO;
    }else{
        
        self.voicebt.enabled = YES;
    }
    [FootView  addSubview:self.voicebt];
    
    self.times = [UILabel  new];
    self.times.textColor = UIColorFromRGB(0x999999);
    self.times.font = [UIFont  systemFontOfSize:14];
    NSNumber *time = _MyAnswerEntity.VoiceTime;
    [self refreshLabelText:[time longValue]];
    [FootView  addSubview:self.times];
    // 重录
    self.rerecordbt = [UIButton  new];

    [self.rerecordbt  setTitleColor:UIColorFromRGB(0x52d8d2) forState:UIControlStateNormal];
    [self.rerecordbt  setTitle:@"重录" forState:UIControlStateNormal];
    self.rerecordbt.tag = 101;
    self.times.font = [UIFont  systemFontOfSize:18];
    [self.rerecordbt  addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    if (self.WaitAnswer == 1) {
        self.recordState = RecordStateNormal;
    }
    [FootView addSubview:self.rerecordbt];
    
    //文字补充标题
    _characterlb = [UILabel new];
    _characterlb.backgroundColor = [UIColor  clearColor];
    _characterlb.textColor = UIColorFromRGB(0x5bc4be);
    _characterlb.font = [UIFont  systemFontOfSize:midFont];
    _characterlb.textAlignment = NSTextAlignmentLeft;
    _characterlb.text = @"文字补充";
    [FootView  addSubview:_characterlb];
    
    
    //文字补充框
    _textView = [LCTextView new];
    _textView.placeholder = @"您可以在此做文字补充说明(非必填项)";
    _textView.text = _MyAnswerEntity.WordContent;
    _textView.backgroundColor = UIColorFromRGB(0xfbffff);
    _textView.placeholderColor = UIColorFromRGB(0x999999);
    _textView.font = [UIFont systemFontOfSize:midFont];
    _textView.placeholderFont = [UIFont systemFontOfSize:midFont];
    //        _textView.showTextLength = YES;
    _textView.XTLength = 1000000;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = UIColorFromRGB(0x5bc4be).CGColor;
    [FootView  addSubview:_textView];
    
    // 录音
    self.soundsbt = [UIButton new];
    
    self.soundsbt.tag = 102;
    [self.soundsbt  addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [FootView   addSubview:self.soundsbt];
    
    self.soundslb = [UILabel  new];
    self.soundslb.textColor = UIColorFromRGB(0x5D5D5D);
    self.soundslb.font = [UIFont  systemFontOfSize:16];
    self.soundslb.textAlignment = NSTextAlignmentCenter;
    self.soundslb.text = @"点击开始录音";
    [FootView  addSubview:self.soundslb];

    if (self.WaitAnswer == 1) {
        self.soundsbt.enabled = YES;
        self.recordState = RecordStateNormal;
        [self changeState];
    }else{
        self.soundsbt.enabled = NO;
        self.recordState = RecordStateComplete;
        [self changeState];
    }
    
    self.commit = [UIButton new];
    [self.commit  setBackgroundImage:[UIImage imageNamed:@"Comit"] forState:UIControlStateNormal];
    self.commit.tag = 103;
    [self.commit  addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.voiceFileState = VoiceFileOld;
    [FootView  addSubview:self.commit];
    

    _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_containerView,17.5+15).widthIs(kScreenWidth - 20).heightIs(kImageWidth+17.5);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,0).widthIs(kImageWidth).heightIs(kImageWidth);
    _midImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,kImageWidth+kImageXspace).widthIs(kImageWidth).heightIs(kImageWidth);
    _rightImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,kImageWidth*2+kImageXspace*2).widthIs(kImageWidth).heightIs(kImageWidth);
    _leftImageView1.sd_layout.leftEqualToView(_leftImageView).topSpaceToView(_haveImageBgView,kImageWidth+17.5+kImageTopspace).widthIs(kImageWidth).heightEqualToWidth();
    _midImageView1.sd_layout.leftEqualToView(_midImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
    _rightImageView1.sd_layout.leftEqualToView(_rightImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightIs(kImageWidth);
    
    if (_MyAnswerEntity.Image1!=nil&&_MyAnswerEntity.Image1.length>4&&(![_MyAnswerEntity.Image1 isEqualToString:@""])) {
        _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_containerView,17.5+15).widthIs(kScreenWidth - 20).heightIs(kImageWidth+17.5);
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
        if (_MyAnswerEntity.Image2!=nil&&_MyAnswerEntity.Image2.length>4&&(![_MyAnswerEntity.Image2 isEqualToString:@""])) {
            
            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"]];
            if (_MyAnswerEntity.Image3!=nil&&_MyAnswerEntity.Image3.length>4&&(![_MyAnswerEntity.Image3 isEqualToString:@""])) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                
                if (_MyAnswerEntity.Image4!=nil&&_MyAnswerEntity.Image4.length>4&&(![_MyAnswerEntity.Image4 isEqualToString:@""])) {
                    
                    _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_containerView,17.5+15).widthIs(kScreenWidth - 20).heightIs(kImageWidth+17.5+kImageWidth+kImageTopspace);
                    
                    [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    
                    if (_MyAnswerEntity.Image5!=nil&&_MyAnswerEntity.Image5.length>4&&(![_MyAnswerEntity.Image5 isEqualToString:@""])) {
                        
                        [_midImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if (_MyAnswerEntity.Image6!=nil&&_MyAnswerEntity.Image6.length>4&&(![_MyAnswerEntity.Image6 isEqualToString:@""])) {
                            
                            
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1,_rightImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image6]];
                            
                            
                            
                            [_rightImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                            
                        }else{
                            // 5
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5]];
                            _rightImageView1.hidden = YES;
                        }
                        
                    }else{
                        // 4
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4]];
                        _rightImageView1.hidden = YES;
                        _midImageView1.hidden = YES;
                    }
                    
                    
                }else{
                    // 3
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3]];
                    _midImageView1.hidden = YES;
                    _rightImageView1.hidden = YES;
                    _leftImageView1.hidden = YES;
                }
                
            }else {
                _photoBrowserArr =@[_leftImageView,_midImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2]];
                _rightImageView.hidden =YES;
                _midImageView1.hidden = YES;
                _rightImageView1.hidden = YES;
                _leftImageView1.hidden = YES;
            }
        }else{
            _photoBrowserArr =@[_leftImageView];
            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1]];
            _midImageView.hidden =YES;
            _rightImageView.hidden =YES;
            _midImageView1.hidden = YES;
            _rightImageView1.hidden = YES;
            _leftImageView1.hidden = YES;
        }
        
    }else{
        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        _haveImageBgView.hidden =YES;
    }
    
    _containerView.sd_layout.topSpaceToView(_scrollView,0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
//    self.usericon.sd_layout.topSpaceToView(_containerView,10).leftSpaceToView(_containerView,10).widthIs(30).heightEqualToWidth();
//    _myName.sd_layout.topSpaceToView(_containerView,33/2.0).leftSpaceToView(self.usericon,15).autoHeightRatio(0);

    _questionLabel.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,10).autoHeightRatio(0).rightSpaceToView(_containerView,0);
    
    if (_haveImageBgView.height == 0) {
        
        _timeLabel.sd_layout.topSpaceToView(_questionLabel,15).leftSpaceToView(_containerView,10).rightEqualToView(_questionLabel).autoHeightRatio(0);
        
    }else if (_haveImageBgView.height ==kImageWidth +17.5 ){
        
        _timeLabel.sd_layout.topSpaceToView(_questionLabel,15+kImageWidth+17.5).leftSpaceToView(_containerView,10).rightEqualToView(_questionLabel).autoHeightRatio(0);
    }else{
        _timeLabel.sd_layout.topSpaceToView(_questionLabel,15+17.5+kImageWidth*2+kImageTopspace).leftSpaceToView(_containerView,10).rightEqualToView(_questionLabel).autoHeightRatio(0);
    }
        
    
    _listenLable.sd_layout.topEqualToView(_timeLabel).rightSpaceToView(_containerView,10).autoHeightRatio(0);
    [_containerView setupAutoHeightWithBottomView:_listenLable bottomMargin:10];
 
    [_containerView updateLayout];
    [_containerView layoutSubviews];
 
 
    FootView.sd_layout.topSpaceToView(_containerView,0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    
    self.doctorIcon.sd_layout.topSpaceToView(FootView,20).leftSpaceToView(FootView,10).widthIs(40).heightEqualToWidth();
    
    self.voicebt.sd_layout.topSpaceToView(FootView,50/2.0).leftSpaceToView(self.doctorIcon,10).widthIs(262/2.0).heightIs(60/2.0);
    
    _characterlb.sd_layout.topSpaceToView(self.voicebt,15).leftEqualToView(self.voicebt).widthIs(75).heightIs(20);
    
    _textView.sd_layout.topSpaceToView(_characterlb,10).leftEqualToView(_characterlb).rightSpaceToView(FootView,15).heightIs(314/2);
//    self.times.sd_layout.centerYEqualToView(self.voicebt).leftSpaceToView(self.voicebt,10).widthIs(56).heightIs(36);
//    
//    self.rerecordbt.sd_layout.topEqualToView(self.times).leftSpaceToView(self.times,5).widthIs(36).heightEqualToWidth();
    
    self.rerecordbt.sd_layout.centerYEqualToView(self.voicebt).rightSpaceToView(FootView,20).widthIs(50).heightIs(25);
    
    self.times.sd_layout.centerYEqualToView(self.voicebt).leftSpaceToView(self.voicebt,10).rightSpaceToView(self.rerecordbt,5).heightIs(36);

    
//    self.soundsbt.sd_layout.centerXIs(self.view.size.width/2.0).topSpaceToView(self.voicebt,210/2.0).widthIs(80).heightEqualToWidth();
    
    self.soundsbt.sd_layout.centerXIs(self.view.size.width/2.0).topSpaceToView(_textView,68/2.0).widthIs(80).heightEqualToWidth();

    
    self.soundslb.sd_layout.topSpaceToView(self.soundsbt,15).centerXEqualToView(self.soundsbt).leftSpaceToView(FootView,0).rightSpaceToView(FootView,0).autoHeightRatio(0);


//    self.soundsbt.sd_layout.centerXIs(self.view.size.width/2.0).topSpaceToView(self.voicebt,100/2.0).widthIs(80).heightEqualToWidth();
    
 
    self.commit.sd_layout.topSpaceToView(self.soundslb,50).centerXEqualToView(self.soundslb).widthIs(180/2.0).heightIs(80/2.0);
    [FootView setupAutoHeightWithBottomView:self.commit bottomMargin:20];
    [_scrollView setupAutoContentSizeWithBottomView:FootView bottomMargin:0];
    
    [_scrollView updateLayout];
    [_scrollView layoutSubviews];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    //显示图片浏览器
    [SFPhotoBrowser showImageInView:[UIApplication sharedApplication].keyWindow selectImageIndex:(tap.view.tag-1001) delegate:self];
}

#pragma mark -WXPhotoBrowserDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser {
    if (self.photoBrowserArr.count>0) {
        return self.photoBrowserArr.count;
    }else {
        return 0;
    }
    
    
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    SFPhoto *photo = [[SFPhoto alloc] init];
    //原图
    photo.srcImageView = self.photoBrowserArr[index];
    
    
    
    //缩略图片的url
    NSString *imgUrl = self.photoBrowserUrlArr[index];
    
    photo.url = [NSURL URLWithString:imgUrl];
    
    return photo;
}

//点击事件
-(void)click:(UIButton*)btn{
    
    if (btn.tag == 100) {
        switch (_voiceFileState) {
            case VoiceFileOld:
            {
                if (_MyAnswerEntity.voiceUrl.length == 0 || [_MyAnswerEntity.voiceUrl isKindOfClass:[NSNull class]]) {
                    NSLog(@"无语音文件");
                    return;
                }
                if (_presenter.isPlaying == NO) {
                    [_presenter play:^(BOOL success) {
                        if (success == YES) {
                            //                    [_voiceButton setTitle:@"正在播放" forState:UIControlStateNormal];
                            _presenter.isPlaying = YES;
                        }else{
                            [_voicebt setTitle:@"播放失败" forState:UIControlStateNormal];
                            _presenter.isPlaying = NO;
                            [self refreshLabelText:[_MyAnswerEntity.VoiceTime longValue]];
                            [_presenter stop];
                        }
                    }];
                }else{
                    [_presenter stop];
                    //            [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
                    _presenter.isPlaying = NO;
                    //            _durationLabel.text = @"0''";
                }
                _playing = !_playing;
            }
                break;
            case VoiceFileNew:
            {
                //播放
                        if (_playing == NO) {
                            [_avRecorder playerStart];
                
                        }else{
                            [_avRecorder playerStop];
                        }
                        _playing = !_playing;
            }
                break;
            default:
                break;
        }
       
        
        
  
    }else if (btn.tag == 101){
        //重录
        [_avRecorder stop];
        [_avRecorder playerStop];
        _avRecorder.audioPath = @"";
        [_avRecorder.timer invalidate];
        _avRecorder.second = 0;
        [self refreshLabelText:0];
        self.voicebt.enabled = NO;
        self.soundsbt.enabled = YES;
        self.recordState = RecordStateNormal;
        self.voiceFileState = VoiceFileNew;
        [self changeState];
    
    }else if (btn.tag == 102){
        //话筒
        if (self.recordState == RecordStateNormal) {
            self.recordState = RecordStateRecording;
            [self changeState];
            //开始录音
            
            [_avRecorder startRecord];
        }else if (self.recordState == RecordStateRecording){
            //结束录音
            [_avRecorder stopRecord];
            NSLog(@"%@   1",self.times.text);
            
            //如果音频文件小于100字节需重新录制
            NSString *path = [NSString GetPathByFileName:_avRecorder.fileName ofType:@"wav"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data.length < 100) {
                [ProgressUtil showError:@"录音时间太短或异常，请重新录制"];
                _avRecorder.audioPath = @"";
                [_avRecorder.timer invalidate];
                _avRecorder.second = 0;
                [self refreshLabelText:0];
                self.voicebt.enabled = NO;
                self.soundsbt.enabled = YES;
                self.recordState = RecordStateNormal;
                [self changeState];
            }else{
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:_avRecorder.audioPath forKey:[NSString stringWithFormat:@"%@avRecorderPath",_MyAnswerEntity.uuid]];
                [defaults setObject:@(_myTime) forKey:[NSString stringWithFormat:@"%@avRecorderTime",_MyAnswerEntity.uuid]];
            }
        }
        
        self.voiceFileState = VoiceFileNew;
        
    }else if (btn.tag == 103){
        
        //发送
//        WS(ws);
//        [ws.presenter  commitAwaitAnswerVoiceWithPath:_avRecorder.audioPath ConsultationID:_MyAnswerEntity.uuid];
//        [self.navigationController  popViewControllerAnimated:YES];
        switch (_voiceFileState) {
            case VoiceFileOld:
            {
                
                [_presenter loadVoiceUrl:^(NSString *file, NSString *downPath) {
                   
                    NSString *fileName = file;
                    
                    NSString *downloadPath = downPath;
                    
                    _amrPath = [NSString GetPathByFileName:fileName ofType:@"amr"];
                    NSLog(@"old amrPath--is- %@",_amrPath);
                    
                    NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
                    
                    if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
                    
                    self.presenter.rect = [self.soundsbt.superview convertRect:self.soundsbt.frame toView:[UIApplication sharedApplication].keyWindow];
    
                    _presenter.TraceID = @(_MyAnswerEntity.TraceID);
                    _presenter.doctorID = @(_MyAnswerEntity.Expert_ID);
                    //提交内容
                    NSString  *CommitTextView =[_textView.text trimming];
                    NSLog(@"文字补充回答%@",CommitTextView);
                    WS(ws);
                    //            [ws.presenter commitAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime];
                    if ([[ConfiguresEntity findConfigureValueWithKey:@"UploadConfig"] isEqualToString:@"1"]) {
                        if (ws.presenter.uploadTag!=0) {
                            [ws.presenter uploadBlockInfos];
                        }else{
                            [ws.presenter  commitAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                        }
                    }else if ([[ConfiguresEntity findConfigureValueWithKey:@"UploadConfig"] isEqualToString:@"2"]){
                        [ws.presenter  commit44AwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                    }else{
                        [ws.presenter  commitOldAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                    }
                }else
                {
                    [ProgressUtil showInfo:@"语音文件有问题,请重新录制音频"];
                    
                }
                   
                }];
                
            }

                break;
            case VoiceFileNew:
            {
                if (_avRecorder.recording == YES) {
                    [ProgressUtil showInfo:@"请先结束录制"];
                    return;
                }
                if (!_avRecorder.audioPath || _avRecorder.audioPath.length == 0) {
                    [ProgressUtil showInfo:@"请先录制音频"];
                    return;
                }
                [_avRecorder stopRecord];
                [_avRecorder playerStop];
                NSLog(@"%@   2",self.times.text);
                
                //转码
                NSLog(@"转码前＝%@",_avRecorder.audioPath);
                
                _amrPath = [NSString GetPathByFileName:_avRecorder.fileName ofType:@"amr"];
                
                NSLog(@"new amrpath %@",_amrPath);
                if([VoiceConverter ConvertWavToAmr:_avRecorder.audioPath amrSavePath:_amrPath]){
                    
                    [self.soundsbt updateLayout];
                    [self.soundsbt.superview updateLayout];
                    NSLog(@"%@--%@",NSStringFromCGRect([self.soundsbt.superview convertRect:self.soundsbt.frame toView:[UIApplication sharedApplication].keyWindow]),NSStringFromCGRect(self.soundsbt.frame));
                    
                    self.presenter.rect = [self.soundsbt.superview convertRect:self.soundsbt.frame toView:[UIApplication sharedApplication].keyWindow];
                    
                    _presenter.TraceID = @(_MyAnswerEntity.TraceID);
                    _presenter.doctorID = @(_MyAnswerEntity.Expert_ID);
                    //提交内容
                    NSString  *CommitTextView =[_textView.text trimming];
                    NSLog(@"文字补充回答%@",CommitTextView);
                    WS(ws);
                    //            [ws.presenter commitAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime];
                    if ([[ConfiguresEntity findConfigureValueWithKey:@"UploadConfig"] isEqualToString:@"1"]) {
                        if (ws.presenter.uploadTag!=0) {
                            [ws.presenter uploadBlockInfos];
                        }else{
                            [ws.presenter  commitAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                            NSLog(@"uploadconfig--is-- %@",_amrPath);
                        }
                    }else if ([[ConfiguresEntity findConfigureValueWithKey:@"UploadConfig"] isEqualToString:@"2"]){
                        [ws.presenter  commit44AwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                    }else{
                        [ws.presenter  commitOldAwaitAnswerVoiceWithPath:_amrPath ConsultationID:_MyAnswerEntity.uuid Time:_myTime WordContent:CommitTextView];
                    }
                    
#pragma mark--  UMeng提交咨询事件统计
                    
                    [MobClick event:@"Record" ];
                    
                }else{
                    NSLog(@"转码失败");
                    [_avRecorder stop];
                    [_avRecorder playerStop];
                    _avRecorder.audioPath = @"";
                    [_avRecorder.timer invalidate];
                    _avRecorder.second = 0;
                    [self refreshLabelText:0];
                    self.voicebt.enabled = NO;
                    self.soundsbt.enabled = YES;
                    self.recordState = RecordStateNormal;
                    [self changeState];
                    
                    if (self.WaitAnswer == 1) {
                        
                        [ProgressUtil showInfo:@"请录制音频"];
                    }else{
                    
                    [ProgressUtil showInfo:@"转码失败,请重新录制音频"];
                    }
                }
            }
                break;
            default:
                break;
        }
        
    }
}
- (void)changeState{
    if (self.recordState == RecordStateNormal) {
        [self.soundsbt  setBackgroundImage:[UIImage imageNamed:@"microphone_noclick"] forState:UIControlStateNormal];
        self.soundslb.text = @"点击开始录音";
    }else if (self.recordState == RecordStateRecording){
        [self.soundsbt  setBackgroundImage:[UIImage imageNamed:@"microphone_click"] forState:UIControlStateNormal];
        self.soundslb.text = @"正在录音，点击结束录制";
    }else{
        [self.soundsbt  setBackgroundImage:[UIImage imageNamed:@"microphone_complete"] forState:UIControlStateNormal];
        self.soundslb.text = @"录音完成";
        self.soundsbt.enabled = NO;
    }
}



#pragma mark delegate

- (void)audioEndWith:(AudioType)audioType message:(NSString *)message{
    if (audioType == AudioTypeRecorderSuccess) {
        if (_avRecorder.audioPath.length > 0) {
            self.recordState = RecordStateComplete;
            [self changeState];
            self.voicebt.enabled = YES;
        }
    }else if (audioType == AudioTypeRecorderError){
        
    }else{
        _playing = NO;
    }
    NSLog(@"%@",message);
}

- (void)secondRefresh:(long)second{
    
    _myTime =second;
    [self refreshLabelText:second];
    
}

- (void)refreshLabelText:(long)second{
    NSString   *time = [NSString  new];
//    if(second  >=  3600){
//        
//          long   minutes = floor(second/60);
//          long  sec = floor(second - minutes * 60);
//          long  hours1 = floor(second / (60 * 60));
//         time = [NSString  stringWithFormat:@"%ld:%02ld:%02ld",hours1,minutes,sec];
//        self.times.text = time;
//        }else if (second >= 60){
//            long   minutes = floor(second/60);
//            long  sec = floor(second - minutes * 60);
//            time = [NSString  stringWithFormat:@"%02ld:%02ld",minutes,sec];
//            self.times.text = time;
//    }else{
        long  sec = second;
        time = [NSString  stringWithFormat:@"%ld''",sec];
        self.times.text = time;
//    }
    
}
-(void)commitAwaitAnswerOnComplete:(BOOL)success info:(NSString *)info{
    if (success) {
        
        
        if (self.WaitAnswer == 1) {
           
            [self.navigationController  popViewControllerAnimated:YES];
           
        }else
        {
            UIViewController* back = nil;
            for(UIViewController* vc in self.navigationController.childViewControllers){
                if([vc isKindOfClass:[MyReplyViewController class]]){
                    back = vc;
                    break;
                }
            }
            
            if(back){
                [self.navigationController popToViewController:back animated:YES];
            }
            
        }
        
       
    }else {
        [ProgressUtil showError:info];
    }
    



}
#pragma mark--分享事件
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL_SHARE_CONSULATION,self.MyAnswerEntity.uuid];
    


    NSLog(@"uuid:%@",self.MyAnswerEntity.uuid);
    if (imageArray) {
        NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        
        NSString  *title = [NSString  stringWithFormat:@"%@医师回答[%@]的问题",_MyAnswerEntity.doctorName,_MyAnswerEntity.consultationContent];
        if (title.length>=124) {
            title = [title  substringToIndex:124];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:text               images:_doctorIcon.image
                                            url:[NSURL URLWithString:urlStr]
                                          title:title                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    
    
}

//-(void)backItemAction:(id)sender{
//
////    NSLog(@"1111");
////    MyReplyViewController  *vc =[MyReplyViewController  new];
////    
////[self.navigationController   pushViewController:vc animated:YES];
//  
//    
//    UIViewController* back = nil;
//    for(UIViewController* vc in self.navigationController.childViewControllers){
//        if([vc isKindOfClass:[MyReplyViewController class]]){
//            back = vc;
//            break;
//        }
//    }
//    
//    if(back){
//        [self.navigationController popToViewController:back animated:YES];
//    }
//
//
//}

- (void)dealloc{
    [_avRecorder playerStop];
    [_avRecorder stopRecord];
    _avRecorder.audioPath = @"";
}
-(UIImageView *)newImageWithTag:(NSInteger)tag
{
    UIImageView *newImage =[[UIImageView alloc]init];
    newImage.tag =tag;
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    newImage.layer.cornerRadius= 8;
    [newImage.layer setBorderWidth:2];
    [newImage.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImage.clipsToBounds =YES;
    newImage.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [newImage addGestureRecognizer:Tap];
    
    return newImage;
}

@end
