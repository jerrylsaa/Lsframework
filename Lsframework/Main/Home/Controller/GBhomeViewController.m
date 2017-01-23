//
//  GBhomeViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBhomeViewController.h"
#import<Photos/Photos.h>
#import "GBexpertTableViewCell.h"
#import "HExpertAnswerViewController.h"
#import "HEAInfoViewController.h"
#import "ExpertAnswerEntity.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

#import "UITableView+FDTemplateLayoutCell.h"
#import "ConsultationDoctorViewController.h"
#import "FPLabel.h"
#import <RongIMKit/RCConversationViewController.h>
#import "HomePresenter.h"
#import "HomeCollectionViewCell.h"
#import "HomeLayout.h"
#import "MedicalServiceViewController.h"
#import "UploadDemo.h"
#import "FollowUpMainViewController.h"
#import "BSHealthRecordViewController.h"
#import "HealthTeachViewController.h"
#import "ArchivesRecordViewController.h"
#import "HomeDailyRecordViewController.h"
#import "BabayArchList.h"
#import "CorePhotoPickerVCManager.h"
#import "UIImage+Category.h"
#import "DefaultChildEntity.h"
#import "ArchivesMainViewController.h"
#import <UIImageView+WebCache.h>
#import "HealthServiceViewController.h"
#import "SFHealthRecordViewController.h"
#import "EventRemindViewController.h"
#import "CaseInfoViewController.h"
#import "JMChatViewController.h"
#import "HExpertAnswerViewController.h"   //专家分答
#import"HRHealthAssessmentViewController.h" //健康测评
#import"PersonFileViewController.h"   //个人档案
#import "GBHealthServiceViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ConfiguresEntity.h"
#import "HMenuCollectionViewCell.h"
#import "OutPatientAppointViewController.h"
#import "ScanQRCodeViewController.h"
#import "ArchivesMainViewController.h"
#import "VaccineViewController.h"
#import "AVRecorderPlayerManager.h"

#import "CouponEnity.h"

#import "CouponViewController.h"

#import "HotQuestionView.h"
#import "ECouponViewController.h"
#import "DailyViewController.h"

#import "DailyFirstArticle.h"
#import "DailyArticleViewController.h"

#import "HWViewController.h"
#import "ExpertAndConsultationViewController.h"
#import "DailyArticleMoreViewController.h"
#import "VaccinePlaneViewController.h"
#import "GBDailyRemindViewController.h"
#import "PatientCaseController.h"
#import "HHealthServiceViewController.h"

#import "BindHospitalViewController.h"

#import "LCSearchBarView.h"
#import "GBSearchViewController.h"
#import "DietManagerViewController.h"
#import "ActivityDetailViewController.h"
#import "AppraiseCollectionViewCell.h"
#import "HealthServicePresenter.h"
#import "GBHealthServiceInfoViewController.h"
#import "ChatListViewController.h"
#import "MoreFunctionViewController.h"
#import "GBHealthSucceedViewController.h"

#import "NewMessageViewController.h"

enum : NSUInteger {
    personalArchivesBtn,
    goToReportBtn,
    healthEvaluationBtn,
    goToDoctorBtn,
    healthRecordBtn,
    healthTeachBtn,
    expertAnswerBtn,
}BtnType;

//#define kColumn 3
//#define KW   35
//#define KW_WIDTH    ([[UIScreen mainScreen] bounds].size.width-KW*4)/kColumn
//#define KW_HEIGHT KW_WIDTH

#define kColumn 3
#define KW   33
#define KW_WIDTH    (([[UIScreen mainScreen] bounds].size.width-KW*4)/kColumn)
#define KW_HEIGHT (KW_WIDTH+18)


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && (SCREEN_MAX_LENGTH < 568.0))
#define IS_IPHONE_5 (IS_IPHONE && (SCREEN_MAX_LENGTH == 568.0))
#define IS_IPHONE_6 (IS_IPHONE && (SCREEN_MAX_LENGTH == 667.0))
#define IS_IPHONE_6P (IS_IPHONE && (SCREEN_MAX_LENGTH == 736.0))
#define DailyWidth  (kScreenWidth - 120-10)/3


#define KW_ItemWidth  (kScreenWidth-kFitWidthScale(290)-1)/2.0f
#define KW_ItemHeight  15+kFitHeightScale(90)+15+14+15
#define KW_ItemHeight2  (15+kFitHeightScale(90)+15+14+15)*2.0f




@interface GBhomeViewController ()<HomePresenterDelegate, UIScrollViewDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ScanQRCodeViewControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HealthServicePresenterDelegate>{

    UICollectionView* _collection;
    UIView    *_leftExpertView;
    UIImageView  *_leftExpertImageView;
    UILabel  *_leftExpertLb;
    UIView    *_menuLineView1;
    UIView    *_menuLineView2;
    UIView    *_menuLineView3;
    UIView    *_menuLineView4;
    UICollectionView* _AppraiseCollection;
    
    UIImageView *_middleLineIV;
    UIImageView *_middleStarIV;
    UIView    *_collectView;
    CGFloat    _ExpertTableHeight;
    NSUInteger  VaccineTime;
    
    UIView  *_CouponView;
    UIButton  *_CouponBtn;
    NSString  *CouponName;
    NSInteger  remberTime;
    NSNumber  *remberIndex;
    NSNumber  *remberCouponId;
    BOOL isFirst;
    NSString   *_DailyTime;
    NSString   *_DailyDevolopment;
    NSString   *_DailyGuild;
    NSString   *_DailyHy;
    BOOL issload;
    //每日必读
    UIView  *_DailyArticleView;
//    UIButton  *_DailytitleButton;
    UIImageView  *_DailyImageView;
    UILabel     *_DailyContentlb;
    UIButton     *_DailyLookCountBt;
    UIButton     *_DailyPraiseCountBt;
    UIButton     *_DailyCommonCountBt;
    UIButton    *_DailyArticleMoreBt;
    
    NSInteger   PraiseNumber;
    //活动
     UIView  *_ActivityView;
     UIButton  *_ActivityBtn;
    CLLocationManager *_locationManager;
}

@property (nonatomic, strong) HomePresenter * presenter;
@property (nonatomic, strong) HealthServicePresenter *Healthpresenter;


@property (nonatomic,copy) NSMutableString *openUrl;
@property (assign) NSInteger today;
@property (nonatomic,copy) NSMutableDictionary *dataDic;

@property (nonatomic, strong)  UIScrollView *ScrollView;

@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *expertView;
@property (nonatomic, strong)  UILabel *expertLb;
@property (nonatomic, strong)  UIButton *expertBt;
@property (nonatomic, strong)  UIButton *VaccineBt;
@property (nonatomic, strong)  UIImageView *imageChildAvatar;
@property (nonatomic, strong)  UIImageView *imageChild;
@property (nonatomic, strong)  UIButton *imageChildAvatarBtn;
@property (nonatomic, strong) UILabel *lbBabyName;
@property (nonatomic, strong) UIImageView *imageSex;
@property (nonatomic, strong) UILabel *buttonHeight;
@property (nonatomic, strong) UIView *heightTapView;
@property (nonatomic, strong) UILabel *btnWeight;
@property (nonatomic, strong) UIView *weightTapView;
@property (nonatomic, strong) UILabel *standardHeightLabel;
@property (nonatomic, strong) UILabel *standardWeightLabel;
@property (nonatomic, strong)  UIButton *imageChildDay;
@property (nonatomic, strong)  UIButton *imageChildinfo;

@property (nonatomic, strong)  UIView *emptyView;
@property (nonatomic, strong)  UIImageView *emptyImageChild;
@property (nonatomic, strong) UILabel *emptyInfoOne;
@property (nonatomic, strong) UILabel *emptyInfoTwo;
@property (nonatomic, strong)  UIButton *addBtn;

@property (nonatomic, strong)  UIView *bottomView;

@property(nonatomic,retain) UITableView* ExpertTable;
@property (nonatomic, strong) HotQuestionView *hotQuestionView;

@property (nonatomic, weak) UIButton *personalArchivesBtn; //个人档案
@property (nonatomic, weak) UIButton *goToReportBtn;  //查看报告
@property (nonatomic, weak) UIButton *healthEvaluationBtn;  //健康测评
@property (nonatomic, weak) UIButton *goToDoctorBtn;   //门诊预约
@property (nonatomic, weak) UIButton *healthRecordBtn;  //健康档案
@property (nonatomic, weak) UIButton *healthTeachBtn;  //健康教育
@property (nonatomic, weak) UIButton *expertAnswerBtn;  //专家分答

@property (nonatomic, strong) UILabel *personalArchivesLable; //个人档案
@property (nonatomic, strong) UILabel *goToReportLable;  //查看报告
@property (nonatomic, strong) UILabel *healthEvaluationLable;  //健康测评
@property (nonatomic, strong) UILabel *goToDoctorLable;   //门诊预约
@property (nonatomic, strong) UILabel *healthRecordLable;  //健康档案
@property (nonatomic, strong) UILabel *healthTeachLable;  //健康教育
@property (nonatomic, strong) UILabel *expertAnswerLable;  //专家分答

@property(nonatomic,retain) NSArray* dataSourceArray;
@property(nonatomic,retain) NSArray* vcArray;

@property(nonatomic,assign) BOOL isUpdateDeviceToken;

@property(nonatomic,retain) NSArray*   ExpertSourceArray;

@property(nonatomic,strong) UIView *screenAppraiseView;
@property(nonatomic,strong) UILabel *scrAprLabel;
@property(nonatomic,strong) UILabel *scrMessageLabel;
@property(nonatomic,strong) UIImageView *scrAprIV;
@property(nonatomic,strong) UIButton *scrBtn;

@property(nonatomic,strong) UIImageView *expertIV;

@property(nonatomic,strong) UIImageView *DailyArticleIV;
@property(nonatomic,strong) UILabel *DailyArticleLb;

@property(nullable,nonatomic,retain) UIButton* remindButton;
@property(nullable,nonatomic,retain) UIImageView* remindImageView;
@property(nullable,nonatomic,retain) UILabel* remindDayLabel;
@property(nullable,nonatomic,retain) UILabel* remindContentLabel;
@property(nonatomic,retain) NSString *qrCode;
@property(nonatomic,retain) NSString *qrCodeType;
@property(nonatomic,retain) NSString *qrCodeID;

@end

