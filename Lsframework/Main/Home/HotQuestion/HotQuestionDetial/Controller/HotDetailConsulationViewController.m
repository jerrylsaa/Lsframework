//
//  HotDetailConsulationViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDetailConsulationViewController.h"

#import "JMFoundation.h"
#import "HotDetailPresenter.h"
#import "SFPhotoBrowser.h"
#import "HEAInfoViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "PayManager.h"
#import "AVRecorderPlayerManager.h"


#import <UITableView+SDAutoTableViewCellHeight.h>
#import "ConsultationCommenList.h"

#import "HHotConsulationTableViewCell.h"
#import "JMFoundation.h"
#import "HotDetailConsulationInfoViewController.h"
#import "PublicPostTextView.h"
#import "UIImage+Category.h"
#import "HotDefaultCollectionViewCell.h"
#import "HotPhotoCollectionViewCell.h"
#import "CorePhotoPickerVCManager.h"
#import "EmotionTextAttachment.h"
#import "ConsulationReplyList.h"

#import "ChatViewController.h"

#import "WXApi.h"
#import "AppDelegate.h"
#import "MoreAskCell.h"
#import "HEAParentQuestionEntity.h"
#import "HeaderViewController.h"
#import "HelfPriceViewController.h"
#import "LCTextView.h"

#import "SFPhotoBrowser.h"
#import "LCChatToolBarView.h"

#define AC_FONT [UIFont systemFontOfSize:14]
#define AC_FONT_SMALL [UIFont systemFontOfSize:12]
#define kToolBarHeight 48
#define kKeyboardHeight (264 - 40)


#define kScrollViewHeight (270/2.0)

#define kRow 3
#define kColumn 6




#define leftXspace   10
#define leftYspace   10

#define QuestionImageXspace   20
#define QuestionImageYspace    5

#define QuestionImageWidtn   kScreenWidth -leftXspace*2

#define QuestionImageSingleWidtn  (kScreenWidth -leftXspace*2 - QuestionImageXspace*2)/3

#define QuestionImageHeight1   QuestionImageSingleWidtn+leftYspace*2

#define QuestionImageHeight2   leftYspace + QuestionImageSingleWidtn + QuestionImageYspace + QuestionImageSingleWidtn +leftYspace


#define QuestionImageYspace2  leftYspace+QuestionImageSingleWidtn+QuestionImageYspace

#define   kImageXspace     15
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-2*kImageXspace)/3


@interface HotDetailConsulationViewController ()<PhotoBrowerDelegate,PayDelegate,HotDetailPresenterDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,HotPhotoCollectionViewCelldelegate,UITextViewDelegate,HHotConsulationTableViewCellDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,LCChatToolBarViewDelegate>{
    UIView *bgView ;
    
    NSInteger  AnswerIndex;
    BOOL convertToSystemKeyboard;
//    UIView  *ReplyView;
    BOOL   isCamera;
    BOOL   isCircle;
    CGFloat _infoHeight;
    CGFloat _totalHeight;
    CGFloat   _WordContentMessageHeight;
    LCChatToolBarView* ReplyView;//聊天工具条
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
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *listenLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UIButton *praiseButton;
//文字补充回答
@property (nonatomic, strong) UIView *WordBackView;
@property (nonatomic, strong) UIButton *WordContentBtn;
@property (nonatomic, strong) UIView *WordContentView;
@property (nonatomic, strong) UILabel  *WordContentMessage;

@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *QuestionImageView1;
@property (nonatomic, strong) UIImageView *QuestionImageView2;
@property (nonatomic, strong) UIImageView *QuestionImageView3;
@property (nonatomic, strong) UIImageView *QuestionImageView4;
@property (nonatomic, strong) UIImageView *QuestionImageView5;
@property (nonatomic, strong) UIImageView *QuestionImageView6;

@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@property (nonatomic, strong)UIView  *ClinicalBack;
@property (nonatomic, strong) UIView *ClinicalBackView; //疗效回访
@property (nonatomic, strong) UILabel  *ClinicalBackTitle; //疗效回访标题
@property (nonatomic, strong) UILabel  *ClinicalBackTime; //疗效回访时间
@property (nonatomic, strong) UILabel  *ClinicalBackMessage; //疗效内容

@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UILabel  *CommentTitle;
@property (nonatomic, strong) UILabel  *CommentTitleCountLb;
//@property (nonatomic, strong) UILabel  *LineLb;
@property(nonatomic,strong)UITableView  *ConsulationTableView;
@property(nonatomic,strong)UIButton  *starButton;
@property (nonatomic, strong) HeaderViewController *askView;
@property (nonatomic, strong) UIButton *askButton;
//@property (nonatomic, strong)
@property (nonatomic, strong) HotDetailPresenter *presenter;


@property(nullable,nonatomic,retain)PublicPostTextView* textView ;
@property(nullable,nonatomic,retain) UIView* toolBar;
@property(nullable,nonatomic,retain) UIButton* addButton;//添加按钮
@property(nullable,nonatomic,retain) UIButton* faceButton;//表情按钮
@property(nullable,nonatomic,retain) UIButton* sendButton;//发送按钮
@property(nullable,nonatomic,retain) UIView* addInputView;
@property(nullable,nonatomic,retain) UIView* faceInputView;
@property(nullable,nonatomic,retain) UIButton* defaultImageBt;
@property(nullable,nonatomic,retain) UIButton* selecImageBt;
@property(nullable,nonatomic,retain) UIButton* circlebtn;
@property(nullable,nonatomic,retain) UILabel* circleTitle;
@property(nullable,nonatomic,retain) UIView* SelectcollectView;
@property(nullable,nonatomic,retain) UIScrollView* faceScrollView;
@property(nullable,nonatomic,retain) UIPageControl* pageControl;
@property(nullable,nonatomic,retain) NSMutableArray* defaultEmotionArray;//默认表情
@property(nullable,nonatomic,retain) UICollectionView* collect;
@property(nullable,nonatomic,retain) NSMutableArray* collectDataSource;
@property(nullable,nonatomic,retain) UILabel* photoNumLabel;
@property(nullable,nonatomic,retain) UIScrollView* scrollView;

@property (nonatomic, strong) UIView *expertPJView;
@property (nonatomic, strong) UIView *expertMidView;
@property (nonatomic, strong) UIImageView *starIV;

@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *addCommentBtn;
@property (nonatomic, strong) UIImageView *expertComIV;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) LCTextView *dpTextView;

//@property(nullable,nonatomic,retain) LCChatToolBarView* ReplyView;//聊天工具条

@end

@implementation HotDetailConsulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kdefaultCenter addObserver:self selector:@selector(halfAction) name:@"half" object:nil];
    
    ReplyView = [LCChatToolBarView new];
    ReplyView.backgroundColor = UIColorFromRGB(0xffffff);
    ReplyView.emotionRow = 3;//3行
    ReplyView.emotionColumn = 6;//6列
    ReplyView.delegate = self;
}

