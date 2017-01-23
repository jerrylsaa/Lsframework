//
//  SecondHEAInfoViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SecondHEAInfoViewController.h"
#import "HEAParentQuestionEntity.h"
#import "HEAParentQuestionTableViewCell.h"
#import "LCTextView.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "JMFoundation.h"
#import "AliPayUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "VoiceConverter.h"
#import "AVRecorderPlayerManager.h"
#import "VoiceConvertUtile.h"
#import "CorePhotoPickerVCManager.h"
#import "ECouponViewController.h"
#import "WXApi.h"
#import "HotDetailPresenter.h"
#import "SFPhotoBrowser.h"
#import "HotDetailConsulationViewController.h"
#import "HotQuestionViewController.h"
#import "HotQuestionView.h"
#import "ExpertDPViewController.h"

static NSString* const paySuccessKeyPath = @"orderPaySuccess";//付款成功
static NSString* const addConsultationPath = @"addConsultation";//添加咨询
static NSString* const laodConsultationPath = @"laodConsultation";//获取咨询
static NSString* const addListenPath = @"addListen";//添加偷听


@interface SecondHEAInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HEAInfoPresenterDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ECouponViewControllerDelegate,UITextViewDelegate,PhotoBrowerDelegate,UIAlertViewDelegate,PraiseDelegate>{
    CGPoint pointAdd;
    CGPoint pointReduce;
    UIView* headerView;
    CGFloat  downlbFont;
    BOOL   isCoupon;
    NSNumber* _couponid;
    BOOL  firstCommit;
    BOOL  IsClinic;  //是否义诊
}

@property(nonatomic,retain) UITableView* table;
@property(nonatomic,retain) UIImageView* iconbgImageView;
@property(nonatomic,retain) UIImageView* doctorIcon;
@property(nonatomic,retain) UILabel* doctorName;
@property(nonatomic,retain) UIView* lineView;
@property(nonatomic,retain) UILabel* doctorTitle;
@property(nonatomic,retain) UILabel* doctorIntroduce;
@property(nonatomic,retain) UILabel* doctorField;
@property(nonatomic,retain) UILabel* CoupondField;
@property(nonatomic,retain) UILabel* questionTimes;
@property(nonatomic,retain) LCTextView* textView;
@property(nonatomic,retain) UILabel* moneyTips;
@property(nonatomic,retain) UILabel* pricenLabel;
@property(nonatomic,retain) UIButton* commitbt;
@property(nonatomic,retain) UIView* headerTitlebgView;
@property(nonatomic,retain) UILabel* titleTips;


@property(nonatomic,retain) NSMutableDictionary* stateDic;//语音按钮状态字典

@property(nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nonatomic,retain) UIButton* currentSelectButton;
@property(nonatomic) CGFloat listenPrice;//偷听价格
@property(nonatomic,retain) HEAParentQuestionEntity* currentQuestion;

@property(nonatomic,retain) UIActivityIndicatorView* indicator;
@property(nonatomic) BOOL isListenType;//偷听
@property(nonatomic) BOOL isReloadAllData;//刷新全部数据
@property(nonatomic,retain) NSIndexPath* saveIndexPath;
@property(nonatomic,retain) UIButton* saveSelectButton;
@property(nonatomic, strong)UIImageView *downImageView;
@property(nonatomic, strong)UIButton *BulletinBtn;
@property(nonatomic, strong)UILabel *downLb;
@property(nonatomic, assign)BOOL   *down;

@property(nonatomic,retain) UIView *uploadImageView;
@property(nonatomic,retain) UIView *HaveImageView;

@property(nonatomic,retain) NSMutableArray *uploadImageArr;
@property(nonatomic,retain) UIButton *privateImageBtn;
@property(nonatomic,retain) UIButton *addImageBtn;
@property(nonatomic,retain) NSMutableArray *upImageViewArr;
@property(nonatomic,assign) BOOL isDoctor;
@property (nonatomic, assign) NSInteger payIndex;//
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic,retain) NSString *uncompletedConStr;

@property (nonatomic,strong) NSString *wxPayType;
@property (nonatomic,strong) NSString *wxCouponPay;

@property (nonatomic,strong) UIView *headerMidView;
@property (nonatomic,strong) UILabel *totalCommentLabel;
@property (nonatomic,strong) UILabel *firstCommentLabel;
@end

@implementation SecondHEAInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarWithTitle:@"分享"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [kdefaultCenter addObserver:self selector:@selector(refreshtableList) name:Notification_HEAInfoViewController object:nil];
    
    
    [self loadData];
    NSLog(@"coupid:%@",self.coupon);
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.presenter = [HEAInfoPresenter new];
    self.presenter.delegate = self;
    [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
    [self.presenter GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
    [self.presenter  getCouPonList];
    
#pragma mark-----判断当前用户是否是医生
    [_presenter getExperIDByUserID:^(BOOL isDoctor, NSString *message) {
        
        if (isDoctor == YES) {
            NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
            [user setObject:message forKey:@"HEAninfoDoctorId"];
        }else{
            NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
            
            [user removeObjectForKey:@"HEAninfoDoctorId"];
        }
        
    }];
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    NSNumber *localDoctorId =[user objectForKey:@"HEAninfoDoctorId"];
    NSLog(@"判断当前医生id:%@",localDoctorId);
#pragma mark----判断当前医生是否是点击进入的医生
    if ([localDoctorId integerValue]==[[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID integerValue]) {
        _isDoctor =YES;
    }
    NSLog(@"判断当前医生是否是点击进入的医生%hhd",_isDoctor);
    
    
    
    
    //医生头像
    [self.doctorIcon sd_setImageWithURL:[NSURL URLWithString:self.expertEntity.imageUrl] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    //医生名字
    self.doctorName.text = self.expertEntity.doctorName;
    //医生职称
    self.doctorTitle.text = self.expertEntity.doctorTitle;
    //医生简介
    self.doctorIntroduce.text = self.expertEntity.introduce;
    //医生领域
    NSString* field = self.expertEntity.domain.length != 0? self.expertEntity.domain: @"";
    NSMutableAttributedString* attrubutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"领域：%@",field]];
    [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, attrubutStr.length)];
    [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, 3)];
    self.doctorField.attributedText = attrubutStr;
    
    //提问次数
    NSString* times = (self.expertEntity.hearCount != 0?[NSString stringWithFormat:@"已有%ld次提问",self.expertEntity.hearCount]: @"");
    self.questionTimes.text = times;
    //textView
    
    //    self.textView.placeholder = [NSString stringWithFormat:@"向%@医生提问，等Ta语音回答；超过48小时未回答，将按支付路径全额退款",self.expertEntity.doctorName];
    
    
    
    //提问价格
    
    self.pricenLabel.text = [NSString stringWithFormat:@"¥%g",self.expertEntity.price];
    
    
    self.titleTips.text = @"专家解答";
    
    if (self.expertEntity.price==0) {
        [_commitbt setTitle:@"免费咨询" forState:UIControlStateNormal];
        [_commitbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"专家解答";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _uncompletedConStr =[NSString stringWithFormat:@"%@UncompletedConsultation",[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorColor = RGB(208, 208, 208);
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    //    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_table registerClass:[HEAParentQuestionTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self setupTableHeaderView];
    
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.table.userInteractionEnabled = NO;
        [ws.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?ws.expertEntity.HOSPITAL_ID:ws.expertEntity.doctorID status:-1];
    }];
    
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.table.userInteractionEnabled = NO;
        [ws.presenter loadMoreExpertConsultaionData];
    }];
    
}

