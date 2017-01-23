//
//  ReplyAnswerViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ReplyAnswerViewController.h"
#import "JMFoundation.h"
#import "ReplyAnswerPresenter.h"
#import "SFPhotoBrowser.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AwaitAnswerViewController.h"
#import "ZHAVRecorder.h"
#import "AVRecorderPlayerManager.h"

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-10*2-2*kImageXspace)/3
#define  topSpace 17.5

#define AC_FONT [UIFont systemFontOfSize:14]
#define AC_FONT_SMALL [UIFont systemFontOfSize:12]

@interface ReplyAnswerViewController ()<ReplyAnswerDelegate>{
    
    UIView *bgView;
}

@property (nonatomic, strong) UIImageView *userHeadImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *headBackView;
@property (nonatomic, strong) UIImageView *doctorImageView;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *doctorNameLabel;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *listenLabel;
@property (nonatomic ,strong) UIImageView *praiseImageView;
@property (nonatomic ,strong) UILabel *praiseLabel;
@property (nonatomic ,strong) ReplyAnswerPresenter *presenter;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImageView *leftImageView1;
@property (nonatomic, strong) UIImageView *midImageView2;
@property (nonatomic, strong) UIImageView *rightImageView3;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;
//文字补充
@property (nonatomic, strong) UIView *wordBackView;
@property (nonatomic, strong) UILabel *wordTitlelb;
@property (nonatomic, strong) UIView *wordContentView;
@property (nonatomic, strong) UILabel *wordContentlb;

@end

@implementation ReplyAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"我答详情";
    [self initRightBarWithTitle:@"分享"];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _presenter = [ReplyAnswerPresenter new];
    _presenter.delegate = self;
    _presenter.url = _MyAnswerEntity.voiceUrl;
    //    [self setupUserHeadImageView];
    //    [self setupUserNameLabel];
    //    [self setupPriceLabel];
    [self setupScrollView];
    [self setupInfoView];
    [self setupDoctorImageView];
    [self setupVoiceButton];
    [self setupDurationLabel];