- (void)setupView{
    self.title = @"问题详情";
    [self initRightBarWithTitle:@"分享"];
    
    
    //
    
    _presenter = [HotDetailPresenter new];
    _presenter.delegate = self;
    [ProgressUtil  show];
    WS(ws);
    [_presenter GetExpertConsultationByUUID:[self.UUID  integerValue] finish:^(BOOL success, NSString *message) {
        [ws.presenter loadDoctorInfoBy:@(ws.presenter.question.Expert_ID)];
        
//    [ws.presenter  GetTherapeuticVisitByConsultationID:[ws.UUID integerValue]];
    }];
    //    监听键盘frame值改变
    //    [kdefaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshConsulationList) name:Notification_RefreshConsulationList object:nil];
    
    [kdefaultCenter addObserver:self selector:@selector(PayAskMoreComepleteRefreshHotHearder) name:Notification_RefreshDoctorQuestionDetail object:nil];
    
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    self.scrollView = scroll;
    [self.view addSubview:scroll];
   scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

-(void)setupHeadView{
    
    self.headerView = [UIView   new];
    self.headerView.backgroundColor =  [UIColor  whiteColor];
    
    [self setupHeadImageView];
    [self setupUserNameLabel];
    [self setupInfoView];
    [self setupDoctorImageView];
    [self setupVoiceButton];
    [self setupDurationLabel];
    
    
    [self setupDoctorNameLabel];
    [self setupPostLabel];
    [self   setupWordContentView];
    [self setupTimeLabel];
   [self  setupClinicalBackView];
    [self setupPriceLabel];
    [self setupListenLabel];
    [self setupPraiseLabel];
    [self setupPraiseButton];
    [self setupTableViewHeader];
    
}
- (void)setupTableViewHeader{
    WS(ws);
    [_presenter loadDataByConsultationID:[self.UUID  integerValue] finish:^(BOOL success, NSString *message) {
        [ProgressUtil dismiss];
        ws.askView = [HeaderViewController new];
        ws.askView.isMainFree  =  [NSNumber  numberWithInteger:self.presenter.question.IsFree];
        ws.askView.dataSource = ws.presenter.dataSource;
    ws.askView.isMainUUID = self.UUID;
    ws.askView.isMainExpertID = @(self.presenter.question.Expert_ID);
        [ws.askView getHeightForAllCell];
        [ws.headerView addSubview:ws.askView];
        if (self.presenter.TherapeuticVisitSource.VisitContent!=nil){
            NSLog(@"有疗效回访");
        ws.askView.sd_layout.leftSpaceToView(ws.headerView,0).rightSpaceToView(ws.headerView,0).topSpaceToView(ws.ClinicalBack,10).heightIs(ws.askView.totalHeight);
            
        }else{
            NSLog(@"无疗效回访");
            ws.askView.sd_layout.leftSpaceToView(ws.headerView,0).rightSpaceToView(ws.headerView,0).topSpaceToView(ws.timeLabel,10).heightIs(ws.askView.totalHeight);
  
        }

        [ws.askView setupView];
        //半价提问
        ws.askButton = [UIButton new];
        ws.askButton.userInteractionEnabled =NO;
        NSLog(@"半价追问名称1：%@",self.presenter.question.OutTime);
        NSLog(@"半价追问名称2：%@",self.presenter.NoAnswer);
        
        [ws.askButton setTitle:@"半价追问" forState:UIControlStateNormal];
        [ws.askButton setTitleColor:UIColorFromRGB(0x61d8d3) forState:UIControlStateNormal];
        [ws.askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [ws.askButton addTarget:self action:@selector(helfPriceAction) forControlEvents:UIControlEventTouchUpInside];
        ws.askButton.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
        ws.askButton.layer.borderWidth = 1.f;
        [ws.askButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [ws.askButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x61d8d3)] forState:UIControlStateHighlighted];
        
        if ([self.presenter.question.OutTime  isEqual:@(1)]||[self.presenter.NoAnswer isEqual:@(1)]) {
            ws.askButton.layer.borderColor = UIColorFromRGB(0xc9c9c9).CGColor;
            [ws.askButton setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateNormal];
        }

        [ws.headerView addSubview:ws.askButton];
        
        ws.addCommentBtn = [UIButton new];
        [ws.addCommentBtn setTitle:@"医生评价" forState:UIControlStateNormal];
        [ws.addCommentBtn setTitleColor:UIColorFromRGB(0xff8a80) forState:UIControlStateNormal];
        [ws.addCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [ws.addCommentBtn addTarget:self action:@selector(addExpertCommentAction) forControlEvents:UIControlEventTouchUpInside];
        ws.addCommentBtn.layer.borderColor = UIColorFromRGB(0xff8a80).CGColor;
        ws.addCommentBtn.layer.borderWidth = 1.f;
        [ws.addCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [ws.addCommentBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff8a80)] forState:UIControlStateHighlighted];
        [ws.headerView addSubview:ws.addCommentBtn];
        if (ws.presenter.question.User_ID == kCurrentUser.userId) {
            //有追问按钮
            
            ws.askButton.sd_layout.widthIs(kScreenWidth/2.0-20).heightIs(30).leftSpaceToView(ws.headerView,10).topSpaceToView(ws.askView,25);
            ws.askButton.sd_cornerRadius = @15;
            
            ws.addCommentBtn.sd_layout.widthIs(kScreenWidth/2.0-20).heightIs(30).leftSpaceToView(ws.headerView,kScreenWidth/2.0+10).topSpaceToView(ws.askView,25);
            ws.addCommentBtn.sd_cornerRadius = @15;
            //有追问按钮高度
            _totalHeight +=55;
        }else{
            //无追问按钮
            ws.askButton.sd_layout.widthIs(231).heightIs(0).centerXEqualToView(ws.headerView).topSpaceToView(ws.askView,0);
            ws.askButton.hidden = YES;
            
            ws.addCommentBtn.sd_layout.widthIs(231).heightIs(30).centerXEqualToView(ws.headerView).topSpaceToView(ws.askView,25);
        }
        
        ws.expertPJView =[UIView new];
        ws.expertPJView.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [ws.headerView addSubview:ws.expertPJView];
        
        UIImageView *topIV =[UIImageView new];
        topIV.image =[UIImage imageNamed:@"topfakeIV"];
        [ws.expertPJView addSubview:topIV];
        
        ws.expertMidView =[UIView new];
        ws.expertMidView.backgroundColor =[UIColor whiteColor];
        [ws.expertPJView addSubview:ws.expertMidView];
        
        UIImageView *docIV =[UIImageView new];
        [docIV  sd_setImageWithURL:[NSURL  URLWithString:_presenter.question.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
        docIV.layer.masksToBounds = YES;
        docIV.layer.cornerRadius = 25;
        [ws.expertMidView addSubview:docIV];
        
        UILabel *docNameLabel =[UILabel new];
        docNameLabel.text =_presenter.question.DoctorName;
        docNameLabel.font =[UIFont boldSystemFontOfSize:15.0f];
        docNameLabel.textColor =UIColorFromRGB(0x333333);
        [ws.expertMidView addSubview:docNameLabel];
        
        UIImageView *docIntroBGIV =[UIImageView new];
        docIntroBGIV.image =[UIImage imageNamed:@"docIntroBGIV"];
        [ws.expertMidView addSubview:docIntroBGIV];
        
        UILabel *docIntroLabel =[UILabel new];
        docIntroLabel.text =_presenter.question.DoctorTitle;
        docIntroLabel.font =[UIFont systemFontOfSize:10.0f];
        docIntroLabel.textColor =UIColorFromRGB(0x999999);
        [ws.expertMidView addSubview:docIntroLabel];
        
        _starIV =[UIImageView new];
        
        [ws.expertMidView addSubview:_starIV];
        
        
        
        UILabel *hosLabel =[UILabel new];
        hosLabel.font =[UIFont systemFontOfSize:12.0f];
        hosLabel.textColor =UIColorFromRGB(0x999999);
        hosLabel.text =[NSString stringWithFormat:@"医院：%@",_presenter.question.HospitalName];
        
        [ws.expertMidView addSubview:hosLabel];
        
        UILabel *depaLabel =[UILabel new];
        depaLabel.font =[UIFont systemFontOfSize:12.0f];
        depaLabel.textColor =UIColorFromRGB(0x999999);
        depaLabel.text =[NSString stringWithFormat:@"科室：%@",_presenter.question.DepartName];;
        [ws.expertMidView addSubview:depaLabel];
        
        UILabel *domainLabel =[UILabel new];
        domainLabel.numberOfLines =0;
        NSString* field = _presenter.question.Domain.length != 0?_presenter.question.Domain: @"";
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
        docNameLabel.sd_layout.leftSpaceToView(docIV,15).topSpaceToView(_expertMidView,22).heightIs(25).widthIs(kJMWidth(docNameLabel));
        docIntroBGIV.sd_layout.leftSpaceToView(docNameLabel,5).centerYEqualToView(docNameLabel).widthIs(kJMWidth(docIntroLabel)+6.2).heightIs(15);
        docIntroLabel.sd_layout.leftSpaceToView(docNameLabel,8.1f).centerYEqualToView(docIntroBGIV).heightIs(21).widthIs(kJMWidth(docIntroLabel));
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
        
        
        _expertPJView.sd_layout.topSpaceToView(ws.askButton,0).leftSpaceToView(ws.headerView,0).rightSpaceToView(ws.headerView,0);
        [_expertPJView setupAutoHeightWithBottomView:bottomfakeIV bottomMargin:0];
//        if (!ws.LineLb) {
//            ws.LineLb = [UILabel new];
//            ws.LineLb.backgroundColor = UIColorFromRGB(0xf2f2f2);
//            [ws.headerView  addSubview:ws.LineLb];
//        }
        
//        if (ws.presenter.question.User_ID != kCurrentUser.userId) {
//            ws.LineLb.sd_layout.leftSpaceToView(ws.headerView,0).rightSpaceToView(ws.headerView,0).topSpaceToView(ws.expertPJView,4).heightIs(5);
//        }else{
//            ws.LineLb.sd_layout.leftSpaceToView(ws.headerView,0).rightSpaceToView(ws.headerView,0).topSpaceToView(ws.expertPJView,4).heightIs(5);
//        }
//        _totalHeight +=9;  //加上线的高度
//        if (!ws.CommentTitle) {
            ws.CommentTitle = [UILabel  new];
            ws.CommentTitle.text = @"评论";
            ws.CommentTitle.font = [UIFont  systemFontOfSize:14];
            ws.CommentTitle.textColor = UIColorFromRGB(0x999999);
            ws.CommentTitle.textAlignment = NSTextAlignmentLeft;
            [ws.headerView  addSubview:ws.CommentTitle];
//        }
        ws.CommentTitle.sd_layout.leftSpaceToView(ws.headerView,20).rightSpaceToView(ws.headerView,20).topSpaceToView(ws.expertPJView,3).heightIs(15);
        
        _totalHeight +=18;  //加上线的高度
//        [ws.headerView setupAutoHeightWithBottomView:ws.CommentTitle bottomMargin:0];
//        if (ws.presenter.question.User_ID == kCurrentUser.userId) {
//      //带有半价追问按钮
//        ws.headerView.height =_totalHeight+ws.askView.totalHeight+15;
//        }else{
//       //无半价追问按钮
//    ws.headerView.height =_totalHeight+ws.askView.totalHeight+15;
//        }
        
        
        [ws.headerView setupAutoHeightWithBottomView:ws.CommentTitle bottomMargin:10];
        [self.headerView layoutSubviews];
        
        
        
        
        [ws setupTableView];
    }];
    NSLog(@"headerView高度：%f",self.headerView.height);
    [_presenter GetExpertHalfPriceByExpertID:ws.presenter.question.Expert_ID];
    [ProgressUtil showWithStatus:@"加载中···"];
    [_presenter GetExpertCommentListByConsultationID:@(ws.presenter.question.uuiD)];
}

-(void)setupTableView{
    
    _ConsulationTableView = [UITableView  new];
    _ConsulationTableView.delegate = self;
    _ConsulationTableView.dataSource = self;
    _ConsulationTableView.scrollEnabled = YES;
    _ConsulationTableView.userInteractionEnabled = YES;
    _ConsulationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ConsulationTableView.tableHeaderView =_headerView;
    [self.scrollView  addSubview:_ConsulationTableView];
    _ConsulationTableView.sd_layout.topSpaceToView(_scrollView,0).leftEqualToView(_scrollView).rightEqualToView(_scrollView).bottomSpaceToView(ReplyView,0);
    
    WS(ws);
//    ws.ConsulationTableView.tableHeaderView = ws.headerView;
    ws.ConsulationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.ConsulationTableView.userInteractionEnabled = NO;
//                ws.ConsulationTableView.tableHeaderView = ws.headerView;
        [ws.presenter GetConsultationCommentListByConsultationID:[ws.UUID integerValue]];
    }];
    
    ws.ConsulationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.ConsulationTableView.userInteractionEnabled = NO;
        //        ws.ConsulationTableView.tableHeaderView = _headerView;
        [ws.presenter getMoreConsultationCommentList];
    }];
    [ws.ConsulationTableView.mj_header beginRefreshing];
//    _ConsulationTableView.backgroundColor = [UIColor redColor];
    
}

-(void)setupReplyView{
    
    [self.scrollView addSubview:ReplyView];
    ReplyView.sd_layout.leftSpaceToView(self.scrollView,0).rightSpaceToView(self.scrollView,0).bottomSpaceToView(self.scrollView,0).heightIs(50);
    [self.scrollView  setupAutoHeightWithBottomView:ReplyView bottomMargin:0];

//    ReplyView = [UIView  new];
  
//    ReplyView.backgroundColor = [UIColor  clearColor];
//    [self.scrollView  addSubview:ReplyView];
//    
//    [ReplyView addSubview:self.toolBarView];
    
    
//    PublicPostTextView* textView = [PublicPostTextView new];
//    textView.delegate =  self;
//    textView.placeholder = @"我来说两句";
////    textView.textColor = UIColorFromRGB(0xfbffff);
//    textView.textColor = [UIColor  blackColor];
//    textView.font = [UIFont systemFontOfSize:bigFont];
//    textView.placeholderColor = UIColorFromRGB(0xcccccc);
//    textView.placeholderFont = [UIFont systemFontOfSize:bigFont];
//    textView.layer.borderWidth = 1;
//    textView.layer.masksToBounds = YES;
//    textView.layer.cornerRadius = 8;
//    textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
////    textView.inputAccessoryView = self.toolBar;
////    textView.autoAdjustHeight = YES;
//    [ReplyView addSubview:textView];
//    self.textView = textView;
//    
//   
//    UIButton* addbt = [UIButton new];
//    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateNormal];
//    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_heigh"] forState:UIControlStateHighlighted];
//    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
//    addbt.tag = 101;
//    [addbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
//    [ReplyView addSubview:addbt];
//    self.addButton = addbt;
//    
//    
//    UIButton  *circlebtn = [UIButton  new];
//    [circlebtn setBackgroundImage:[UIImage imageNamed:@"circle_dot"] forState:UIControlStateNormal];
//    self.circlebtn = circlebtn;
//    circlebtn.hidden = YES;
//    [ReplyView  addSubview:circlebtn];
//    
//    UILabel  *circleTitle = [UILabel  new];
//    circleTitle.textColor = [UIColor  whiteColor];
//    circleTitle.font = [UIFont systemFontOfSize:20/2];
//    circleTitle.textAlignment = NSTextAlignmentCenter;
//    self.circleTitle = circleTitle;
//    [self.circlebtn addSubview:circleTitle];
//    
//    
//    
//    UIButton* facebt = [UIButton new];
//    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
//    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
//
//    facebt.tag = 102;
//    [facebt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
//    [ReplyView addSubview:facebt];
//    self.faceButton = facebt;
//    
//    UIButton* sendbt = [UIButton new];
//    sendbt.userInteractionEnabled = NO;
//    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_NoSendImage"] forState:UIControlStateNormal];
//  [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_SendImage"] forState:UIControlStateSelected];
//    sendbt.tag = 103;
//    [sendbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
////    sendbt.userInteractionEnabled = NO;
//    [ReplyView addSubview:sendbt];
//    self.sendButton = sendbt;
    
    
    //添加约束
//    ReplyView.sd_layout.bottomSpaceToView(self.scrollView,0).leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).heightIs(50);
    
    
//    addbt.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(ReplyView,5).widthIs(55/2.0).heightEqualToWidth();
//    
//    circlebtn.sd_layout.topSpaceToView(ReplyView,8).leftSpaceToView(addbt,-8).widthIs(25/2).heightIs(25/2);
//    
//    circleTitle.sd_layout.centerXEqualToView(circlebtn).centerYEqualToView(circlebtn).widthIs(25/2).heightEqualToWidth();
//    
//    facebt.sd_layout.topEqualToView(addbt).leftSpaceToView(addbt,5).widthRatioToView(addbt,1).heightEqualToWidth();
//
//    sendbt.sd_layout.centerYEqualToView(ReplyView).rightSpaceToView(ReplyView,5).heightIs(76/2).widthIs(100/2);
    ReplyView.sd_layout.bottomSpaceToView(self.scrollView,0).leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).heightIs(50);
    

//  textView.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(facebt,5).rightSpaceToView(sendbt,5).heightIs(sendbt.frame.size.height);
//    [self.scrollView  setupAutoHeightWithBottomView:ReplyView bottomMargin:0];

//    [self setupPhotoNumLabel];
}