@implementation GBhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [self initBackBarWithImage:nil];
//    self.title = @"首页";  RedMessages@2x  GB_LeftMessageBar
//   [self leftBarCustomImg:[UIImage imageNamed:@"newsRedMessages"]];
    [_presenter getRedDot:^(BOOL success) {

        
        if (success == 1) {
            
            [self leftBarCustomImg:[UIImage imageNamed:@"newsRedMessages"]];
            
        }else{
            [self leftBarCustomImg:[UIImage imageNamed:@"GB_LeftMessageBar"]];

        }
      self.isHideTabbar = NO;
        
    }];
    
//    [self initBackBarWithImage:[UIImage imageNamed:@"newsRedMessages"]];
    [self initRightBarWithImage:[UIImage imageNamed:@"home_rightItem_qrcode"]];
    
    
    self.isHideTabbar = NO;
    
    kCurrentUser.needToUpdateChildInfo = YES;
    kCurrentUser.hotIsNeedReload = NO;
    //同步更新首页孩子信息
    kCurrentUser.needToUpdateChildInfo = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildAdvetar:) name:@"UPDATECHILD" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBaby:) name:Notification_Change_Baby object:nil];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshHomeHot:) name:Notification_RefreshHomePraiseHot object:nil];

    [kdefaultCenter addObserver:self selector:@selector(refreshDailayArticlePraiseCount) name:Notification_Refresh_DailyArticlePraiseCount object:nil];
    
    [kCurrentUser addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReshHealthServiceCount) name:Notification_RefreshHealthServiceCount object:nil];

#pragma mark   ********************_presenter调用事件******************
    #pragma mark----检查版本更新
    [self checkOnline];
    
    #pragma mark----上传设备token到服务器
    if (kCurrentUser.geTuiDeviceToken!=nil&&kCurrentUser.geTuiDeviceToken.length!=0) {
        NSLog(@"-1-1-1-1-1-1-1-1-1-1--1");
        [self insertDeviceToken];
    }

    /*******************/
    #pragma mark----加载热门咨询
    [_presenter getExperIDByUserID:^(BOOL isDoctor, NSString *message) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@(isDoctor) forKey:[NSString stringWithFormat:@"%dIsdoctorMineView",kCurrentUser.userId]];
    }];
    
    
    #pragma mark----名医推荐
    [_presenter  loadExpertData];
    
    #pragma mark---每日文章
    [_presenter  getDailyFirstArticle];

    #pragma mark---健康测评数据
    [_Healthpresenter  loadHealthService];

    #pragma mark---测评总数
    [_presenter GetEHRChildRecordCount];

    /**********************/

    
    if (kCurrentUser.userId ==0) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"账号已过期，请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag =1009;
        [alertView show];
        
    }
    
#pragma mark----活动页请求
    NSString *appVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_presenter  getFirstActivityVersion:@([appVersion integerValue])];
 
    
#pragma mark----下拉刷新页面
    WS(ws);
    _ScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        _ScrollView.userInteractionEnabled =NO;
        
        [_presenter getChildInfo];
        

        
        //名医推荐
        [_presenter  loadExpertData];
        
        //每日文章
        [_presenter  getDailyFirstArticle];
        
        //获取测评总数
        [_presenter GetEHRChildRecordCount];
        
        //健康测评数据
        [_Healthpresenter  loadHealthService];

        
        //加载热门咨询
        [_hotQuestionView loadData:^(CGFloat height) {
            ws.hotQuestionView.sd_layout.heightIs(height);
            [ws.ScrollView setupAutoHeightWithBottomView:ws.hotQuestionView bottomMargin:0];
            ws.hotQuestionView.totalHeight = height;
            kCurrentUser.hotIsNeedReload = YES;
        }];
        
    }];
   
}
#pragma mark **************************UI布局、约束*********************
-(void)setupView{
    
    _presenter = [HomePresenter  new];
    _presenter.delegate = self;
    
    _Healthpresenter = [HealthServicePresenter  new];
    _Healthpresenter.delegate = self;
    
    //搜索框
    LCSearchBarView* searchBarView = [LCSearchBarView new];
    searchBarView.frame = CGRectMake(0, 0, 512/2, 60/2);
    searchBarView.searchTextField.delegate = self;
    self.navigationItem.titleView = searchBarView;
    
    _ScrollView  = [UIScrollView  new];
    _ScrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view  addSubview:_ScrollView];
    
    _emptyView = [UIView  new];
    _emptyView.backgroundColor = UIColorFromRGB(0xffffff);
    [_ScrollView addSubview:_emptyView];
    
    
    
    //    _emptyImageChild = [UIImageView  new];
    //[_emptyImageChild  setImage:[UIImage  imageNamed:@"touxiang_normal"]];
    //    [_emptyView  addSubview:_emptyImageChild];
    //
    //    _emptyInfoOne = [UILabel new];
    //     _emptyInfoOne.text =  @"您还没有添加宝宝,";
    //    _emptyInfoOne.textAlignment = NSTextAlignmentCenter;
    //    _emptyInfoOne.textColor = UIColorFromRGB(0x00a7a0);
    //    _emptyInfoOne.font = [UIFont  systemFontOfSize:18];
    //    [_emptyView  addSubview: _emptyInfoOne];
    //
    //    _emptyInfoTwo = [UILabel new];
    //    _emptyInfoTwo.text =  @"添加后便可享受便捷的宝宝健康服务";
    //    _emptyInfoTwo.textAlignment = NSTextAlignmentCenter;
    //    _emptyInfoTwo.textColor = UIColorFromRGB(0x00a7a0);
    //    _emptyInfoTwo.font = [UIFont  systemFontOfSize:18];
    //    [_emptyView  addSubview: _emptyInfoTwo];
    //
    //
    //    _addBtn = [UIButton  new];
    //    [_addBtn  setImage:[UIImage  imageNamed:@"ButtonAdd"] forState:UIControlStateNormal];
    //  [_addBtn  addTarget:self action:@selector(addchildAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [_emptyView  addSubview:_addBtn];
    
    _collectView = [UIView  new];
    _collectView.backgroundColor = [UIColor  whiteColor];
    [_ScrollView   addSubview:_collectView];
    //
    //    _bottomView = [UIView  new];
    //    _bottomView.backgroundColor  = [UIColor  whiteColor];
    //    [_ScrollView addSubview:_bottomView];
    
    
    _menuLineView1 = [UIView new];
    _menuLineView1.backgroundColor = UIColorFromRGB(0xc8f1f0);
    [_collectView   addSubview:_menuLineView1];
    
    
    _menuLineView4 = [UIView new];
    _menuLineView4.backgroundColor = _menuLineView1.backgroundColor;
    [_collectView   addSubview:_menuLineView4];

    
    _leftExpertView = [UIView  new];
    _leftExpertView.backgroundColor = [UIColor  whiteColor];
    UITapGestureRecognizer *leftExpertTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftExpertAction)];
    [_leftExpertView   addGestureRecognizer:leftExpertTap];
    [_collectView   addSubview:_leftExpertView];
    
    
    
    _leftExpertImageView = [UIImageView  new];
    _leftExpertImageView.userInteractionEnabled = YES;
    _leftExpertImageView.backgroundColor = [UIColor  clearColor];
 _leftExpertImageView.image = [UIImage  imageNamed:@"GBhome_menu-answer"];
    [_leftExpertView  addSubview:_leftExpertImageView];
 
    _leftExpertLb = [UILabel new];
    _leftExpertLb.text = @"咨询专家";
    _leftExpertLb.textAlignment = NSTextAlignmentCenter;
    _leftExpertLb.font = [UIFont systemFontOfSize:16];
    _leftExpertLb.backgroundColor = [UIColor  clearColor];
    _leftExpertLb.textColor = UIColorFromRGB(0x666666);
    [_leftExpertView  addSubview:_leftExpertLb];

    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    CGFloat width = KW_WIDTH;
    //    CGFloat height = KW_HEIGHT;
    //    layout.itemSize = CGSizeMake(width,height);
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.tag = 1000;
    _collection.backgroundColor = [UIColor  clearColor];
    _collection.showsVerticalScrollIndicator = NO;
    _collection.scrollEnabled = NO;
    //    [_collection registerClass:[MineMenuCell class] forCellWithReuseIdentifier:@"menuCell"];
    [_collection registerClass:[HMenuCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectView addSubview:_collection];
    
//    _middleLineIV =[UIImageView new];
//    _middleLineIV.image =[UIImage imageNamed:@"collecitonmidLineIV"];
//    [_collectView addSubview:_middleLineIV];
//    
//    _middleStarIV =[UIImageView new];
//    _middleStarIV.image =[UIImage imageNamed:@"collecitonmidStarIV"];
//    [_collectView addSubview:_middleStarIV];
    //
    
    _menuLineView2 = [UIView new];
    _menuLineView2.backgroundColor = _menuLineView1.backgroundColor;
    [_collection   addSubview:_menuLineView2];
    
    _menuLineView3 = [UIView new];
    _menuLineView3.backgroundColor = _menuLineView1.backgroundColor;
    [_collection   addSubview:_menuLineView3];

    _topView = [UIView  new];
    _topView.backgroundColor = UIColorFromRGB(0xedfffd);
//    _topView.backgroundColor = [UIColor  whiteColor];
    _topView.clipsToBounds = NO;
    //    _topView.layer.masksToBounds = YES;
    [_collectView addSubview:_topView];
    
    UITapGestureRecognizer* clickDailyRemind = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HomeDaily)];
    [_topView addGestureRecognizer:clickDailyRemind];
    
    /**每日提醒***/
    UIButton* remind = [UIButton new];
    [remind setBackgroundImage:[UIImage imageNamed:@"mrtx_shape"] forState:UIControlStateNormal];
    remind.titleLabel.font = [UIFont systemFontOfSize:15];
    [remind setTitle:@"每日提醒" forState:UIControlStateNormal];
    [remind  addTarget:self action:@selector(HomeDaily) forControlEvents:UIControlEventTouchUpInside];
    [_collectView addSubview:remind];
    self.remindButton = remind;
    UIImageView* remindImageView = [UIImageView new];
    remindImageView.image = [UIImage imageNamed:@"green_shape"];
    remindImageView.userInteractionEnabled = YES;
    [_topView addSubview:remindImageView];
    self.remindImageView = remindImageView;
    UILabel* remindDayLabel = [UILabel new];
    remindDayLabel.textColor = UIColorFromRGB(0x00a7a0);
    remindDayLabel.font = [UIFont systemFontOfSize:midFont];
    [_topView addSubview:remindDayLabel];
    self.remindDayLabel = remindDayLabel;
    UILabel* remindContentLabel = [UILabel new];
    remindContentLabel.backgroundColor = [UIColor   clearColor];
    remindContentLabel.textColor = UIColorFromRGB(0x00a7a0);
    remindContentLabel.font = [UIFont systemFontOfSize:smidFont];
    [_topView addSubview:remindContentLabel];
    self.remindContentLabel = remindContentLabel;
    
    
    