- (void)setupTableHeaderView{
    headerView = [UIView new];
    _privateImageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //    _privateImageBtn.hidden =YES;
    [_privateImageBtn setImage:[UIImage imageNamed:@"HEprivateuploadoff"] forState:UIControlStateNormal];
    [_privateImageBtn setImage:[UIImage imageNamed:@"HEprivateuploadon"] forState:UIControlStateSelected];
    [_privateImageBtn addTarget:self action:@selector(openUploadPrivate:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *puLabel =[UILabel new];
    //    puLabel.hidden =YES;
    puLabel.text =@"公开图片";
    puLabel.font =[UIFont systemFontOfSize:12];
    puLabel.textColor =UIColorFromRGB(0x999999);
    
    _uploadImageView =[UIView new];
    //    _uploadImageView.hidden =YES;
    UIButton *upImageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [upImageBtn setImage:[UIImage imageNamed:@"HEaddimage"] forState:UIControlStateNormal];
    [upImageBtn addTarget:self action:@selector(showSheet) forControlEvents:UIControlEventTouchUpInside];
    [_uploadImageView addSubview:upImageBtn];
    upImageBtn.sd_layout.topEqualToView(_uploadImageView).leftEqualToView(_uploadImageView).widthIs(50).heightIs(40);
    UILabel *upLabelTip =[UILabel new];
    upLabelTip.text =@"点击添加图片";
    upLabelTip.font =[UIFont systemFontOfSize:14];
    upLabelTip.textColor =UIColorFromRGB(0x666666);
    [_uploadImageView addSubview:upLabelTip];
    upLabelTip.sd_layout.centerYEqualToView(upImageBtn).leftSpaceToView(upImageBtn,10).widthIs(90).heightIs(15);
    UILabel *upLabelTips =[UILabel new];
    upLabelTips.text =@"(最多3张)";
    upLabelTips.font =[UIFont systemFontOfSize:11];
    upLabelTips.textAlignment=NSTextAlignmentLeft;
    upLabelTips.textColor =UIColorFromRGB(0x999999);
    [_uploadImageView addSubview:upLabelTips];
    upLabelTips.sd_layout.centerYEqualToView(upImageBtn).leftSpaceToView(upLabelTip,0).widthIs(60).heightIs(12);
    
    
    _HaveImageView =[UIView new];
    _HaveImageView.hidden =YES;
    _HaveImageView.backgroundColor = [UIColor clearColor];
    
    
    for (int i =1; i<=3; i++) {
        UIImageView * photoImage =[UIImageView new];
        //            photoImage.contentMode =UIViewContentModeScaleAspectFill;
        photoImage.layer.masksToBounds = YES;
        photoImage.userInteractionEnabled = YES;
        photoImage.tag = 3000 + i;
        //            photoImage.layer.cornerRadius= 8;
        [photoImage.layer setBorderWidth:0.5];
        [photoImage.layer setBorderColor:RGB(80,199, 192).CGColor];
        photoImage.clipsToBounds =NO;
        [_HaveImageView addSubview:photoImage];
        [self.upImageViewArr addObject:photoImage];
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [photoImage addGestureRecognizer:tap];
        
        //删除按钮
        UIButton* deletebt = [UIButton new];
        [deletebt setBackgroundImage:[UIImage imageNamed:@"circle_del_icon1"] forState:UIControlStateNormal];
        
        UIButton* button = [UIButton new];
        [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [photoImage sd_addSubviews:@[deletebt,button]];
        
        
        photoImage.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
        
        deletebt.sd_layout.topSpaceToView(photoImage,-8).rightSpaceToView(photoImage,-8).widthIs(16).heightEqualToWidth();
        button.sd_layout.topSpaceToView(photoImage,-8).rightSpaceToView(photoImage,-8).widthIs(35).heightEqualToWidth();
        
        
        
        if (i==3) {
            _addImageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [_addImageBtn setImage:[UIImage imageNamed:@"HEhaveaddImage"] forState:UIControlStateNormal];
            [_addImageBtn addTarget:self action:@selector(showSheet) forControlEvents:UIControlEventTouchUpInside];
            [_HaveImageView addSubview:_addImageBtn];
            _addImageBtn.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(photoImage,10).widthIs(50).heightIs(50);
            
        }
    }
    
    
    [headerView sd_addSubviews:@[self.downImageView,self.BulletinBtn,self.downLb,self.iconbgImageView,self.doctorIcon,self.doctorName,self.lineView,self.doctorTitle,self.doctorIntroduce,self.doctorField,self.CoupondField,self.questionTimes,self.textView,_uploadImageView,_HaveImageView,_privateImageBtn,puLabel,self.moneyTips,self.pricenLabel,self.commitbt,self.headerTitlebgView]];
    [self.headerTitlebgView addSubview:self.titleTips];
    
    
    //
    
    //    _downLb = [UILabel new];
    ////    _downLb.text = self.expertEntity.Notice;
    //    _downLb.textAlignment = NSTextAlignmentCenter;
    //    _downLb.numberOfLines = 0;
    //    _downLb.backgroundColor = [UIColor redColor];
    //    _downLb.textColor = UIColorFromRGB(0xffffff);
    //    _downLb.font = [UIFont  systemFontOfSize:13];
    //    [self.BulletinBtn  addSubview:_downLb];
    //下拉图片
    CGFloat  top = 79/2;
    CGFloat  k_width = 558/2;
    CGFloat  k_height = 234/2;
    CGFloat  kk_width = 546/2-5;
    CGFloat  kk_height = 150/2 ;
    CGFloat  kkk_width = 118/2;
    CGFloat  kkk_height = 154/2;
    
    
    
    if (kScreenWidth == 320) {
        k_width = 558/2.5;
        k_height = 234/2.5;
        kk_width = 546/2.5;
        kk_height = 150/2.5;
        top = 79/2.5;
        kkk_width = 118/2.5;
        kkk_height = 154/2.5;
    }
    if (kScreenWidth == 375) {
        kk_width = 546/2-3;
        kk_height = 150/2;
        
    }
    
    self.downImageView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,11).heightIs(kkk_height).widthIs(kkk_width);
    self.BulletinBtn.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,kScreenWidth-k_width-16).heightIs(k_height).widthIs(k_width);
    if (kScreenWidth == 375) {
        self.downLb.sd_layout.topSpaceToView(headerView,top).leftSpaceToView(headerView,kScreenWidth-k_width-12).heightIs(kk_height).widthIs(kk_width);
    }else{
        
        self.downLb.sd_layout.topSpaceToView(headerView,top).leftSpaceToView(headerView,kScreenWidth-k_width-14).heightIs(kk_height).widthIs(kk_width);
    }
    self.iconbgImageView.sd_layout.topSpaceToView(_BulletinBtn,15).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
    self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    //医生头像
    //    self.iconbgImageView.sd_layout.topSpaceToView(headerView,30).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
    //    self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    self.doctorIcon.sd_layout.centerXEqualToView(self.iconbgImageView).centerYEqualToView(self.iconbgImageView).widthIs(60).heightEqualToWidth();
    self.doctorIcon.sd_cornerRadiusFromWidthRatio = @(0.5);
    //医生名字
    self.doctorName.sd_layout.topSpaceToView(self.iconbgImageView,20).heightIs(20).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0);
    //横线
    self.lineView.sd_layout.topSpaceToView(self.doctorName,12).heightIs(1).leftEqualToView(self.iconbgImageView).widthIs(25);
    //医生职称
    self.doctorTitle.sd_layout.centerYEqualToView(self.lineView).heightIs(15).leftSpaceToView(self.lineView,0).rightSpaceToView(headerView,0);
    //医生介绍
    CGFloat introduceHeight = [JMFoundation calLabelHeight:self.doctorIntroduce.font andStr:self.expertEntity.introduce withWidth:kScreenWidth-10*2];
    self.doctorIntroduce.sd_layout.topSpaceToView(self.doctorTitle,10).heightIs(introduceHeight).leftSpaceToView(headerView,10).rightSpaceToView(headerView,10);
    //领域
    CGFloat fieldHeight = [JMFoundation calLabelHeight:self.doctorField.font andStr:[NSString stringWithFormat:@"领域：%@",self.expertEntity.domain] withWidth:kScreenWidth-10*2];
    
    self.doctorField.sd_layout.topSpaceToView(self.doctorIntroduce,5).heightIs(fieldHeight).leftEqualToView(self.doctorIntroduce).rightEqualToView(self.doctorIntroduce);
    
    //优惠券次数
    
    CGFloat fieldHeight1 = [JMFoundation calLabelHeight:self.CoupondField.font andStr:[NSString stringWithFormat:@"免费义诊次数:%@次",_presenter.Couponcount] withWidth:kScreenWidth-10*2];
    
    self.CoupondField.sd_layout.topSpaceToView(self.doctorField,10).heightIs(fieldHeight1).leftEqualToView(self.doctorIntroduce).rightEqualToView(self.doctorIntroduce);
    
    UIView *headerMidBGView =[UIView new];
    headerMidBGView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [headerView addSubview:headerMidBGView];
    
    _headerMidView =[UIView new];
    _headerMidView.userInteractionEnabled =YES;
    UITapGestureRecognizer *dpTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dpTapAction)];
    [_headerMidView addGestureRecognizer:dpTap];
    _headerMidView.backgroundColor =[UIColor whiteColor];
    _headerMidView.layer.cornerRadius =5.0f;
    _headerMidView.layer.masksToBounds =YES;
    [headerMidBGView addSubview:_headerMidView];
    
    _totalCommentLabel =[UILabel new];
    //    _totalCommentLabel.text =@"kjhasuigdy1g8d721gd1gbhdjas";
    _totalCommentLabel.font =[UIFont systemFontOfSize:14.0f];
    _totalCommentLabel.textColor =UIColorFromRGB(0x666666);
    [_headerMidView addSubview:_totalCommentLabel];
    
    UIImageView *grayLine =[UIImageView new];
    grayLine.backgroundColor =UIColorFromRGB(0xeeeeee);
    [_headerMidView addSubview:grayLine];
    
    _firstCommentLabel =[UILabel new];
    _firstCommentLabel.numberOfLines =0;
    //    _firstCommentLabel.text =@"ashgdhjasdhwqhdiqwuhdiuqw";
    [_headerMidView addSubview:_firstCommentLabel];
    
    _totalCommentLabel.sd_layout.leftSpaceToView(_headerMidView,10).topSpaceToView(_headerMidView,10).heightIs(20).widthIs(200);
    grayLine.sd_layout.leftSpaceToView(_headerMidView,10).topSpaceToView(_totalCommentLabel,5).rightSpaceToView(_headerMidView,10).heightIs(1);
    _firstCommentLabel.sd_layout.topSpaceToView(grayLine,5).leftSpaceToView(_headerMidView,10).rightSpaceToView(_headerMidView,10).autoHeightRatio(0);
    
    
    _headerMidView.sd_layout.topSpaceToView(headerMidBGView,10).leftSpaceToView(headerMidBGView,10).rightSpaceToView(headerMidBGView,10);
    [_headerMidView setupAutoHeightWithBottomView:_firstCommentLabel bottomMargin:10];
    headerMidBGView.sd_layout.topSpaceToView(self.CoupondField,15).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).autoHeightRatio(0);
    [headerMidBGView setupAutoHeightWithBottomView:_headerMidView bottomMargin:10];
    
    //提问次数
    self.questionTimes.sd_layout.bottomSpaceToView(self.textView,5).heightIs(10).leftSpaceToView(headerView,10).rightSpaceToView(headerView,10);
    //textView
    self.textView.sd_layout.topSpaceToView(headerMidBGView,30).leftEqualToView(self.doctorIntroduce).rightEqualToView(self.doctorIntroduce).heightIs(195);
    
    _uploadImageView.sd_layout.topSpaceToView(self.textView,15).leftEqualToView(self.textView).rightEqualToView(self.textView).heightIs(65);
    _HaveImageView.sd_layout.topSpaceToView(self.textView,15).leftEqualToView(self.textView).rightEqualToView(self.textView).heightIs(65);
    
    _privateImageBtn.sd_layout.topSpaceToView(_HaveImageView,0).leftEqualToView(self.textView).heightIs(13).widthIs(13);
    
    puLabel.sd_layout.centerYEqualToView(_privateImageBtn).leftSpaceToView(_privateImageBtn,0).heightIs(13).widthIs(80);
    
    self.moneyTips.sd_layout.topSpaceToView(_privateImageBtn,10).leftEqualToView(self.textView).rightEqualToView(self.textView).heightIs(10);
    //提问价格
    self.pricenLabel.sd_layout.topSpaceToView(self.moneyTips,15).heightIs(15).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0);
    if([_textView.text trimming].length >= 20){
        if(self.expertEntity.price==0){
            [_commitbt  setImage:[UIImage  imageNamed:@"HEInfoCommit_FreeBtn"] forState:UIControlStateNormal];
        }else{
            [_commitbt  setImage:[UIImage  imageNamed:@"HEInfoCommit_CMBtn"] forState:UIControlStateNormal];
        }
        self.commitbt.sd_layout.topSpaceToView(self.pricenLabel,15).heightIs(100/2).centerXEqualToView(self.pricenLabel).widthIs(320/2);
    }else{
        //提交按钮
        self.commitbt.sd_layout.topSpaceToView(self.pricenLabel,15).heightIs(40).centerXEqualToView(self.pricenLabel).widthIs(100);
    }
    
    self.headerTitlebgView.sd_layout.topSpaceToView(self.commitbt,15).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0);
    self.titleTips.sd_layout.topSpaceToView(self.headerTitlebgView,15).heightIs(20).leftSpaceToView(self.headerTitlebgView,10).rightSpaceToView(self.headerTitlebgView,0);
    [self.headerTitlebgView setupAutoHeightWithBottomView:self.titleTips bottomMargin:15];
    
    [headerView setupAutoHeightWithBottomView:self.headerTitlebgView bottomMargin:0];
    
    [headerView layoutSubviews];
    
}