#pragma mark---  懒加载键盘视图
#pragma mark  *加载键盘照片视图
-(UIView *)addInputView{
    if(!_addInputView){
        _addInputView = [UIView new];
        _addInputView.height = kKeyboardHeight;
        _addInputView.backgroundColor = RGB(250, 250, 250);
        
        //照片
        UIButton* Photo = [UIButton new];
        [Photo setBackgroundImage:[UIImage imageNamed:@"HotConsulation_picture"] forState:UIControlStateNormal];
//        Photo.tag = 105;
        [Photo addTarget:self action:@selector(clickInputViewCameraAction) forControlEvents:UIControlEventTouchUpInside];
        [_addInputView addSubview:Photo];
        
        UILabel* PhotoTitle = [UILabel new];
        PhotoTitle.textAlignment = NSTextAlignmentCenter;
        PhotoTitle.text = @"照片";
        PhotoTitle.textColor = UIColorFromRGB(0x767676);
        PhotoTitle.font = [UIFont systemFontOfSize:midFont];
        [_addInputView addSubview:PhotoTitle];
        
        
        

        
//        //拍摄
//        UIButton* camera = [UIButton new];
//        [camera setBackgroundImage:[UIImage imageNamed:@"circle_camerra_icon"] forState:UIControlStateNormal];
//        camera.tag = 106;
//        [camera addTarget:self action:@selector(clickInputViewCameraAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_addInputView addSubview:camera];
//        
//        UILabel* cameraTitle = [UILabel new];
//        cameraTitle.textAlignment = NSTextAlignmentCenter;
//        cameraTitle.text = @"拍摄";
//        cameraTitle.textColor = UIColorFromRGB(0x767676);
//        cameraTitle.font = [UIFont systemFontOfSize:midFont];
//        [_addInputView addSubview:cameraTitle];
        
        Photo.sd_layout.topSpaceToView(_addInputView,20).leftSpaceToView(_addInputView,20).widthIs(60).heightEqualToWidth();
        PhotoTitle.sd_layout.topSpaceToView(Photo,10).leftEqualToView(Photo).rightEqualToView(Photo).heightIs(20);
        
//        camera.sd_layout.topEqualToView(Photo).leftSpaceToView(Photo,50/2).widthIs(60).heightEqualToWidth();
//        
//        cameraTitle.sd_layout.topEqualToView(PhotoTitle).leftEqualToView(camera).rightEqualToView(camera).heightIs(20);
        
        
    }
    return _addInputView;
}
#pragma mark  *加载键盘表情视图
-(UIView *)faceInputView{
    if(!_faceInputView){
        _faceInputView = [UIView new];
        _faceInputView.height = kKeyboardHeight;
        _faceInputView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIScrollView* faceScrollView = [UIScrollView new];
        faceScrollView.showsHorizontalScrollIndicator = NO;
        faceScrollView.pagingEnabled = YES;
        faceScrollView.delegate = self;
        faceScrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        self.faceScrollView = faceScrollView;
        [_faceInputView addSubview:faceScrollView];
        
        UIPageControl* pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = RGB(232, 208, 217);
        pageControl.currentPageIndicatorTintColor = RGB(248, 187, 208);
        self.pageControl = pageControl;
        [_faceInputView addSubview:pageControl];
        
        UIButton* deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_face_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteFaceAction) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:deleteButton];
        
        UIButton* defaultImageButton = [UIButton new];
        defaultImageButton.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [defaultImageButton setImage:[UIImage imageNamed:@"Hotemoij_default"] forState:UIControlStateNormal];
        defaultImageButton.tag = 108;
        [defaultImageButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
        self.defaultImageBt = defaultImageButton;
        [_faceInputView addSubview:defaultImageButton];
        
        UIButton* defaultSelImageButton = [UIButton new];
        [defaultSelImageButton setImage:[UIImage imageNamed:@"Hotemoij_selec"] forState:UIControlStateNormal];
        defaultSelImageButton.tag = 109;
        [defaultSelImageButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
        self.selecImageBt = defaultSelImageButton;
        
        
        [_faceInputView addSubview:defaultSelImageButton];

        
        CGFloat width = 33;
        CGFloat height = 33;
        CGFloat horizontalMargin = (kScreenWidth - kColumn * width) / (kColumn + 1);
        CGFloat verticalMargin = (kScrollViewHeight - kRow * height) / (kRow + 1);
        
        NSInteger pageTotal = (kColumn * kRow);//当前页表情总个数
        
        NSInteger page = self.defaultEmotionArray.count / pageTotal;
        if(self.defaultEmotionArray.count % pageTotal ){
            page ++ ;
        }
        NSLog(@"====%ld",self.defaultEmotionArray.count);
        faceScrollView.contentSize = CGSizeMake(kScreenWidth * page, kScrollViewHeight);
        pageControl.numberOfPages = page;
        
        NSInteger currentPage = 0;
        for(int i = 0; i < self.defaultEmotionArray.count; i++){
            if(i % pageTotal == 0 ){
                //整数
                currentPage = i / pageTotal;
            }
            NSInteger j = (i - currentPage * pageTotal);
            CGFloat x = currentPage * kScreenWidth + horizontalMargin + (width + horizontalMargin) * (j % kColumn);
            
            //            NSLog(@"---%g",x);
            
            CGFloat y = verticalMargin + (height + verticalMargin) * (j / kColumn);
            //            NSLog(@"---%ld",self.defaultEmotionArray.count);
            UIButton* emotion = [UIButton new];
            emotion.frame = CGRectMake(x, y, width, height);
            //            emotion.backgroundColor = [UIColor redColor];
            NSDictionary* emotionDic = [self.defaultEmotionArray objectAtIndex:i];
            [emotion setBackgroundImage:[UIImage imageNamed:[emotionDic valueForKey:@"png"]] forState:UIControlStateNormal];
            
            emotion.tag = 200 + i;
            [emotion addTarget:self action:@selector(clickEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [faceScrollView addSubview:emotion];
        }
        
        
        
        faceScrollView.sd_layout.topSpaceToView(_faceInputView,0).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(kScrollViewHeight);
        pageControl.sd_layout.topSpaceToView(faceScrollView,20).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(8);
        defaultImageButton.sd_layout.leftSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        defaultSelImageButton.sd_layout.leftSpaceToView(defaultImageButton,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        deleteButton.sd_layout.rightSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        
    }
    return _faceInputView;
    
}
#pragma mark  *加载键盘选择照片视图
-(UIView *)SelectcollectView{
    if(!_SelectcollectView){
        
        _SelectcollectView = [UIView new];
        _SelectcollectView.height = kKeyboardHeight;
        _SelectcollectView.backgroundColor = RGB(250, 250, 250);

        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat marign = 15;
        CGFloat width = (kScreenWidth - 3 * marign) / 3;
        CGFloat height =  width;
        layout.itemSize = CGSizeMake(width, height);
        
        UICollectionView* collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collect.delegate = self;
        collect.dataSource = self;
        collect.scrollEnabled = NO;
        self.collect = collect;
        collect.backgroundColor = [UIColor clearColor];
        [_SelectcollectView   addSubview:collect];
        [collect registerClass:[HotDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
        [collect registerClass:[HotPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
        
        
        UILabel* photoNum = [UILabel new];
        photoNum.textColor = UIColorFromRGB(0x767676);
        photoNum.font = [UIFont systemFontOfSize:smidFont];
        photoNum.textAlignment = NSTextAlignmentCenter;
        self.photoNumLabel = photoNum;
        [_SelectcollectView addSubview:photoNum];

        
        collect.sd_layout.topSpaceToView(_SelectcollectView,40/2).leftSpaceToView(_SelectcollectView,0).rightSpaceToView(_SelectcollectView,0).heightIs(height+16);
            collect.backgroundColor = [UIColor redColor];
        
        photoNum.sd_layout.topSpaceToView(self.collect,10).centerXEqualToView(_SelectcollectView).widthIs(100).heightIs(20);
        
    }
    return _SelectcollectView;
    
}

-(NSMutableArray *)collectDataSource{
    if(!_collectDataSource){
        _collectDataSource=[NSMutableArray array];
        [_collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
    }
    return _collectDataSource;
}

-(NSMutableArray *)defaultEmotionArray{
    if(!_defaultEmotionArray){
//        if (isDefaultEmoij == YES) {
            NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
            
            _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
                [_defaultEmotionArray removeObjectsInRange:NSMakeRange(30, 6)];
    }
    return _defaultEmotionArray;
}



#pragma mark---  头视图控件
- (void)setupHeadImageView{
    _totalHeight = 0;
    _userHeadImageView = [UIImageView new];
    _userHeadImageView.userInteractionEnabled = YES;
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.UserImg]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    [_headerView addSubview:_userHeadImageView];
    _userHeadImageView.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_headerView,10).widthIs(35).heightIs(35);
    _userHeadImageView.sd_cornerRadius = @17.5;
    _totalHeight += 45;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHead)];
    [_userHeadImageView addGestureRecognizer:tap];
}


- (void)setupUserNameLabel{
    _userNameLabel = [UILabel new];
    _userNameLabel.text = self.presenter.question.NickName;
    _userNameLabel.textColor = UIColorFromRGB(0x333333);
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:_userNameLabel];
    _userNameLabel.sd_layout.leftSpaceToView(_userHeadImageView,15).centerYEqualToView(_userHeadImageView).heightIs(20);
    [_userNameLabel setSingleLineAutoResizeWithMaxWidth:150];
}

- (void)setupInfoView{
    _infoLabel = [UILabel new];
    [_headerView addSubview:_infoLabel];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    _infoLabel.backgroundColor =[UIColor clearColor];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _infoLabel.text = self.presenter.question.ConsultationContent;
    
    _infoHeight = [JMFoundation calLabelHeight:_infoLabel.font andStr:_infoLabel.text withWidth:(kScreenWidth - 20)];
    WSLog(@"&&---%g",_infoHeight);
    _infoLabel.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_userHeadImageView,15).rightSpaceToView(_headerView,10).heightIs(_infoHeight);
    _totalHeight += (_infoHeight + 15);
    _haveImageBgView =[[UIView alloc]init];
    
    [_headerView addSubview:_haveImageBgView];
    
    _QuestionImageView1 =[[UIImageView alloc]init];
    
    _QuestionImageView1.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView1.tag =1001;
    _QuestionImageView1.layer.cornerRadius= 8;
    [_QuestionImageView1.layer setBorderWidth:2];
    [_QuestionImageView1.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView1.clipsToBounds =YES;
    _QuestionImageView1.userInteractionEnabled =YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView1 addGestureRecognizer:leftTap];
    [_haveImageBgView addSubview:_QuestionImageView1];
    
    _QuestionImageView2 =[[UIImageView alloc]init];
    _QuestionImageView2.tag =1002;
    _QuestionImageView2.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView2.layer.cornerRadius= 8;
    [_QuestionImageView2.layer setBorderWidth:2];
    [_QuestionImageView2.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView2.clipsToBounds =YES;
    _QuestionImageView2.userInteractionEnabled =YES;
    UITapGestureRecognizer *midTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView2 addGestureRecognizer:midTap];
    [_haveImageBgView addSubview:_QuestionImageView2];
    
    _QuestionImageView3 =[[UIImageView alloc]init];
    _QuestionImageView3.tag =1003;
    _QuestionImageView3.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView3.layer.cornerRadius= 8;
    [_QuestionImageView3.layer setBorderWidth:2];
    [_QuestionImageView3.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView3.clipsToBounds =YES;
    _QuestionImageView3.userInteractionEnabled =YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView3 addGestureRecognizer:rightTap];
    [_haveImageBgView addSubview:_QuestionImageView3];
    
    
    
    
    
    _QuestionImageView4 =[[UIImageView alloc]init];
    _QuestionImageView4.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView4.tag =1004;
    _QuestionImageView4.layer.cornerRadius= 8;
    [_QuestionImageView4.layer setBorderWidth:2];
    [_QuestionImageView4.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView4.clipsToBounds =YES;
    _QuestionImageView4.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView4 addGestureRecognizer:Tap4];
    [_haveImageBgView addSubview:_QuestionImageView4];
    
    _QuestionImageView5 =[[UIImageView alloc]init];
    _QuestionImageView5.tag =1005;
    _QuestionImageView5.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView5.layer.cornerRadius= 8;
    [_QuestionImageView5.layer setBorderWidth:2];
    [_QuestionImageView5.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView5.clipsToBounds =YES;
    _QuestionImageView5.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView5 addGestureRecognizer:Tap5];
    [_haveImageBgView addSubview:_QuestionImageView5];
    
    _QuestionImageView6 =[[UIImageView alloc]init];
    _QuestionImageView6.tag =1006;
    _QuestionImageView6.contentMode =UIViewContentModeScaleAspectFill;
    _QuestionImageView6.layer.cornerRadius= 8;
    [_QuestionImageView6.layer setBorderWidth:2];
    [_QuestionImageView6.layer setBorderColor:RGB(80,199, 192).CGColor];
    _QuestionImageView6.clipsToBounds =YES;
    _QuestionImageView6.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QuestionImageView6 addGestureRecognizer:Tap6];
    [_haveImageBgView addSubview:_QuestionImageView6];

    
//    _haveImageBgView.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_infoLabel,0).widthIs(280).heightIs(97.5);
//    _QuestionImageView1.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,0).widthIs(80).heightIs(80);
//    _QuestionImageView2.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,100).widthIs(80).heightIs(80);
//    _QuestionImageView3.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,200).widthIs(80).heightIs(80);
//    
//    _QuestionImageView1.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,0).widthIs(80).heightIs(80);
//    _QuestionImageView2.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,100).widthIs(80).heightIs(80);
//    _QuestionImageView3.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,200).widthIs(80).heightIs(80);
//    
//    if (!self.presenter.question.IsOpenImage) {
//        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
//        _haveImageBgView.hidden =YES;
//    }else {
//        _totalHeight += 80;
//        if (self.presenter.question.Image1!=nil&&self.presenter.question.Image1.length>4&&(![self.presenter.question.Image1 isEqualToString:@""])) {
//            [_QuestionImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//            if (self.presenter.question.Image2!=nil&&self.presenter.question.Image2.length>4&&(![self.presenter.question.Image2 isEqualToString:@""])) {
//                
//                [_QuestionImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                if (self.presenter.question.Image3!=nil&&self.presenter.question.Image3.length>4&&(![self.presenter.question.Image3 isEqualToString:@""])) {
//                    _photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3];
//                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]];
//                    [_QuestionImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                }else {
//                    _photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2];
//                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2]];
//                    _QuestionImageView3.hidden =YES;
//                }
//            }else{
//                _photoBrowserArr =@[_QuestionImageView1];
//                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1]];
//                _QuestionImageView2.hidden =YES;
//                _QuestionImageView3.hidden =YES;
//            }
//            
//        }else{
//            _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
//            _haveImageBgView.hidden =YES;
//        }
//        
//    }
    _haveImageBgView.sd_layout.topSpaceToView(_infoLabel,0).leftEqualToView(_infoLabel).widthIs(QuestionImageWidtn).heightIs(QuestionImageHeight2);
    _QuestionImageView1.sd_layout.topSpaceToView(_haveImageBgView,leftYspace).leftSpaceToView(_haveImageBgView,0).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    
    _QuestionImageView2.sd_layout.topSpaceToView(_haveImageBgView,leftYspace).leftSpaceToView(_haveImageBgView,QuestionImageSingleWidtn+QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    _QuestionImageView3.sd_layout.topSpaceToView(_haveImageBgView,leftYspace).leftSpaceToView(_haveImageBgView,2*QuestionImageSingleWidtn+2*QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    
    
    _QuestionImageView4.sd_layout.topSpaceToView(_haveImageBgView,QuestionImageYspace2).leftSpaceToView(_haveImageBgView,0).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    
    _QuestionImageView5.sd_layout.topSpaceToView(_haveImageBgView,QuestionImageYspace2).leftSpaceToView(_haveImageBgView,QuestionImageSingleWidtn+QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    
    _QuestionImageView6.sd_layout.topSpaceToView(_haveImageBgView,QuestionImageYspace2).leftSpaceToView(_haveImageBgView,2*QuestionImageSingleWidtn+2*QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
    
    
    if (!self.presenter.question.IsOpenImage) {
        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        _haveImageBgView.hidden =YES;
    }else {
        
        if (self.presenter.question.Image1==nil|self.presenter.question.Image1.length==0|self.presenter.question.Image1.length<5) {
            
            _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
            _haveImageBgView.hidden =YES;
        }else{
            
            if (self.presenter.question.Image4==nil|self.presenter.question.Image4.length==0|self.presenter.question.Image4.length<5 ) {
                //一行相片
                _haveImageBgView.sd_layout.topSpaceToView(_infoLabel,0).leftEqualToView(_infoLabel).widthIs(QuestionImageWidtn).heightIs(QuestionImageHeight1);
                _totalHeight += QuestionImageHeight1;
                
                if (self.presenter.question.Image1!=nil&&self.presenter.question.Image1.length>4&&(![self.presenter.question.Image1 isEqualToString:@""])) {
                    _haveImageBgView.hidden =NO;
                    [_QuestionImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    if (self.presenter.question.Image2!=nil&&self.presenter.question.Image2.length>4&&(![self.presenter.question.Image2 isEqualToString:@""])) {
                        
                        [_QuestionImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        if (self.presenter.question.Image3!=nil&&(![self.presenter.question.Image3 isEqualToString:@""])&&self.presenter.question.Image3.length>4) {
                            
                            [_QuestionImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3];
                            _QuestionImageView4.hidden = YES;
                            _QuestionImageView5.hidden = YES;
                            _QuestionImageView6.hidden = YES;
                            
                            
                        }else {
                            //只有2张图 1, 2
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2];
                            
                            _QuestionImageView3.hidden = YES;
                            _QuestionImageView4.hidden = YES;
                            _QuestionImageView5.hidden = YES;
                            _QuestionImageView6.hidden = YES;
                            
                            
                        }
                        
                        
                    }else{
                        //只有1张图 1
                        
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1]];
                        self.photoBrowserArr =@[_QuestionImageView1];
                        _QuestionImageView2.hidden = YES;
                        _QuestionImageView3.hidden = YES;
                        _QuestionImageView4.hidden = YES;
                        _QuestionImageView5.hidden = YES;
                        _QuestionImageView6.hidden = YES;
                        
                    }
                }
                
                
            }else{
                //2行相片
                _totalHeight += QuestionImageHeight2;
                
                [_QuestionImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                [_QuestionImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                [_QuestionImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3]];
                self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3];
                
                if (self.presenter.question.Image4!=nil&&self.presenter.question.Image4.length>4&&(![self.presenter.question.Image4 isEqualToString:@""])) {
                    
                    [_QuestionImageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    if (self.presenter.question.Image5!=nil&&self.presenter.question.Image5.length>4&&(![self.presenter.question.Image5 isEqualToString:@""])) {
                        
                        [_QuestionImageView5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        
                        if (self.presenter.question.Image6!=nil&&self.presenter.question.Image6.length>4&&(![self.presenter.question.Image6 isEqualToString:@""])) {
                            
                            [_QuestionImageView6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                            
                            //只有6张图
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image6]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4,_QuestionImageView5,_QuestionImageView6];
                            
                        }else{
                            
                            //只有5张图
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image5]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4,_QuestionImageView5];
                            _QuestionImageView6.hidden = YES;
                            
                        }//6
                    }else{
                        //只有4张图
                        
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.question.Image4]];
                        self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4];
                        _QuestionImageView5.hidden = YES;
                        _QuestionImageView6.hidden = YES;
                        
                    }   // 5
                }  //4
                
            }
        }
    }

    
}
- (void)setupDoctorImageView{
    
    _headBackView = [UIImageView new];
    _headBackView.userInteractionEnabled = YES;
    _headBackView.image = [UIImage imageNamed:@"HEADoctorIcon"];
    _headBackView.layer.masksToBounds = YES;
    _headBackView.layer.cornerRadius = 27.5f;
    [_headerView addSubview:_headBackView];
    _headBackView.sd_layout.leftSpaceToView(_headerView,7.5).topSpaceToView(_haveImageBgView,17.5).widthIs(55).heightIs(55);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageAction)];
    [_headBackView addGestureRecognizer:tap];
    
    
    _doctorImageView = [UIImageView new];
    _doctorImageView.userInteractionEnabled = YES;
    [_headerView addSubview:_doctorImageView];
    
    
    _doctorImageView.layer.masksToBounds = YES;
    _doctorImageView.layer.cornerRadius = 25;
    [_doctorImageView  sd_setImageWithURL:[NSURL  URLWithString:self.presenter.question.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
    [_doctorImageView addGestureRecognizer:tap];
    
    _doctorImageView.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_haveImageBgView,20).widthIs(50).heightIs(50);
    _totalHeight += 70;
}

