//
//  MyQuestionDetailViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyQuestionDetailViewController.h"
#import "JMFoundation.h"
#import "MyQuestionDetailPresenter.h"
#import "SFPhotoBrowser.h"
#import "HeaderViewController.h"
#import "UIImage+Category.h"
#import "HelfPriceViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "LCTextView.h"





#define AC_FONT [UIFont systemFontOfSize:14]
#define AC_FONT_SMALL [UIFont systemFontOfSize:12]

@interface MyQuestionDetailViewController ()<MyQuestionDetailDelegate,UIAlertViewDelegate,PhotoBrowerDelegate,UIGestureRecognizerDelegate>

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
@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;
//@property (nonatomic, strong) UIAlertView *payView;

@property (nonatomic ,strong) MyQuestionDetailPresenter *presenter;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HeaderViewController *askView;
@property (nonatomic, strong) UIButton *askButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *addCommentBtn;
@property (nonatomic, strong) UIImageView *expertComIV;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) LCTextView *dpTextView;
@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, strong) UIView *expertPJView;
@property (nonatomic, strong) UIView *expertMidView;
@property (nonatomic, strong) UIImageView *starIV;
@property (nonatomic, strong) UILabel *commentLabel;
//@property (nonatomic, assign) BOOL isPaid;

@end

@implementation MyQuestionDetailViewController

//- (UIAlertView *)payView{
//    if (!_payView) {
//        _payView = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"支付宝",@"微信",@"取消", nil];
//    }
//    return _payView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_askView) {
        [_askView removeFromSuperview];
        [_askButton removeFromSuperview];
        [_bgView removeFromSuperview];
        [self setupHeaderView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"我问详情";
    _presenter = [MyQuestionDetailPresenter new];
    _presenter.delegate = self;
//    _presenter.myReply = _myReply;
//    _presenter.url =_myReply.VoiceUrl;
    [self  initRightBarWithTitle:@"分享"];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [kdefaultCenter addObserver:self selector:@selector(questionHalf) name:@"half" object:nil];
    WS(ws);
    [_presenter GetExpertConsultationByUUID:self.uuid finish:^(BOOL success, NSString *message) {
        ws.myReply = ws.presenter.myReply;
        [ws wsChange];
    }];
    
//    [self setupBgView];
}
- (void)wsChange{
    WS(ws);
    [self setupScrollView];
    [self setupInfoView];
    [self setupDoctorImageView];
    [self setupVoiceButton];
    [self setupDurationLabel];
    [self setupDoctorNameLabel];
    [self setupPostLabel];
    [self setupTimeLabel];
    [self setupPriceLabel];
    [self setupListenLabel];
    [self setupHeaderView];
    [ProgressUtil show];
    [ws.presenter GetExpertCommentListByConsultationID:ws.myReply.uuid];
}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupInfoView{
    _infoLabel = [UILabel new];
    [_scrollView addSubview:_infoLabel];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    _infoLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _infoLabel.text = _myReply.ConsultationContent;
    
    _infoLabel.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,10).autoHeightRatio(0);
    
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
    
    _haveImageBgView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_infoLabel,0).widthIs(280).heightIs(97.5);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,0).widthIs(80).heightIs(80);
    _midImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,100).widthIs(80).heightIs(80);
     _rightImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,200).widthIs(80).heightIs(80);
    
        if (_myReply.Image1!=nil&&_myReply.Image1.length>4&&(![_myReply.Image1 isEqualToString:@""])) {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (_myReply.Image2!=nil&&_myReply.Image2.length>4&&(![_myReply.Image2 isEqualToString:@""])) {
                
                [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (_myReply.Image3!=nil&&_myReply.Image3.length>4&&(![_myReply.Image3 isEqualToString:@""])) {
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image3]];
                    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                }else {
                    _photoBrowserArr =@[_leftImageView,_midImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image2]];
                    _rightImageView.hidden =YES;
                }
            }else{
                _photoBrowserArr =@[_leftImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myReply.Image1]];
                _midImageView.hidden =YES;
                _rightImageView.hidden =YES;
            }
            
        }else{
            _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
            _haveImageBgView.hidden =YES;
        }
    
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
    _doctorImageView.layer.masksToBounds = YES;
    _doctorImageView.layer.cornerRadius = 25;