//    [self setupDoctorNameLabel];
//    [self setupPostLabel];
    [self  setupWordContentView];
    [self setupTimeLabel];
    [self setupPraiseLabel];
    //    [self setupPraiseImageView];
    [self setupListenLabel];
    [self setupBgView];
    [self  setupRecordBtn];
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupUserHeadImageView{
    _userHeadImageView = [UIImageView new];
    [_scrollView addSubview:_userHeadImageView];
    _userHeadImageView.image = [UIImage imageNamed:@"my_answer"];
    _userHeadImageView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_scrollView,15).widthIs(40).heightIs(40);
}
- (void)setupUserNameLabel{
    _userNameLabel = [UILabel new];
    [_scrollView addSubview:_userNameLabel];
    _userNameLabel.text = @"默默";
    //    _userNameLabel.text = _MyAnswerEntity.userName;
    _userNameLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _userNameLabel.font = AC_FONT;
    _userNameLabel.sd_layout.leftSpaceToView(_userHeadImageView,10).topSpaceToView(_scrollView,25).widthIs(100).heightIs(20);
}
- (void)setupPriceLabel{
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromRGB(0xDA2011);
    _priceLabel.text = [NSString stringWithFormat:@"¥%g",_MyAnswerEntity.expertPrice];
    _priceLabel.font = AC_FONT;
    _priceLabel.sd_layout.rightSpaceToView(_scrollView,10).topSpaceToView(_scrollView,25).heightIs(20).widthIs(100);
}
- (void)setupInfoView{
    _infoLabel = [UILabel new];
    [_scrollView addSubview:_infoLabel];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    _infoLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _infoLabel.text = _MyAnswerEntity.consultationContent;
    _infoLabel.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_userHeadImageView,15).rightSpaceToView(_scrollView,10).autoHeightRatio(0);
    
    _haveImageBgView =[[UIView alloc]init];
    
    [_scrollView addSubview:_haveImageBgView];
    
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
    
    _midImageView2 = [self newImageWithTag:1005];
    [_haveImageBgView addSubview:_midImageView2];
    
    _rightImageView3 = [self newImageWithTag:1006];
    [_haveImageBgView addSubview:_rightImageView3];
    
    
    _haveImageBgView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_infoLabel,0).widthIs(kScreenWidth-20).heightIs(kImageWidth+topSpace);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,topSpace).leftSpaceToView(_haveImageBgView,0).widthIs(kImageWidth).heightIs(kImageWidth);
    _midImageView.sd_layout.topSpaceToView(_haveImageBgView,topSpace).leftSpaceToView(_haveImageBgView,kImageWidth+kImageXspace).widthIs(80).heightIs(80);
    _rightImageView.sd_layout.topSpaceToView(_haveImageBgView,topSpace).leftSpaceToView(_haveImageBgView,kImageWidth*2+kImageXspace*2).widthIs(kImageWidth).heightIs(kImageWidth);
    _leftImageView1.sd_layout.leftEqualToView(_leftImageView).topSpaceToView(_haveImageBgView,topSpace+kImageXspace+kImageWidth).widthIs(kImageWidth).heightEqualToWidth();
    _midImageView2.sd_layout.leftEqualToView(_midImageView).topEqualToView(_leftImageView1).heightIs(kImageWidth).widthEqualToHeight();
    _rightImageView3.sd_layout.leftEqualToView(_rightImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightIs(kImageWidth);
    
    if (_MyAnswerEntity.Image1!=nil&&_MyAnswerEntity.Image1.length>4&&(![_MyAnswerEntity.Image1 isEqualToString:@""])) {
        _haveImageBgView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_infoLabel,0).widthIs(kScreenWidth-20).heightIs(kImageWidth+topSpace);
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
        if (_MyAnswerEntity.Image2!=nil&&_MyAnswerEntity.Image2.length>4&&(![_MyAnswerEntity.Image2 isEqualToString:@""])) {
            
            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (_MyAnswerEntity.Image3!=nil&&_MyAnswerEntity.Image3.length>4&&(![_MyAnswerEntity.Image3 isEqualToString:@""])) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                
                if (_MyAnswerEntity.Image4!=nil&&_MyAnswerEntity.Image4.length>4&&(![_MyAnswerEntity.Image4 isEqualToString:@""])) {
                    
                    _haveImageBgView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_infoLabel,0).widthIs(kScreenWidth-20).heightIs(kImageWidth+topSpace+kImageXspace+kImageWidth);
                    
                    [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    
                    if ((_MyAnswerEntity.Image5!=nil&&_MyAnswerEntity.Image5.length>4&&(![_MyAnswerEntity.Image5 isEqualToString:@""]))) {
                        
                        [_midImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if ((_MyAnswerEntity.Image6!=nil&&_MyAnswerEntity.Image6.length>4&&(![_MyAnswerEntity.Image6 isEqualToString:@""]))) {
                            
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView2,_rightImageView3];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image6]];
                            
                            [_rightImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                        }else{
                            // 5
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView2];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image5]];
                            
                            _rightImageView3.hidden = YES;
                        }
                        
                    }else{
                        // 4
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image4]];
                        _rightImageView3.hidden = YES;
                        _midImageView2.hidden = YES;
                        
                    }
                }else{
                    // 3
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image3]];
                    _rightImageView3.hidden = YES;
                    _midImageView2.hidden = YES;
                    _leftImageView1.hidden = YES;
                }
                
            }else {
                _photoBrowserArr =@[_leftImageView,_midImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image2]];
                _rightImageView.hidden =YES;
                _rightImageView3.hidden = YES;
                _midImageView2.hidden = YES;
                _leftImageView1.hidden = YES;
            }
        }else{
            _photoBrowserArr =@[_leftImageView];
            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_MyAnswerEntity.Image1]];
            _midImageView.hidden =YES;
            _rightImageView.hidden =YES;
            _rightImageView3.hidden = YES;
            _midImageView2.hidden = YES;
            _leftImageView1.hidden = YES;
        }
        
    }else{
        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        _haveImageBgView.hidden =YES;
    }
    
    //    }
    
}
- (void)setupDoctorImageView{
    
    _headBackView = [UIImageView new];
    _headBackView.image = [UIImage imageNamed:@"HEADoctorIcon"];
    _headBackView.layer.masksToBounds = YES;
    _headBackView.layer.cornerRadius = 27.5f;
    [_scrollView addSubview:_headBackView];
    _headBackView.sd_layout.leftSpaceToView(_scrollView,7.5).topSpaceToView(_haveImageBgView,17.5).widthIs(55).heightIs(55);
    
    _doctorImageView = [UIImageView new];
    [_scrollView addSubview:_doctorImageView];
    [ _doctorImageView sd_setImageWithURL:[NSURL  URLWithString:_MyAnswerEntity.imageUrl] placeholderImage:[UIImage  imageNamed:@"doctor_defaul"]];
    _doctorImageView.layer.masksToBounds = YES; //没这句话它圆不起来
    _doctorImageView.layer.cornerRadius = 25;
    _doctorImageView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_haveImageBgView,20).widthIs(50).heightIs(50);
}
- (void)setupVoiceButton{
    _voiceButton = [UIButton new];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
    _voiceButton.titleLabel.font = AC_FONT;
    [_scrollView addSubview:_voiceButton];
    [_voiceButton addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    _voiceButton.sd_layout.leftSpaceToView(_doctorImageView,5).topSpaceToView(_haveImageBgView,25).heightIs(30).widthIs(120);
}
- (void)setupDurationLabel{
    _durationLabel = [UILabel new];
    [_scrollView addSubview:_durationLabel];
//    _durationLabel.text = @"0''";
    _durationLabel.text = [NSString stringWithFormat:@"%@",_MyAnswerEntity.VoiceTime];
    _durationLabel.font = AC_FONT;
    _durationLabel.textColor = UIColorFromRGB(0x979797);
    _durationLabel.sd_layout.leftSpaceToView(_voiceButton,15).topSpaceToView(_haveImageBgView,35).rightSpaceToView(_scrollView,10).heightIs(20);
}
//- (void)setupDoctorNameLabel{
//    _doctorNameLabel = [UILabel new];
//    [_scrollView addSubview:_doctorNameLabel];
//    _doctorNameLabel.text = _MyAnswerEntity.doctorName;
//    _doctorNameLabel.font = AC_FONT;
//    _doctorNameLabel.textColor = UIColorFromRGB(0x979797);
//    _doctorNameLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).rightSpaceToView(_voiceButton,0).autoHeightRatio(0);
//}
//- (void)setupPostLabel{
//    _postLabel = [UILabel new];
//    [_scrollView addSubview:_postLabel];
//    _postLabel.text = _MyAnswerEntity.introduce;
//    _postLabel.font = AC_FONT_SMALL;
//    _postLabel.textColor = UIColorFromRGB(0x979797);
//    _postLabel.sd_layout.leftSpaceToView(_doctorNameLabel,10).topSpaceToView(_doctorImageView,17).rightSpaceToView(_scrollView,10).autoHeightRatio(0);
//}

-(void)setupWordContentView{
//背景框
    _wordBackView = [UIView  new];
    _wordBackView.backgroundColor = [UIColor clearColor];
    [_scrollView  addSubview:_wordBackView];
    
    
    //文字补充标题
    _wordTitlelb = [UILabel new];
    _wordTitlelb.backgroundColor = [UIColor  clearColor];
    _wordTitlelb.textColor = UIColorFromRGB(0x5bc4be);
    _wordTitlelb.font = [UIFont  systemFontOfSize:midFont];
    _wordTitlelb.textAlignment = NSTextAlignmentLeft;
    _wordTitlelb.text = @"文字补充";
    [_wordBackView  addSubview:_wordTitlelb];
    
    
    //文字补充框
    _wordContentView = [UIView new];
    _wordContentView.backgroundColor = UIColorFromRGB(0xfbffff);
    _wordContentView.layer.masksToBounds = YES;
    _wordContentView.layer.cornerRadius = 5;
    _wordContentView.layer.borderWidth = 1;
_wordContentView.layer.borderColor = UIColorFromRGB(0x5bc4be).CGColor;
    [_wordBackView  addSubview:_wordContentView];
    
    _wordContentlb = [UILabel new];
    _wordContentlb.backgroundColor = [UIColor  clearColor];
    _wordContentlb.textColor = UIColorFromRGB(0x5D5D5D);
    _wordContentlb.font = [UIFont  systemFontOfSize:midFont];
    _wordContentlb.textAlignment = NSTextAlignmentLeft;
    _wordContentlb.text = _MyAnswerEntity.WordContent;
    _wordContentlb.numberOfLines = 0;
    [_wordContentView  addSubview:_wordContentlb];

    
//    CGFloat  wordContentHeight = [JMFoundation  calLabelHeght:_wordContentlb];
    
 CGFloat  wordContentHeight  = [JMFoundation  calLabelHeight:_wordContentlb.font andStr:_wordContentlb.text withWidth:kScreenWidth-20];
    _wordBackView.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).rightSpaceToView(_scrollView,10);
    
    _wordTitlelb.sd_layout.topEqualToView(_wordBackView).leftEqualToView(_wordBackView).heightIs(15).widthIs([JMFoundation  calLabelWidth:_wordTitlelb]);
    _wordContentView.sd_layout.topSpaceToView(_wordTitlelb,10).leftEqualToView(_wordTitlelb).rightEqualToView(_wordBackView).heightIs(wordContentHeight+20);
    _wordContentlb.sd_layout.topSpaceToView(_wordContentView,10).leftSpaceToView(_wordContentView,10).rightSpaceToView(_wordContentView,10).heightIs(wordContentHeight);
    
    
    [_wordBackView   setupAutoHeightWithBottomView:_wordContentView bottomMargin:0];



}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    [_scrollView addSubview:_timeLabel];
    _timeLabel.font = AC_FONT_SMALL;