- (void)setupVoiceButton{
    _voiceButton = [UIButton new];
//    [self.delegate isHotFree:[NSNumber  numberWithInteger:self.presenter.question.IsFree]];
    NSLog(@"isfree%d",self.presenter.question.IsFree);
    if( [[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree] isEqualToString:@"1"]){
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"HEAVoice_Free"] forState:UIControlStateNormal];
        [_voiceButton setTitle:@"限时免费" forState:UIControlStateNormal];
    }else{
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
        if (self.presenter.question.VoiceUrl && self.presenter.question.VoiceUrl.length > 0) {
            if (self.presenter.question.IsListen == 1) {
                [_voiceButton setTitle:@"点击播放" forState:UIControlStateNormal];
            }else{
                [_voiceButton setTitle:@"一元旁听" forState:UIControlStateNormal];
            }
        }else{
            [_voiceButton setTitle:@"未回答" forState:UIControlStateNormal];
        }
    }
    
    _voiceButton.titleLabel.font = AC_FONT;
    [_voiceButton addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_voiceButton];
    _voiceButton.sd_layout.leftSpaceToView(_doctorImageView,5).topSpaceToView(_haveImageBgView,25).heightIs(30).widthIs(120);
}
- (void)setupDurationLabel{
    _durationLabel = [UILabel new];
    [_headerView addSubview:_durationLabel];
    _durationLabel.text = [NSString stringWithFormat:@"%ld''",self.presenter.question.VoiceTime];
    _durationLabel.font = AC_FONT;
    _durationLabel.textColor = UIColorFromRGB(0x979797);
    _durationLabel.sd_layout.leftSpaceToView(_voiceButton,15).topSpaceToView(_haveImageBgView,35).rightSpaceToView(_headerView,10).heightIs(20);
}