#pragma mark - 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    static NSString *cellID4 = @"cell4";
    static NSString *cellID5 = @"cell5";
    static NSString *cellID6 = @"cell6";
    
    HEAParentQuestionEntity *preQuestion =[self.presenter.dataSource objectAtIndex:indexPath.row];
    
    HEAParentQuestionTableViewCell* cell;
    
    
    
    if (![preQuestion.IsOpenImage boolValue]) {
        cell = [_table dequeueReusableCellWithIdentifier:cellID0];
        
        if (cell==nil) {
            cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
            
        }
        
        cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
        
        cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
        
        
        
    }else{
        if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
            
            cell = [_table dequeueReusableCellWithIdentifier:cellID0];
            
            if (cell==nil) {
                cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                
                
            }
            cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
            cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
            
        }else {
            
            if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])) {
               
                cell = [_table dequeueReusableCellWithIdentifier:cellID1];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
            }else if ((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
               
                cell = [_table dequeueReusableCellWithIdentifier:cellID2];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
            }else if ((preQuestion.Image3!=nil&&preQuestion.Image3.length!=0)&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                
                cell = [_table dequeueReusableCellWithIdentifier:cellID3];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
            }else if (((preQuestion.Image4!=nil&&preQuestion.Image4.length!=0)&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""]))){
                cell = [_table dequeueReusableCellWithIdentifier:cellID4];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
            }else if (((preQuestion.Image5!=nil&&preQuestion.Image5.length!=0)&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""]))){
                
                cell = [_table dequeueReusableCellWithIdentifier:cellID5];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
            }else{
                
                cell = [_table dequeueReusableCellWithIdentifier:cellID6];
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID6];
                }
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
            }
            