//--------健康测评---------
//    _screenAppraiseView =[UIView new];
////    _screenAppraiseView.backgroundColor =UIColorFromRGB(0xf2f2f2);
//    [_ScrollView addSubview:_screenAppraiseView];
    
    
//    _scrAprIV =[UIImageView new];
//    _scrAprIV.image =[UIImage imageNamed:@"screenAppraiseIV.jpg"];
//    
//    _scrAprIV.contentMode =UIViewContentModeScaleAspectFill;
//    _scrAprIV.clipsToBounds =YES;
//    [_screenAppraiseView addSubview:_scrAprIV];
//    
//    _scrAprLabel =[UILabel new];
//    _scrAprLabel.numberOfLines =0;
//    _scrAprLabel.textColor =UIColorFromRGB(0xffffff);
//    _scrAprLabel.font =[UIFont systemFontOfSize:15];
//    _scrAprLabel.textAlignment =NSTextAlignmentCenter;
//    [_screenAppraiseView addSubview:_scrAprLabel];
//    
//    _scrBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_scrBtn setImage:[UIImage imageNamed:@"screenAppraiseBtn"] forState:UIControlStateNormal];
//    [_scrBtn addTarget:self action:@selector(screenAppraiseViewAction) forControlEvents:UIControlEventTouchUpInside];
//    [_screenAppraiseView addSubview:_scrBtn];
    
    
    
      //  --------健康测评---------
    _screenAppraiseView =[UIView new];
    _screenAppraiseView.backgroundColor = [UIColor  whiteColor];
    [_ScrollView addSubview:_screenAppraiseView];
    
    
    _scrAprLabel = [UILabel new];
    _scrAprLabel.text = @"宝宝健康测试";
    _scrAprLabel.textAlignment = NSTextAlignmentLeft;
    _scrAprLabel.font = [UIFont systemFontOfSize:15];
    _scrAprLabel.backgroundColor = [UIColor  clearColor];
    _scrAprLabel.textColor = UIColorFromRGB(0x2dcbc4);
    [_screenAppraiseView  addSubview:_scrAprLabel];
    
    _scrMessageLabel = [UILabel new];
    _scrMessageLabel.font = [UIFont systemFontOfSize:12];
    _scrMessageLabel.backgroundColor = [UIColor  clearColor];
    _scrMessageLabel.textAlignment = NSTextAlignmentLeft;
    _scrMessageLabel.textColor = UIColorFromRGB(0x999999);
    [_screenAppraiseView  addSubview:_scrMessageLabel];

    

    UICollectionViewFlowLayout* Appraiselayout = [UICollectionViewFlowLayout new];
    Appraiselayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _AppraiseCollection  = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:Appraiselayout];
    _AppraiseCollection.delegate = self;
    _AppraiseCollection.dataSource = self;
    _AppraiseCollection.tag = 1001;
    _AppraiseCollection.backgroundColor = [UIColor whiteColor];
    _AppraiseCollection.showsHorizontalScrollIndicator = NO;
    _AppraiseCollection.scrollEnabled = YES;
    [_AppraiseCollection registerClass:[AppraiseCollectionViewCell class] forCellWithReuseIdentifier:@"Appraisecell"];
    [_screenAppraiseView addSubview:_AppraiseCollection];

    
    
    
    //名医推荐
    _expertView = [UIView  new];
    _expertView.backgroundColor = UIColorFromRGB(0xffffff);
    [_ScrollView   addSubview:_expertView];
    
//    _expertIV =[UIImageView new];
//    _expertIV.image =[UIImage imageNamed:@"experticonimage"];
//    _expertIV.backgroundColor = [UIColor  clearColor];
//    [_expertView addSubview:_expertIV];
    
    _expertLb = [UILabel new];
    _expertLb.text = @"名医推荐";
    _expertLb.font = [UIFont systemFontOfSize:16];
    _expertLb.backgroundColor = [UIColor  clearColor];
    _expertLb.textColor = UIColorFromRGB(0x2dcbc4);
    [_expertView  addSubview:_expertLb];
    
    _expertBt = [UIButton  new];
    [_expertBt  setImage:[UIImage  imageNamed:@"Expert_MORE"] forState:UIControlStateNormal];
    _expertBt.backgroundColor = [UIColor  clearColor];
    _expertBt.tag = 102;
    [_expertBt  addTarget:self action:@selector(MoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [_expertView addSubview:_expertBt];
    
    
    _ExpertTable = [UITableView new];
    _ExpertTable.scrollEnabled =NO;
    _ExpertTable.delegate = self;
    _ExpertTable.dataSource = self;
    _ExpertTable.backgroundColor = [UIColor whiteColor];
    [_ExpertTable registerClass:[GBexpertTableViewCell class] forCellReuseIdentifier:@"cell"];
    _ExpertTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_ScrollView addSubview:_ExpertTable];
    
    
    
    
    //---------------热 点 问 题-----------------
    _hotQuestionView = [HotQuestionView new];
    [_ScrollView addSubview:_hotQuestionView];
    
    
    
    _imageChildDay = [UIButton  new];
    [_imageChildDay  setBackgroundImage:[UIImage  imageNamed:@"imageChildDay"] forState:UIControlStateNormal];
    _imageChildDay.titleLabel.numberOfLines = 2;
    //    [_imageChildDay  setTitle:@"0岁11月23天" forState:UIControlStateNormal];
    [_imageChildDay  addTarget:self action:@selector(HomeDaily) forControlEvents:UIControlEventTouchUpInside];
    _imageChildDay.titleLabel.textAlignment = NSTextAlignmentCenter;
    _imageChildDay.titleLabel.textColor  = [UIColor  whiteColor];
    _imageChildDay.titleLabel.font = [UIFont  systemFontOfSize:smallFont];
    _imageChildDay.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _imageChildDay.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_topView  addSubview:_imageChildDay];
    
    _imageChildinfo = [UIButton  new];
    [_imageChildinfo  setBackgroundImage:[UIImage  imageNamed:@"imageChildinfo"] forState:UIControlStateNormal];
    //    [_imageChildinfo  setTitle:@"宝宝的好奇心驱使TA在家里“探险”，每个角落都会去了解。" forState:UIControlStateNormal];
    [_imageChildinfo  addTarget:self action:@selector(HomeDaily) forControlEvents:UIControlEventTouchUpInside];
    _imageChildinfo.titleLabel.numberOfLines = 2;
    _imageChildinfo.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_imageChildinfo setTitleColor:UIColorFromRGB(0x00a7a0) forState:UIControlStateNormal];
    _imageChildinfo.titleLabel.font = [UIFont  systemFontOfSize:12];
    _imageChildinfo.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_topView  addSubview:_imageChildinfo];
    
    
    
    //    [self setupGoToReportBtn];//查看报告
    //    [self setupPersonalArchivesBtn];   //个人档案
    //    [self setupHealthEvaluationBtn];//健康测评
    //    [self setupGoToDoctorBtn];//门诊预约
    //    [self setupHealthRecordBtn]; //健康档案
    //    [self setupHealthTeachBtn]; //健康教育
    //    [self setupExpertAnswerBtn]; //专家分答
    
    //    [_presenter checkIsSignToady];
    _imageChild.layer.masksToBounds = YES;
    
    _imageChild.layer.cornerRadius = 160/4;
    _imageChildAvatar.userInteractionEnabled = YES;
    [_imageChildAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageChildAvatarTapAction:)]];
    _today = -1;
    [_ExpertTable  reloadData];
    
    [self configurationConstraint];
    
}

-(void)configurationConstraint{
    _ScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //    CGFloat collectHeight = kFitHeightScale(418);
    CGFloat collectHeight = KW_ItemHeight2;
    
    /******/
    
    //    _emptyView.sd_layout.topSpaceToView(_ScrollView,0).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0).heightIs(25);
    
    _collectView.sd_layout.topSpaceToView(_ScrollView,0).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0);
    
    
    _leftExpertView.sd_layout.topSpaceToView(_collectView,0).leftSpaceToView(_collectView,0).widthIs(kFitWidthScale(290)-1).heightIs(collectHeight);
    
    _menuLineView1.sd_layout.topSpaceToView(_collectView,5).leftSpaceToView(_leftExpertView,0).widthIs(1).heightIs(collectHeight-10);
    
    CGFloat  topSpace = (collectHeight-kFitHeightScale(150)-16-15)/2;
    _leftExpertImageView.sd_layout.centerXEqualToView(_leftExpertView).topSpaceToView(_leftExpertView,topSpace).heightIs(kFitHeightScale(150)).widthIs(kFitHeightScale(150));
    
    _leftExpertLb.sd_layout.topSpaceToView(_leftExpertImageView,15).centerXEqualToView(_leftExpertView).heightIs(16).widthIs([JMFoundation  calLabelWidth:_leftExpertLb]);
    
    _collection.sd_layout.topSpaceToView(_collectView,0).leftSpaceToView(_collectView,kFitWidthScale(290)).rightSpaceToView(_collectView,0).heightIs(collectHeight);
    
    
    _menuLineView2.sd_layout.topSpaceToView(_collection,KW_ItemHeight).leftSpaceToView(_collection,5).widthIs(kScreenWidth-kFitWidthScale(290)-10).heightIs(1);
    
    _menuLineView3.sd_layout.topSpaceToView(_collection,5).leftSpaceToView(_collection,KW_ItemWidth).widthIs(1).heightIs(collectHeight-10);
     _menuLineView4.sd_layout.topSpaceToView(_collection,0).leftSpaceToView(_collectView,5).rightSpaceToView(_collectView,5).heightIs(1);
    