- (void)setupDoctorNameLabel{
    _doctorNameLabel = [UILabel new];
    [_headerView addSubview:_doctorNameLabel];
    _doctorNameLabel.text = self.presenter.expertAnswer[0].doctorName;
    NSLog(@"%@",self.presenter.expertAnswer[0].doctorName);
    _doctorNameLabel.numberOfLines = 0;
    _doctorNameLabel.textAlignment = NSTextAlignmentCenter;
    _doctorNameLabel.font = AC_FONT;
    _doctorNameLabel.textColor = UIColorFromRGB(0x979797);
//    _doctorNameLabel.sd_layout.leftEqualToView(_doctorImageView).topSpaceToView(_doctorImageView,15).rightSpaceToView(_voiceButton,0).heightIs([JMFoundation calLabelHeght:_doctorNameLabel]);
    _doctorNameLabel.sd_layout.topSpaceToView(_doctorImageView,15).centerXEqualToView(_doctorImageView).heightIs(14).widthIs([JMFoundation  calLabelWidth:_doctorNameLabel]);
}
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    [_headerView addSubview:_postLabel];
    _postLabel.text = self.presenter.expertAnswer[0].introduce;
    NSLog(@"医生简介：%@",self.presenter.expertAnswer[0].introduce);
    
    _postLabel.numberOfLines = 1;
    _postLabel.font = AC_FONT_SMALL;
    _postLabel.textColor = UIColorFromRGB(0x979797);
    _postLabel.sd_layout.leftSpaceToView(_doctorNameLabel,10).topSpaceToView(_doctorImageView,17).rightSpaceToView(_headerView,10).heightIs(14);
    _totalHeight += 31;

}
//文字补充回答
-(void)setupWordContentView{
    
    
    _WordBackView = [UIView  new];
    _WordBackView.backgroundColor = [UIColor  clearColor];
    [_headerView  addSubview:_WordBackView];
    

    _WordContentBtn = [UIButton  new];

    _WordContentBtn.backgroundColor = [UIColor  clearColor];
    [_WordContentBtn setImage:[UIImage  imageNamed:@"WordContent_Close"] forState:UIControlStateNormal];

    [_WordContentBtn  setImage:[UIImage  imageNamed:@"WordContent_Open"] forState:UIControlStateSelected];
    
//
    [_WordContentBtn  addTarget:self action:@selector(WordContentClick:) forControlEvents:UIControlEventAllEvents];
    [_WordBackView  addSubview:_WordContentBtn];
    
    
    _WordContentView  = [UIView  new];
    _WordContentView.backgroundColor = [UIColor  whiteColor];
    _WordContentView.layer.masksToBounds = YES;
    _WordContentView.layer.cornerRadius = 10/2;
    _WordContentView.layer.borderWidth = 1;
    _WordContentView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    [_WordBackView addSubview:_WordContentView];
    
    _WordContentMessage = [UILabel  new];
    _WordContentMessage.backgroundColor = [UIColor  clearColor];
    _WordContentMessage.font = [UIFont  systemFontOfSize:15];
    _WordContentMessage.numberOfLines = 0;
    _WordContentMessage.text=self.presenter.question.WordContent;
    _WordContentMessage.textColor = UIColorFromRGB(0x333333);
    _WordContentMessage.textAlignment = NSTextAlignmentLeft;
    [_WordContentView  addSubview:_WordContentMessage];
    
    _WordBackView.sd_layout.topSpaceToView(_doctorNameLabel,30/2).leftEqualToView(_voiceButton).rightSpaceToView(_headerView,30/2);

    
    _WordContentBtn.sd_layout.topSpaceToView(_WordBackView,0).leftSpaceToView(_WordBackView,0).widthIs(154/2).heightIs(16);
    
    _WordContentView.sd_layout.topSpaceToView(_WordContentBtn,20/2).leftEqualToView(_WordContentBtn).rightEqualToView(_WordBackView);
    
    _WordContentMessageHeight = [JMFoundation calLabelHeight:_WordContentMessage.font andStr:_WordContentMessage.text withWidth:(kScreenWidth - 100)];
    
    _WordContentMessage.sd_layout.topSpaceToView(_WordContentView,20/2).leftSpaceToView(_WordContentView,20/2).rightSpaceToView(_WordContentView,20/2).heightIs(_WordContentMessageHeight);
    
    [_WordContentView setupAutoHeightWithBottomView:_WordContentMessage bottomMargin:20/2];
    
    _WordContentBtn.selected = YES;
        if (_WordContentBtn.selected ==NO) {
            _WordContentView.hidden = YES;
            [_WordBackView  setupAutoHeightWithBottomView:_WordContentBtn bottomMargin:0];
            _totalHeight += 31;
            
        }else{
            _WordContentView.hidden = NO;
            [_WordBackView  setupAutoHeightWithBottomView:_WordContentView bottomMargin:0];
            
            _totalHeight += (61+_WordContentMessageHeight);
        }
}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    _timeLabel.backgroundColor = [UIColor  clearColor];
    [_headerView addSubview:_timeLabel];
    _timeLabel.font = AC_FONT_SMALL;
//    NSString* MyListenDetailTime = [NSDate getDateCompare:self.presenter.question.CreateTime];
    _timeLabel.text = self.presenter.question.CreateTime;
//    UIView *bottomView = _doctorNameLabel.height > (_postLabel.height + 5) ? _doctorNameLabel : _postLabel;
    _timeLabel.textColor = UIColorFromRGB(0x979797);
    
    if (_WordContentMessage.text.length == 0 || _WordContentMessage.text == nil) {
        NSLog(@"没有补充回答");
        _WordBackView.hidden = YES;
        _WordBackView.height = 0;
    _timeLabel.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_doctorNameLabel,20).widthIs(kJMWidth(_timeLabel)).heightIs(15);
        _totalHeight -= 31;

    }else{
        if (self.presenter.question.IsListen == 1 ||self.presenter.question.IsFree == 1) {
                NSLog(@"旁听过或者限时免费");
            _WordBackView.hidden = NO;
            _timeLabel.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_WordBackView,20).widthIs(kJMWidth(_timeLabel)).heightIs(15);
        }else{
            NSLog(@"没有旁听过");
            _WordBackView.hidden = YES;
            _WordBackView.height = 0;
            _timeLabel.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_doctorNameLabel,20).widthIs(kJMWidth(_timeLabel)).heightIs(15);
            _totalHeight -= 31;
        }
    }


//
//    if ([JMFoundation calLabelHeght:_doctorNameLabel] > [JMFoundation calLabelHeght:_postLabel]) {
//        _totalHeight += ([JMFoundation calLabelHeght:_doctorNameLabel]+15+25);
//    }else{
//        _totalHeight += ([JMFoundation calLabelHeght:_doctorNameLabel]+15+25);
//    }
    
   
}
- (void)setupPraiseLabel{
    _praiseLabel = [UILabel new];
    _praiseLabel.font = _timeLabel.font;
    _praiseLabel.userInteractionEnabled = YES;
    _praiseLabel.textColor = _timeLabel.textColor;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.text = [NSString stringWithFormat:@"%ld",self.presenter.question.PraiseCount];
    [_headerView addSubview:_praiseLabel];
    _praiseLabel.sd_layout.rightSpaceToView(_headerView,0).bottomEqualToView(_timeLabel).heightIs(20).widthIs(40);
    //    [_praiseLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    UITapGestureRecognizer *praiseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseTapAction)];
    [_praiseLabel addGestureRecognizer:praiseTap];
}
- (void)setupPraiseButton{
    _praiseButton = [UIButton new];
    _praiseButton.backgroundColor = [UIColor  clearColor];
    if (self.presenter.question.isPraise == 1) {
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
    }else{
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
    }
    [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_praiseButton];
    _praiseButton.sd_layout.rightSpaceToView(_praiseLabel,0).bottomEqualToView(_timeLabel).heightIs(20).widthIs(20);
    
     _totalHeight += 35;
}


-(void)setupClinicalBackView{
    
    _ClinicalBack= [UIView  new];
    _ClinicalBack.backgroundColor = [UIColor  whiteColor];
    [_headerView  addSubview:_ClinicalBack];
    
    _ClinicalBackView  = [UIView  new];
    _ClinicalBackView.backgroundColor = [UIColor  whiteColor];
    _ClinicalBackView.layer.masksToBounds = YES;
    _ClinicalBackView.layer.cornerRadius = 10/2;
    _ClinicalBackView.layer.borderWidth = 1;
    _ClinicalBackView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    [_ClinicalBack addSubview:_ClinicalBackView];
    
    _ClinicalBackTitle = [UILabel  new];
    _ClinicalBackTitle.backgroundColor = [UIColor  clearColor];
    _ClinicalBackTitle.font =  [UIFont  boldSystemFontOfSize:15];
    _ClinicalBackTitle.textColor =  UIColorFromRGB(0x333333);
    _ClinicalBackTitle.text = @"疗效回访";
    _ClinicalBackTitle.textAlignment = NSTextAlignmentLeft;
    [_ClinicalBackView  addSubview:_ClinicalBackTitle];
    
    
    _ClinicalBackTime = [UILabel  new];
    _ClinicalBackTime.backgroundColor = [UIColor  clearColor];
    _ClinicalBackTime.font = AC_FONT_SMALL;
    _ClinicalBackTime.textColor = UIColorFromRGB(0x999999);
    _ClinicalBackTime.textAlignment = NSTextAlignmentRight;
    [_ClinicalBackView  addSubview:_ClinicalBackTime];
    
    
    _ClinicalBackMessage = [UILabel  new];
    _ClinicalBackMessage.backgroundColor = [UIColor  clearColor];
    _ClinicalBackMessage.font = [UIFont  systemFontOfSize:15];
    _ClinicalBackMessage.numberOfLines = 0;
    _ClinicalBackMessage.textColor = UIColorFromRGB(0x333333);
    _ClinicalBackMessage.textAlignment = NSTextAlignmentLeft;
    [_ClinicalBackView  addSubview:_ClinicalBackMessage];
    
    
    if (self.presenter.TherapeuticVisitSource.VisitContent != nil) {
        
//        NSTimeInterval timeInterval = [self.presenter.TherapeuticVisitSource.CreateTime doubleValue];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
//        //                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        [formatter setDateFormat:@"YYYY-MM-dd"];
//        NSDate *confromTimesp = [NSDate  dateWithTimeIntervalSince1970:timeInterval];
//        NSString*confromTimespStr = [formatter  stringFromDate:confromTimesp];
//        
//        //                    NSString* myAnswerTime = [NSDate getDateCompare:confromTimespStr];
//        _ClinicalBackTime.text=confromTimespStr;
//        [_ClinicalBackTime  updateLayout];
        
        _ClinicalBackTime.text= self.presenter.TherapeuticVisitSource.CreateTime;
        [_ClinicalBackTime  updateLayout];
        
        _ClinicalBackMessage.text = [NSString  stringWithFormat:@"%@:%@",self.presenter.TherapeuticVisitSource.XiaoBianName,self.presenter.TherapeuticVisitSource.VisitContent];
        
        NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:_ClinicalBackMessage.text];
        
        [Str addAttribute:NSForegroundColorAttributeName
                    value:UIColorFromRGB(0xf8bbd0)
                    range:NSMakeRange(0, self.presenter.TherapeuticVisitSource.XiaoBianName.length)];
        _ClinicalBackMessage.attributedText = Str;
        _ClinicalBack.hidden = NO;
        
    }else{
        NSLog(@"无疗效回访数据");
        _ClinicalBack.hidden = YES;
    }
    _ClinicalBack.sd_layout.topSpaceToView(_timeLabel,10).leftEqualToView(_headerView).rightEqualToView(_headerView);
    
    _ClinicalBackView.sd_layout.leftSpaceToView(_ClinicalBack,30/2).rightSpaceToView(_ClinicalBack,30/2).topSpaceToView(_ClinicalBack,0);
    
    
    _ClinicalBackTitle.sd_layout.leftSpaceToView(_ClinicalBackView,20/2).topSpaceToView(_ClinicalBackView,20/2).heightIs(16).widthIs(kJMWidth(_ClinicalBackTitle));
    
    _ClinicalBackTime.sd_layout.topEqualToView(_ClinicalBackTitle).rightSpaceToView(_ClinicalBackView,20/2).heightIs(12);
    
    CGFloat  ClinicalBackMessageHeight  = [JMFoundation calLabelHeight:_ClinicalBackMessage.font andStr:_ClinicalBackMessage.text withWidth:(kScreenWidth - 50)];
    
    _ClinicalBackMessage.sd_layout.topSpaceToView(_ClinicalBackTitle,30/2).leftEqualToView(_ClinicalBackTitle).rightEqualToView(_ClinicalBackTime).heightIs(ClinicalBackMessageHeight);
    
    [_ClinicalBackView setupAutoHeightWithBottomView:_ClinicalBackMessage bottomMargin:30/2];
    
    [_ClinicalBack  setupAutoHeightWithBottomView:_ClinicalBackView bottomMargin:10];
    NSLog(@"1111111111111:%ff",_totalHeight);
    if (self.presenter.TherapeuticVisitSource.VisitContent != nil){
        _totalHeight += (10+10+16+15+ClinicalBackMessageHeight+15+10);
        
        NSLog(@"1111111111111:%f ---%f",_totalHeight,ClinicalBackMessageHeight);
    }else{
        
        
    }
    NSLog(@"%@",_ClinicalBackMessage.text);
    
    
}

- (void)setupPriceLabel{
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_headerView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromRGB(0x61d8d3);
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.presenter.question.ExpertPrice];
    _priceLabel.font = AC_FONT;
    _priceLabel.sd_layout.rightSpaceToView(_headerView,10).topEqualToView(_userNameLabel).heightIs(15);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:120];
}