//    NSString* myAnswerTime = [NSDate getDateCompare:_MyAnswerEntity.createTime];
//    _timeLabel.text = myAnswerTime;
    _timeLabel.text = _MyAnswerEntity.createTime;
//    UIView *bottomView = _doctorNameLabel.height > (_postLabel.height + 5) ? _doctorNameLabel : _postLabel;
    _timeLabel.textColor = UIColorFromRGB(0x979797);
    if (_MyAnswerEntity.WordContent.length == 0) {
        _wordBackView.hidden = YES;
  _timeLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).widthIs(kJMWidth(_timeLabel)).heightIs(15);
    }else{
        _wordBackView.hidden = NO;
    _timeLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_wordBackView,15).widthIs(kJMWidth(_timeLabel)).heightIs(15);
    }
}
- (void)setupPraiseLabel{

    
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromRGB(0xDA2011);
    _priceLabel.text = [NSString stringWithFormat:@"¥%g",_MyAnswerEntity.expertPrice];
    _priceLabel.font = AC_FONT;
    _priceLabel.sd_layout.rightSpaceToView(_scrollView,10).topEqualToView(_timeLabel).heightIs(15);
    [_priceLabel  setSingleLineAutoResizeWithMaxWidth:60];
}
- (void)setupPraiseImageView{
    _praiseImageView = [UIImageView new];
    [_scrollView addSubview:_praiseImageView];
    _praiseImageView.image = [UIImage imageNamed:@"icon_praise"];
    UIView *bottomView = _doctorNameLabel.height > (_postLabel.height + 5) ? _doctorNameLabel : _postLabel;
    _praiseImageView.sd_layout.rightSpaceToView(_praiseLabel,5).topSpaceToView(bottomView,15).heightIs(20).widthIs(20);
}
- (void)setupListenLabel{
    _listenLabel = [UILabel new];
    [_scrollView addSubview:_listenLabel];
    _listenLabel.font = AC_FONT_SMALL;
    _listenLabel.textColor = UIColorFromRGB(0x979797);
    _listenLabel.text = [NSString stringWithFormat:@"听过  %d",_MyAnswerEntity.hearCount];
    _listenLabel.textAlignment = NSTextAlignmentRight;
    _listenLabel.sd_layout.rightSpaceToView(self.priceLabel,5).topEqualToView(_timeLabel).heightIs(15);
    [_priceLabel  setSingleLineAutoResizeWithMaxWidth:100];
}
- (void)setupBgView{
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView insertSubview:bgView atIndex:0];
    bgView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_timeLabel,-25);
    
}
-(void)setupRecordBtn{
    UIView  *RecordView = [UIView  new];
    RecordView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scrollView insertSubview:RecordView atIndex:0];
    
    
    
    UIButton  *RecordBtn = [UIButton new];
    RecordBtn.backgroundColor = UIColorFromRGB(0x52d8d2);
    [RecordBtn setTitle:@"重新回答" forState:UIControlStateNormal];
    RecordBtn.titleLabel.font = AC_FONT;
    [RecordBtn addTarget:self action:@selector(RecordAction) forControlEvents:UIControlEventTouchUpInside];
    [RecordView addSubview:RecordBtn];
    
    RecordView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(bgView,0).heightIs(80);
    RecordBtn.sd_layout.centerXEqualToView(RecordView).centerYEqualToView(RecordView).widthIs(76).heightIs(34);
    
    [_scrollView setupAutoContentSizeWithBottomView:RecordView bottomMargin:0];
    
}