//    _middleLineIV.sd_layout.leftSpaceToView(_collectView,25).rightSpaceToView(_collectView,25).topSpaceToView(_collectView,collectHeight/2.0f+14).heightIs(1);
//    _middleStarIV.sd_layout.centerXEqualToView(_collectView).centerYEqualToView(_middleLineIV).widthIs(26).heightIs(12);
    
    
    self.remindButton.sd_layout.topSpaceToView(_menuLineView4,30).centerXEqualToView(_collectView).widthIs(100).heightIs(25);
    
    _topView.sd_layout.topSpaceToView(self.remindButton,(-25/2.0)).leftSpaceToView(_collectView,15).rightSpaceToView(_collectView,15);
    _topView.sd_cornerRadius = @5;
    
    self.remindImageView.sd_layout.topSpaceToView(_topView,15 + 25 / 2.0).leftSpaceToView(_topView,15).widthIs(11/2.6).heightIs(13);
    
    self.remindDayLabel.sd_layout.topEqualToView(self.remindImageView).leftSpaceToView(self.remindImageView,7.5).rightSpaceToView(_topView,15).heightIs(15);
    self.remindContentLabel.sd_layout.topSpaceToView(self.remindDayLabel,5).autoHeightRatio(0).leftEqualToView(self.remindImageView).rightEqualToView(self.remindDayLabel);
    [_topView setupAutoHeightWithBottomView:self.remindContentLabel bottomMargin:5];
    

    
    [_collectView setupAutoHeightWithBottomView:_collection bottomMargin:20];
    
    _screenAppraiseView.sd_layout.topSpaceToView(_collectView,5).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0);
    
    CGFloat  scrAprLbWidth = [JMFoundation  calLabelWidth:[UIFont  systemFontOfSize:15] andStr:_scrAprLabel.text withHeight:16];
    
    _scrAprLabel.sd_layout.topSpaceToView(_screenAppraiseView,15).leftSpaceToView(_screenAppraiseView,15).widthIs(scrAprLbWidth).heightIs(16);

    _scrMessageLabel.sd_layout.topSpaceToView(_screenAppraiseView,15+(16-12)/2).leftSpaceToView(_scrAprLabel,10).widthIs(kScreenWidth-_scrAprLabel.size.width).heightIs(12);
    
    
    _AppraiseCollection.sd_layout.topSpaceToView(_scrAprLabel,15).leftSpaceToView(_screenAppraiseView,0).rightSpaceToView(_screenAppraiseView,0).heightIs(90);
    
    
    [_screenAppraiseView  setupAutoHeightWithBottomView:_AppraiseCollection bottomMargin:15];
    
    
    
    
    _expertView.sd_layout.topSpaceToView(_screenAppraiseView,5).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0).heightIs(28.5);
    
//    _expertIV.sd_layout.leftSpaceToView(_expertView,10).centerYEqualToView(_expertView).widthIs(27).heightIs(27);
    
    _expertLb.sd_layout.topSpaceToView(_expertView,12.5f).leftSpaceToView(_expertView,15).heightIs(16).widthIs(80);
    
    _expertBt.sd_layout.topSpaceToView(_expertView,8.0f).rightSpaceToView(_expertView,0).heightIs(48/2).widthIs(186/2);
    
    _ExpertTable.sd_layout.topSpaceToView(_expertView,0).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0).heightIs(3*169.675964+12.5);
    
    
    _hotQuestionView.sd_layout.leftSpaceToView(_ScrollView,0).topSpaceToView(_ExpertTable,5).rightSpaceToView(_ScrollView,0);
    //    [_ScrollView setupAutoContentSizeWithBottomView:_hotQuestionView bottomMargin:0];
    //    WS(ws);
    ////    NSLog(@"是否加载：%d",_hotQuestionView.isLoad)
    //
    ////    if (_hotQuestionView.isLoad == YES) {
    //    NSLog(@"是否加载：%d",issload);
    //    if (issload== YES) {
    //
    //        _hotQuestionView.sd_layout.heightIs(_hotQuestionView.totalHeight);
    //        [_ScrollView setupAutoHeightWithBottomView:ws.hotQuestionView bottomMargin:0];
    //    }else{
    //    WS(ws);
    //        [_hotQuestionView loadData:^(CGFloat height) {
    //            ws.hotQuestionView.sd_layout.heightIs(height);
    //            [ws.ScrollView setupAutoHeightWithBottomView:ws.hotQuestionView bottomMargin:0];
    //            ws.hotQuestionView.totalHeight = height;
    //            ws.hotQuestionView.isLoad = YES;
    //        }];
    //    }
    //    _collection.backgroundColor = [UIColor greenColor];
    //    _ScrollView.backgroundColor = [UIColor blueColor];
}

#pragma mark **********************通知事件**************************
#pragma mark   *监听刷新首页点赞数量
- (void)refreshDailayArticlePraiseCount{
     [_presenter  getDailyFirstArticle];
    [_DailyPraiseCountBt  updateLayout];
}
#pragma mark   * 监听刷新本页面点赞
- (void)refreshHomeHot:(NSNotification *)notification{
  kCurrentUser.hotIsNeedReload = NO;
}
#pragma mark    *编辑宝宝后更新首页

- (void)updateChildAdvetar:(NSNotification*) notice{
    NSLog(@"更新宝宝1111");
    [_presenter updateChildInfo];
}
#pragma mark   *监听切换宝宝首页刷新数据
- (void)changeBaby:(NSNotification*) notice{
    WSLog(@"切换宝宝");
    NSDictionary* userInfo = notice.userInfo;
    BabayArchList* baby = [userInfo objectForKey:@"baby"];
    [ProgressUtil showWithStatus:@"正在加载宝贝信息"];
    [self.presenter setDefaultBaby:baby];
    
}
#pragma mark   *健康测评结束后刷新测评数量
-(void)ReshHealthServiceCount{
    
   [_presenter GetEHRChildRecordCount];
    
}

#pragma mark ***************HomePresenterDelegate****************

- (void)onGetEHRChildRecordCountCompletion:(BOOL)success info:(NSInteger)message{
    if (success) {
//        _scrAprLabel.text =[NSString stringWithFormat:@"已有%d位宝妈宝爸为宝宝进行测试了,赶快加入吧",message];
        _scrMessageLabel.text =[NSString stringWithFormat:@"已有%d位宝妈宝爸进行了测试",message];

    }
    
    
    
}



-(void)onChangeChildAvaterCompleted:(NSString *)path{
    
    [_imageChild setImage:[UIImage imageWithContentsOfFile:path]];
    [kdefaultCenter postNotificationName:Notification_synchronizeIcon object:nil userInfo:nil];
    
}
//获取当天的信息
/*
-(void)onGetAlertWithDay:(NSUInteger)day{
    
        [_imageChildinfo  setTitle:[NSString  stringWithFormat:@"%@",_presenter.birthDates[day].alert] forState:UIControlStateNormal];
        [_imageChildDay  setTitle:[NSString  stringWithFormat:@"%@",_presenter.birthDates[day].date] forState:UIControlStateNormal];

        
            });
}
 */
- (void)onGetAlertWithCompletion:(BOOL) success Day:(NSUInteger)day{
    if (success) {
//        [_imageChildinfo  setTitle:[NSString  stringWithFormat:@"%@",_presenter.birthDates[day].alert] forState:UIControlStateNormal];
//        [_imageChildDay  setTitle:[NSString  stringWithFormat:@"%@",_presenter.birthDates[day].date] forState:UIControlStateNormal];
        self.remindButton.hidden =NO;
        self.remindImageView.hidden =NO;
        self.remindContentLabel.hidden =NO;
        self.remindDayLabel.hidden =NO;
        _topView.hidden =NO;
        [_topView sd_clearAutoLayoutSettings];
        _topView.sd_layout.topSpaceToView(self.remindButton,(-25/2.0)).leftSpaceToView(_collectView,15).rightSpaceToView(_collectView,15);
        _topView.sd_cornerRadius = @5;
        self.remindButton.sd_layout.topSpaceToView(_menuLineView4,30).centerXEqualToView(_collectView).widthIs(100).heightIs(25);
        [_topView setupAutoHeightWithBottomView:self.remindContentLabel bottomMargin:5];
        
        
        
        [_collectView setupAutoHeightWithBottomView:_topView bottomMargin:20];
        [_collectView updateLayout];
        
        self.remindContentLabel.text = [NSString  stringWithFormat:@"%@",_presenter.alertEntity.alert];
        self.remindDayLabel.text =  [NSString  stringWithFormat:@"%@",_presenter.alertEntity.date];
        [self.remindDayLabel updateLayout];
        [_topView updateLayout];
        
        if ([[NSString stringWithFormat:@"%@", _presenter.alertEntity.StandardWeight] isEqualToString: @"<null>"]||[NSString stringWithFormat:@"%@", _presenter.alertEntity.StandardWeight].length == 0) {
            _standardHeightLabel.text =  nil;
            _standardWeightLabel.text =  nil;
        }else{
            _standardHeightLabel.text =[NSString stringWithFormat:@"%@cm    |",_presenter.alertEntity.StandardHeight];
            _standardWeightLabel.text =[NSString stringWithFormat:@"|   %@kg",_presenter.alertEntity.StandardWeight];
        }
        _standardHeightLabel.hidden = NO;
        _standardWeightLabel.hidden = NO;

      /*  _imageChildDay.hidden = NO;
        _imageChildinfo.hidden = NO;
    [_topView  setupAutoHeightWithBottomView:_imageChildinfo bottomMargin:10];

        [_topView  updateLayout];
        [_collectView  updateLayout];
        [_ScrollView  updateLayout];
       */
        
        [_topView  updateLayout];
        [_collectView  updateLayout];

        
    }else{
        _standardHeightLabel.hidden = YES;
        _standardWeightLabel.hidden = YES;
        [_imageChildinfo  setTitle:nil forState:UIControlStateNormal];
        [_imageChildDay  setTitle:nil forState:UIControlStateNormal];
        
        self.remindContentLabel.text = @"";
        self.remindDayLabel.text = @"";
        
        [self.remindDayLabel updateLayout];
        [_topView updateLayout];

        WSLog(@"hello=");
        
        /*
       _imageChildinfo.hidden = YES;
        _imageChildDay.hidden = YES;
        [_topView  setupAutoHeightWithBottomView:_lbBabyName bottomMargin:20];

        [_topView  updateLayout];
        [_collectView  updateLayout];
        [_ScrollView  updateLayout];
         */
        
//        self.remindContentLabel.text = @"";
//        self.remindDayLabel.text = @"";
//        
//        [_collectView setupAutoHeightWithBottomView:_collection bottomMargin:0];
//        
//        [_collectView updateLayout];
        self.remindContentLabel.text = @"";
        self.remindDayLabel.text = @"";
        self.remindButton.hidden =YES;
        self.remindImageView.hidden =YES;
        self.remindContentLabel.hidden =YES;
        self.remindDayLabel.hidden =YES;
        _topView.hidden =YES;
        [_topView sd_clearAutoLayoutSettings];
        _topView.sd_layout.topSpaceToView(self.remindButton,(-25/2.0)).leftSpaceToView(_collectView,15).rightSpaceToView(_collectView,15).heightIs(0);
        self.remindButton.sd_layout.topSpaceToView(_menuLineView4,30).centerXEqualToView(_collectView).widthIs(100).heightIs(25);
        //        _topView.sd_cornerRadius = @5;
        //        [self.remindDayLabel updateLayout];
        [_topView updateLayout];
        [_collectView sd_clearAutoLayoutSettings];
        _collectView.sd_layout.topSpaceToView(_ScrollView,0).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0);
        [_collectView setupAutoHeightWithBottomView:_collection bottomMargin:20];
        
        [_collectView updateLayout];
    
    }

}
//获取疫苗提醒
/*
- (void)onGetVaccineEventWithCompletion:(BOOL) success Day:(NSUInteger)day{
    if (success) {
        if (_presenter.VaccineSource.count != 0) {
            NSInteger Time=[_presenter.VaccineSource[0].Time integerValue];
            VaccineTime = Time - day;
            WSLog(@"疫苗接种倒计时天数：%ld",VaccineTime);
            if (VaccineTime >30 ) {
                _VaccineBt.hidden = YES;

            }else{
                _VaccineBt.hidden = NO;
//            _VaccineBt.sd_layout.topSpaceToView(_topView,0).rightSpaceToView(_topView,5/2).widthIs(89/2).heightIs(86/2);
                [_VaccineBt  setTitle:[NSString  stringWithFormat:@"%ld",VaccineTime] forState:UIControlStateNormal];
            }

        }else{
        _VaccineBt.hidden = YES;
        
        }
    }
}
*/