//            if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])) {
//                
//                cell = [_table dequeueReusableCellWithIdentifier:cellID1];
//                
//                if (cell==nil) {
//                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
//                    
//                }
//                
//                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
//                
//                
//            }else if((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])){
//                
//                cell = [_table dequeueReusableCellWithIdentifier:cellID2];
//                
//                if (cell==nil) {
//                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
//                    
//                }
//                
//                
//                
//                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
//                
//            }else {
//                cell = [_table dequeueReusableCellWithIdentifier:cellID3];
//                
//                if (cell==nil) {
//                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
//                    
//                }
//                
//                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
//                
//                
//                
//            }
        }
    
    }
    
    cell.detalIsFreeQuestion = YES;
    NSNumber* isSelect = (NSNumber*)[self.stateDic objectForKey:@(indexPath.row)];
    cell.isSelect = [isSelect intValue];
    if (self.expertEntity.price==0) {
        //        cell.isFree =YES;
     
    HEAParentQuestionEntity* model = [self.presenter.dataSource objectAtIndex:indexPath.row];
        NSLog(@"模型的 免费 是 %@",model.IsFree);
    if ([[NSString  stringWithFormat:@"%@",model.IsFree]  isEqualToString:@"1"]) {
        cell.isFreeQusetion =YES;
    }else{
        
        cell.isFreeQusetion =NO;
    }
        
    }
    WS(ws);
    __weak typeof(cell) weakCell = cell;
    HEAParentQuestionEntity* question = [ws.presenter.dataSource objectAtIndex:indexPath.row];
    
    [cell clickAudionButtonOnCompletion:^(UIButton *bt) {
        NSArray* result = [question.voiceUrl componentsSeparatedByString:@"/"];
        if(question.isListen|weakCell.isFree|ws.isDoctor|(weakCell.detalIsFreeQuestion &&[[NSString  stringWithFormat:@"%@",question.IsFree]  isEqualToString:@"1"])){
            
            if (weakCell.isFree) {
                [ws.presenter addListenQuestion:question withListenPrice:0];
            }
            //已经偷听过了
            if([NSString fileIsExist:[result lastObject]]){
                //语音文件存在
                NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
                if(!bt.selected){
                    [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                        NSLog(@"播放完成");
                        [ws.stateDic setObject:@0 forKey:@(indexPath.row)];
                        [ws.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        player = nil;
                    }];
                }
                [ws.stateDic setObject:@1 forKey:@(indexPath.row)];
                
                if(ws.currentIndexPath && [ws.currentIndexPath isEqual:indexPath]){
                    //点击了同一个cell,播放／暂停
                    if(bt.selected){
                        NSLog(@"停止");
                        [[AVRecorderPlayerManager sharedManager] pause];
                        [ws.stateDic setObject:@0 forKey:@(indexPath.row)];
                    }
                }else{
                    //点击不同cell
                    if(ws.currentIndexPath && [(NSNumber*)[ws.stateDic objectForKey:@(ws.currentIndexPath.row)] intValue]){
                        //清除上次按钮选中状态，暂停上次播放语音
                        [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                    }
                }
                if (self.currentIndexPath) {
                    [ws.table reloadRowsAtIndexPaths:@[ws.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                ws.currentIndexPath = indexPath;
                ws.currentSelectButton = bt;
                //                [ws.table reloadData];
                [ws.table reloadRowsAtIndexPaths:@[ws.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //语音文件不存在，下载
                if( ws.currentIndexPath && [(NSNumber*)[ws.stateDic objectForKey:@(ws.currentIndexPath.row)] intValue]){
                    //清除上次按钮选中状态,停止上次播放
                    [[AVRecorderPlayerManager sharedManager] pause];
                    [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                    [ws.table reloadRowsAtIndexPaths:@[ws.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                [ws.stateDic setObject:@1 forKey:@(indexPath.row)];
                
                ws.isReloadAllData = YES;
                
                if(ws.saveIndexPath || ws.saveSelectButton){
                    ws.saveIndexPath = nil;
                    ws.saveSelectButton = nil;
                }
                
                ws.saveIndexPath = indexPath;
                ws.saveSelectButton = bt;
                ws.indicator = weakCell.activityIndicator;
                
                [weakCell.activityIndicator startAnimating];
                
                [ws.presenter downloadAudioFile:question.voiceUrl];
            }
        }else{
            //未偷听，跳到支付页面
            NSLog(@"未偷听，请先支付");
            
            ws.currentIndexPath = indexPath;
            ws.currentSelectButton = bt;
            ws.indicator = weakCell.activityIndicator;
            
            ws.currentQuestion = question;
            ws.isListenType = YES;
            
            if([kDefaultsUser valueForKey:[NSString stringWithFormat:@"%ld",question.uuID]] && [kDefaultsUser valueForkey:@"listenOrderID"]){
                //处理支付成功，但是走订单支付接口失败
                NSString *orderID = [kDefaultsUser valueForkey:@"orderID"];
                
                [ws.indicator startAnimating];
                [ws.presenter tradePaySuccessWithOrderID:orderID];
                
            }else if([kDefaultsUser valueForKey:[NSString stringWithFormat:@"%ld",question.uuID]] && [kDefaultsUser valueForkey:addListenPath]){
                //处理支付成功，订单支付接口成功，但是添加偷听失败
                if(ws.listenPrice == 0){
                    ws.listenPrice = ws.expertEntity.price;
                    //                    ws.listenPrice = 0.01;//test
                }
                
                [ws.indicator startAnimating];
                [ws.presenter addListenQuestion:ws.currentQuestion withListenPrice:ws.listenPrice];
                
            }else{
                //选择支付方式
                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                sheet.tag = 1001;
                [sheet showInView:ws.view];
            }
            
        }
    }];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    cell.delegate =  self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HEAParentQuestionEntity* question = [self.presenter.dataSource objectAtIndex:indexPath.row];
    //    HotDetailViewController *vc = [HotDetailViewController new];
    HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController  new];
    vc.UUID = [NSNumber  numberWithInteger:question.uuID];
    //    vc.row = [NSNumber numberWithInteger:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HEAParentQuestionEntity* question = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:question keyPath:@"question" cellClass:[HEAParentQuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}

-(void)onCompletion:(BOOL)success info:(NSString *)message{
    
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    //    [ProgressUtil dismiss];
    
    
    if([kDefaultsUser valueForkey:@"orderID"]){
        //处理订单支付接口失败情况
        [kDefaultsUser removeValueWithKey:@"orderID"];
        [kDefaultsUser removeValueWithKey:paySuccessKeyPath];
    }
    
    if([kDefaultsUser valueForkey:addConsultationPath]){
        //处理添加咨询失败情况
        [kDefaultsUser removeValueWithKey:addConsultationPath];
    }
    
    if([kDefaultsUser valueForkey:laodConsultationPath]){
        //处理加载咨询失败情况
        [kDefaultsUser removeValueWithKey:laodConsultationPath];
    }
    
    
    if(success){
        [ProgressUtil dismiss];
        self.expertEntity.hearCount = self.presenter.totalCount;
        NSString* times = (self.expertEntity.hearCount != 0?[NSString stringWithFormat:@"已有%ld次提问",self.expertEntity.hearCount]: @"");
        self.questionTimes.text = times;
        [self.questionTimes updateLayout];
        
        [_table reloadData];
        
        
    }else{
        
        [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:laodConsultationPath];
        
        [ProgressUtil showError:message];
        
    }
}

-(void)MoreOnCompletion:(BOOL)success info:(NSString *)message{
    _table.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    
    if(success){
        
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:message];
    }
    
}




- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url{
    
    
    if (success) {
        if ([self.wxPayType isEqualToString:@"questionBiz"]) {
            
            self.wxCouponPay =nil;
            
            NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"" forKey:[NSString stringWithFormat:@"%@UncompletedConsultation",[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID]];
            [userDefaults synchronize];
            
            _textView.text =nil;
            
            [ProgressUtil show];
            [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
            
            [_presenter getCouPonList];
            
            for (UIImageView *imageiew in _upImageViewArr) {
                imageiew.image = nil;
            }
            
            _photoArray = nil;
            if (_uploadImageArr.count!=0) {
                _uploadImageView.hidden =NO;
                _HaveImageView.hidden =YES;
                _uploadImageArr =nil;
                _photoArray =nil;
            }
            
            [_table reloadData];
            
        }else if([self.wxPayType isEqualToString:@"listenBiz"]){
            //偷听
            
            
            self.currentQuestion.isListen = 1;//已经偷听
            
            [self.stateDic setObject:@1 forKey:@(self.currentIndexPath.row)];
            
            //        [self.indicator startAnimating];
            
            [self.presenter downloadAudioFile:url];
        }
        
        
        
    }else{
        [ProgressUtil showInfo:message];
    }
}

-(void)addOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        NSLog(@"咨询成功");
        for (UIImageView *imageiew in _upImageViewArr) {
            imageiew.image = nil;
        }
        
        _photoArray = nil;
        NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:[NSString stringWithFormat:@"%@UncompletedConsultation",[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID]];
        [userDefaults synchronize];
        
        if(_textView.text.length != 0){
            _textView.text = nil;
            _textView.textLength = 0;
        }
        [ProgressUtil show];
        [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
        
        
        if (_uploadImageArr.count!=0) {
            _uploadImageView.hidden =NO;
            _HaveImageView.hidden =YES;
            _uploadImageArr =nil;
            _photoArray =nil;
        }
        //咨询成功获取优惠券次数
        [self.presenter GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
        
        if (IsClinic) {
            
            [ProgressUtil  showSuccess:@"已成功使用一次免费义诊"];
            
        }
    }else{
        if (IsClinic) {
            //咨询成功获取优惠券次数
            if ([message  isEqualToString:@"消耗完毕"]) {
                WSLog(@"免费义诊优惠券使用完毕请求失败");
                [ProgressUtil  showError:@"免费义诊的次数已被抢光啦，请您付费提问～"];
                [self.presenter GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
            }else{
                WSLog(@"免费义诊请求网络断开失败");
                if ((self.expertEntity.price==0)|self.isDoctor) {
                    [ProgressUtil show];
                    [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
                    if (_uploadImageArr.count!=0) {
                        _uploadImageView.hidden =NO;
                        _HaveImageView.hidden =YES;
                        _uploadImageArr =nil;
                        _photoArray =nil;
                    }
                    return ;
                }
                [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:addConsultationPath];
                
                [ProgressUtil showError:message];
            }
            
        }else{
            WSLog(@"添加数据网络断开失败");
            if ((self.expertEntity.price==0)|self.isDoctor) {
                [ProgressUtil show];
                [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
                if (_uploadImageArr.count!=0) {
                    _uploadImageView.hidden =NO;
                    _HaveImageView.hidden =YES;
                    _uploadImageArr =nil;
                    _photoArray =nil;
                }
                return ;
            }
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:addConsultationPath];
            
            [ProgressUtil showError:message];
        }
        
    }
}
-(void)listenOnCompletion:(BOOL)success info:(NSString *)message{
    //    if(success){
    
    //通知首页刷新
    //        [kdefaultCenter postNotificationName:Notification_HotIsLoad object:nil];
    
    NSLog(@"添加偷听成功");
    //添加偷听成功，下载语音开始播放
    HEAParentQuestionEntity* question = self.presenter.dataSource[self.currentIndexPath.row];
    question.hearCount ++;
    question.isListen = 1;//已经偷听
    
    [self.stateDic setObject:@1 forKey:@(self.currentIndexPath.row)];
    
    //        [self.indicator startAnimating];
    
    [self.presenter downloadAudioFile:question.voiceUrl];
    
    //    }else{
    //        if(self.isListenType){
    //            self.isListenType = NO;
    //            [self.indicator stopAnimating];
    //        }
    //
    //        [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
    //        [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:addListenPath];
    //
    ////        [ProgressUtil showError:message];
    //    }
}

-(void)tradeIDOnCompletion:(BOOL)success info:(NSString *)message{
    //    [ProgressUtil dismiss];
    WS(ws);
    if (_payIndex == 1000) {
        //插入咨询
        [_presenter addExpertConsultation:_textView.text doctorID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID photo:_photoArray isOpen:_privateImageBtn.selected complete:^(BOOL success, NSString *message) {
            if (success == YES) {
                [ws pay:success message:message];
            }else{
                [ProgressUtil showError:message];
            }
        }];
    }else if (_payIndex == 1001){
        //插入偷听
        NSDictionary *parameter = @{@"Expert_ID":@(self.currentQuestion.expertID),@"ConsultationID":@(self.currentQuestion.uuID),@"UserID":@(kCurrentUser.userId),@"Price":@(1),@"OrderID":self.presenter.orderID};
        [[FPNetwork POST:API_INSERT_LISTEN_QUESTION_RECORDS withParams:parameter] addCompleteHandler:^(FPResponse *response) {
            if (response.success == YES) {
                [ws pay:success message:message];
            }else{
                [ProgressUtil showError:response.message];
            }
        }];
    }else if (_payIndex == 1008){
        [self afterPhotoUpload];
        
    }else{
        [self pay:success message:message];
    }
}
- (void)pay:(BOOL )success message:(NSString *)message{
    if(success){
        //获取订单号成功
        NSLog(@"订单号==%@",self.presenter.orderID);
        //走支付宝接口
        NSString* orderID = [NSString stringWithFormat:@"%.@",self.presenter.orderID];
        CGFloat price = self.expertEntity.price;
        if(self.coupon  != nil){
            NSLog(@"优惠券支付");
            price = _presenter.price;
        }
        NSString* title = @"提问支付";
        if([self.presenter.bussinessType isEqualToString:@"listenBiz"]){
            title = @"旁听支付";
            price = 1;//偷听价格
            self.listenPrice = price;
        }
        
        //        price = 0.01;//test
        
        WS(ws);
        [AliPayUtil payWithTitle:title withDetail:@"详情" withOrderNum:orderID withPrice:price callback:^(NSDictionary*dict){
            //支付成功调用，订单支付成功接口，并且调用插入咨询表的接口
            NSString* payStatus = dict[@"resultStatus"];
            if([payStatus isEqualToString:@"9000"]){
                NSLog(@"支付成功");
                [ProgressUtil showSuccess:@"付款成功"];
                if(ws.isListenType){
                    [ws.indicator startAnimating];
                }
                [ws.presenter tradePaySuccessWithOrderID:ws.presenter.orderID];
                
                
            }else if([payStatus isEqualToString:@"6001"]){
                NSLog(@"用户中途取消支付");
                self.coupon = nil;
                [ProgressUtil showInfo:@"用户取消支付"];
            }else if([payStatus isEqualToString:@"6002"]){
                self.coupon = nil;
                NSLog(@"网络连接出错");
                [ProgressUtil showInfo:@"网络连接出错"];
            }else if([payStatus isEqualToString:@"4000"]){
                self.coupon = nil;
                NSLog(@"订单支付失败");
                [ProgressUtil showInfo:@"订单支付失败"];
            }else{
                self.coupon = nil;
                NSLog(@"正在处理中");
            }
            
        }];
        
        
    }else{
        [ProgressUtil showError:message];
    }
    
}

-(void)paySuccessOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        if([self.presenter.bussinessType isEqualToString:@"questionBiz"]){
            //咨询
            [self afterPhotoUpload];
            
            //            [self.presenter  GetConsumptionCouponWithcouponID:self.coupon expert_ID:self.expertEntity.doctorID ConsultationID:[NSNumber  numberWithInteger:0]];
            
            [self.presenter   GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
            [_presenter getCouPonList];
            //            [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
        }else if([self.presenter.bussinessType isEqualToString:@"listenBiz"]){
            //偷听
            [self.presenter addListenQuestion:self.currentQuestion withListenPrice:self.listenPrice];
        }
    }else{
        if(self.isListenType){
            //---偷听－－－－
            self.isListenType = NO;
            [self.indicator stopAnimating];
            
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:[NSString stringWithFormat:@"%ld",(long)self.currentQuestion.uuID]];
            //保存偷听订单号到本地
            [kDefaultsUser saveValue:self.presenter.orderID withKeyPath:@"listenOrderID"];
        }else{
            //－－－－咨询－－－－－
            //保存支付失败状态，下次跳过支付宝/微信支付，直接走支付成功接口
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:paySuccessKeyPath];
            //保存订单号到本地
            [kDefaultsUser saveValue:self.presenter.orderID withKeyPath:@"orderID"];
        }
        
        
        
        [ProgressUtil showError:message];
    }
}

-(void)downloadOnCompletion:(BOOL)success info:(NSString *)message{
    [self.indicator stopAnimating];
    WS(ws);
    
    if(success){
        //先转码，在播放
        NSString* downloadPath = [NSString getDownloadPath:self.presenter.voiceURL];
        NSArray* result = [ws.presenter.voiceURL componentsSeparatedByString:@"/"];
        
        //文件名不带后缀
        NSString* fileName = [NSString getFileName:[result lastObject]];
        
        NSString *convertedPath = [VoiceConvertUtile GetPathByFileName:fileName ofType:@"wav"];
        //amr格式转wav格式
        if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
            
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                NSLog(@"播放完成");
                [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                [ws.table reloadRowsAtIndexPaths:@[ws.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                player = nil;
            }];
            
        }else{
            //转码失败
            
        }
        
        if(self.isReloadAllData){
            self.isReloadAllData = NO;
            [self.table reloadData];
            self.currentIndexPath = self.saveIndexPath;
            self.currentSelectButton = self.saveSelectButton;
            
        }else{
            [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //清除保存的订单id
        if([kDefaultsUser valueForkey:@"listenOrderID"]){
            //处理订单支付接口失败情况
            [kDefaultsUser removeValueWithKey:@"listenOrderID"];
            [kDefaultsUser removeValueWithKey:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
        }
        if([kDefaultsUser valueForkey:addListenPath]){
            [kDefaultsUser removeValueWithKey:addListenPath];
            [kDefaultsUser removeValueWithKey:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
        }
        
    }else{
        [ProgressUtil showError:message];
        
    }
}

-(void)GetCouponByCouponCodeCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil dismiss];
        
        [_presenter getCouPonList];
        
        ECouponViewController   *vc = [ECouponViewController   new];
        vc.doctorID =[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID;
        vc.delegate = self;
        [self.navigationController  pushViewController:vc animated:YES];
    }else {
        [ProgressUtil showError:message];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //使用优惠码
    if (buttonIndex == 0) {
        NSLog(@"优惠码取消");
    }
    else if (buttonIndex == 1) {
        NSLog(@"优惠码确定");
        UITextField *pwdField = [alertView textFieldAtIndex:0];
        if ((pwdField.text ==nil)|[pwdField.text isEqualToString:@""]) {
            [ProgressUtil showError:@"请输入优惠码"];
            return;
        }
        [ProgressUtil show];
        
        [_presenter getCouponByCouponCode:pwdField.text];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _payIndex = actionSheet.tag;
    NSString* bussinessType = nil;
    NSLog(@"选择按钮优惠券：%@",_presenter.Couponcount);
    
    
    if ([_presenter.Couponcount  integerValue] >0 && isCoupon == YES) {
        
        if(actionSheet.tag == 1000){
            //咨询
            
            bussinessType = @"questionBiz";
            
            if(buttonIndex == 0){
                NSLog(@"支付宝支付");
                self.wxCouponPay =nil;
                
                [ProgressUtil show];
                [self.presenter getTradeID:bussinessType withPrice:self.expertEntity.price withPayType:@"alipay"];
#pragma 打点统计*专家解答-->支付
                [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
                
#pragma mark--  UMeng事件统计
                [MobClick event:@"apay_consult" ];
                
            }else if (buttonIndex == 1){
#pragma 打点统计*专家解答-->支付
                [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
                
                NSLog(@"微信支付");
                [ProgressUtil show];
                self.wxPayType =@"questionBiz";
                [self.presenter weixinPayOpenImage:_privateImageBtn.selected PhotoArr:_photoArray Question:_textView.text DoctorId:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
            }else if (buttonIndex == 2){
                NSLog(@"优惠券");
#pragma 打点统计*专家解答-->支付
                [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
#pragma mark--  UMeng事件统计
                self.wxPayType =@"questionBiz";
                
                [MobClick event:@"apay_coupon" ];
                ECouponViewController   *vc = [ECouponViewController   new];
                vc.delegate = self;
                vc.doctorID =[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID;
                [self.navigationController  pushViewController:vc animated:YES];
            }else if (buttonIndex == 3){
                NSLog(@"取消");
#pragma 打点统计*专家解答-->取消
                [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewCanclePay Action:DotEventEnter  Remark:nil];
                
            }
        }
        else if(actionSheet.tag == 1001){
            //偷听
            bussinessType = @"listenBiz";
            
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue]){
                //清除上次按钮选中状态,停止上次播放
                [[AVRecorderPlayerManager sharedManager] pause];
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.table reloadData];
            }
            if(buttonIndex == 0){
                NSLog(@"支付宝支付");
                self.wxCouponPay =nil;
                
                [ProgressUtil show];
                [self.presenter getTradeID:bussinessType withPrice:1.f withPayType:@"alipay"];
                
            }else if (buttonIndex == 1){
                [ProgressUtil show];
                self.wxPayType =@"listenBiz";
                
                NSLog(@"微信支付");
                [self.presenter weixinPayWithListenId:self.currentQuestion.uuID];
                
                
            }else if (buttonIndex == 2){
                
                
                NSLog(@"取消");
            }
            
        }else if (actionSheet.tag ==1008){
            //向自己提问
            if(buttonIndex == 0){
                NSLog(@"确定");
                self.wxCouponPay =nil;
                [ProgressUtil show];
                
                [_presenter getTradeID:@"questionBiz" withPrice:0.f withPayType:@"alipay"];
                
#pragma mark--  UMeng事件统计
                if (self.isDoctor) {
                    [MobClick event:@"free_doc" ];
                }else{
                    [MobClick event:@"free_user" ];
                }
                //            [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
            }else if (buttonIndex == 1){
                NSLog(@"取消");
            }
        }else if (actionSheet.tag ==1100){
            //免费义诊
            if (buttonIndex == 0) {
                //确定
                
                [self.presenter addExpertConsultation:_textView.text doctorID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID photo:_photoArray isOpen:_privateImageBtn.selected  couponid:self.coupon  Freeclinic:@(1)];
                
            }else if (buttonIndex == 1){
                //取消
                NSLog(@"取消免费义诊");
                
            }
            
        }else if (actionSheet.tag ==1009){
            
            if (buttonIndex == 0) {
                NSLog(@"上传照片");
                [self pickPhoto];
            }else if (buttonIndex == 1) {
                NSLog(@"拍照上传");
                [self takePhoto];
            }else if (buttonIndex == 2) {
                NSLog(@"取消");
            }
            
        }
    }
    else{
        
        if(actionSheet.tag == 1000){
            //咨询
            bussinessType = @"questionBiz";
            if ([_presenter.Couponcount  integerValue] >0&&_presenter.CouPonSource.count==0) {
                if(buttonIndex == 0){
                    NSLog(@"支付宝支付");
                    self.wxCouponPay =nil;
                    
                    [ProgressUtil show];
#pragma 打点统计*专家解答-->支付
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
#pragma mark--  UMeng事件统计
                    [MobClick event:@"apay_consult" ];
                    [self.presenter getTradeID:bussinessType withPrice:self.expertEntity.price withPayType:@"alipay"];
                    
                }else if (buttonIndex == 1){
                    NSLog(@"微信支付");
#pragma 打点统计*专家解答-->支付
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
                    [ProgressUtil show];
                    //            _privateImageBtn.selected
                    //            _photoArray
                    self.wxPayType =@"questionBiz";
                    
                    [self.presenter weixinPayOpenImage:_privateImageBtn.selected PhotoArr:_photoArray Question:_textView.text DoctorId:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
                    
                }else if (buttonIndex ==2){
                    NSLog(@"优惠码");
#pragma 打点统计*专家解答-->支付
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
                    self.wxPayType =@"questionBiz";
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入优惠码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    UITextField *pwdField = [alertView textFieldAtIndex:0];
                    pwdField.placeholder = @"请输入优惠码";
                    [alertView show];
                    
                }else if (buttonIndex ==3){
                    NSLog(@"取消");
                    
#pragma 打点统计*专家解答-->取消
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewCanclePay Action:DotEventEnter  Remark:nil];
                    
                }
                
            }else {
                if(buttonIndex == 0){
                    NSLog(@"支付宝支付");
                    self.wxCouponPay =nil;
                    
                    [ProgressUtil show];
#pragma 打点统计*专家解答-->支付
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
#pragma mark--  UMeng事件统计
                    [MobClick event:@"apay_consult" ];
                    [self.presenter getTradeID:bussinessType withPrice:self.expertEntity.price withPayType:@"alipay"];
                    
                }else if (buttonIndex == 1){
                    NSLog(@"微信支付");
#pragma 打点统计*专家解答-->支付
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewPay Action:DotEventEnter  Remark:nil];
                    [ProgressUtil show];
                    //            _privateImageBtn.selected
                    //            _photoArray
                    self.wxPayType =@"questionBiz";
                    
                    [self.presenter weixinPayOpenImage:_privateImageBtn.selected PhotoArr:_photoArray Question:_textView.text DoctorId:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
                    
                }else if (buttonIndex ==2){
                    NSLog(@"取消");
                    
#pragma 打点统计*专家解答-->取消
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewCanclePay Action:DotEventEnter  Remark:nil];
                }
                
            }
            
        }
        else if(actionSheet.tag == 1001){
            //偷听
            bussinessType = @"listenBiz";
            
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue]){
                //清除上次按钮选中状态,停止上次播放
                [[AVRecorderPlayerManager sharedManager] pause];
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.table reloadData];
            }
            if(buttonIndex == 0){
                NSLog(@"支付宝支付");
                self.wxCouponPay =nil;
                
                [ProgressUtil show];
                [self.presenter getTradeID:bussinessType withPrice:self.expertEntity.price withPayType:@"alipay"];
                
            }else if (buttonIndex == 1){
                NSLog(@"微信支付");
                [ProgressUtil show];
                self.wxPayType =@"listenBiz";
                
                [self.presenter weixinPayWithListenId:self.currentQuestion.uuID];
            }else if (buttonIndex ==2){
                NSLog(@"取消");
                
            }
            
        }else if (actionSheet.tag ==1008){
            
            if(buttonIndex == 0){
                NSLog(@"确定");
                [ProgressUtil show];
                
                [self afterPhotoUpload];
#pragma mark--  UMeng事件统计
                if (self.isDoctor) {
                    [MobClick event:@"free_doc" ];
                }else{
                    [MobClick event:@"free_user" ];
                }
                
                
                //            [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
            }else if (buttonIndex == 1){
                NSLog(@"取消");
            }
        }else if (actionSheet.tag ==1100){
            //免费义诊
            if (buttonIndex == 0) {
                //确定
                
                [self.presenter addExpertConsultation:_textView.text doctorID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID photo:_photoArray isOpen:_privateImageBtn.selected  couponid:self.coupon  Freeclinic:@(1)];
                
            }else if (buttonIndex == 1){
                //取消
                NSLog(@"取消免费义诊");
                
            }
            
        }else if (actionSheet.tag ==1009){
            
            if (buttonIndex == 0) {
                NSLog(@"上传照片");
                [self pickPhoto];
            }else if (buttonIndex == 1) {
                NSLog(@"拍照上传");
                [self takePhoto];
            }else if (buttonIndex == 2) {
                NSLog(@"取消");
            }
            
        }
    }
    
}
//- (void)GetExpertCanConsumeCountOnCompletion:(BOOL) success info:(NSString*) message{
//    if (success) {
//        NSNumber  *str = _presenter.Couponcount;
//        NSLog(@"====次数：%@",str);
//        //优惠券次数
//        
//        _CoupondField.text = [NSString  stringWithFormat:@"免费义诊次数:%@次",_presenter.Couponcount];
//        _CoupondField.textColor = UIColorFromRGB(0x999999);
//        NSMutableAttributedString *Str1 = [[NSMutableAttributedString alloc] initWithString:_CoupondField.text ];
//        [Str1 addAttribute:NSForegroundColorAttributeName
//                     value:UIColorFromRGB(0x61d8d3)
//                     range:NSMakeRange(0, 7)];
//        _CoupondField.attributedText = Str1;
//        
//    }else{
//        [ProgressUtil  showError:message];
//    }
//}

-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message{
    
    if(success){
        
        for (NSInteger  i= 0; i<_presenter.CouPonSource.count; i++){
            if ([[NSString stringWithFormat:@"%@", _presenter.CouPonSource[i].ClaimStatus]  isEqualToString: @"0"]) {
                isCoupon = YES;
                break;
            }
        }
        NSLog(@"ss优惠券2：%d",isCoupon);
    }else{
        
        [ProgressUtil  showError:message];
    }
    
    
    
}

- (void)getExpertCommentListSuccess{
    _totalCommentLabel.text =[NSString stringWithFormat:@"收到的点评 %@",_presenter.myCommentListEntity.TotalCount?_presenter.myCommentListEntity.TotalCount:@0];
    if (_presenter.myCommentListEntity.CommentConetent.length!= 0){
        NSString* field = _presenter.myCommentListEntity.CommentConetent;
        NSMutableAttributedString* attrubutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",_presenter.myCommentListEntity.NickName,field]];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, attrubutStr.length)];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff8a80) range:NSMakeRange(0, _presenter.myCommentListEntity.NickName.length+1)];
        
        [attrubutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:NSMakeRange(0, attrubutStr.length)];
        _firstCommentLabel.attributedText = attrubutStr;
        
    }else{
        _firstCommentLabel.text =@"暂无评价";
        
    }
    [headerView layoutSubviews];
    
}

#pragma mark----监听文本框内容改变通知
- (void)textDidChange{
    
    
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:_textView.text forKey:_uncompletedConStr];
    [userDefaults synchronize];
    if([_textView.text trimming].length >= 20){
        if(self.expertEntity.price==0){
            [_commitbt  setImage:[UIImage  imageNamed:@"HEInfoCommit_FreeBtn"] forState:UIControlStateNormal];
        }else{
            [_commitbt  setImage:[UIImage  imageNamed:@"HEInfoCommit_CMBtn"] forState:UIControlStateNormal];
        }
        self.commitbt.sd_layout.topSpaceToView(self.pricenLabel,15).heightIs(100/2).centerXEqualToView(self.pricenLabel).widthIs(320/2);
        
        [self.commitbt updateLayout];
        [headerView  updateLayout];
        [headerView layoutSubviews];
//        _table.tableHeaderView = headerView;
        
    }else{
        if(self.expertEntity.price==0){
            [_commitbt setTitle:@"免费咨询" forState:UIControlStateNormal];
            [_commitbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_commitbt  setImage:nil  forState:UIControlStateNormal];
            
        }else{
            [_commitbt setTitle:@"写好了" forState:UIControlStateNormal];
            [_commitbt  setImage:nil  forState:UIControlStateNormal];
            [_commitbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        self.commitbt.sd_layout.topSpaceToView(self.pricenLabel,15).heightIs(40).centerXEqualToView(self.pricenLabel).widthIs(100);
        
        [self.commitbt updateLayout];
        [headerView  updateLayout];
        [headerView layoutSubviews];
//        _table.tableHeaderView = headerView;
        
    }
    
    firstCommit = YES;
}

#pragma mark 赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.presenter.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter praise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:1];
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount++;
            [ws.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //            [ws lastRefresh];
            //            首页刷新
            kCurrentUser.hotIsNeedReload = NO;
            //圈子首页刷新
            [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
            
            
        }else{
            [ProgressUtil showError:@"点赞失败"];
        }
    }];
}
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.presenter.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter cancelPraise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:0];
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount--;
            [ws.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //            [ws lastRefresh];
            //            首页刷新
            kCurrentUser.hotIsNeedReload = NO;
            //圈子首页刷新
            [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
            
            
            
        }else{
            [ProgressUtil showError:@"取消点赞失败"];
        }
    }];
}

- (void)lastRefresh{
    for (BaseViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HotQuestionViewController class]]) {
            [(HotQuestionViewController *)vc refresh];
        }
    }
}


#pragma mark * 通知刷新本页面点赞
- (void)refreshtableList{
    NSLog(@"刷新医生详情页面");
    [_table.mj_header  beginRefreshing];
}


#pragma mark * 照片墙浏览代理
-(NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.upImageViewArr.count;
}
-(SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    SFPhoto* sfPhoto = [SFPhoto new];
    
    //原图
    sfPhoto.srcImageView = self.upImageViewArr[index];
    
    //缩略图片的url
    //    NSString *imgUrl = self.photoWallURL[index];
    //    if(imgUrl && imgUrl.length != 0){
    //        sfPhoto.url = [NSURL URLWithString:imgUrl];
    //    }
    
    
    return sfPhoto;
}


#pragma mark - 点击事件

/**
 *  分享
 */
-(void)rightItemAction:(id)sender{
    NSLog(@"分享");
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL_SHARE_EXPERTANSWER,[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
    NSLog(@"%@",urlStr);
    
    if (imageArray) {
        NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        NSString  *String = [NSString  stringWithFormat:@"%@——%@",self.expertEntity.doctorName,self.expertEntity.introduce];
        
        NSString *title = String ;
        
        
        
        if(String.length > 40){
            title = [String substringWithRange:NSMakeRange(0, 40)];
        }
        NSData * imageData = UIImageJPEGRepresentation(self.doctorIcon.image,1);
        
        NSLog(@"data1:%u",[imageData length]/1000);
        
        NSLog(@"压缩前%@",self.doctorIcon.image);
        [JMFoundation  imageCompressForSize:self.doctorIcon.image targetSize:CGSizeMake(80, 0)];
        NSLog(@"压缩后%@",self.doctorIcon.image);
        
        NSData * imageData1 = UIImageJPEGRepresentation(self.doctorIcon.image,0.5);
        
        NSLog(@"data2:%u",[imageData1 length]/1000);
        
        UIImage *shareimage = [UIImage imageWithData: imageData1];
        
        NSLog(@"压缩后1%@",shareimage);
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:text               images:self.doctorIcon.image
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
/**
 *  提交
 */
- (void)commitAction{
#pragma mark--  UMeng提交咨询事件统计
    
    [MobClick event:@"consultation" ];
    IsClinic  = NO;
    NSLog(@"提交");
    if (kCurrentUser.userId == 0) {
        //账户超时，退回登陆页面
        [ProgressUtil showError:@"账户超时"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPsw"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
    }
    
    if ([self.expertEntity.IsVacation isEqual:@1]) {
        [ProgressUtil showInfo:@"医生正在休假无法提问"];
        return;
    }
    
    if([_textView isFirstResponder]){
        [_textView resignFirstResponder];
    }
    
    if([_textView.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入问题"];
        return ;
    }
    if (firstCommit) {
        
        if([_textView.text rangeOfString:@"报告"].location !=NSNotFound){
            [ProgressUtil showInfo:@"是否忘记提交报告"];
            firstCommit = NO;
            return ;
        }
        
    }
    if([AVRecorderPlayerManager sharedManager].player.playing){
        [[AVRecorderPlayerManager sharedManager] pause];
    }
    
    if ((self.expertEntity.price==0)|self.isDoctor) {
        _payIndex = 1008;
        
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:self.isDoctor?@"确定向自己免费咨询":@"确定提交免费咨询" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        sheet.tag =1008;
        [sheet showInView:self.view];
        
#pragma 打点统计*专家解答-->写好了
        
        [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewWrite Action:DotEventEnter  Remark:nil];
        
        
        
    } else{
        if ([_presenter.Couponcount integerValue]>0) {
            IsClinic  = YES;
            
            UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"确定提交免费咨询" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
            sheet.tag =1100;
            [sheet showInView:self.view];
#pragma 打点统计*专家解答-->写好了
            
            [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewWrite Action:DotEventEnter  Remark:nil];
            
            
            NSLog(@"优惠券次数大于0  %ld",[_presenter.Couponcount integerValue]);
        }else{
            //
            if([[kDefaultsUser valueForkey:paySuccessKeyPath] boolValue]){
                //处理支付成功，但是订单支付接口失败
                NSString *orderID = [kDefaultsUser valueForkey:@"orderID"];
                [ProgressUtil show];
                [self.presenter tradePaySuccessWithOrderID:orderID];
            }else if([[kDefaultsUser valueForkey:addConsultationPath] boolValue]){
                //处理支付成功，但是添加咨询失败
                if([_textView.text trimming].length == 0){
                    [ProgressUtil showInfo:@"请输入文字"];
                    return ;
                }
                [ProgressUtil show];
                [self afterPhotoUpload];
                
                //        [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
                
            }else if([[kDefaultsUser valueForkey:laodConsultationPath] boolValue]){
                //处理支付成功，但是加载咨询接口失败
                [ProgressUtil show];
                [self.presenter loadExpertConsultaionData:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID status:-1];
            }else{
                //选择支付方式
                //判断优惠券次数有没有
                NSLog(@"ss优惠券1:%d",isCoupon);
                
                if ([_presenter.Couponcount  integerValue] >0 && isCoupon == YES) {
                    
                    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信",@"优惠券",nil];
                    sheet.tag = 1000;
                    [sheet showInView:self.view];
#pragma 打点统计*专家解答-->写好了
                    
                    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewWrite Action:DotEventEnter  Remark:nil];
                    
                }else {
                    if([_presenter.Couponcount  integerValue] >0&&_presenter.CouPonSource.count==0){
                        
                        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信",@"优惠码",nil];
                        sheet.tag = 1000;
                        [sheet showInView:self.view];
#pragma 打点统计*专家解答-->写好了
                        
                        [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewWrite Action:DotEventEnter  Remark:nil];
                        
                        
                        
                        
                    }else {
                        
                        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                        sheet.tag = 1000;
                        [sheet showInView:self.view];
#pragma 打点统计*专家解答-->写好了
                        
                        [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewWrite Action:DotEventEnter  Remark:nil];
                        
                    }}
            }
        }
        
    }
}
- (void)handleTapGestureRadar:(UITapGestureRecognizer *)sender {
    
    CGAffineTransform fromTransform = CGAffineTransformScale(_downImageView.transform, 0.2, 0.2);
    _downImageView.alpha = 0.2;
    [_downImageView setTransform:fromTransform];
    
    
    [UIView animateWithDuration:0.5// 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:5.0 // 初始速度
     
                        options:UIViewAnimationOptionTransitionCurlDown // 动画过渡效果
                     animations:^{
                         
                         // code...
                         [_downImageView setTransform:fromTransform];
                         _downImageView.alpha = 0.5;
                         _downImageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                     } completion:^(BOOL finished) {
                         
                         // 动画完成后执行
                         
                         // code...
                         _downImageView.alpha = 1;
                         _downImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         if (_down == YES) {
                             
                             [_downImageView setImage:[UIImage  imageNamed:@"Baby_selec"]];
                             CGFloat  top = 79/2;
                             CGFloat  k_width = 558/2;
                             CGFloat  k_height = 234/2;
                             CGFloat  kk_width = 546/2;
                             CGFloat  kk_height = 150/2;
                             if (kScreenWidth == 320) {
                                 k_width = 558/2.5;
                                 k_height = 234/2.5;
                                 kk_width = 546/2.5;
                                 kk_height = 150/2.5;
                                 top = 79/2.5;
                             }
                             if (kScreenWidth == 414) {
                                 kk_width = 546/2-5;
                             }
                             if (kScreenWidth == 375) {
                                 kk_width = 546/2-3;
                                 
                             }
                             
                             
                             
                             [UIView animateWithDuration:0.5 animations:^{
                                 self.BulletinBtn.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,kScreenWidth-k_width-16).heightIs(k_height).widthIs(k_width);
                                 if (kScreenWidth == 375) {
                                     self.downLb.sd_layout.topSpaceToView(headerView,top).leftSpaceToView(headerView,kScreenWidth-k_width-12).heightIs(kk_height).widthIs(kk_width);
                                 }else{
                                     
                                     self.downLb.sd_layout.topSpaceToView(headerView,top).leftSpaceToView(headerView,kScreenWidth-k_width-14).heightIs(kk_height).widthIs(kk_width);
                                 }
                                 
                                 
                                 self.iconbgImageView.sd_layout.topSpaceToView(_BulletinBtn,15).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
                                 self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
                                 
                                 [self.iconbgImageView  updateLayout];
                                 [headerView  updateLayout];
                                 
                                 
                             }];
                             
                             _down = NO;
                             
                         }else{
                             [_downImageView setImage:[UIImage  imageNamed:@"Baby_Normal"]];
                             
                             [UIView animateWithDuration:0.5 animations:^{
                                 self.BulletinBtn.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).heightIs(0).widthIs(0);
                                 self.downLb.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).heightIs(0).widthIs(0);
                                 
                                 self.iconbgImageView.sd_layout.topSpaceToView(headerView,30).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
                                 self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
                                 [self.iconbgImageView  updateLayout];
                                 [headerView  updateLayout];
                                 
                                 
                             }];
                             _down = YES;
                         }
//                         _table.tableHeaderView = headerView;
                     }];
    
    
}
-(void)BulletinClick{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.BulletinBtn.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).heightIs(0).widthIs(0);
        self.downLb.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).heightIs(0).widthIs(0);
        
        self.iconbgImageView.sd_layout.topSpaceToView(headerView,30).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
        self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
        
        
        [self.iconbgImageView  updateLayout];
        [headerView  updateLayout];
//        _table.tableHeaderView = headerView;
        
    }];
    
    CGAffineTransform fromTransform = CGAffineTransformScale(_downImageView.transform, 0.2, 0.2);
    _downImageView.alpha = 0.2;
    [_downImageView setTransform:fromTransform];
    
    
    [UIView animateWithDuration:0.5 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:30.0 // 初始速度
     
                        options:UIViewAnimationOptionTransitionCurlDown // 动画过渡效果
                     animations:^{
                         
                         // code...
                         [_downImageView setTransform:fromTransform];
                         _downImageView.alpha = 0.5;
                         _downImageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                     } completion:^(BOOL finished) {
                         
                         // 动画完成后执行
                         
                         // code...
                         _downImageView.alpha = 1;
                         _downImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         
                         [_downImageView setImage:[UIImage  imageNamed:@"Baby_Normal"]];
                         _down = YES;
                         
                     }];
    
    
    
    
    
}
#pragma mark * 删除照片
- (void)deleteAction:(UIButton*) bt{
    UIImageView* imageView = (UIImageView*)bt.superview;
    
    if(imageView.tag == 3001){
        //左边图片
        WSLog(@"---left");
        if(self.uploadImageArr.count == 1){
            [self.uploadImageArr removeLastObject];
            [self.photoArray removeLastObject];
            _addImageBtn.hidden = YES;
            _uploadImageView.hidden =NO;
            _HaveImageView.hidden =YES;
            
            imageView.image = nil;
            
        }else if(self.uploadImageArr.count == 2){
            [self.uploadImageArr removeObjectAtIndex:0];
            [self.photoArray removeObjectAtIndex:0];
            _addImageBtn.hidden = NO;
            
            imageView.image = nil;
            imageView.image = [self.uploadImageArr lastObject];
            
            
            for (int i = (int )_uploadImageArr.count; i<3; i++) {
                if (_upImageViewArr[i]) {
                    UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                    photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
                    photoImagees.hidden = YES;
                }
                
            }
            
            
            
        }else if(self.uploadImageArr.count == 3){
            [self.uploadImageArr removeObjectAtIndex:0];
            [self.photoArray removeObjectAtIndex:0];
            _addImageBtn.hidden = NO;
            
            imageView.image = nil;
            imageView.image = [self.uploadImageArr objectAtIndex:0];
            
            UIImageView* middleImageView = [self.upImageViewArr objectAtIndex:1];
            middleImageView.image = [self.uploadImageArr lastObject];
            
            
            for (int i = (int )_uploadImageArr.count; i<3; i++) {
                if (_upImageViewArr[i]) {
                    UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                    photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
                    photoImagees.hidden = YES;
                }
                
            }
            
        }
        
    }else if(imageView.tag == 3002){
        //中间图片
        WSLog(@"---middle");
        if(self.uploadImageArr.count == 2){
            [self.uploadImageArr removeLastObject];
            [self.photoArray removeLastObject];
            
            
            _addImageBtn.hidden = NO;
            
            imageView.image = nil;
            
            for (int i = (int )_uploadImageArr.count; i<3; i++) {
                if (_upImageViewArr[i]) {
                    UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                    photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
                    photoImagees.hidden = YES;
                }
                
            }
        }else if(self.uploadImageArr.count == 3){
            _addImageBtn.hidden = NO;
            
            [self.uploadImageArr removeObjectAtIndex:1];
            [self.photoArray removeObjectAtIndex:1];
            
            
            imageView.image = nil;
            imageView.image = [self.uploadImageArr lastObject];
            
            UIImageView* lastImageView = [self.upImageViewArr lastObject];
            lastImageView.image = nil;
            lastImageView.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
            lastImageView.hidden = YES;
            
        }
        
    }else if(imageView.tag == 3003){
        //右边图片
        WSLog(@"---right");
        
        [self.uploadImageArr removeLastObject];
        [self.photoArray removeLastObject];
        
        
        _addImageBtn.hidden = NO;
        
        imageView.image = nil;
        imageView.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
        imageView.hidden = YES;
        
    }
    
    [self.view updateLayout];
    
}