[_doctorImageView  sd_setImageWithURL:[NSURL  URLWithString:_myReply.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
    _doctorImageView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_haveImageBgView,20).widthIs(50).heightIs(50);
}
- (void)setupVoiceButton{
    _voiceButton = [UIButton new];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
    _voiceButton.titleLabel.font = AC_FONT;
    [_scrollView addSubview:_voiceButton];
    [_voiceButton addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
    _voiceButton.sd_layout.leftSpaceToView(_doctorImageView,5).topSpaceToView(_haveImageBgView,25).heightIs(30).widthIs(120);
    if ([_myReply.VoiceUrl isKindOfClass:[NSNull class]] || _myReply.VoiceUrl.length == 0) {
        [_voiceButton setTitle:@"未回答" forState:UIControlStateNormal];
    }
}
- (void)setupDurationLabel{
    _durationLabel = [UILabel new];
    [_scrollView addSubview:_durationLabel];
    _durationLabel.text = [NSString stringWithFormat:@"%ld''",_myReply.VoiceTime];
    _durationLabel.font = AC_FONT;
    _durationLabel.textColor = UIColorFromRGB(0x979797);
    _durationLabel.sd_layout.leftSpaceToView(_voiceButton,15).topSpaceToView(_haveImageBgView,35).rightSpaceToView(_scrollView,10).heightIs(20);
}
- (void)setupDoctorNameLabel{
    _doctorNameLabel = [UILabel new];
    [_scrollView addSubview:_doctorNameLabel];
    _doctorNameLabel.text = _myReply.DoctorName;
    _doctorNameLabel.font = AC_FONT;
    _doctorNameLabel.textColor = UIColorFromRGB(0x979797);
    _doctorNameLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).rightSpaceToView(_voiceButton,0).autoHeightRatio(0);
}
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    [_scrollView addSubview:_postLabel];
    _postLabel.text = _myReply.Introduce;
    _postLabel.font = AC_FONT_SMALL;
    _postLabel.textColor = UIColorFromRGB(0x979797);
    _postLabel.sd_layout.leftSpaceToView(_doctorNameLabel,10).topSpaceToView(_doctorImageView,17).rightSpaceToView(_scrollView,10).autoHeightRatio(0);
}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    [_scrollView addSubview:_timeLabel];
    _timeLabel.font = AC_FONT_SMALL;
    NSString* myQuestionDetailTime = [NSDate getDateCompare:_myReply.CreateTime];
    _timeLabel.text = myQuestionDetailTime;
    UIView *bottomView = _doctorNameLabel.height > (_postLabel.height + 5) ? _doctorNameLabel : _postLabel;
    _timeLabel.textColor = UIColorFromRGB(0x979797);
    _timeLabel.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(bottomView,20).widthIs(100).heightIs(15);
}
- (void)setupPriceLabel{
    _priceLabel = [UILabel new];
//    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromRGB(0xDA2011);
    _priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)[_myReply.ExpertPrice integerValue]];
    _priceLabel.font = AC_FONT_SMALL;
    CGFloat width = [JMFoundation calLabelWidth:AC_FONT_SMALL andStr:_priceLabel.text withHeight:15];
    if (width < 20) {
        width = 20;
    }
    _priceLabel.sd_layout.rightSpaceToView(_scrollView,10).topEqualToView(_timeLabel).heightIs(15).widthIs(width);
}
- (void)setupListenLabel{
    _listenLabel = [UILabel new];
    [_scrollView addSubview:_listenLabel];
    _listenLabel.font = AC_FONT_SMALL;
    _listenLabel.textColor = UIColorFromRGB(0x979797);
    _listenLabel.text = [NSString stringWithFormat:@"听过  %@",_myReply.HearCount];
    _listenLabel.textAlignment = NSTextAlignmentRight;
    _listenLabel.sd_layout.rightSpaceToView(_priceLabel,10).topEqualToView(_timeLabel).heightIs(15).widthIs(100);
    
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0xefefef);
    [_scrollView addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_listenLabel,4).heightIs(2);
}