-(void)onGetChildInfoComplete:(BOOL)success today:(NSInteger)today{
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            _today = today;
            [_presenter getAlertWithDay:_today];
//            [_presenter  getVaccineEventWithDay:_today];
    ChildEntity * child = _presenter.childEntity;
    _buttonHeight.text =[NSString stringWithFormat:@"%@ cm", child.birthHeight];
    _btnWeight.text = [NSString stringWithFormat:@"%@ kg", child.birthWeight];
    _imageSex.image = [child.childSex isEqualToString:@"1"] ? [UIImage imageNamed:@"nan"] : [UIImage imageNamed:@"nv"];
    _lbBabyName.text = [NSString stringWithFormat:@"%@", child.childName];
      //设置头像
            UIImage* placeholderImage = nil;
            
            if(child.child_Img.length == 0){
                placeholderImage = [UIImage imageNamed:@"imageChild"];
            }
            [_imageChild sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,child.child_Img]] placeholderImage:placeholderImage];
        
            
        _emptyView.hidden = YES;
//            _topView.hidden = NO;
            
//            _collectView.sd_layout.topSpaceToView(_topView,0);
//            [_collectView updateLayout];

            [_topView updateLayout];
            [_collectView  updateLayout];
            
            [self.lbBabyName  updateLayout];
        });
        
//        [_collectView setupAutoHeightWithBottomView:_topView bottomMargin:15];
//        [_collectView updateLayout];
        
        
    }else{
//        _emptyView.hidden = NO;
//        _emptyInfoOne.text =  @"您还没有添加宝宝,";
//        _emptyInfoTwo.text =  @"添加后便可享受便捷的宝宝健康服务";
//        _topView.hidden = YES;
//        
//        _collectView.sd_layout.topSpaceToView(_emptyView,0);
//        [_collectView updateLayout];
        
        self.remindContentLabel.text = @"";
        self.remindDayLabel.text = @"";
        self.remindButton.hidden =YES;
        self.remindImageView.hidden =YES;
        self.remindContentLabel.hidden =YES;
        self.remindDayLabel.hidden =YES;
        _topView.hidden =YES;
        [_topView sd_clearAutoLayoutSettings];
        _topView.sd_layout.topSpaceToView(self.remindButton,(-25/2.0)).leftSpaceToView(_collectView,15).rightSpaceToView(_collectView,15).heightIs(0);
        self.remindButton.sd_layout.topSpaceToView(_menuLineView4,30).centerXEqualToView(_collectView).widthIs(100).heightIs(25);
//        _topView.sd_cornerRadius = @5;
//        [self.remindDayLabel updateLayout];
        [_topView updateLayout];
        
        [_collectView sd_clearAutoLayoutSettings];
        _collectView.sd_layout.topSpaceToView(_ScrollView,0).leftSpaceToView(_ScrollView,0).rightSpaceToView(_ScrollView,0);
        [_collectView setupAutoHeightWithBottomView:_collection bottomMargin:0];
        
        [_collectView updateLayout];


        
//        ArchivesMainViewController * vc = [ArchivesMainViewController new];
//        [self.navigationController pushViewController:vc animated:YES];

    }
    
}
/*
- (void)onLoadChildStandardInfoComplete:(BOOL)success withInfoDictionary:(NSDictionary *)infoDict {
    if (success) {
        NSLog(@"%@",infoDict);
        
//        dispatch_async(dispatch_get_main_queue(), ^(){
        
            if ([[NSString stringWithFormat:@"%@",[infoDict objectForKey:@"StandardHeight"]]  isEqualToString: @"<null>"]) {
            }else{
            _standardHeightLabel.text =[NSString stringWithFormat:@"%@cm    |",[infoDict objectForKey:@"StandardHeight"]];
            _standardWeightLabel.text =[NSString stringWithFormat:@"|   %@kg",[infoDict objectForKey:@"StandardWeight"]];
            }
//        });
    }else{
        _standardHeightLabel.text =  nil;
        _standardWeightLabel.text = nil;
    
    }
}
*/
-(void)onUpdateCompletion:(BOOL)success today:(NSInteger)today{
    dispatch_async(dispatch_get_main_queue(), ^(){
        _emptyInfoOne.text =@"网络不可用，请检查网络设置";
        _emptyInfoTwo.text =@"";
        _emptyView.hidden = NO;
//        _topView.hidden = YES;
    });

    
}
//每日必读回调
-(void)onGetDailyFirstArticleCompletion:(BOOL)success info:(NSString *)message{
    if (success) {
        if (_presenter.DailyFirstSource.count == 0) {
            
        }else{
            DailyFirstArticle  *model = _presenter.DailyFirstSource[0];
        [_DailyImageView  setImageWithUrl:model.Photo placeholderImage:nil];
    _DailyContentlb.text = model.Title;

   //文章点赞状态
if([model.IsPraise integerValue] == 0){
    //当前用户没有点过赞
  [_DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"Heart_icon"]  forState:UIControlStateNormal];
    }else{
        //当前用户点过赞
    [_DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"Heart_red_icon"]  forState:UIControlStateNormal];
    }
[_DailyCommonCountBt setTitle:[NSString  stringWithFormat:@"%@",model.CommonCount] forState:UIControlStateNormal];
 [_DailyLookCountBt setTitle:[NSString  stringWithFormat:@"%@",model.Clicks] forState:UIControlStateNormal];
[_DailyPraiseCountBt setTitle:[NSString  stringWithFormat:@"%@",model.PraiseCount] forState:UIControlStateNormal];
            
    if ([model.CommonCount integerValue] >=100) {
        
        [_DailyCommonCountBt setTitle:@"99+" forState:UIControlStateNormal];
        
    }else if ([model.Clicks integerValue] >=100){
        
     [_DailyLookCountBt setTitle:@"99+" forState:UIControlStateNormal];
    
    }else if ([model.PraiseCount integerValue] >=100){
        
       [_DailyPraiseCountBt setTitle:@"99+" forState:UIControlStateNormal];
        

    }
        }
        
        [_topView  updateLayout];
        [_collectView  updateLayout];

        
    }else{
    
        [ProgressUtil  showError:message];
    }
}


//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"点赞成功"];
         [_presenter  getDailyFirstArticle];
    }else{
        
        [ProgressUtil  showError:message];
    }
    
    
    
}

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"取消点赞成功"];
        
         [_presenter  getDailyFirstArticle];
    }else{
        
        [ProgressUtil  showError:message];
    }
    
}
//活动页回调
-(void)onGetFirstActivityInfoCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        if (_presenter.ActivitySource.count !=0) {
            NSLog(@"是否开展%@",_presenter.ActivitySource[0].IsOn);
            if ([_presenter.ActivitySource[0].IsOn isEqual:@(1)]) {
              
                [self  showActivityView];
            }
        }
    }else{
        
        [ProgressUtil  showError:message];
    }
    
}
-(void)setDefaultBabyCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [_presenter getChildInfo];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"确定");
        NSString *babyId =[[DefaultChildEntity defaultChild].babyID stringValue];
        
        NSDictionary * params = @{@"BabyID":babyId,@"DoctorID":self.qrCode};
        
        [[FPNetwork POST:@"SetBabyHospitalBind" withParams:params]  addCompleteHandler:^(FPResponse* response) {
            if(response.status ==200){
                
                [ProgressUtil showInfo:response.message];
                
            }
            else if (response.status ==500){
                
                [ProgressUtil showError:@"授权失败"];
            }
            else {
                [ProgressUtil showError:@"网络不可用"];
                
            }
            
        }];
        
        
    }else if (buttonIndex == 1) {
        NSLog(@"取消");
        
    }
}

-(void)onGetBindHospitalInfoSuccess:(BOOL)complete{
    if (complete) {
        if (_qrCodeID!=nil&&_presenter.hospitalEntity[0]!=nil) {
            
            BindHospitalViewController *vc =[BindHospitalViewController new];
            vc.type =_qrCodeType;
            vc.expertID =_qrCodeID;
            vc.hospitalEntity =_presenter.hospitalEntity[0];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [ProgressUtil showError:@"无法识别二维码"];
            
        }
    }
}