#pragma mark - 手势监听
- (void)tapGestureAction:(UITapGestureRecognizer*) tap{
    UIImageView* imageView = (UIImageView*)tap.view;
    NSInteger index = imageView.tag - 3001;
    NSLog(@"----%ld",index);
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [SFPhotoBrowser showImageInView:window selectImageIndex:index delegate:self];
    
}

- (void)dpTapAction{
    ExpertDPViewController *vc =[ExpertDPViewController new];
    vc.expertEntity =_expertEntity;
    [self.navigationController pushViewController:vc animated:YES];
#pragma 打点统计*专家解答->医生评价
    [BasePresenter  EventStatisticalDotTitle:DotHEAninfoViewAppraise Action:DotEventEnter  Remark:nil];
    
}

#pragma mark - 懒加载
-(UIImageView*)downImageView{
    if (!_downImageView) {
        _downImageView = [UIImageView new];
        [_downImageView  setImage:[UIImage  imageNamed:@"Baby_selec"]];
        _down = NO;
        UITapGestureRecognizer *tapRecognizerRadar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRadar:)];
        
        [_downImageView addGestureRecognizer:tapRecognizerRadar];
        _downImageView.userInteractionEnabled = YES;
        
    }
    
    return _downImageView;
}

-(UILabel*)downLb{
    if (!_downLb) {
        downlbFont = 16;
        if (kScreenWidth == 320) {
            downlbFont = 13;
        }
        if (kScreenWidth == 375) {
            downlbFont = 15;
        }
        
        _downLb = [UILabel new];
        _downLb.text = self.expertEntity.Notice;
        _downLb.backgroundColor = [UIColor clearColor];
        _downLb.textColor = UIColorFromRGB(0xffffff);
        _downLb.font = [UIFont  systemFontOfSize:downlbFont];
        _downLb.textAlignment = NSTextAlignmentCenter;
        _downLb.numberOfLines = 0;
    }
    
    
    
    return  _downLb;
}