- (void)setupListenLabel{
    _listenLabel = [UILabel new];
    [_headerView addSubview:_listenLabel];
    _listenLabel.font = AC_FONT_SMALL;
    _listenLabel.textColor = UIColorFromRGB(0x979797);
    _listenLabel.text = [NSString stringWithFormat:@"听过  %ld",(long)self.presenter.question.HearCount];
    _listenLabel.textAlignment = NSTextAlignmentRight;
//    _listenLabel.sd_layout.rightSpaceToView(_priceLabel,10).topEqualToView(_userNameLabel).heightIs(15).widthIs(100);
    
    _listenLabel.sd_layout.leftSpaceToView(_timeLabel,10).centerYEqualToView(_timeLabel).heightIs(15).widthIs([JMFoundation calLabelWidth:_listenLabel]);
    
}


#pragma mark -collectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

//    PhotoCollectionViewCell* photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
//    
//    if(!photoCell.delegate){
//        photoCell.delegate = self;
//    }
//    
//    photoCell.photoImageView.image = self.collectDataSource[indexPath.item];
//    return photoCell;
    
    HotDefaultCollectionViewCell* defaultCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
    HotPhotoCollectionViewCell* photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if(!photoCell.delegate){
        photoCell.delegate = self;
    }
    
    if(self.collectDataSource.count == 1){
        //默认照片
        defaultCell.defaultImageView.image = self.collectDataSource[indexPath.item];
        return defaultCell;
    }else{
        // >= 2
        if(indexPath.item == self.collectDataSource.count -1){
            defaultCell.defaultImageView.image = self.collectDataSource[indexPath.item];
            return defaultCell;
        }else{
            photoCell.photoImageView.image = self.collectDataSource[indexPath.item];
            return photoCell;
        }
    }

    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self.textView resignFirstResponder];
    self.addButton.selected = NO;
 UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if([cell isKindOfClass:[HotDefaultCollectionViewCell class]]){
        CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
        //设置类型
        manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
        
        //最多可选3张
        
        NSInteger maxPhotoNumber = 0;
        if(self.collectDataSource.count == 1){
            maxPhotoNumber = 5;
        }else if(self.collectDataSource.count == 2){
            maxPhotoNumber = 4;
        }else if(self.collectDataSource.count == 3){
            maxPhotoNumber = 3;
        }else if(self.collectDataSource.count == 4){
            maxPhotoNumber = 2;
        }else if(self.collectDataSource.count == 5){
            maxPhotoNumber = 1;
        }else if(self.collectDataSource.count == 6){
            maxPhotoNumber = 0;
        }else{
            maxPhotoNumber = 6;
        }
        
        manager.maxSelectedPhotoNumber = maxPhotoNumber;
        
        //错误处理
        if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
            NSLog(@"设备不可用");
            return;
        }
        
        UIViewController *pickerVC=manager.imagePickerController;
        WS(ws);
        //选取结束
        manager.finishPickingMedia=^(NSArray *medias){
            
            if(medias.count != 0){
                [ws.collectDataSource removeLastObject];
            }
            
            for (CorePhoto *photo in medias) {
                [ws.collectDataSource addObject:photo.editedImage];
            }
            
            if(ws.collectDataSource.count >= 1 && ws.collectDataSource.count <= 6){
                [ws.collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
            }
            
            ws.photoNumLabel.hidden = ws.collectDataSource.count == 1;
            if(ws.collectDataSource.count != 1){
                ws.photoNumLabel.text = [NSString stringWithFormat:@"%ld/3",ws.collectDataSource.count -1];
                ws.circleTitle.text =  [NSString stringWithFormat:@"%ld",ws.collectDataSource.count -1];
                self.circlebtn.hidden =  NO;
            }
            
            [self SelectcollectView];
            [ws.collect reloadData];
        };
        
        [self presentViewController:pickerVC animated:YES completion:nil];
        
        
            isCamera = YES;
    }

    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 0, 15);
    
    
}



#pragma mark -tableview 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.presenter.ConsultationDataSource.count;
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    static NSString *cellID4 = @"cell4";
    static NSString *cellID5 = @"cell5";
    static NSString *cellID6 = @"cell6";

    ConsultationCommenList  *preQuestion =  [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
    

    
    HHotConsulationTableViewCell  * cell;
    

        if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
            
            cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID0];
            
            if (cell==nil) {
                cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                    cell.delegate = self;
            }
            
            
            cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];

            cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
    
            
        }else {
            
            if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])) {
                
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID1];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
                
            }else if ((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID2];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
            }else if ((preQuestion.Image3!=nil&&preQuestion.Image3.length!=0)&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID3];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
                
            }else if ((preQuestion.Image4!=nil&&preQuestion.Image4.length!=0)&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID4];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
                
            }else if ((preQuestion.Image5!=nil&&preQuestion.Image5.length!=0)&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID5];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
                
            }else{
                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID6];
                cell.delegate = self;
                
                if (cell==nil) {
                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID6];
                    cell.delegate = self;
                }
                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
                
            }
                
            
//            if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])) {
//                
//                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID1];
//                cell.delegate = self;
//                
//                if (cell==nil) {
//                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
//                    cell.delegate = self;
//                    
//                    
//                }
//                
//                
//                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
//                
//                
//            }else if((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])){
//                
//                
//                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID2];
//                cell.delegate = self;
//                
//                if (cell==nil) {
//                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
//                   cell.delegate = self;
//                    
//                }
//                
//                
//                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
//
//                
//            }else {
//                
//                cell = [_ConsulationTableView dequeueReusableCellWithIdentifier:cellID3];
//                cell.delegate = self;
//                if (cell==nil) {
//                    cell = [[HHotConsulationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
//                    
//                    
//                }
//                
//                
//                cell.CommenList = [self.presenter.ConsultationDataSource objectAtIndex:indexPath.row];
//                
//                
//                
//            }
        }