-(void)onScanDone:(NSString*)qrCode{
    [self.navigationController popViewControllerAnimated:NO];
    
    //判断字符是否包含某字符串；
    if (qrCode!=nil) {
        self.qrCode =qrCode;
    }else {
        [ProgressUtil showError:@"无法识别二维码"];
        return;
    }
    if ([qrCode rangeOfString:@"http://weixin.qq.com"].location != NSNotFound) {
        [ProgressUtil show];
        
        [_presenter bindWx2mlWithUrl:qrCode];
        
    }else{
        if ([qrCode rangeOfString:@"type"].location == NSNotFound) {
            NSLog(@"qrCode 不存在 type");
            if ([DefaultChildEntity defaultChild].babyID==nil) {
                
                [self.navigationController pushViewController:[ArchivesMainViewController new] animated:YES];
                
            }else{
                UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"提示：您确定将此页面的信息授权给当前医院及医生查看，该信息仅作医务使用。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                [sheet showInView:self.view];
            }

            
        } else{
            NSLog(@"qrCode 包含 type");
            

            NSArray *step1 = [qrCode componentsSeparatedByString:@"&"];
            for (NSString *string1 in step1) {
                if ([string1 rangeOfString:@"type"].location != NSNotFound) {
                    NSArray *step2 = [string1 componentsSeparatedByString:@"="];
                    for (NSString *string2 in step2) {
                        if ([string2 rangeOfString:@"type"].location == NSNotFound) {
                            _qrCodeType =string2;
                        }
                    }
                }
                else if ([string1 rangeOfString:@"id"].location != NSNotFound) {
                    NSArray *step2 = [string1 componentsSeparatedByString:@"="];
                    for (NSString *string2 in step2) {
                        if ([string2 rangeOfString:@"id"].location == NSNotFound) {
                            _qrCodeID =string2;
                        }
                    }
                }

            }
            
            if (_qrCodeID!=nil) {
                [ProgressUtil show];
                [_presenter getNewExpertDoctorInfoWithExpertID:_qrCodeID];
                return;
            }else {
                [ProgressUtil showError:@"无法识别二维码"];
                
            }
            
            

        }
    }
//    //字条串开始包含有某字符串
//    if ([string hasPrefix:@"hello"]) {
//        NSLog(@"string 包含 hello");
//    } else {
//        NSLog(@"string 不存在 hello");
//    }
//    
//    //字符串末尾有某字符串；
//    if ([string hasSuffix:@"martin"]) {
//        NSLog(@"string 包含 martin");
//    } else {
//        NSLog(@"string 不存在 martin");
//    }
    
    
}





//头像点击事件
-(void)imageChildAvatarTapAction:(id)sender{
 PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
if(status == PHAuthorizationStatusDenied || status ==PHAuthorizationStatusRestricted){
    
    NSLog(@"不允许访问");
    //无权限
    // 获取当前App的基本信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的手机相册",app_Name];

    UIAlertView* alertView= [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    alertView.tag =1003;
    [alertView show];
    }
    if (![DefaultChildEntity isHasDefaultChild]) {
        [ProgressUtil showInfo:@"请添加宝贝信息再上传头像"];
        return;
    }
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = 1;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        runOnBackground(^{
            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
                NSString * path = [photo.editedImage saveToLocal];
                [ws.presenter changeChildAvaterWithPath:path];
            }];
            
        });
        
    };
    [self.navigationController presentViewController:pickerVC animated:YES completion:nil];
}

-(void)onGetExpertListCompletion{
    
    _ExpertTable.userInteractionEnabled = YES;
    [_ExpertTable reloadData];
    
    [_ScrollView.mj_header endRefreshing];
    _ScrollView.userInteractionEnabled =YES;
}
- (void)onGetCouponListCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        if (_presenter.CouponDataSource.count == 0) {
            remberIndex =  nil;
            remberCouponId = nil;
        }else{
            if ([[NSString stringWithFormat:@"%@", _presenter.CouponDataSource[_presenter.CouponDataSource.count-1].IsClaim]  isEqualToString: @"1" ] ||[[NSString stringWithFormat:@"%@", _presenter.CouponDataSource[_presenter.CouponDataSource.count-1].IsClaim]  isEqualToString: @"2" ]) {
                remberIndex =  nil;
                remberCouponId = nil;
            }else{
                
                for (NSInteger  i=_presenter.CouponDataSource.count-1; i>=0; i--){
                    
                    if ([[NSString stringWithFormat:@"%@", _presenter.CouponDataSource[i].IsClaim]  isEqualToString: @"0" ]) {
                        //第一张优惠券可用
                        NSLog(@"优惠券可用");
                        NSLog(@"优惠券金额：%ld",_presenter.CouponDataSource[i].Money);
                        
                        
                        if (_presenter.CouponDataSource[i].Money == 10) {
                            CouponName = @"CouponImage_10";
                        }
                        if (_presenter.CouponDataSource[i].Money == 20) {
                            CouponName = @"CouponImage_20";
                        }
                        if (_presenter.CouponDataSource[i].Money == 30) {
                            CouponName = @"CouponImage_30";
                        }
                        if (_presenter.CouponDataSource[i].Money == 60) {
                            CouponName = @"CouponImage_60";
                        }
                        if (_presenter.CouponDataSource[i].Money == 100) {
                            CouponName = @"CouponImage_100";
                        }
                        remberIndex = [NSNumber  numberWithInteger:i];
                        remberCouponId = _presenter.CouponDataSource[i].couponID;
                    }
                }
            }
        }
        NSLog(@"id：%@",remberCouponId);
        NSLog(@"第几个：%@",remberIndex);
        
    }else{
        [ProgressUtil  showError:message];
    }
    //获取当前时间戳
    NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * str = [currentDate format2String:@"yyyy-MM-dd"];
    NSString * str1 =  [NSString   stringWithFormat:@"%@ 00:00:00",str];
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   *date=[formatter   dateFromString:str1];
    NSTimeInterval current=[date timeIntervalSince1970];
    NSInteger  currentTime  = current;
    NSLog(@"当前的时间：%d",currentTime);
    NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
    remberTime  =  [[user1 objectForKey:[NSString stringWithFormat:@"%ldRemberTimeeGBhomeView",(long)kCurrentUser.userId]] integerValue];
    NSInteger   a =  (currentTime - remberTime)/3600;
    NSLog(@"相差一天：%d",a);
    if ((currentTime - remberTime)/3600 >= 24) {
        if (remberCouponId != nil) {
            //            if (isFirst) {
            //            [self  showUserCouponView];
            //            }
        }
        
    }
}
- (void)onGetClaimCouponCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [self.navigationController  pushViewController:[CouponViewController  new] animated:YES];
    }else{
        
        [ProgressUtil  showError:message];
        
    }
    
    
    
}
- (void)LoadHealthonComplete:(BOOL) success info:(NSString*) info{
    if (success) {
        
    NSLog(@"健康测评数量%d",self.Healthpresenter.HealthSource.count);
        
        [_AppraiseCollection  reloadData];
    }else{
        
        [ProgressUtil  showError:info];
        
    }
    
    
}