- (void)setupHeaderView{
    WS(ws);
    [_presenter loadDataByConsultationID:self.uuid finish:^(BOOL success, NSString *message) {
        [ProgressUtil dismiss];
        ws.askView = [HeaderViewController new];
        ws.askView.dataSource = ws.presenter.dataSource;
        [ws.askView getHeightForAllCell];
        [ws.scrollView addSubview:ws.askView];
        ws.askView.sd_layout.leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0).topSpaceToView(ws.listenLabel,10).heightIs(ws.askView.totalHeight);
        [ws.askView setupView];
        
        //半价追问
        ws.askButton = [UIButton new];
        [ws.askButton setTitle:@"半价追问" forState:UIControlStateNormal];
        [ws.askButton setTitleColor:UIColorFromRGB(0x61d8d3) forState:UIControlStateNormal];
        [ws.askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [ws.askButton addTarget:self action:@selector(helfPriceAction) forControlEvents:UIControlEventTouchUpInside];
        ws.askButton.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
        ws.askButton.layer.borderWidth = 1.f;
        [ws.askButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [ws.askButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x61d8d3)] forState:UIControlStateHighlighted];
        [ws.scrollView addSubview:ws.askButton];
        
        //        AddExpertComment
        ws.addCommentBtn = [UIButton new];
        [ws.addCommentBtn setTitle:@"医生评价" forState:UIControlStateNormal];
        [ws.addCommentBtn setTitleColor:UIColorFromRGB(0xff8a80) forState:UIControlStateNormal];
        [ws.addCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [ws.addCommentBtn addTarget:self action:@selector(addExpertCommentAction) forControlEvents:UIControlEventTouchUpInside];
        ws.addCommentBtn.layer.borderColor = UIColorFromRGB(0xff8a80).CGColor;
        ws.addCommentBtn.layer.borderWidth = 1.f;
        [ws.addCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [ws.addCommentBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff8a80)] forState:UIControlStateHighlighted];
        [ws.scrollView addSubview:ws.addCommentBtn];
        
        if ([ws.myReply.User_ID integerValue] == kCurrentUser.userId) {
            ws.askButton.sd_layout.widthIs(kScreenWidth/2.0-20).heightIs(30).leftSpaceToView(ws.scrollView,10).topSpaceToView(ws.askView,25);
            ws.askButton.sd_cornerRadius = @15;
            
            ws.addCommentBtn.sd_layout.widthIs(kScreenWidth/2.0-20).heightIs(30).leftSpaceToView(ws.scrollView,kScreenWidth/2.0+10).topSpaceToView(ws.askView,25);
            ws.addCommentBtn.sd_cornerRadius = @15;
        }else{
            ws.askButton.sd_layout.widthIs(231).heightIs(0).centerXEqualToView(ws.scrollView).topSpaceToView(ws.askView,0);
            ws.askButton.hidden = YES;
            
            ws.addCommentBtn.sd_layout.widthIs(231).heightIs(30).centerXEqualToView(ws.scrollView).topSpaceToView(ws.askView,25);
            
        }

        
        
        ws.bgView = [UIView new];
        ws.bgView.backgroundColor = [UIColor whiteColor];
        [ws.scrollView insertSubview:ws.bgView atIndex:0];
        
        if (ws.askButton.hidden == YES) {
            ws.bgView.sd_layout.leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0).topSpaceToView(ws.scrollView,0).bottomSpaceToView(ws.askButton,-55);
//            [ws.scrollView setupAutoContentSizeWithBottomView:ws.addCommentBtn bottomMargin:25];
        }else{
            ws.bgView.sd_layout.leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0).topSpaceToView(ws.scrollView,0).bottomSpaceToView(ws.askButton,-55);
//            [ws.scrollView setupAutoContentSizeWithBottomView:ws.addCommentBtn bottomMargin:25];
        }
        
        ws.expertPJView =[UIView new];
        ws.expertPJView.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [ws.scrollView addSubview:ws.expertPJView];
        
        UIImageView *topIV =[UIImageView new];
        topIV.image =[UIImage imageNamed:@"topfakeIV"];
        [ws.expertPJView addSubview:topIV];
        
        ws.expertMidView =[UIView new];
        ws.expertMidView.backgroundColor =[UIColor whiteColor];
        [ws.expertPJView addSubview:ws.expertMidView];
        
        UIImageView *docIV =[UIImageView new];
        [docIV  sd_setImageWithURL:[NSURL  URLWithString:_myReply.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
        docIV.layer.masksToBounds = YES;
        docIV.layer.cornerRadius = 25;
        [ws.expertMidView addSubview:docIV];

        UILabel *docNameLabel =[UILabel new];
        docNameLabel.text =ws.myReply.DoctorName;
        docNameLabel.font =[UIFont boldSystemFontOfSize:15.0f];
        docNameLabel.textColor =UIColorFromRGB(0x333333);
        [ws.expertMidView addSubview:docNameLabel];
        
        UIImageView *docIntroBGIV =[UIImageView new];
        docIntroBGIV.image =[UIImage imageNamed:@"docIntroBGIV"];
        [ws.expertMidView addSubview:docIntroBGIV];
        
        UILabel *docIntroLabel =[UILabel new];
        docIntroLabel.text =ws.myReply.DoctorTitle;
        docIntroLabel.font =[UIFont systemFontOfSize:10.0f];
        docIntroLabel.textColor =UIColorFromRGB(0x999999);
        [ws.expertMidView addSubview:docIntroLabel];
        
        _starIV =[UIImageView new];
        
        [ws.expertMidView addSubview:_starIV];
        
        
        
        UILabel *hosLabel =[UILabel new];
        hosLabel.font =[UIFont systemFontOfSize:12.0f];
        hosLabel.textColor =UIColorFromRGB(0x999999);
        hosLabel.text =[NSString stringWithFormat:@"医院：%@",ws.myReply.HospitalName];
        
        [ws.expertMidView addSubview:hosLabel];
        
        UILabel *depaLabel =[UILabel new];
        depaLabel.font =[UIFont systemFontOfSize:12.0f];
        depaLabel.textColor =UIColorFromRGB(0x999999);
        depaLabel.text =[NSString stringWithFormat:@"科室：%@",ws.myReply.DepartName];;
        [ws.expertMidView addSubview:depaLabel];
        
        UILabel *domainLabel =[UILabel new];
        domainLabel.numberOfLines =0;
        NSString* field = ws.myReply.Domain.length != 0?ws.myReply.Domain: @"";
        NSMutableAttributedString* attrubutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"领域：%@",field]];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, attrubutStr.length)];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, 3)];
        
        [attrubutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, attrubutStr.length)];
        domainLabel.attributedText = attrubutStr;
        [ws.expertMidView addSubview:domainLabel];
        
        UIImageView *lineIV =[UIImageView new];
        lineIV.image =[UIImage imageNamed:@"line_mid"];
        [ws.expertMidView addSubview:lineIV];
        
        _commentLabel =[UILabel new];
        _commentLabel.numberOfLines =0;
        [ws.expertMidView addSubview:_commentLabel];
        
        UIImageView *bottomfakeIV =[UIImageView new];
        bottomfakeIV.image =[UIImage imageNamed:@"bottomfakeIV"];
        [ws.expertPJView addSubview:bottomfakeIV];
        
        docIV.sd_layout.leftSpaceToView(_expertMidView,10).topSpaceToView(_expertMidView,14.5).widthIs(50).heightIs(50);
        docNameLabel.sd_layout.leftSpaceToView(docIV,15).topSpaceToView(_expertMidView,22).heightIs(25).widthIs(60);
        docIntroBGIV.sd_layout.leftSpaceToView(docNameLabel,0).centerYEqualToView(docNameLabel).widthIs(47).heightIs(15);
        docIntroLabel.sd_layout.leftSpaceToView(docNameLabel,3.1f).centerYEqualToView(docIntroBGIV).heightIs(21).widthIs(47);
        if (kScreenWidth<325) {
            _starIV.sd_layout.rightSpaceToView(_expertMidView,0).centerYEqualToView(docNameLabel).widthIs(117).heightIs(17);
        }else {
            _starIV.sd_layout.rightSpaceToView(_expertMidView,14.5).centerYEqualToView(docNameLabel).widthIs(117).heightIs(17);
        }
        hosLabel.sd_layout.leftEqualToView(docNameLabel).topSpaceToView(docNameLabel,11).heightIs(20).widthIs(200);
        depaLabel.sd_layout.leftEqualToView(docNameLabel).topSpaceToView(hosLabel,10).heightIs(20).widthIs(200);
        domainLabel.sd_layout.leftEqualToView(docNameLabel).rightSpaceToView(_expertMidView,14.5).topSpaceToView(depaLabel,10).autoHeightRatio(0);
        lineIV.sd_layout.topSpaceToView(domainLabel,11).leftSpaceToView(_expertMidView,8).rightSpaceToView(_expertMidView,8).heightIs(1);
        _commentLabel.sd_layout.topSpaceToView(lineIV,10).leftSpaceToView(_expertMidView,10).rightSpaceToView(_expertMidView,10).autoHeightRatio(0);
        [_expertMidView setupAutoHeightWithBottomView:_commentLabel bottomMargin:15.0f];
        
        topIV.sd_layout.leftSpaceToView(_expertPJView,0).rightSpaceToView(_expertPJView,0).topSpaceToView(_expertPJView,0).heightIs(19);
        _expertMidView.sd_layout.topSpaceToView(topIV,0).leftSpaceToView(_expertPJView,6.52f).rightSpaceToView(_expertPJView,7.39f);
        bottomfakeIV.sd_layout.leftSpaceToView(_expertPJView,0).rightSpaceToView(_expertPJView,0).topSpaceToView(_expertMidView,0).heightIs(14);
        [_expertPJView setupAutoHeightWithBottomView:bottomfakeIV bottomMargin:0];

        _expertPJView.sd_layout.topSpaceToView(ws.bgView,0).leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0);
        [ws.scrollView setupAutoContentSizeWithBottomView:ws.expertPJView bottomMargin:0];
    }];
}
- (void)setupBgView{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView insertSubview:bgView atIndex:0];
    bgView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_timeLabel,-25);
    [_scrollView setupAutoContentSizeWithBottomView:bgView bottomMargin:0];
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