//    [cell.AnswerCountBtn   addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside ];
//    cell.AnswerCountBtn.tag = indexPath.row ;
//
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _ConsulationTableView;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([self.textView  isFirstResponder]) {
        [self.view endEditing:YES];
        self.textView.text = nil;
        self.textView.placeholder = @"此刻的心情是怎样的";
        [ self.textView resignFirstResponder];//直接取消输入框的第一响应  ]

        
    }else{
    
    HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController  new];
        vc.RefreshPopViewRow = ^(BOOL isRefresh){
            
            if (isRefresh == YES) {
                [self.presenter.ConsultationDataSource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView reloadData];
            }
            
        };
    vc.commentID = [NSNumber  numberWithInteger:[self.presenter.ConsultationDataSource  objectAtIndex:indexPath.row].uuid];
    vc.userID = [self.presenter.ConsultationDataSource  objectAtIndex:indexPath.row].UserID;
    [self.navigationController  pushViewController:vc animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ConsultationCommenList *conmodel = [self.presenter.ConsultationDataSource   objectAtIndex:indexPath.row];
    
    return [_ConsulationTableView cellHeightForIndexPath:indexPath model:conmodel keyPath:@"CommenList" cellClass:[HHotConsulationTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}
#pragma mark delegate
- (void)playFinished{
    _presenter.isPlaying = NO;
    if ([[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]) {
        [_presenter  FreeListeningCountWithConsultationID:[self.UUID  integerValue]];
        NSLog(@"打印uuid：%ld",[self.UUID  integerValue]);
        
    }
    
    if ([[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]) {
        [_voiceButton setTitle:@"限时免费" forState:UIControlStateNormal];
        
        
    }else{
        [_voiceButton setTitle:@"点击播放" forState:UIControlStateNormal];
    }
    
    
}
- (void)second:(NSString *)second{
    _durationLabel.text = second;
}
- (void)payComplete:(BOOL ) success{
//    NSLog(@"%d",success);
//    if (success == YES) {
        self.presenter.question.IsListen = 1;
        //通知首页刷新
        //        [kdefaultCenter postNotificationName:Notification_HotIsLoad object:nil];
        [self  setupHeadView];
        [self listenAction];
//    [self  setupWordContentView];
//    [self  setupTimeLabel];
//    [_headerView  updateLayout];
//    [self.headerView layoutSubviews];
//    [_ConsulationTableView setTableHeaderView:_headerView];

    //通知咨询页面刷新
    [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
//    }
}

- (void)onFreeListeningCountCompletion:(BOOL) success info:(NSString*) messsage{
    if (success) {
        NSLog(@"计数成功");
    }else{
        
        [ProgressUtil  showError:messsage];
        
    }
}
- (void)loadDoctorInfoCompletion:(BOOL) success info:(NSString*) messsage{
    if (success) {
        [self  setupReplyView];
        [self setupHeadView];
    }
}
-(void)GetTherapeuticVisitCompletion:(BOOL) success info:(NSString*) messsage{
    if(success){
//            if (self.presenter.TherapeuticVisitSource.count!=0){
//        
////             
//                [self  setupHeadView];
////
//        
//            }else{
//        
//            }

    
        
    }else{
        
        [ProgressUtil  showError:messsage];
        
    }
    
}
#pragma mark -- 评论列表代理--
-(void)GetConsultationCommentListCompletion:(BOOL)success info:(NSString*)message{
    _ConsulationTableView.userInteractionEnabled = YES;
    [_ConsulationTableView.mj_footer resetNoMoreData];
    [_ConsulationTableView.mj_header endRefreshing];
    
    
    if(success){
        //        [ProgressUtil  dismiss];
        [self.headerView layoutSubviews];

        [self.ConsulationTableView setTableHeaderView:self.headerView];
        _CommentTitle.text = [NSString  stringWithFormat:@"评论 %ld",_presenter.totalCount];

        
        if(ReplyView.textView.text.length != 0){
            ReplyView.textView.text = nil;
        }
        
        ReplyView.sendButton.selected = NO;
        
        [ReplyView.imageDataSource removeAllObjects];
        ReplyView.imageDataSource = nil;
        
        
        [_ConsulationTableView reloadData];
//        [_ConsulationTableView updateLayout];
        
        
    }else{
        
    }
}

-(void)GetMoreConsultationCommentListCompletion:(BOOL)success info:(NSString*)message{
    
    _ConsulationTableView.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [_ConsulationTableView.mj_footer endRefreshingWithNoMoreData]: [_ConsulationTableView.mj_footer endRefreshing];
    
    if(success){
        [self.headerView layoutSubviews];
        [self.ConsulationTableView setTableHeaderView:self.headerView];
        [_ConsulationTableView reloadData];
        

    }else{
        [ProgressUtil showError:message];
    }
    
    
}
-(void)getConsulationReplyCompletion:(BOOL) success info:(NSString*) messsage{

    if (success) {
        
        
        
        
    }else{
    
    
    
    
    }
}


-(void)InsertConsulationOnCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        
    
    [_presenter GetConsultationCommentListByConsultationID:[self.UUID  integerValue]];
    [self.ConsulationTableView  reloadData];
    }else{
        
        [ProgressUtil showError:message];
        
    }
}

- (void)getExpertCommentListSuccess{
    [ProgressUtil dismiss];
    
    _starIV.image =[UIImage imageNamed:_presenter.myComment.StarLevel?[NSString stringWithFormat:@"starLevel%@",_presenter.myComment.StarLevel]:@"starLevel0"];
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
        [_addCommentBtn setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateNormal];
        _addCommentBtn.layer.borderColor = UIColorFromRGB(0xc9c9c9).CGColor;
        _addCommentBtn.userInteractionEnabled =NO;
    }else{
        if (_presenter.question.User_ID != kCurrentUser.userId) {
            
            [_addCommentBtn setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateNormal];
            _addCommentBtn.layer.borderColor = UIColorFromRGB(0xc9c9c9).CGColor;
            _addCommentBtn.userInteractionEnabled =NO;
        }
    }
    
    [_headerView layoutSubviews];
    [_ConsulationTableView setTableHeaderView:_headerView];
    
}

- (void)addExpertCommentSuccess{
    [ProgressUtil showSuccess:@"评价成功"];
    
    [_alphaView removeFromSuperview];
    
    [ProgressUtil showWithStatus:@"加载中···"];
    [_presenter GetExpertCommentListByConsultationID:@(_presenter.question.uuiD)];
}


#pragma mark Action

- (void)praiseAction:(UIButton *)button{
    WS(ws);
    _praiseButton.userInteractionEnabled = NO;
    if (self.presenter.question.isPraise == 1) {
        //取消点赞
        [_presenter cancelPraise:[NSString stringWithFormat:@"%ld",[self.UUID  integerValue]] success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"取消点赞成功"];
                ws.presenter.question.isPraise = 0;
                ws.presenter.question.PraiseCount --;
                ws.praiseLabel.text = [NSString stringWithFormat:@"%ld",ws.presenter.question.PraiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
                kCurrentUser.hotIsNeedReload = NO;
                //通知咨询页面刷新
                [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
                //圈子首页刷新
                [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
                //刷新热门搜索页面数据
                [kdefaultCenter postNotificationName:Notification_HotSearch object:nil userInfo:nil];
                //刷新医生详情页面数据
                [kdefaultCenter postNotificationName:Notification_HEAInfoViewController object:nil userInfo:nil];
            }else{
                [ProgressUtil showError:@"取消点赞失败"];
            }
        }];
    }else{
        //点赞
        [_presenter praise:[NSString stringWithFormat:@"%ld",[self.UUID  integerValue]] success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"点赞成功"];
                ws.presenter.question.isPraise = 1;
                ws.presenter.question.PraiseCount ++;
                ws.praiseLabel.text = [NSString stringWithFormat:@"%ld",ws.presenter.question.PraiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
                kCurrentUser.hotIsNeedReload = NO;
                //通知咨询页面刷新
                [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
                //圈子首页刷新
                [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
                //刷新热门搜索页面数据
                [kdefaultCenter postNotificationName:Notification_HotSearch object:nil userInfo:nil];
                //刷新医生详情页面数据
                [kdefaultCenter postNotificationName:Notification_HEAInfoViewController object:nil userInfo:nil];

            }else{
                [ProgressUtil showSuccess:@"点赞失败"];
            }
        }];
    }
}
- (void)praiseTapAction{
    [self praiseAction:_praiseButton];
}
//-(void)answer:(UIButton*)btn{
//    if(btn!=self.starButton){
//        self.starButton.selected=NO;
//        self.starButton=btn;
//    }
//    self.starButton.selected=YES;
//    
//    if (btn.selected == YES) {
//        AnswerIndex = btn.tag;
//    }
//    NSLog(@"点击的楼层%ld",(long)AnswerIndex);
//    HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController  new];
//    
//    vc.CommenList = [self.presenter.ConsultationDataSource  objectAtIndex:AnswerIndex];
//    vc.isAnswer = YES;
//    [self.navigationController  pushViewController:vc animated:YES];
//
//}
- (void)listenAction{
    if ([self.presenter.question.VoiceUrl isKindOfClass:[NSNull class]] || self.presenter.question.VoiceUrl.length == 0) {
        
        return;
    }
    kCurrentUser.hotIsNeedReload = YES;
    NSLog(@"%ld%@",self.presenter.question.IsListen,[NSString stringWithFormat:@"%ld",self.presenter.question.IsFree ]);
    if (self.presenter.question.IsListen == 1||[[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]) {
        if (self.presenter.question.VoiceUrl.length == 0 || [self.presenter.question.VoiceUrl isKindOfClass:[NSNull class]]) {
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
            if ([[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]) {
                [_presenter  FreeListeningCountWithConsultationID:[self.UUID  integerValue]];
                NSLog(@"打印uuid：%ld",[self.UUID  integerValue]);
                
            }
            if ([[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]) {
                [_voiceButton setTitle:@"限时免费" forState:UIControlStateNormal];
            }else{
                [_voiceButton setTitle:@"点击播放" forState:UIControlStateNormal];
            }
            _presenter.isPlaying = NO;
            _durationLabel.text = @"0''";
        }
        
    }else{
        //支付逻辑
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        sheet.tag = 1000;
        [sheet showInView:self.view];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 1000){
        if(buttonIndex == 0){
            NSLog(@"支付宝");
            PayManager *pay = [PayManager new];
            pay.delegate = self;
            [pay payWithPayType:@"alipay" expertID:@(self.presenter.question.Expert_ID) consultationID:self.UUID uuid:self.UUID];
        }else if (buttonIndex ==1){
            [ProgressUtil show];
            
            NSLog(@"微信支付");
            [self.presenter weixinPayWithListenId:[self.UUID  integerValue]];
        }
    }
}

-(void)GetExpertHalfPriceOnCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        if ([self.presenter.question.OutTime  isEqual:@(1)]||[self.presenter.NoAnswer isEqual:@(1)]) {
            //不能追问
            NSLog(@"超时%@",self.presenter.question.OutTime);
            NSLog(@"医生回答：%@",self.presenter.NoAnswer);
            
            self.askButton.userInteractionEnabled =NO;
            
        }else{
        
        self.askButton.userInteractionEnabled =YES;
            
        }
    }else{
        self.askButton.userInteractionEnabled =NO;
        [ProgressUtil showError:message];
    }
}

- (void)helfPriceAction{
    
    if (_presenter.ifVacation!=nil&&[_presenter.ifVacation integerValue] ==1) {
        [ProgressUtil showInfo:@"医生正在休假,无法追问"];
        return;
    }
    HelfPriceViewController *vc = [HelfPriceViewController new];
    vc.expert_ID = self.presenter.question.Expert_ID;
    vc.consultationID = self.presenter.question.uuiD;
    vc.uuid = self.presenter.question.uuiD;
    vc.price = [self.presenter.halfPrice floatValue]*2;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url{
    
    
    if (success) {
        
        self.presenter.question.IsListen = 1;
        
        [self listenAction];
  
        //通知咨询页面刷新
        [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
        
    }else{
        [ProgressUtil showInfo:message];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    //显示图片浏览器
    [SFPhotoBrowser showImageInView:[UIApplication sharedApplication].keyWindow selectImageIndex:(tap.view.tag-1001) delegate:self];
}
- (void)ImageAction{
    
    HEAInfoViewController *vc = [HEAInfoViewController new];
    vc.expertEntity = self.presenter.expertAnswer[0];
    
    vc.expertEntity.doctorID = @(self.presenter.question.Expert_ID);
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)halfAction{
    [_ConsulationTableView removeFromSuperview];
    [_headerView removeFromSuperview];
//    WS(ws);
//    [_presenter GetExpertConsultationByUUID:[self.UUID  integerValue] finish:^(BOOL success, NSString *message) {
//        [ws.presenter loadDoctorInfoBy:@(ws.presenter.question.Expert_ID)];
//    }];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setupView];
}
- (void)tapUserHead{
    if (self.presenter.question.User_ID == kCurrentUser.userId) {
        [ProgressUtil showError:@"不能与自己私聊"];
        return;
    }
    ChatViewController *vc = [ChatViewController new];
    vc.chatType = ChatTypeSingal;
    vc.ReceiveUserID = self.presenter.question.User_ID;
    vc.nickName = self.presenter.question.NickName;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)WordContentClick:(UIButton*)btn{
    if (btn.selected == NO) {
        _WordContentView.hidden = NO;
        [_WordBackView  setupAutoHeightWithBottomView:_WordContentView bottomMargin:0];
//        self.headerView.height = self.headerView.height +30 +_WordContentMessageHeight;
        [_headerView setupAutoHeightWithBottomView:_CommentTitle bottomMargin:10];
        [_headerView layoutSubviews];
        btn.selected = YES;
    }else{
        _WordContentView.hidden = YES;
        [_WordBackView  setupAutoHeightWithBottomView:_WordContentBtn bottomMargin:0];
//        self.headerView.height = self.headerView.height-(30+_WordContentMessageHeight) ;
        [_headerView setupAutoHeightWithBottomView:_CommentTitle bottomMargin:10];
        [_headerView layoutSubviews];
        btn.selected = NO;
    }
    
    [_timeLabel  updateLayout];
    [_headerView  updateLayout];
    [self.headerView layoutSubviews];
    [_ConsulationTableView setTableHeaderView:_headerView];
    
    NSLog(@"点击后的高度%f",self.headerView.height);
}

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
    [_presenter addExpertComment:_dpTextView.text Stars:_stars ConsultationID:@(_presenter.question.uuiD) ExpertID:@(_presenter.question.Expert_ID)];
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



#pragma mark---键盘相关点击事件
#pragma mark * 点击键盘上的toolbar
- (void)clickToolBar:(UIButton*) bt{
    if(self.textView.inputView)self.textView.inputView = nil;
      [self.textView  becomeFirstResponder];
    if(bt.tag == 101){
        NSLog(@"点击添加");
        self.addInputView = nil;
        NSLog(@"点击添加时图片数量：%lu",self.collectDataSource.count);
        if (self.collectDataSource.count >1) {
            self.textView.inputView = self.SelectcollectView;
            bt.selected = NO;
        }else{
            self.textView.inputView = self.addInputView;
            bt.selected = YES;
        }
        NSLog(@"数量%lu",self.collectDataSource.count);
    }else if(bt.tag == 102){
        NSLog(@"点击表情");
        self.addButton.selected = NO;
        
        if(convertToSystemKeyboard){
            convertToSystemKeyboard = NO;
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
            
        }else{
            convertToSystemKeyboard = YES;
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
            self.faceInputView = nil;
            self.textView.inputView = self.faceInputView;
            
        }
    }else if(bt.tag == 103){
        NSMutableString* mutableStr  = [NSMutableString string];
        [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            EmotionTextAttachment* attach = attrs[@"NSAttachment"];
            if(attach){
                //表情
                [mutableStr appendString:attach.emotionTag];
            }else{
                //拼接文本
                NSAttributedString* temp = [self.textView.attributedText attributedSubstringFromRange:range];
                [mutableStr appendString:temp.string];
            }
        }];
        
        NSString* consultation = mutableStr;
        NSLog(@"%@",consultation);
        NSLog(@"%@",self.collectDataSource);
        
        //上传图片
        if(self.collectDataSource.count == 1||self.collectDataSource.count ==0){
            //没选照片，直接走发布接口
            [ProgressUtil show];
    [self.presenter  commitConsultation:@"" ConsultationID:[self.UUID  integerValue] CommentContent:consultation];
        }else{
            [ProgressUtil showWithStatus:@"正在上传照片..."];
        [self.presenter  ConsultationPost:self.collectDataSource ConsultationID:[self.UUID  integerValue] CommentContent:consultation];
            [self.collectDataSource  removeAllObjects];
            [_collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
        }
        [self.textView  endEditing:YES];
        self.textView.text = nil;
        self.textView.placeholder = @"我来说两句";
         [self.collect reloadData];
        self.photoNumLabel.hidden = YES;
        self.circlebtn.hidden = YES;
        self.sendButton.selected = NO;
        self.sendButton.userInteractionEnabled = NO;
        [self.textView   resignFirstResponder];
        
         [self textViewDidChange:_textView];
        
        
#pragma 打点统计*问题详情页面->评论
[BasePresenter  EventStatisticalDotTitle:DotHotQuestionSend Action:DotEventEnter  Remark:nil];

        
    }
    [self.textView reloadInputViews];
    
  
    
}
#pragma mark * 点击键盘上的选择图片
- (void)clickInputViewCameraAction{
    [self.textView resignFirstResponder];
    self.addButton.selected = NO;
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    
    NSInteger maxPhotoNumber = 0;
    if(self.collectDataSource.count == 1){
        maxPhotoNumber = 3;
    }else if(self.collectDataSource.count == 2){
        maxPhotoNumber = 2;
    }else if(self.collectDataSource.count == 3){
        maxPhotoNumber = 1;
    }
    
    manager.maxSelectedPhotoNumber = maxPhotoNumber;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        if(medias.count != 0){
            [ws.collectDataSource removeLastObject];
        }
        
        for (CorePhoto *photo in medias) {
            [ws.collectDataSource addObject:photo.editedImage];
        }
        
        if(ws.collectDataSource.count >= 1 && ws.collectDataSource.count <= 3){
            [ws.collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
        }
        
        ws.photoNumLabel.hidden = ws.collectDataSource.count == 1;
        if(ws.collectDataSource.count != 1){
            ws.photoNumLabel.text = [NSString stringWithFormat:@"%ld/3",ws.collectDataSource.count -1];
            ws.circleTitle.text = [NSString stringWithFormat:@"%ld",ws.collectDataSource.count -1];
            self.circlebtn.hidden =   NO;
        }
        
        [ws.collect reloadData];
    };
    NSLog(@"选择照片数量1：%lu",self.collectDataSource.count);
        [self presentViewController:pickerVC animated:YES completion:nil];
    isCamera = YES;
    NSLog(@"图片");
    
    
    //    }else{
    //    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //    //设置类型
    //    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeCamera;
    //
    //    //错误处理
    //    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
    //        NSLog(@"设备不可用");
    //        return;
    //    }
    //
    //    UIViewController *pickerVC=manager.imagePickerController;
    //    WS(ws);
    //    //选取结束
    //    manager.finishPickingMedia=^(NSArray *medias){
    //
    //        if(medias.count != 0){
    //            [ws.collectDataSource removeLastObject];
    //        }
    //
    //        for (CorePhoto *photo in medias) {
    //            [ws.collectDataSource addObject:photo.editedImage];
    //        }
    //
    //        if(ws.collectDataSource.count >= 1 && ws.collectDataSource.count <= 3){
    //            [ws.collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
    //        }
    //
    //        ws.photoNumLabel.hidden = ws.collectDataSource.count == 1;
    //        if(ws.collectDataSource.count != 1){
    //            ws.photoNumLabel.text = [NSString stringWithFormat:@"%ld/3",ws.collectDataSource.count -1];
    //        }
    //
    //
    //        [ws.collect reloadData];
    //    };
    // [self presentViewController:pickerVC animated:YES completion:nil];
    //    }
}
#pragma mark * 点击键盘上的选择表情
- (void)clickEmotionAction:(UIButton*) emotionbt{
    NSInteger index = emotionbt.tag - 200;
    NSDictionary* emotionDic = self.defaultEmotionArray[index];
    NSString  *emotion= [emotionDic valueForKey:@"tag"];

        if(!self.textView.text || self.textView.text.length == 0){
            self.textView.text = emotion;
        }else{
            NSMutableString* mutableStr = [NSMutableString stringWithString:self.textView.text];
            [mutableStr appendString:emotion];
    
            self.textView.text = mutableStr;
        }
    if (self.textView.text!=nil&& self.textView.text.length!=0) {
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
        
    }else{
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
    }
    NSLog(@"点击表情");
    NSLog(@"%@",self.textView.text);

}
#pragma mark * 删除表情
- (void)deleteFaceAction{
    [self.textView deleteBackward];
    
    
    if (self.textView.text!=nil&& self.textView.text.length!=0) {
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
        
    }else{
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
    }
    
    NSLog(@"删除表情");
    NSLog(@"%@",self.textView.text);
    
}
#pragma mark * 删除图片
-(void)clickDeleteHotPhotos:(HotPhotoCollectionViewCell*_Nonnull)photocell{
    NSIndexPath* indexPath = [self.collect indexPathForCell:photocell];
    if(self.collectDataSource.count > 1){
        
        if(self.collectDataSource.count == 2){
            [self.collectDataSource replaceObjectAtIndex:self.collectDataSource.count - 1 withObject:[UIImage imageNamed:@"circle_add_icon"]];
        }
        [self.collectDataSource removeObjectAtIndex:indexPath.item];
        
        self.photoNumLabel.text = [NSString stringWithFormat:@"%ld/3",self.collectDataSource.count -1];
        
        NSLog(@"显示：%lu",self.collectDataSource.count );
        if (self.collectDataSource.count == 1) {
        self.circlebtn.hidden = YES;
        self.addButton.selected = YES;
      if(self.textView.inputView)self.textView.inputView = nil;
        self.addInputView = nil;
        self.SelectcollectView = nil;
        self.textView.inputView = self.addInputView;
        [self.textView  reloadInputViews];

        }else{
        self.circleTitle.text =[NSString stringWithFormat:@"%ld",self.collectDataSource.count -1];
        }
        if(self.collectDataSource.count == 1){
            self.photoNumLabel.hidden = YES;
        }
        
        [self.collect reloadData];
    }
}

#pragma mark * textViewDidChange文本框改变监听
- (void)textViewDidChange:(UITextView *)textView
{
    
    
//    if (textView.text != nil||textView.text.length !=0) {
//        self.sendButton.userInteractionEnabled = YES;
//        self.sendButton.selected = YES;
//
//    }
//    if (textView.text.length == 0) {
//        
//        self.sendButton.userInteractionEnabled = NO;
//        self.sendButton.selected = NO;
//    }
    
    NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString=[textView.text stringByTrimmingCharactersInSet:set];
    if (trimedString.length==0) {
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
        
    }else{
        
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
    }
    
    CGFloat height = [JMFoundation calLabelHeight:textView.font andStr:textView.text withWidth:textView.width];
    if (ReplyView.height == 100) {
        if (textView.text.length > 0) {
            return;
        }
    }
    if (height > textView.height) {
        textView.sd_layout.heightIs(textView.height+25);
        ReplyView.sd_layout.heightIs(ReplyView.height+25);
        if (textView.height > 80) {
            textView.height = 80;
            ReplyView.sd_layout.heightIs(100);
        }
    }
    if ([textView.text isEqualToString:@""] || textView.text == nil || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"\n"]) {
        self.textView.placeholderLabel.hidden = NO;
        self.textView.placeholder = @"我来说两句";
        textView.sd_layout.heightIs(38);
        ReplyView.sd_layout.heightIs(50);
        
    }
    

    
}
#pragma mark * keyboardWillHide监听
- (void)HotDetailConsulationkeyboardWillHide:(NSNotification*)notification{
    
    convertToSystemKeyboard = NO;
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
    if(self.textView.inputView)self.textView.inputView = nil;
    self.faceInputView = nil;
    self.textView.inputView = nil;
    self.addButton.selected = NO;
    NSLog(@"隐藏键盘");
    
    
    
}
#pragma mark * 监听点击用户头像
- (void)clickBabyIconWithConsultationCommenList:(ConsultationCommenList* _Nonnull) commenList{
    
        NSLog(@"点击了用户头像－－%ld",(long)commenList.UserID);
    if ((long)commenList.UserID == kCurrentUser.userId) {
        [ProgressUtil showError:@"不能与自己私聊"];
        return;
    }
    ChatViewController *vc = [ChatViewController new];

    vc.chatType = ChatTypeSingal;
    vc.ReceiveUserID = commenList.UserID;
    vc.nickName = commenList.NickName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 监听通知回调
- (void)refreshConsulationList{
    [_ConsulationTableView.mj_header beginRefreshing];
}


#pragma mark * 切换表情
-(void)defaultButton:(UIButton*)btn{
    if (btn.tag == 108) {

        NSLog(@"默认");

        if(self.textView.inputView)self.textView.inputView = nil;
        self.faceInputView = nil;
        [_defaultEmotionArray removeAllObjects];
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        [_defaultEmotionArray removeObjectsInRange:NSMakeRange(30, 6)];
        self.textView.inputView = self.faceInputView;
        [self.textView reloadInputViews];
        self.defaultImageBt.backgroundColor = UIColorFromRGB(0XF2F2F2);
        self.selecImageBt.backgroundColor = [UIColor  whiteColor];
        
    }else{

        NSLog(@"选中");

    if(self.textView.inputView)self.textView.inputView = nil;
        self.faceInputView = nil;
        [_defaultEmotionArray removeAllObjects];
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        [_defaultEmotionArray removeObjectsInRange:NSMakeRange(0, 30)];
        self.textView.inputView = self.faceInputView;
        [self.textView reloadInputViews];
        self.defaultImageBt.backgroundColor = [UIColor  whiteColor];
        self.selecImageBt.backgroundColor =UIColorFromRGB(0XF2F2F2);
        
    }
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
  
    
    [kdefaultCenter removeObserver:self name:Notification_RefreshConsulationList object:nil];
    [kdefaultCenter removeObserver:self name:@"half" object:nil];
    [kdefaultCenter removeObserver:self name:Notification_RefreshDoctorQuestionDetail object:nil];

    
}

#pragma mark -- scroll代理-- 修改
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x / kScreenWidth == (int)(scrollView.contentOffset.x / kScreenWidth)){
        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    }
  
    if([scrollView isEqual:self.ConsulationTableView]){
        if([ReplyView.textView isFirstResponder]){
            [ReplyView.textView resignFirstResponder];
        }
        
        if([ReplyView.unUsedTextView isFirstResponder]){
            [ReplyView.unUsedTextView resignFirstResponder];
        }
        
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.textView resignFirstResponder];
        NSLog(@"tableview滑动");
    }

}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"热门咨询详情页"];
    if (isCamera == YES) {
        [self.textView becomeFirstResponder];
        if(self.textView.inputView)self.textView.inputView = nil;
        self.addInputView = nil;
        self.textView.inputView = self.SelectcollectView;
        [self.textView reloadInputViews];
    }
    isCamera = NO;
    self.view.backgroundColor = [UIColor  whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HotDetailConsulationkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self setupHeadView];
    

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"热门咨询详情页"];
    
    if ([[NSString  stringWithFormat:@"%ld",self.presenter.question.IsFree ] isEqualToString:@"1"]&&_presenter.isPlaying == YES) {
        [_presenter  FreeListeningCountWithConsultationID:[self.UUID  integerValue]];
    }
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    
    if(self.textView.inputView){
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
    }
    
      [_player playerStop];

 [kdefaultCenter removeObserver:self name:Notification_RefreshDoctorQuestionDetail object:nil];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [_ConsulationTableView.mj_header beginRefreshing];
}