#pragma mark *************tableview的代理(名医推荐)**************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.presenter.dataSource.count>3) {
        return 3;
    }
    
    return self.presenter.dataSource.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GBexpertTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.expertAnswer = [self.presenter.dataSource objectAtIndex:indexPath.row];
    ExpertAnswerEntity  *model = self.presenter.dataSource[indexPath.row];
    
    [cell  setExpertAnswer:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HEAInfoViewController* info = [HEAInfoViewController new];
    info.expertEntity = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:info animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _ExpertTableHeight =  [_ExpertTable cellHeightForIndexPath:indexPath model:self.presenter.dataSource[indexPath.row] keyPath:@"expertAnswer" cellClass:[GBexpertTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    NSLog(@"专家测评：%f",_ExpertTableHeight);
    return _ExpertTableHeight;


}
#pragma mark    *******************collectionview的代理**************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView.tag == 1000) {
      return 2;
    }else{
     return 1;
    
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1000) {
        if (section ==0) {
            return self.dataSourceArray.count-2;
        }
        return self.dataSourceArray.count-2;
    }else{
    NSLog(@"----健康测评数量%ld",self.Healthpresenter.HealthSource.count);
        return self.Healthpresenter.HealthSource.count;
    }
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1000) {

    if (indexPath.section==0) {
        HMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.imageHeight = kFitHeightScale(90);
       [cell initCellWith:self.dataSourceArray[indexPath.item]];
        return cell;
    }else {
        HMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.imageHeight = kFitHeightScale(90);
        [cell initCellWith:self.dataSourceArray[indexPath.item+2]];
        
        return cell;
    }
    }else{
        AppraiseCollectionViewCell* Apracell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Appraisecell" forIndexPath:indexPath];

        Apracell.HealthService = [self.Healthpresenter.HealthSource objectAtIndex:indexPath.row];
        return Apracell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //每个item的距边缘的距离
    if (collectionView.tag == 1000) {
    return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
    
    return   UIEdgeInsetsMake(0, 15, 0, 15);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item的大小
    if (collectionView.tag == 1000) {
  
        return CGSizeMake(KW_ItemWidth,KW_ItemHeight);
    }else{
    
     return CGSizeMake(120, 90);
    
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//每个section的距离
   if (collectionView.tag == 1000) {
       return 0;
    
   }else{
    return 15;
   }
}
//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //每个item之间的间距
     if (collectionView.tag == 1000) {
    if (section ==0) {
//        CGFloat kw =(([[UIScreen mainScreen] bounds].size.width-56。0f*3.0f-50.0f)/2.0f)-2.0f;
        

        return 0;
        
    }else{
//        CGFloat kws =(([[UIScreen mainScreen] bounds].size.width-60.0f*4.0f-50.0f)/3.0f)-2.0f;
        

        return 0;
    }
     }else{
     
         return  15;
     }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView.tag == 1000) {
    NSLog(@"MENU_____indexpath:%ld----section：%ld",indexPath.item,indexPath.section);
        
        NSDictionary *dic =[NSDictionary dictionary];
        if (indexPath.section ==0) {
            dic = self.dataSourceArray[indexPath.item];
            
        }else{
            dic = self.dataSourceArray[indexPath.item+2];
            
        }
        
        if([dic[@"title"] isEqualToString:@"膳食管理"]){
            
            //直接跳转到膳食管理
            
            DietManagerViewController *vc = [DietManagerViewController new];
            
            [self.navigationController pushViewController:vc animated:YES];
            #pragma 打点统计*膳食管理按钮
            [BasePresenter  EventStatisticalDotTitle:DotDietManager Action:DotEventEnter  Remark:nil];
  
            
            
        }else if ([dic[@"title"] isEqualToString:@"健康服务"]){
            //健康服务
            HHealthServiceViewController *vc = [HHealthServiceViewController new];
#pragma 打点统计*首页--健康服务按钮
            [BasePresenter  EventStatisticalDotTitle:DotHealthTeach Action:DotEventEnter  Remark:nil];

            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([dic[@"title"] isEqualToString:@"身高体重"]){
            //身高体重
            NSArray *entityArray = [DefaultChildEntity MR_findAll];
            
            if (entityArray.count > 0) {
                DefaultChildEntity *entity = entityArray.lastObject;
                NSLog(@"%@",entity.babyID);
                if ([entity.babyID intValue] != 0) {
                    
                    HWViewController *vc = [HWViewController new];
                    vc.bodyType = BodyTypeHeight;
                    [self.navigationController pushViewController:vc animated:YES];
        #pragma 打点统计*首页--身高体重
                    [BasePresenter  EventStatisticalDotTitle:DotHeightAndWeight Action:DotEventEnter  Remark:nil];

                }
            }else{
                [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
            }
            
            
            
        }else if ([dic[@"title"] isEqualToString:@"更多功能"]){
#pragma 打点统计*首页--更多

    [BasePresenter  EventStatisticalDotTitle:DotHomerMore Action:DotEventEnter  Remark:nil];
        [self.navigationController pushViewController:[[MoreFunctionViewController alloc] init] animated:YES];
        }

    }else{
        NSLog(@"indexpath:%ld----section：%ld",indexPath.item,indexPath.section);
        
        NSArray *entityArray = [DefaultChildEntity MR_findAll];
        if (entityArray.count > 0) {
            DefaultChildEntity *entity = entityArray.lastObject;
            if ([entity.babyID intValue] != 0) {
                
                GBHealthServiceInfoViewController  *vc = [GBHealthServiceInfoViewController new];
                HealthService *model =  [self.Healthpresenter.HealthSource objectAtIndex:indexPath.item];
                vc.healthService = model;
                vc.title = model.Name;
                vc.EvalName = model.Remark;
                vc.type = GBHealthServiceInfoTypeFromNormal;
                
                [self.navigationController pushViewController:vc animated:YES];
                
#pragma 打点统计*首页-->健康测评
                
                [BasePresenter  EventStatisticalDotTitle:DotHealthService Action:DotEventEnter  Remark:nil];

            }
        }else{
        [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
        }
    }
    
   

}





- (void)onBindWx2mlCompletion{

    [_presenter  loadExpertData];

}


#pragma mark ******************点击事件*********************

#pragma mark  *导航栏左侧按钮事件

-(void)leftBarCustomImg:(UIImage *)image
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [button addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)backItemAction:(id)sender{
    
//    JMChatViewController * vc  =[[JMChatViewController alloc] init];
//    
//    vc.conversationType = ConversationType_CUSTOMERSERVICE;
//    
//    vc.targetId = PUBLIC_SERVICE_KEY;
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    
//    ChatListViewController  *vc = [ChatListViewController new];
    NewMessageViewController *vc = [NewMessageViewController new];
    
    [self.navigationController  pushViewController:vc animated:YES];
    
    
}
#pragma mark *导航栏右侧事件(扫描二维码)
-(void)rightItemAction:(id)sender{
    
    
    ScanQRCodeViewController *qrCode = [[ScanQRCodeViewController alloc] init];
    qrCode.delegate =self;
    [self.navigationController pushViewController:qrCode animated:NO];
    
}

#pragma mark * textfield代理(首页搜索事件)
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //    WSLog(@"开始搜索");
    [textField resignFirstResponder];
    GBSearchViewController* searchVc = [GBSearchViewController new];
    searchVc.isBecomeFirstResponsder = YES;
    
    [self.navigationController pushViewController:searchVc animated:YES];
}


#pragma mark  *每日提醒事件
-(void)HomeDaily{
    

    
    GBDailyRemindViewController  *vc= [GBDailyRemindViewController  new];
    vc.time = _today;
    [self.navigationController  pushViewController:vc animated:YES];
#pragma 打点统计*首页-->每日提醒

    [BasePresenter  EventStatisticalDotTitle:DotHomeDailyRemind Action:DotEventEnter  Remark:nil];
 
    
}

#pragma mark *查看更多<名医推荐更多、热门咨询更多>

-(void)MoreClick:(UIButton*)btn{
 if (btn.tag == 102){
        //专家咨询查看更多
        ExpertAndConsultationViewController* expert = [ExpertAndConsultationViewController new];
        expert.segmentType = SegmentExpertType;
        
        [self.navigationController pushViewController:expert animated:YES];
        
    }
}
#pragma mark *咨询专家事件
-(void)leftExpertAction{
    ExpertAndConsultationViewController* expert = [ExpertAndConsultationViewController new];
    expert.segmentType = SegmentConsulationType;
#pragma 打点统计*首页-->咨询专家按钮

    [BasePresenter  EventStatisticalDotTitle:DotExpertConsulation Action:DotEventEnter  Remark:nil];

    [self.navigationController pushViewController:expert animated:YES];
    
    
}

#pragma mark *活动点击参加事件
-(void)ActivityClick{
    [UIView animateWithDuration:0.2 animations:^{
        _ActivityView.alpha =0;
    } completion:^(BOOL finished) {
        [_ActivityView removeFromSuperview];
    }];
    
    ActivityDetailViewController  *VC = [ActivityDetailViewController new];
    VC.url =[NSString  stringWithFormat:@"%@?userid=%ld", _presenter.ActivitySource[0].H5Url,kCurrentUser.userId];
    
    
    [self.navigationController  pushViewController:VC animated:YES];
    
}
-(void)showActivityView{
    
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    
    _ActivityView = [UIView  new];
    _ActivityView.backgroundColor = [UIColor  colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.45];
    _ActivityView.frame = window.bounds;
    _ActivityView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActivityView:)];
    [_ActivityView addGestureRecognizer:tap];
    [window addSubview:_ActivityView];
    
    
    UIImageView *ActivityImageView = [UIImageView  new];
    ActivityImageView.userInteractionEnabled = YES;
    ActivityImageView.backgroundColor = [UIColor  clearColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActivityAction:)];
    [ActivityImageView addGestureRecognizer:tap1];
    [_ActivityView  addSubview:ActivityImageView];
    
      [ActivityImageView sd_setImageWithURL:[NSURL URLWithString:_presenter.ActivitySource[0].Activity_iconUrl]  placeholderImage:nil];
    
     CGSize  ImageSize =  [JMFoundation  GetImageSizeWithURL:_presenter.ActivitySource[0].Activity_iconUrl];
    
    NSLog(@"图片尺寸：%f---%f",ImageSize.width,ImageSize.height);
    
    
    ActivityImageView.sd_layout.centerXEqualToView(_ActivityView).centerYEqualToView(_ActivityView).widthIs(kFitWidthScale(ImageSize.width)).heightIs(kFitHeightScale(ImageSize.height));
    
}
- (void)ActivityAction:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.2 animations:^{
        _ActivityView.alpha =0;
    } completion:^(BOOL finished) {
        [_ActivityView removeFromSuperview];
    }];
    
    ActivityDetailViewController  *VC = [ActivityDetailViewController new];
    VC.url =[NSString  stringWithFormat:@"%@?userid=%ld", _presenter.ActivitySource[0].H5Url,kCurrentUser.userId];
    
    
    [self.navigationController  pushViewController:VC animated:YES];
}

- (void)dismissActivityView:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.2 animations:^{
        tap.view.alpha =0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

#pragma mark  *检测是否需要更新版本
- (void)checkOnline {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDic =[[NSBundle mainBundle] infoDictionary];
        NSString *currentStatus =[infoDic valueForKey:@"CFBundleVersion"];
        NSLog(@"==================%@=====================",currentStatus);
        WS(ws);
        [[FPNetwork POST:API_GET_APPVERSION withParams:@{@"innerVersion":@([currentStatus integerValue]),@"appType":@1}] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                if (response.data!=nil) {
                    _dataDic =response.data;
                    if ([[_dataDic valueForKey:@"Update_Status"] integerValue]==1) {
                        if (![currentStatus isEqualToString:[_dataDic valueForKey:@"Version"]]){
                            [ws alertViewOptionalAction:[_dataDic valueForKey:@"Version"] with:[_dataDic valueForKey:@"UpdateContent"]];
                            ws.openUrl =[_dataDic valueForKey:@"Download_URL"];}
                    }else if ([[_dataDic valueForKey:@"Update_Status"] integerValue]==2) {
                        if (![currentStatus isEqualToString:[_dataDic valueForKey:@"Version"]]){
                            [ws alertViewRequiredAction:[_dataDic valueForKey:@"Version"] with:[_dataDic valueForKey:@"UpdateContent"]];
                            ws.openUrl =[_dataDic valueForKey:@"Download_URL"];
                        }
                    }
                }
            }
            else {
                [ProgressUtil showError:@"网络故障"];
            }
        }];
        
    });
}

- (void)alertViewOptionalAction:(NSString *)version with:(NSString *)updateContent{
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"有可用的更新版本:%@",version] message:[NSString stringWithFormat:@"%@",updateContent] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag =1001;
    NSString *message = [NSString stringWithFormat:@"%@",updateContent];
    
    
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode =NSLineBreakByWordWrapping;
    textLabel.numberOfLines =0;
    textLabel.textAlignment =NSTextAlignmentLeft;
    textLabel.text = message;
    
    UIScrollView *scrollView =[UIScrollView new];
    //    scrollView.showsVerticalScrollIndicator =NO;
    [scrollView addSubview:textLabel];
    textLabel.sd_layout.leftSpaceToView(scrollView,10).rightSpaceToView(scrollView,10).topSpaceToView(scrollView,0).autoHeightRatio(0);
    [scrollView setupAutoHeightWithBottomView:textLabel bottomMargin:10];
    [alertView setValue:scrollView forKey:@"accessoryView"];
    
    alertView.message =@"";
    
    [alertView show];
    
}
- (void)alertViewRequiredAction:(NSString *)version with:(NSString *)updateContent{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"有可用的更新版本:%@",version] message:[NSString stringWithFormat:@"%@",updateContent] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag =1002;
    NSString *message = [NSString stringWithFormat:@"%@",updateContent];
    
    
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode =NSLineBreakByWordWrapping;
    textLabel.numberOfLines =0;
    textLabel.textAlignment =NSTextAlignmentLeft;
    textLabel.text = message;
    
    UIScrollView *scrollView =[UIScrollView new];
    //    scrollView.showsVerticalScrollIndicator =NO;
    [scrollView addSubview:textLabel];
    textLabel.sd_layout.leftSpaceToView(scrollView,10).rightSpaceToView(scrollView,10).topSpaceToView(scrollView,0).autoHeightRatio(0);
    [scrollView setupAutoHeightWithBottomView:textLabel bottomMargin:10];
    [alertView setValue:scrollView forKey:@"accessoryView"];
    
    alertView.message =@"";
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1001) {
        
        if(buttonIndex==0){
            
        }
        else if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openUrl]];
        }
    }
    else if (alertView.tag==1002) {
        
        
        if(buttonIndex==0){
            [self alertViewRequiredAction:[_dataDic valueForKey:@"Version"] with:[_dataDic valueForKey:@"UpdateContent"]];
        }
        else if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openUrl]];
            [self alertViewRequiredAction:[_dataDic valueForKey:@"Version"] with:[_dataDic valueForKey:@"UpdateContent"]];
        }
    }
    //照片权限设置
    else  if (alertView.tag == 1003) {
        if(buttonIndex==0){
            //取消设置
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }else if (alertView.tag ==1009){
        if (buttonIndex ==0) {
            [DefaultChildEntity MR_truncateAll];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPsw"];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
        }
    }
    
    
}
#pragma mark  *上传设备token到服务器
- (void)insertDeviceToken{
    [_presenter insertBindDevice];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"token"]){
        //        [_presenter updateChildInfo];
    }
    
}