-(UIButton*)BulletinBtn{
    if(!_BulletinBtn){
        _BulletinBtn = [UIButton new];
        [_BulletinBtn  setImage:[UIImage  imageNamed:@"BulletinBoard"] forState:UIControlStateNormal];
        
        [_BulletinBtn  addTarget:self action:@selector(BulletinClick) forControlEvents:UIControlEventTouchUpInside];
        _BulletinBtn.userInteractionEnabled = YES;
        
    }
    return _BulletinBtn;
}

-(UIImageView *)iconbgImageView{
    if(!_iconbgImageView){
        _iconbgImageView = [UIImageView new];
        _iconbgImageView.userInteractionEnabled = YES;
        _iconbgImageView.backgroundColor = UIColorFromRGB(0xffffff);
        _iconbgImageView.layer.masksToBounds = YES;
        _iconbgImageView.layer.borderWidth = 1;
        _iconbgImageView.layer.borderColor = UIColorFromRGB(0x37e0ce).CGColor;
    }
    return _iconbgImageView;
}

-(UIImageView *)doctorIcon{
    if(!_doctorIcon){
        _doctorIcon = [UIImageView new];
        _doctorIcon.userInteractionEnabled = YES;
    }
    return _doctorIcon;
}
-(UILabel *)doctorName{
    if(!_doctorName){
        _doctorName = [UILabel new];
        _doctorName.textAlignment = NSTextAlignmentCenter;
        _doctorName.textColor = UIColorFromRGB(0x333333);
        _doctorName.font = [UIFont systemFontOfSize:bigFont];
    }
    return _doctorName;
}
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0x999999);
    }
    return _lineView;
}
-(UILabel *)doctorTitle{
    if(!_doctorTitle){
        _doctorTitle = [UILabel new];
        _doctorTitle.textColor = UIColorFromRGB(0x999999);
        _doctorTitle.font = [UIFont systemFontOfSize:midFont];
    }
    return _doctorTitle;
}
-(UILabel *)doctorIntroduce{
    if(!_doctorIntroduce){
        _doctorIntroduce = [UILabel new];
        _doctorIntroduce.numberOfLines = 0;
        //        _doctorIntroduce.textAlignment = NSTextAlignmentCenter;
        _doctorIntroduce.textColor = self.doctorName.textColor;
        _doctorIntroduce.font = [UIFont systemFontOfSize:sbigFont];
    }
    return _doctorIntroduce;
}