- (void)listenAction{
    [self play];
//    if (_isPaid == NO) {
//        [self.payView show];
//    }else{
//        [self play];
//    }
}
- (void)playFinished{
    _presenter.isPlaying = NO;
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
}
- (void)second:(NSString *)second{
    _durationLabel.text = second;
}
//- (void)payCallBack:(BOOL)success{
//    if (success == YES) {
//        [self play];
//        _isPaid = YES;
//    }
//}

- (void)play{
    if (_myReply.VoiceUrl.length == 0 || [_myReply.VoiceUrl isKindOfClass:[NSNull class]]) {
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
        _durationLabel.text = @"0''";
    }

}


- (void)helfPriceAction{
    HelfPriceViewController *vc = [HelfPriceViewController new];
    vc.expert_ID = [self.myReply.Expert_ID integerValue];
    vc.consultationID = [self.myReply.uuid integerValue];
    vc.uuid = [self.myReply.uuid integerValue];
    vc.price = [self.myReply.ExpertPrice floatValue];;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)questionHalf{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setupView];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        //支付宝
//        [_presenter payWithPayType:@"alipay"];
//    }else if (buttonIndex == 1){
//        //微信
//    }else{
//        //取消
//    }
//}

- (void)addExpertCommentAction{
    _alphaView = [UIView new];
    _alphaView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    _alphaView.frame = [UIApplication sharedApplication].keyWindow.frame;
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dimissAlphaView:)];
    tap1.delegate =self;
    [_alphaView addGestureRecognizer:tap1];
    
    _expertComIV =[UIImageView new];
    _expertComIV.userInteractionEnabled =YES;
    _expertComIV.frame =CGRectMake(kScreenWidth/2.0f-150, kScreenHeight/2.0f-161.25f, 310, 322.5f);
    _expertComIV.image =[UIImage imageNamed:@"expertComIV"];
    [_alphaView addSubview:_expertComIV];
    
    UILabel *pjLabel =[UILabel new];
    pjLabel.text =@"评价:";
    pjLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    pjLabel.textColor =[UIColor whiteColor];
    pjLabel.frame =CGRectMake(20, 50, 50, 20);
    [_expertComIV addSubview:pjLabel];
    
    _stars=0;
    for (int i=0; i<5; i++) {
        UIButton *starBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.tag =1000+i;
        [starBtn addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [starBtn setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateHighlighted];

        starBtn.frame =CGRectMake(70+i*40, 47.5, 25, 25);
        
        [_expertComIV addSubview:starBtn];

    }
    
    UILabel *dpLabel =[UILabel new];
    dpLabel.text =@"点评:";
    dpLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    dpLabel.textColor =[UIColor whiteColor];
    dpLabel.frame =CGRectMake(20, 90, 50, 20);
    [_expertComIV addSubview:dpLabel];
    
    UIImageView *dpTextfieldBG =[UIImageView new];
    dpTextfieldBG.image =[UIImage imageNamed:@"dpTextfieldBG"];
    dpTextfieldBG.frame =CGRectMake(60, 90, 232, 150);
    [_expertComIV addSubview:dpTextfieldBG];
    
    _dpTextView =[LCTextView new];
    _dpTextView.placeholder =@"您的评价对我们很有帮助";
    _dpTextView.placeholderColor =UIColorFromRGB(0xb3b6b6);
    _dpTextView.textLength =10000;
    _dpTextView.XTLength =10000;
    _dpTextView.font =[UIFont boldSystemFontOfSize:15.0f];
    _dpTextView.textColor =[UIColor colorWithRed:0.3258 green:0.3258 blue:0.3258 alpha:1.0];
    _dpTextView.frame =CGRectMake(70, 100, 212, 130);
    [_expertComIV addSubview:_dpTextView];
    
    UIButton *commitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setImage:[UIImage imageNamed:@"commitBtnBG"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.frame =CGRectMake(kScreenWidth/2.0f-167/2.0f, CGRectGetMaxY(dpTextfieldBG.frame)+20, 167, 40.5f);
    [_expertComIV addSubview:commitBtn];

    [[UIApplication sharedApplication].keyWindow addSubview:_alphaView];
}

- (void)starBtnAction:(UIButton *)btn{
    _stars =btn.tag-1000+1;
    for (NSInteger i=0;i<=btn.tag-1000 ; i++) {
        UIButton *starBtn =[_expertComIV viewWithTag:i+1000];
        
        [starBtn setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateHighlighted];
        
        
    }
    if (btn.tag!=1004) {
        for (NSInteger i=btn.tag-1000+1; i<=4; i++) {
            UIButton *starBtn =[_expertComIV viewWithTag:i+1000];
            
            [starBtn setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
            [starBtn setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateHighlighted];
            
        }
    }
}

- (void)commitAction{
    if (_stars ==0) {
        [ProgressUtil showInfo:@"请选择星级"];
        return;
    }
    if (_dpTextView.text==nil||_dpTextView.text.length==0||[_dpTextView.text isEqualToString:@""]) {
        [ProgressUtil showInfo:@"请填写点评内容"];
        return;
    }
    [ProgressUtil show];
    [_presenter addExpertComment:_dpTextView.text Stars:_stars ConsultationID:_myReply.uuid ExpertID:_myReply.Expert_ID];
}

- (void)dimissAlphaView:(UITapGestureRecognizer *)tap{
    [tap.view removeFromSuperview];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_expertComIV]) {
        return NO;
    }
    return YES;
    
}

