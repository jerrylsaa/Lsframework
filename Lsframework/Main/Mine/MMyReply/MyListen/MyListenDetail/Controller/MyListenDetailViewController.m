//
//  MyListenDetailViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyListenDetailViewController.h"
#import "JMFoundation.h"
#import "MyListenDetailPresenter.h"
#import "SFPhotoBrowser.h"
#import "HeaderViewController.h"
#import "UIImage+Category.h"
#import "HelfPriceViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>



#define AC_FONT [UIFont systemFontOfSize:14]
#define AC_FONT_SMALL [UIFont systemFontOfSize:12]

@interface MyListenDetailViewController ()<MyListenDetailDelegate,PhotoBrowerDelegate>

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
@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@property (nonatomic, strong) MyListenDetailPresenter *presenter;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HeaderViewController *askView;
@property (nonatomic, strong) UIButton *askButton;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation MyListenDetailViewController

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
    self.title = @"我听详情";
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    [self  initRightBarWithTitle:@"分享"];
    _presenter = [MyListenDetailPresenter new];
    _presenter.delegate = self;
//    _presenter.url = _myListen.VoiceUrl;
    
//    [self setupUserHeadImageView];
//    [self setupUserNameLabel];
    [kdefaultCenter addObserver:self selector:@selector(listenHalf) name:@"half" object:nil];
    WS(ws);
    [_presenter GetExpertConsultationByUUID:self.uuid finish:^(BOOL success, NSString *message) {
        ws.myListen = ws.presenter.myListen;
        [ws wsChange];
    }];
//    [self setupBgView];
}

- (void)wsChange{
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
    _userNameLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _userNameLabel.font = AC_FONT;
    _userNameLabel.sd_layout.leftSpaceToView(_userHeadImageView,10).topSpaceToView(_scrollView,25).widthIs(100).heightIs(20);
}
- (void)setupInfoView{
    _infoLabel = [UILabel new];
    [_scrollView addSubview:_infoLabel];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    _infoLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _infoLabel.text = _myListen.ConsultationContent;
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
    
    _haveImageBgView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_infoLabel,0).widthIs(280).heightIs(97.5);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,0).widthIs(80).heightIs(80);
    _midImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,100).widthIs(80).heightIs(80);
    _rightImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,200).widthIs(80).heightIs(80);
    
    if (![_myListen.IsOpenImage boolValue]) {
        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        _haveImageBgView.hidden =YES;
    }else {
        if (_myListen.Image1!=nil&&_myListen.Image1.length>4&&(![_myListen.Image1 isEqualToString:@""])) {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (_myListen.Image2!=nil&&_myListen.Image2.length>4&&(![_myListen.Image2 isEqualToString:@""])) {
                
                [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (_myListen.Image3!=nil&&_myListen.Image3.length>4&&(![_myListen.Image3 isEqualToString:@""])) {
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image3]];
                    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                }else {
                    _photoBrowserArr =@[_leftImageView,_midImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image2]];
                    _rightImageView.hidden =YES;
                }
            }else{
                _photoBrowserArr =@[_leftImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_myListen.Image1]];
                _midImageView.hidden =YES;
                _rightImageView.hidden =YES;
            }
            
        }else{
            _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
            _haveImageBgView.hidden =YES;
        }

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
    [_doctorImageView  sd_setImageWithURL:[NSURL  URLWithString:_myListen.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
    
    _doctorImageView.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_haveImageBgView,20).widthIs(50).heightIs(50);
}
- (void)setupVoiceButton{
    _voiceButton = [UIButton new];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
    _voiceButton.titleLabel.font = AC_FONT;
    [_voiceButton addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_voiceButton];
    _voiceButton.sd_layout.leftSpaceToView(_doctorImageView,5).topSpaceToView(_haveImageBgView,25).heightIs(30).widthIs(120);
}
- (void)setupDurationLabel{
    _durationLabel = [UILabel new];
    [_scrollView addSubview:_durationLabel];
    _durationLabel.text = [NSString stringWithFormat:@"%ld''",_myListen.VoiceTime];
    _durationLabel.font = AC_FONT;
    _durationLabel.textColor = UIColorFromRGB(0x979797);
    _durationLabel.sd_layout.leftSpaceToView(_voiceButton,15).topSpaceToView(_haveImageBgView,35).rightSpaceToView(_scrollView,10).heightIs(20);
}
- (void)setupDoctorNameLabel{
    _doctorNameLabel = [UILabel new];
    [_scrollView addSubview:_doctorNameLabel];
    _doctorNameLabel.text = _myListen.DoctorName;
    _doctorNameLabel.font = AC_FONT;
    _doctorNameLabel.textColor = UIColorFromRGB(0x979797);
    _doctorNameLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).rightSpaceToView(_voiceButton,0).autoHeightRatio(0);
}
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    [_scrollView addSubview:_postLabel];
    _postLabel.text = _myListen.Introduce;
    _postLabel.font = AC_FONT_SMALL;
    _postLabel.textColor = UIColorFromRGB(0x979797);
    _postLabel.sd_layout.leftSpaceToView(_doctorNameLabel,10).topSpaceToView(_doctorImageView,17).rightSpaceToView(_scrollView,10).autoHeightRatio(0);
}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    [_scrollView addSubview:_timeLabel];
    _timeLabel.font = AC_FONT_SMALL;
  NSString* MyListenDetailTime = [NSDate getDateCompare:_myListen.CreateTime];
    _timeLabel.text = MyListenDetailTime;
    UIView *bottomView = _doctorNameLabel.height > (_postLabel.height + 5) ? _doctorNameLabel : _postLabel;
    _timeLabel.textColor = UIColorFromRGB(0x979797);
    _timeLabel.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(bottomView,20).widthIs(100).heightIs(15);
}