#pragma mark----注释事件
#pragma mark---   隐藏首页咨询专家引导图
/*
 - (void)showUserGuildView{
 BOOL isFirstTime =YES;
 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
 [user setObject:@(isFirstTime) forKey:[NSString stringWithFormat:@"%dFirstTimeGBhomeView",kCurrentUser.userId]];
 
 NSString *imageName = nil;
 if (IS_IPHONE_4_OR_LESS) {
 imageName = @"expertAnswerGuild960";
 
 } else if (IS_IPHONE_5){
 imageName = @"expertAnswerGuild1136";
 
 } else if (IS_IPHONE_6){
 imageName = @"expertAnswerGuild1334";
 
 }else if (IS_IPHONE_6P){
 imageName = @"expertAnswerGuild2208";
 
 }
 NSArray* windows = [UIApplication sharedApplication].windows;
 UIWindow *window = [windows objectAtIndex:0];
 
 UIImage *image = [UIImage imageNamed:imageName];
 UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
 imageView.frame = window.bounds;
 imageView.userInteractionEnabled = YES;
 
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
 [imageView addGestureRecognizer:tap];
 
 [window addSubview:imageView];
 }
 
 - (void)dismissGuideView:(UITapGestureRecognizer *)tap{
 
 [UIView animateWithDuration:0.2 animations:^{
 tap.view.alpha =0;
 } completion:^(BOOL finished) {
 [tap.view removeFromSuperview];
 NSLog(@"提示后显示图片名称:%@",remberIndex);
 if (remberIndex != nil) {
 NSInteger  i = [remberIndex  integerValue];
 
 if (_presenter.CouponDataSource[i].Money == 10) {
 CouponName = @"CouponImage_10";
 }
 if (_presenter.CouponDataSource[i].Money == 20) {
 CouponName = @"CouponImage_20";
 }
 if (_presenter.CouponDataSource[i].Money == 30) {
 CouponName = @"CouponImage_30";
 }
 if (_presenter.CouponDataSource[i].Money == 60) {
 CouponName = @"CouponImage_60";
 }
 if (_presenter.CouponDataSource[i].Money == 100) {
 CouponName = @"CouponImage_100";
 }
 [self  showUserCouponView];
 }
 }];
 }
 */
/*
-(void)showUserCouponView{
    //获取当前时间戳
    NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * str = [currentDate format2String:@"yyyy-MM-dd"];
    NSString * str1 =  [NSString   stringWithFormat:@"%@ 00:00:00",str];
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   *date=[formatter   dateFromString:str1];
    NSTimeInterval current=[date timeIntervalSince1970];
    NSInteger  currentTime  = current;
    NSLog(@"记住的时间：%d",currentTime);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(currentTime) forKey:[NSString stringWithFormat:@"%dRemberTimeeGBhomeView",kCurrentUser.userId]];
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    _CouponView = [UIView  new];
    _CouponView.backgroundColor = [UIColor  colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.45];
    _CouponView.frame = window.bounds;
    _CouponView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCouponView:)];
    [_CouponView addGestureRecognizer:tap];
    
    [window addSubview:_CouponView];
    
    if (remberIndex != nil) {
        NSInteger  i = [remberIndex  integerValue];
        
        if (_presenter.CouponDataSource[i].Money == 10) {
            CouponName = @"CouponImage_10";
        }
        if (_presenter.CouponDataSource[i].Money == 20) {
            CouponName = @"CouponImage_20";
        }
        if (_presenter.CouponDataSource[i].Money == 30) {
            CouponName = @"CouponImage_30";
        }
        if (_presenter.CouponDataSource[i].Money == 60) {
            CouponName = @"CouponImage_60";
        }
        if (_presenter.CouponDataSource[i].Money == 100) {
            CouponName = @"CouponImage_100";
        }
    }
    
    UIImageView *CouponImageView = [UIImageView  new];
    CouponImageView.userInteractionEnabled = YES;
    CouponImageView.backgroundColor = [UIColor  clearColor];
    CouponImageView.image = [UIImage  imageNamed:CouponName];
    [_CouponView  addSubview:CouponImageView];
    _CouponBtn = [UIButton  new];
    _CouponBtn.backgroundColor = [UIColor  clearColor];
    [_CouponBtn  addTarget:self action:@selector(CouponClick) forControlEvents:UIControlEventTouchUpInside];
    [CouponImageView  addSubview:_CouponBtn];
    
    CouponImageView.sd_layout.centerXEqualToView(_CouponView).centerYEqualToView(_CouponView).widthIs(kFitWidthScale(560)).heightIs(kFitHeightScale(850));
    int  bottom = 60/2;
    if (kScreenHeight == 480) {
        bottom = 40/2;
    }
    
    _CouponBtn.sd_layout.bottomSpaceToView(CouponImageView,bottom).centerXEqualToView(CouponImageView).widthIs(kFitWidthScale(332)).heightIs(kFitHeightScale(78));
}
 - (void)dismissCouponView:(UITapGestureRecognizer *)tap{
 
 [UIView animateWithDuration:0.2 animations:^{
 tap.view.alpha =0;
 } completion:^(BOOL finished) {
 [tap.view removeFromSuperview];
 }];
 }
 

-(void)CouponClick{
 
    [_presenter  getClaimCouponWithcouponID:remberCouponId];
    
    [UIView animateWithDuration:0.2 animations:^{
        _CouponView.alpha =0;
    } completion:^(BOOL finished) {
        [_CouponView removeFromSuperview];
    }];
    
    
    
}
*/

#pragma mark - collectionview数据源懒加载
-(NSArray *)dataSourceArray{
    if(!_dataSourceArray){
        
 NSDictionary* dic1 = @{@"title":@"膳食管理",@"image":@"GBhome_menu-food"};
 NSDictionary* dic2 = @{@"title":@"健康服务",@"image":@"GBhome_menu-healthsre"};
 NSDictionary* dic3 = @{@"title":@"身高体重",@"image":@"GBhome_menu-weightHeight"};
 NSDictionary* dic4 = @{@"title":@"更多功能",@"image":@"GBhome_menu-more"};
        
        
 NSMutableArray* array = [NSMutableArray arrayWithArray:@[dic1,dic2,dic3,dic4]];
        
        
        
        /*if(![[ConfiguresEntity findConfigureValueWithKey:configureKey] isEqualToString:@"true"]){
         //移除专家咨询
         [array removeObjectAtIndex:6];
         }
         */
        //        if(![[ConfiguresEntity findConfigureValueWithKey:configureKey] isEqualToString:@"true"]){
        //            //移除专家咨询
        //            [array removeObjectAtIndex:0];
        //        }
        //        NSLog(@"----%@",[ConfiguresEntity findConfigureValueWithKey:openMZYYKey]);
        //        if([[ConfiguresEntity findConfigureValueWithKey:openMZYYKey] isEqualToString:@"false"]){
        //            //移除门诊预约
        //            [array removeObjectAtIndex:1];
        //        }
        
        _dataSourceArray = array;
        
    }
    return _dataSourceArray;
}

#pragma mark - cell高度私有方法

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
    [MobClick beginLogPageView:@"首页"];
    
    [_presenter getRedDot:^(BOOL success) {
        
        
        if (success == YES) {
            
            [self leftBarCustomImg:[UIImage imageNamed:@"newsRedMessages"]];
            
        }else{
            [self leftBarCustomImg:[UIImage imageNamed:@"GB_LeftMessageBar"]];
            
        }
        self.isHideTabbar = NO;
        
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
#pragma mark---   隐藏首页咨询专家引导图
    /*
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
     BOOL isFirstTime = [[user objectForKey:[NSString stringWithFormat:@"%dFirstTimeGBhomeView",kCurrentUser.userId]] boolValue];
     isFirst = isFirstTime;
     if (!isFirstTime) {
     [self showUserGuildView];
     
     }
     */
    
    //      [_presenter  getCouponList];
    //      [_presenter  loadExpertData];
    //    [_presenter  getDailyFirstArticle];
    
    
    if (kCurrentUser.needToUpdateChildInfo) {
        [ProgressUtil showWithStatus:@"正在加载宝贝信息"];
        [_presenter getChildInfo];
        kCurrentUser.needToUpdateChildInfo = NO;
    }

    WS(ws);
    if (kCurrentUser.hotIsNeedReload == NO) {
        [_hotQuestionView loadData:^(CGFloat height) {
            ws.hotQuestionView.sd_layout.heightIs(height);
            [ws.ScrollView setupAutoHeightWithBottomView:ws.hotQuestionView bottomMargin:0];
            ws.hotQuestionView.totalHeight = height;
            kCurrentUser.hotIsNeedReload = YES;
        }];
    }
    
    //    [_presenter GetEHRChildRecordCount];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -
-(void)dealloc{
    [kCurrentUser removeObserver:self forKeyPath:@"token"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATECHILD" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_Change_Baby object:nil];
    
    
        [kdefaultCenter removeObserver:self name:Notification_Refresh_DailyArticlePraiseCount object:nil];
    [kdefaultCenter removeObserver:self name:Notification_RefreshHomePraiseHot object:nil];
    
        [kdefaultCenter removeObserver:self name:Notification_RefreshHealthServiceCount object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