-(UILabel *)doctorField{
    if(!_doctorField){
        _doctorField = [UILabel new];
        _doctorField.numberOfLines = 0;
        _doctorField.textColor = self.doctorTitle.textColor;
        _doctorField.font = self.doctorIntroduce.font;
    }
    return _doctorField;
}
-(UILabel *)CoupondField{
    if(!_CoupondField){
        _CoupondField = [UILabel new];
        _CoupondField.numberOfLines = 1;
        _CoupondField.font = self.doctorIntroduce.font;
    }
    return _CoupondField;
}

-(UILabel *)questionTimes{
    if(!_questionTimes){
        _questionTimes = [UILabel new];
        _questionTimes.textAlignment = NSTextAlignmentRight;
        _questionTimes.textColor = self.doctorTitle.textColor;
        _questionTimes.font = [UIFont systemFontOfSize:smallFont];
    }
    return _questionTimes;
}

-(LCTextView *)textView{
    if(!_textView){
        
        _textView = [LCTextView new];
        _textView.placeholder = [NSString stringWithFormat:@"向%@医生提问，等Ta语音回答或输入文字回答；超过48小时未回答，将按支付路径全额退款",self.expertEntity.doctorName];
        NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
        NSString *textContent =[userDefaults objectForKey:_uncompletedConStr];
        if (textContent!=nil&&(![textContent isEqualToString:@""])) {
            
            _textView.text =textContent;
            _textView.placeholderLabel.hidden =YES;
            
        }
        _textView.backgroundColor = UIColorFromRGB(0xfbffff);
        _textView.placeholderColor = UIColorFromRGB(0x999999);
        _textView.font = [UIFont systemFontOfSize:midFont];
        _textView.placeholderFont = [UIFont systemFontOfSize:smallFont];
        //        _textView.showTextLength = YES;
        _textView.XTLength = 1000000;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = UIColorFromRGB(0x5bc4be).CGColor;
    }
    
    
    return _textView;
}

-(UILabel *)moneyTips{
    if(!_moneyTips){
        _moneyTips = [UILabel new];
        _moneyTips.textColor = self.doctorTitle.textColor;
        _moneyTips.font = [UIFont systemFontOfSize:smallFont];
        
        NSString* tips = @"*公开提问，答案每被旁听1次，你从中分成¥0.5";
        
        NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:tips];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:midFont] range:NSMakeRange(0, 1)];
        
        [attributeStr addAttribute:NSForegroundColorAttributeName value:self.doctorTitle.textColor range:NSMakeRange(1, tips.length-1)];
        
        
        
        _moneyTips.attributedText = attributeStr;
    }
    return _moneyTips;
}

-(UILabel *)pricenLabel{
    if(!_pricenLabel){
        _pricenLabel = [UILabel new];
        _pricenLabel.textAlignment = NSTextAlignmentCenter;
        _pricenLabel.textColor = UIColorFromRGB(0xd50000);
        _pricenLabel.font = self.doctorName.font;
    }
    return _pricenLabel;
}