-(void)rightItemAction:(id)sender{
    
#pragma 打点统计*问题详情页面->问题详情页面->分享
    [BasePresenter  EventStatisticalDotTitle:DotHotQuestionShare Action:DotEventEnter  Remark:nil];
    
    NSLog(@"分享");
    if ([_textView  isFirstResponder]) {
        
        [_textView  resignFirstResponder];
    }

    if (_doctorImageView.image !=nil) {

        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%ld",URL_SHARE_CONSULATION,[self.UUID  integerValue]];
        
        
        if (imageArray) {
            NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
            
            NSString  *title = [NSString  stringWithFormat:@"%@医师回答[%@]的问题",self.presenter.expertAnswer[0].doctorName,self.presenter.question.ConsultationContent];
            
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
    }else {
        [ProgressUtil showInfo:@"正在加载,请稍后"];
    }
}
-(void)PayAskMoreComepleteRefreshHotHearder{

    self.presenter.question.IsListen = 1;

    [self  setupHeadView];


    NSLog(@"刷新本页面数据");


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark * 点击工具条获取图片代理
-(void)clickAddPhotoCompleteHandler:(Complete)complete{
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    
    NSInteger maxPhotoNumber = 0;
    if(ReplyView.imageDataSource.count == 1){
        maxPhotoNumber = 5;
    }else if(ReplyView.imageDataSource.count == 2){
        maxPhotoNumber = 4;
    }else if(ReplyView.imageDataSource.count == 3){
        maxPhotoNumber = 3;
    }else if(ReplyView.imageDataSource.count == 4){
        maxPhotoNumber = 2;
    }else if(ReplyView.imageDataSource.count == 5){
        maxPhotoNumber = 1;
    }else if(ReplyView.imageDataSource.count == 6){
        maxPhotoNumber = 0;
    }
    else{
        maxPhotoNumber = 6;
    }
    manager.maxSelectedPhotoNumber = maxPhotoNumber;
    
    
    //    manager.maxSelectedPhotoNumber = 3;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    //    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        NSMutableArray* imageDataSource = [NSMutableArray array];
        for (CorePhoto *photo in medias) {
            [imageDataSource addObject:photo.editedImage];
        }
        
        if(complete){
            complete(imageDataSource);
        }
        isCamera = YES;
    };
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}
#pragma mark * 发送评论代理
-(void)sendCommitPostWith:(BOOL)isNeedUploadPImage content:(NSString *)consultation imageDataSource:(NSMutableArray * _Nonnull)imageDataSource{
    
    NSLog(@"这个是--  -- %@-%@",consultation,imageDataSource);
    if(isNeedUploadPImage){
        //先上传图片
        [ProgressUtil showWithStatus:@"正在上传照片..."];
        [self.presenter  ConsultationPost:imageDataSource ConsultationID:[self.UUID  integerValue] CommentContent:consultation];
        
        
    }else{
        //直接走发送评论接口
        
        [ProgressUtil show];
        [self.presenter  commitConsultation:@"" ConsultationID:[self.UUID  integerValue] CommentContent:consultation];
        
    }
    
    
}



@end