- (void)setupPriceLabel{
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromRGB(0xDA2011);
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_myListen.ExpertPrice];
    _priceLabel.font = AC_FONT;
    _priceLabel.sd_layout.rightSpaceToView(_scrollView,10).topEqualToView(_timeLabel).heightIs(15).widthIs(60);
}

- (void)setupListenLabel{
    _listenLabel = [UILabel new];
    [_scrollView addSubview:_listenLabel];
    _listenLabel.font = AC_FONT_SMALL;
    _listenLabel.textColor = UIColorFromRGB(0x979797);
    _listenLabel.text = [NSString stringWithFormat:@"听过  %@",_myListen.HearCount];
    _listenLabel.textAlignment = NSTextAlignmentRight;
    _listenLabel.sd_layout.rightSpaceToView(_priceLabel,10).topEqualToView(_timeLabel).heightIs(15).widthIs(100);
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
        if ([ws.myListen.User_ID integerValue] == kCurrentUser.userId) {
            ws.askButton.sd_layout.widthIs(231).heightIs(30).centerXEqualToView(ws.scrollView).topSpaceToView(ws.askView,25);
            ws.askButton.sd_cornerRadius = @15;
        }else{
            ws.askButton.sd_layout.widthIs(231).heightIs(0).centerXEqualToView(ws.scrollView).topSpaceToView(ws.askView,0);
            ws.askButton.hidden = YES;
        }
        
        ws.bgView = [UIView new];
        ws.bgView.backgroundColor = [UIColor whiteColor];
        [ws.scrollView insertSubview:ws.bgView atIndex:0];
        if (ws.askButton.hidden == YES) {
            ws.bgView.sd_layout.leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0).topSpaceToView(ws.scrollView,0).bottomSpaceToView(ws.askButton,-55);
            [ws.scrollView setupAutoContentSizeWithBottomView:ws.askButton bottomMargin:25];
        }else{
            ws.bgView.sd_layout.leftSpaceToView(ws.scrollView,0).rightSpaceToView(ws.scrollView,0).topSpaceToView(ws.scrollView,0).bottomSpaceToView(ws.askButton,-55);
            [ws.scrollView setupAutoContentSizeWithBottomView:ws.askButton bottomMargin:25];
        }
    }];
}

- (void)setupBgView{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView insertSubview:bgView atIndex:0];
    bgView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_timeLabel,-25);
    [_scrollView setupAutoContentSizeWithBottomView:bgView bottomMargin:0];
}

- (void)listenAction{
    if (_myListen.VoiceUrl.length == 0 || [_myListen.VoiceUrl isKindOfClass:[NSNull class]]) {
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
                _durationLabel.text = @"0'''";
            }
        }];
    }else{
        [_presenter stop];
        [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
        _presenter.isPlaying = NO;
        _durationLabel.text = @"0''";
    }
}
- (void)playFinished{
    _presenter.isPlaying = NO;
    [_voiceButton setTitle:@"播放" forState:UIControlStateNormal];
    
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
- (void)helfPriceAction{
    HelfPriceViewController *vc = [HelfPriceViewController new];
    vc.expert_ID = [self.myListen.Expert_ID integerValue];
    vc.consultationID = [self.myListen.ConsultationID integerValue];
    vc.uuid = [self.myListen.ConsultationID integerValue];
    vc.price = [self.myListen.ExpertPrice floatValue];;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)listenHalf{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setupView];
}

#pragma mark -- - 分享点击事件
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL_SHARE_CONSULATION,self.myListen.ConsultationID];

    if (imageArray) {
        NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        NSString  *title = [NSString  stringWithFormat:@"%@医师回答[%@]的问题",_myListen.DoctorName,_myListen.ConsultationContent];
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