- (void)addExpertCommentSuccess{
    [ProgressUtil showSuccess:@"评价成功"];
    
    [_alphaView removeFromSuperview];
    
    [ProgressUtil show];
    [_presenter GetExpertCommentListByConsultationID:_myReply.uuid];
}

- (void)getExpertCommentListSuccess{
    [ProgressUtil dismiss];
    
    _starIV.image =[UIImage imageNamed:[NSString stringWithFormat:@"starLevel%@",_presenter.myComment.StarLevel]];
    if (_presenter.myComment.CommentConetent.length!= 0){
        NSString* field = _presenter.myComment.CommentConetent;
        NSMutableAttributedString* attrubutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",_presenter.myComment.NickName,field]];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, attrubutStr.length)];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff8a80) range:NSMakeRange(0, _presenter.myComment.NickName.length+1)];
        
        [attrubutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:NSMakeRange(0, attrubutStr.length)];
        _commentLabel.attributedText = attrubutStr;
    }else{
        _commentLabel.text =@"暂无评价";
    }
    if ([_presenter.myComment.AddComment integerValue]==1) {
        [_addCommentBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _addCommentBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _addCommentBtn.userInteractionEnabled =NO;
    }
    
    [_scrollView updateLayout];
}

#pragma mark--分享事件
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL_SHARE_CONSULATION,self.myReply.uuid];
    
    if (imageArray) {
    NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        NSString  *title = [NSString  stringWithFormat:@"%@医师回答[%@]的问题",_myReply.DoctorName,_myReply.ConsultationContent];
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


-(void)dealloc{
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
    [kdefaultCenter removeObserver:self name:@"half" object:nil];
    [_player playerStop];
}

@end