-(void)RecordAction{
    
    
    AwaitAnswerViewController *vc = [AwaitAnswerViewController  new];
    vc.MyAnswerEntity = _MyAnswerEntity;
    
    [[ZHAVRecorder sharedRecorder] playerStop];//所有语音播放停止
    [[ZHAVRecorder sharedRecorder] stop];
    [[AVRecorderPlayerManager sharedManager] stop];
    
    
    
    
    [self.navigationController  pushViewController:vc animated:YES];
    
    
    
    
}

- (void)voiceAction{
    if (_MyAnswerEntity.voiceUrl.length == 0 || [_MyAnswerEntity.voiceUrl isKindOfClass:[NSNull class]]) {
        NSLog(@"无语音文件");
        return;
    }
    if (_presenter.isPlaying == NO) {
        [_presenter play:^(BOOL success) {
            if (success == YES) {
                [_voiceButton setTitle:@"正在播放" forState:UIControlStateNormal];
                _presenter.isPlaying = YES;
            }else{
                [_voiceButton setTitle:@"播放失败" forState:UIControlStateNormal];
                _presenter.isPlaying = NO;
                _durationLabel.text = @"0''";
            }
        }];
    }else{
        [_presenter stop];
        [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
        _presenter.isPlaying = NO;
//        _durationLabel.text = @"0''";
        _durationLabel.text = [NSString stringWithFormat:@"%@",_MyAnswerEntity.VoiceTime];
    }
}
- (void)playFinished{
    _presenter.isPlaying = NO;
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
//    _durationLabel.text = @"0''";
    _durationLabel.text = [NSString stringWithFormat:@"%@",_MyAnswerEntity.VoiceTime];
}
- (void)second:(NSString *)second{
    _durationLabel.text = second;
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

-(void)dealloc{
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
    [_player playerStop];
}

#pragma mark--分享事件
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL_SHARE_CONSULATION,self.MyAnswerEntity.uuid];
    if (imageArray) {
        NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        
        NSString  *title = [NSString  stringWithFormat:@"%@医师回答[%@]的问题",_MyAnswerEntity.doctorName,_MyAnswerEntity.consultationContent];
        if (title.length>=124) {
            title = [title  substringToIndex:124];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:text               images:_doctorImageView.image
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