-(UIButton *)commitbt{
    if(!_commitbt){
        _commitbt = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitbt.backgroundColor = RGB(80,199, 192);
        [_commitbt setTitle:@"写好了" forState:UIControlStateNormal];
        _commitbt.layer.masksToBounds = YES;
        _commitbt.layer.cornerRadius = 5;
        [_commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitbt;
}
-(UIView *)headerTitlebgView{
    if(!_headerTitlebgView){
        _headerTitlebgView = [UIView new];
        _headerTitlebgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _headerTitlebgView ;
}

-(UILabel *)titleTips{
    if(!_titleTips){
        _titleTips = [UILabel new];
        _titleTips.textColor = UIColorFromRGB(0x666666);
        _titleTips.font = self.doctorName.font;
        
    }
    return _titleTips;
}

-(NSMutableDictionary *)stateDic{
    if(!_stateDic){
        _stateDic = [NSMutableDictionary dictionary];
    }
    return _stateDic;
}

- (NSMutableArray *)uploadImageArr{
    if (_uploadImageArr ==nil) {
        _uploadImageArr =[NSMutableArray array];
    }
    return _uploadImageArr;
}

- (NSMutableArray *)upImageViewArr{
    if (_upImageViewArr ==nil) {
        _upImageViewArr =[NSMutableArray array];
    }
    return _upImageViewArr;
}

#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark---umeng页面统计

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"专家解答-提问页"];
    if (self.expertEntity.Notice.length == 0) {
        _downImageView.hidden = YES;
        _downLb.hidden = YES;
        _BulletinBtn.hidden = YES;
        self.iconbgImageView.sd_layout.topSpaceToView(headerView,30).centerXEqualToView(headerView).widthIs(65).heightEqualToWidth();
        self.iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
        [_iconbgImageView  updateLayout];
        [headerView  updateLayout];
        
    }else{
        _downImageView.hidden = NO;
        _downImageView.hidden = NO;
        _downLb.hidden = NO;
        _BulletinBtn.hidden = NO;
    }
    
//    _table.tableHeaderView = headerView;
    
    firstCommit = YES;
    [_presenter getExpertCommentListByExpertID:_expertEntity.doctorID];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"专家解答-提问页"];
    if([AVRecorderPlayerManager sharedManager].player.playing){
        [[AVRecorderPlayerManager sharedManager] pause];
    }
}

- (void)backItemAction:(id)sender{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    
    [super backItemAction:sender];
}

- (void)showSheet {
    WS(ws);
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *uploadPhotos = [UIAlertAction actionWithTitle:@"上传照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"上传照片");
            [ws pickPhoto];
        }];
        
        UIAlertAction *uploadPhotosByCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照上传");
            [ws takePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:uploadPhotos];
        [alert addAction:uploadPhotosByCamera];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        sheet.tag =1009;
        [sheet showInView:self.view];
        
    }
    
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)pickPhoto{
    WS(ws);
    
    //    _uploadImageArr =nil;
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    NSInteger count = 0;
    
    //    if (_upImageViewArr) {
    //        for (UIImageView *imageView in _upImageViewArr) {
    //            if (imageView.image) {
    //                count ++;
    //            }
    //        }
    //    }else{
    //        count = 0;
    //    }
    
    //    if (count == 3) {
    //        [ProgressUtil showInfo:@"最多选择三张图片"];
    //        return;
    //    }
    //    manager.maxSelectedPhotoNumber = 3 - count;
    
    WSLog(@"imageCount = %ld",_uploadImageArr.count);
    
    if(_uploadImageArr && _uploadImageArr.count != 0){
        if(_uploadImageArr.count == 1){
            count = 2;
        }else if(_uploadImageArr.count == 2){
            count = 1;
        }else if(_uploadImageArr.count == 3){
            count = 0;
        }
    }else{
        count = 3;
    }
    manager.maxSelectedPhotoNumber = count;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        //        runOnBackground(^{
        //            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
        //                //                NSString * path = [photo.editedImage saveToLocal];
        //                //                [ws.urls addObject:path];
        //
        //            }];
        runOnMainThread(^{
            //                [ws resetImageView];
            
            [ProgressUtil dismiss];
            
            NSLog(@"%d", medias.count);
            
            for (CorePhoto *photo in medias) {
                
                NSLog(@"%@", photo);
                if (![self.uploadImageArr containsObject:photo.editedImage]) {
                    [self.uploadImageArr addObject:photo.editedImage];
                }
            }
            NSLog(@"%d", _uploadImageArr.count);
            if (_uploadImageArr.count!=0) {
                _uploadImageView.hidden =YES;
                _HaveImageView.hidden =NO;
                
                [ws.presenter uploadPhoto:_uploadImageArr];
                
                if (_uploadImageArr.count!=3) {
                    _addImageBtn.hidden = NO;
                    
                    
                    for (int i = (int )_uploadImageArr.count; i<3; i++) {
                        if (_upImageViewArr[i]) {
                            UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                            photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
                            photoImagees.hidden = YES;
                        }
                        
                        
                    }
                    for (int i =1; i <_uploadImageArr.count+1; i++) {
                        if (_upImageViewArr[i-1]) {
                            UIImageView *photoImageetsss =(UIImageView *)(_upImageViewArr[i-1]);
                            photoImageetsss.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                        }
                    }
                }else {
                    _addImageBtn.hidden = YES;
                    for (int i =1; i<=_uploadImageArr.count; i++) {
                        if (_upImageViewArr[i-1]) {
                            UIImageView *photoImagee =(UIImageView *)(_upImageViewArr[i-1]);
                            photoImagee.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                        }
                        
                    }
                    
                }
                
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新
                for (int i =0; i<_uploadImageArr.count; i++) {
                    if (_upImageViewArr[i]) {
                        UIImageView *photoImagess =(UIImageView *)(_upImageViewArr[i]);
                        photoImagess.image =_uploadImageArr[i];
                        photoImagess.hidden = NO;
                        
                    }
                    
                }
                
                [ws.view updateLayout];
                
                
            });
            
            
        });
        //        });
        
    };
    
    [ws presentViewController:pickerVC animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WS(ws);
    if (_uploadImageArr.count ==3) {
        _uploadImageArr =nil;
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.uploadImageArr addObject:image];
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        _uploadImageView.hidden =YES;
        _HaveImageView.hidden =NO;
        
        
        if (_uploadImageArr.count!=3) {
            _addImageBtn.hidden = NO;
            for (int i =(int )_uploadImageArr.count; i<3; i++) {
                if (_upImageViewArr[i]) {
                    UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                    photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,((_uploadImageArr.count)*70)).widthIs(0).heightIs(0);
                    photoImagees.hidden = YES;
                }
                
            }
            for (int i =1; i <_uploadImageArr.count+1; i++) {
                if (_upImageViewArr[i-1]) {
                    UIImageView *photoImageesss =(UIImageView *)(_upImageViewArr[i-1]);
                    photoImageesss.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                }
            }
        }else {
            _addImageBtn.hidden = YES;
            for (int i =1; i<=_uploadImageArr.count; i++) {
                if (_upImageViewArr[i-1]) {
                    UIImageView *photoImagee =(UIImageView *)(_upImageViewArr[i-1]);
                    photoImagee.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                }
                
            }
            
        }
        
        [ws.presenter uploadPhoto:_uploadImageArr];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新
        for (int i =0; i<_uploadImageArr.count; i++) {
            if (_upImageViewArr[i]) {
                UIImageView *photoImageess =(UIImageView *)(_upImageViewArr[i]);
                photoImageess.image =(UIImage *)_uploadImageArr[i];
                photoImageess.hidden = NO;
            }
            
        }
        
        [ws.view updateLayout];
        
        
    });
    NSLog(@"%ld ==",_uploadImageArr.count);
    
    
    //    [self uploadData];
}
// 选取图片结束和拍照结束的时候调用上传图片
- (void)uploadPhotoDataOnCompletion:(BOOL) success info:(NSString*) message urlPhotoPathArr:(NSMutableArray *)photoPathArr{
    NSLog(@"&&&&&&&&&&&&%@",photoPathArr);
    _photoArray = photoPathArr;
    [ProgressUtil showSuccess:@"图片上传成功"];
}
//其他调用上传图片代理内方法转移到这里，原调用位置不变
- (void)afterPhotoUpload{
    NSLog(@"8888888coupon%@",self.coupon);
    [self.presenter addExpertConsultation:_textView.text doctorID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID photo:_photoArray isOpen:_privateImageBtn.selected  couponid:self.coupon Freeclinic:@(0)];
}

-(void)GetCouponID:(NSNumber *)couPID{
    self.coupon = couPID;
    self.wxCouponPay =nil;
    
    //    [NSNumber numberWithInteger:5]
    [_presenter  GetConsultationConsumptionCouponPriceWithCouponID:self.coupon Expert_ID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
}

-(void)wxPayByUseCouponID:(NSNumber *)couponId {
    self.coupon = couponId;
    self.wxCouponPay =@"wxCouponPay";
    
    [_presenter  GetConsultationConsumptionCouponPriceWithCouponID:self.coupon Expert_ID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
    
    
}

-(void)payFreeByCouponID:(NSNumber*)couPID{
    self.coupon = couPID;
    self.wxCouponPay =nil;
    [ProgressUtil show];
    if (self.coupon !=nil) {
        //消费优惠券
        [self.presenter  GetConsumptionCouponWithcouponID:self.coupon expert_ID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID ConsultationID:[NSNumber  numberWithInteger:0]];
    }
    [self.presenter GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
    [self afterPhotoUpload];
    [_presenter getCouPonList];
    
}

-(void)GetConsultationCouponPriceCompletion:(BOOL)success info:(NSString*)message{
    if ([self.wxCouponPay isEqualToString:@"wxCouponPay"]) {
        if (success) {
            NSLog(@"8888888888888888");
            if (_presenter.Status == 0) {
                if(_presenter.price == 0){
                    [ProgressUtil  showInfo:@"咨询成功"];
                    if (self.coupon !=nil) {
                        //消费优惠券
                        [self.presenter  GetConsumptionCouponWithcouponID:self.coupon expert_ID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID ConsultationID:[NSNumber  numberWithInteger:0]];
                    }
                    [self.presenter   GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
                    [self afterPhotoUpload];
                    
                }else if(_presenter.price >0){
                    //                    [ProgressUtil  showInfo:message];
                    
                    [self.presenter weixinPayOpenImage:_privateImageBtn.selected PhotoArr:_photoArray Question:_textView.text DoctorId:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID CouponID:self.coupon];
                }
                
            }
        }
        else{
            NSLog(@"999999999999");
            
            [ProgressUtil  showError:message];
        }
    }else {
        if (success) {
            NSLog(@"8888888888888888");
            if (_presenter.Status == 0) {
                if(_presenter.price == 0){
                    [ProgressUtil  showInfo:@"咨询成功"];
                    if (self.coupon !=nil) {
                        //消费优惠券
                        [self.presenter  GetConsumptionCouponWithcouponID:self.coupon expert_ID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID ConsultationID:[NSNumber  numberWithInteger:0]];
                    }
                    [self.presenter   GetExpertCanConsumeCountWithExpertID:[_hospitalType isEqualToString:@"MyBindHospital"]?self.expertEntity.HOSPITAL_ID:self.expertEntity.doctorID];
                    [self afterPhotoUpload];
                }else if(_presenter.price >0){
                    //                [ProgressUtil  showInfo:message];
                    
                    [self.presenter getTradeID: @"questionBiz" withPrice:_presenter.price
                                   withPayType:@"alipay" withCouponID:self.coupon];
                }
                
            }
        }
        else{
            NSLog(@"999999999999");
            
            [ProgressUtil  showError:message];
        }
    }
}
-(void)GetConsumptionCouponCompletion:(BOOL)success info:(NSString*)message{
    if(success){
        [ProgressUtil dismiss];
        //        [ProgressUtil  showInfo:message];
        
    }else{
        
        [ProgressUtil  showError: message];
        
    }
}


- (void)openUploadPrivate:(UIButton *)btn{
    btn.selected =!btn.selected;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_HEAInfoViewController object:nil];
}
@end
