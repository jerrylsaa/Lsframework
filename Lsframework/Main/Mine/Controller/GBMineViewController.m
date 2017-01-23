//
//  GBMineViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

//
//  MineViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBMineViewController.h"
#import "MineMenuCell.h"
#import "GBMineMenuCell.h"
#import "MDoctorGudieViewController.h"
#import "MDoctorAppointViewController.h"
#import "MDoctorApplyViewController.h"
#import "MDoctorWalletViewController.h"
#import "MDoctorEvaluteViewController.h"
//#import "MHeplFeedbackViewController.h"
#import "BSHelpAndFeedbackViewController.h"
#import "SetUpController.h"
#import "CorePhotoPickerVCManager.h"
#import "MMedicalSerVicePackageViewController.h"
#import "MBabyManagerViewController.h"
#import "MinePresenter.h"
#import "MMedicalNoSerViceViewController.h"
#import "DefaultChildEntity.h"
#import "BehaviourViewController.h"
#import "BabayArchList.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Category.h"
#import "ArchivesMainViewController.h"
#import "MyReplyViewController.h"
#import "ConfiguresEntity.h"
#import "MMyAppointViewController.h"
#import "MWarningViewController.h"
#import "HExpertAnswerViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "GBChildEntity.h"
#import "CouponViewController.h"
#import "MDoctorSettingViewController.h"
#import "MineTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MineCollectionFlowLayout.h"
#import "MineHeaderCollectionCell.h"
#import "MBabyInfoViewController.h"
#import "MAccountViewController.h"
#import "MHealthServiceOderViewController.h"
#import "HWViewController.h"
#import "VaccinePlaneViewController.h"

#import "NSDate+Category.h"

#import "GBArchivesRecordViewController.h"
#import "BabayArchList.h"
#import "NSDate+Category.h"

#import "MyFavoriteViewController.h"
#import "MyBindDoctorViewController.h"

#define kColumn 3

#define k_userImageViewWidth   170/2
#define    k_babyHeight     14
#define    k_sexImageViewWidth     30/2
#define    k_sexYspace      10
#define    K_Yspace    (k_userImageViewWidth-k_babyHeight-k_sexImageViewWidth-k_sexYspace+124)/2

typedef NS_ENUM(NSInteger, PhotoSourceType) {
    PhotoSourceOnlyLiaryType = 1000,
    PhotoSourceCamerAndLibaryType
};

@interface GBMineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,MinePresenterDelegate
,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIScrollView* _scroll;
    UIView* _containerView;
    UIView* _footView;
    
    UIView* _headerbgView;
    UIImageView* _icon;//头像
    UIView  *_managerView;  //管理
    UILabel* _baby;//当前宝宝
    UIImageView  *_sexImageView;  //性别
    UILabel* _userName;//当前宝宝
    UIButton  *_managerBtn;
    UIButton* _servicePackage;//医疗服务套餐
//    UIView* _line;//分割线
//    UILabel* _baby;//当前宝贝
//    UIButton* _manager;//管理
    
    UICollectionView* _collection;
    
    CorePhotoPickerVCManager* _corePhotoManager;
    
    NSString* _currentBabyName;
    NSString* _currentUserName;
    
    BOOL isChangeBaby;
    NSString  *babyDateString;
    
}

@property(nonatomic,retain) UIImageView* userImageView;

@property(nonatomic,retain) NSArray* imageArray;
@property(nonatomic,retain) NSArray* titleArray;

@property(nonatomic,retain) MinePresenter* presenter;

@property(nonatomic,retain) BabayArchList* currentBaby;

@property(nonatomic,retain) NSArray* vcArray;

@property(nullable,nonatomic,retain) UITableView* table;

@property(nullable,nonatomic,retain) NSMutableArray<NSArray*> * dataSource;

@property(nullable,nonatomic,retain) UIView* collectionbgView;
@property(nullable,nonatomic,retain) UICollectionView* headerCollection;
@property(nullable,nonatomic,retain) UILabel* heightTitleLabel;
@property(nullable,nonatomic,retain) UILabel* weightTitleLabel;
@property(nullable,nonatomic,retain) UILabel* vaccineTitleLabel;
@property(nullable,nonatomic,retain) BabayArchList* currentSelectBaby;
@property(nullable,nonatomic,retain) UIButton* indactorbgButton;

@end

@implementation GBMineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBackBarWithImage:nil];
    
    self.presenter = [MinePresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter loadAllBaby];
    
    //注册通知
    [self registerNotification];
    
    
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
//    [self.table sd_resetLayout];

    
//    [_presenter getChildInfo];
//    [_presenter   getExperIDByUserID];
//    NSString* currentBaby = [DefaultChildEntity defaultChild].childName;
//    if(currentBaby.length == 0){
//        currentBaby = @"无";
//    }
//    WSLog(@"%@",currentBaby);
//    _baby.text = [NSString stringWithFormat:@"%@",currentBaby ];
//    _currentBabyName = currentBaby;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(isChangeBaby && self.currentSelectBaby){
        WSLog(@"isChange = %d",isChangeBaby)
        isChangeBaby = NO;
        //发送切换宝宝通知
        NSDictionary* userInfo = @{@"baby":self.currentSelectBaby};
        [kdefaultCenter postNotificationName:Notification_Change_Baby object:nil userInfo:userInfo];
    }
    
    [MobClick endLogPageView:@"我的"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}



#pragma mark - 加载子视图
- (void)setupView{
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    
    UIView *statusBarView=[UIView new];
    statusBarView.backgroundColor = [UIColor  colorWithRed:107/255.0 green:211/255.0 blue:207/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    statusBarView.sd_layout.topSpaceToView(self.view,-20).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(20);
    
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.bounces = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = RGB(242, 242, 242);
    
    [self.view addSubview:table];
    self.table = table;
    
    [table registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    table.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
//    [scroll setupAutoContentSizeWithBottomView:table bottomMargin:0];
    
    [self setupTableHeaderView];
    
    
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    
    UIView* collectionbgView = [UIView new];
    collectionbgView.backgroundColor = [UIColor  colorWithRed:107/255.0 green:211/255.0 blue:207/255.0 alpha:1];
    [headerView addSubview:collectionbgView];
    self.collectionbgView = collectionbgView;
//    collectionbgView.backgroundColor = UIColorFromRGB(0xffffff);
    
    //collectionView
    MineCollectionFlowLayout* mineLayout = [MineCollectionFlowLayout new];
    mineLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mineLayout.itemSize = CGSizeMake(100, 140);
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mineLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[MineHeaderCollectionCell class] forCellWithReuseIdentifier:@"collection"];
    self.headerCollection = collectionView;
    [collectionbgView addSubview:collectionView];
    
    UIView* noBabyAddbgView = [UIView new];
    noBabyAddbgView.tag = 102;
    noBabyAddbgView.hidden = YES;
    [collectionbgView addSubview:noBabyAddbgView];
    
    
    UIImageView* iconbgImageView = [UIImageView new];
    iconbgImageView.userInteractionEnabled = YES;
    iconbgImageView.image = [UIImage imageNamed:@"GB_MineICON"];
    [noBabyAddbgView addSubview:iconbgImageView];
    
    UIButton* noBabyAddButton = [UIButton new];
    [noBabyAddButton setBackgroundImage:[UIImage imageNamed:@"mine_unadd_baby"] forState:UIControlStateNormal];
    [noBabyAddButton addTarget:self action:@selector(addBabyAction) forControlEvents:UIControlEventTouchUpInside];
    [noBabyAddbgView addSubview:noBabyAddButton];


    
    UIButton* addBabyButton = [UIButton new];
    [addBabyButton setBackgroundImage:[UIImage imageNamed:@"mine_add_baby"] forState:UIControlStateNormal];
    [addBabyButton addTarget:self action:@selector(addBabyAction) forControlEvents:UIControlEventTouchUpInside];
    addBabyButton.tag = 101;
    [collectionbgView addSubview:addBabyButton];
    
    UIButton* indactor = [UIButton new];
    indactor.hidden = YES;
    [indactor setBackgroundImage:[UIImage imageNamed:@"_managerBtn"] forState:UIControlStateNormal];
    [collectionbgView addSubview:indactor];
    
    UIButton* indactorbgButton = [UIButton new];
    [indactorbgButton addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
    indactorbgButton.hidden = YES;
    [collectionbgView addSubview:indactorbgButton];

    
    UIImageView* triangle = [UIImageView new];
    triangle.userInteractionEnabled = YES;
    triangle.image = [UIImage imageNamed:@"triangle_shape"];
    triangle.tag = 103;
    [headerView addSubview:triangle];
    
    
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [headerView addSubview:bottomView];
    
    
    
    //身高
    UIView  *heightView = [UIView new];
    heightView.backgroundColor = [UIColor clearColor];
    heightView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *tap1 = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapAction)];
    [heightView  addGestureRecognizer:tap1];
    [bottomView  addSubview:heightView];
    
    UILabel* heightLabel = [UILabel new];
    heightLabel.text = @"身高";
    heightLabel.textAlignment = NSTextAlignmentCenter;
    heightLabel.textColor = RGB(97, 172, 168);
    heightLabel.font = [UIFont systemFontOfSize:sbigFont];
    [heightView addSubview:heightLabel];
    
    UILabel* heightTitleLabel = [UILabel new];
    heightTitleLabel.textAlignment = NSTextAlignmentCenter;
    heightTitleLabel.textColor = UIColorFromRGB(0x666666);
    heightTitleLabel.font = [UIFont systemFontOfSize:midFont];
    [heightView addSubview:heightTitleLabel];
    self.heightTitleLabel = heightTitleLabel;

    
    //体重
    UIView  *weightView = [UIView new];
    weightView.backgroundColor = [UIColor clearColor];
    weightView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *tap2 = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapAction2)];
    [weightView  addGestureRecognizer:tap2];

    [bottomView  addSubview:weightView];

    
    UILabel* weightLabel = [UILabel new];
    weightLabel.text = @"体重";
    weightLabel.textAlignment = NSTextAlignmentCenter;
    weightLabel.textColor = heightLabel.textColor;
    weightLabel.font = heightLabel.font;
    [weightView addSubview:weightLabel];
    
    UILabel* weightTitleLabel = [UILabel new];
    weightTitleLabel.textAlignment = NSTextAlignmentCenter;
    weightTitleLabel.textColor = heightTitleLabel.textColor;
    weightTitleLabel.font = heightTitleLabel.font;
    [weightView addSubview:weightTitleLabel];
    self.weightTitleLabel = weightTitleLabel;

    
    
    //疫苗vaccine
    
    UIView  *vaccineView = [UIView new];
    vaccineView.backgroundColor = [UIColor clearColor];
    vaccineView.userInteractionEnabled = YES;
    UITapGestureRecognizer  *tap3 = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapAction3)];
    [vaccineView  addGestureRecognizer:tap3];
    [bottomView  addSubview:vaccineView];

    UILabel* vaccineLabel = [UILabel new];
    vaccineLabel.text = @"疫苗";
    vaccineLabel.textAlignment = NSTextAlignmentCenter;
    vaccineLabel.textColor = heightLabel.textColor;
    vaccineLabel.font = heightLabel.font;
    [vaccineView addSubview:vaccineLabel];
    
    UILabel* vaccineTitleLabel = [UILabel new];
    vaccineTitleLabel.textAlignment = NSTextAlignmentCenter;
    vaccineTitleLabel.textColor = heightTitleLabel.textColor;
    vaccineTitleLabel.font = heightTitleLabel.font;
    [vaccineView addSubview:vaccineTitleLabel];
    self.vaccineTitleLabel = vaccineTitleLabel;

    self.heightTitleLabel.text = @"0 cm";
    self.weightTitleLabel.text = @"0 kg";
    self.vaccineTitleLabel.text = @"暂无";

    
    //竖线
    UIView* line1 = [UIView new];
    line1.backgroundColor = UIColorFromRGB(0xebebeb);
    [bottomView addSubview:line1];
    UIView* line2 = [UIView new];
    line2.backgroundColor = UIColorFromRGB(0xebebeb);
    [bottomView addSubview:line2];
    
    

    collectionbgView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0);
    
    noBabyAddbgView.sd_layout.topSpaceToView(collectionbgView,50).leftSpaceToView(collectionbgView,0).rightSpaceToView(collectionbgView,0).heightIs(140);
    iconbgImageView.sd_layout.topSpaceToView(noBabyAddbgView,0).centerXEqualToView(noBabyAddbgView).widthIs(85).heightEqualToWidth();
     iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    noBabyAddButton.sd_layout.topSpaceToView(iconbgImageView,15).centerXEqualToView(iconbgImageView).widthIs(216/2.0).heightIs(54/2.0);


    collectionView.sd_layout.topSpaceToView(collectionbgView,50).leftSpaceToView(collectionbgView,0).rightSpaceToView(collectionbgView,0).heightIs(140);
    
    addBabyButton.sd_layout.topSpaceToView(collectionbgView,25).rightSpaceToView(collectionbgView,15).widthIs(136/2.0).heightIs(20);
    
    indactor.sd_layout.centerYEqualToView(collectionView).rightSpaceToView(collectionbgView,15).widthIs(18).heightIs(18);
    
    indactorbgButton.sd_layout.centerYEqualToView(collectionView).rightSpaceToView(collectionbgView,0).leftSpaceToView(collectionView,0).heightEqualToWidth();
    
    [collectionbgView setupAutoHeightWithBottomView:collectionView bottomMargin:10];
    
    triangle.sd_layout.topSpaceToView(collectionbgView,-8).leftSpaceToView(headerView,80).widthIs(9).heightIs(8);
    
    bottomView.sd_layout.topSpaceToView(collectionbgView,0).leftEqualToView(collectionbgView).rightEqualToView(collectionbgView).heightIs(135/2.0);
    
    CGFloat space = kScreenWidth / 3.0;
    
    heightView.sd_layout.topSpaceToView(bottomView,0).leftSpaceToView(bottomView,0).widthIs(space).heightIs(55);
    
    heightLabel.sd_layout.topSpaceToView(heightView,15).heightIs(15).centerXIs(space / 2.0).widthIs(100);
    heightTitleLabel.sd_layout.topSpaceToView(heightLabel,10).centerXEqualToView(heightLabel).heightIs(15).widthIs(space);
//    [heightTitleLabel setSingleLineAutoResizeWithMaxWidth:space];
    
    weightView.sd_layout.topSpaceToView(bottomView,0).leftSpaceToView(bottomView,space).widthIs(space).heightIs(55);
    weightLabel.sd_layout.topSpaceToView(weightView,15).heightIs(15).centerXIs(space / 2.0).widthIs(100);
    weightTitleLabel.sd_layout.topSpaceToView(weightLabel,10).centerXEqualToView(weightLabel).heightRatioToView(heightTitleLabel,1).widthIs(space);
//    [weightTitleLabel setSingleLineAutoResizeWithMaxWidth:space];

    
     vaccineView.sd_layout.topSpaceToView(bottomView,0).leftSpaceToView(bottomView,2*space).widthIs(space).heightIs(55);
    vaccineLabel.sd_layout.topSpaceToView(vaccineView,15).heightIs(15).centerXIs(space / 2.0).widthIs(100);
     vaccineTitleLabel.sd_layout.topSpaceToView(vaccineLabel,10).centerXEqualToView(vaccineLabel).heightRatioToView(heightTitleLabel,1).widthIs(space);
//    [vaccineTitleLabel setSingleLineAutoResizeWithMaxWidth:space];

    
    line1.sd_layout.topEqualToView(heightLabel).widthIs(0.8).heightIs(40).leftSpaceToView(bottomView,space);
    line2.sd_layout.topEqualToView(heightLabel).widthRatioToView(line1,1).heightRatioToView(line1,1).leftSpaceToView(bottomView,space * 2);

    
    
    [headerView setupAutoHeightWithBottomView:bottomView bottomMargin:0];
    
    
    [headerView layoutSubviews];
    self.table.tableHeaderView = headerView;
    
    
}

#pragma mark -代理
#pragma mark * tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* sectionDataSource = self.dataSource[section];
    
    return sectionDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSArray* sectionDataSource = self.dataSource[indexPath.section];
    
    cell.dic = sectionDataSource[indexPath.row];
    cell.row = indexPath.row;
    cell.sectionDataSource =sectionDataSource;

    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* sectionDataSource = self.dataSource[indexPath.section];
    NSDictionary* dicDataSource = sectionDataSource[indexPath.row];
    
    NSString* imageName = [dicDataSource objectForKey:@"icon"];
    if([imageName isEqualToString:@"wdzh_icon"]){
        //我的帐号
        MAccountViewController* account = [MAccountViewController new];
        WSLog(@"%@----",self.currentSelectBaby.nickName);
        account.nickName = self.currentSelectBaby.nickName;
        
        [self.navigationController pushViewController:account animated:YES];
        
    }else if([imageName isEqualToString:@"zxkf_icon"]){
        //我的咨询
        MyReplyViewController    *vc2 = [MyReplyViewController new];
        [self.navigationController pushViewController:vc2 animated:YES];
    }else if([imageName isEqualToString:@"wdyy_icon"]){
        //我的预约
        MMyAppointViewController* vc = [MMyAppointViewController new];
        NSString* url = [NSString URLDecodedString:[ConfiguresEntity findConfigureValueWithKey:@"openmzyyurl2"]];
        
        vc.appointURL = [NSString stringWithFormat:@"%@?token=%@&username=%@&pass=%@",url,kCurrentUser.token,kCurrentUser.phone,kCurrentUser.userPasswd];
        NSLog(@"url = %@",vc.appointURL);
        
        [self.navigationController pushViewController:vc animated:YES];

    }else if([imageName isEqualToString:@"GB_Mine_Favorite"]){
        //我的喜欢
        MyFavoriteViewController* vc = [MyFavoriteViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([imageName isEqualToString:@"wdfw_icon"]){
        //我的服务
        MHealthServiceOderViewController *vc =[MHealthServiceOderViewController new];
        vc.noDirectPush =2;
        [self.navigationController pushViewController:vc  animated:YES];

        
    }
//    else if([imageName isEqualToString:@"wdtx_icon"]){
//        //我的提醒
//        MWarningViewController     *vc5 = [MWarningViewController new];
//        [self.navigationController pushViewController:vc5   animated:YES];
//    }
    else if([imageName isEqualToString:@"wdqb_icon"]){
        //我的钱包
        MDoctorWalletViewController    *vc3 = [MDoctorWalletViewController new];
        [self.navigationController pushViewController:vc3 animated:YES];
    }else if([imageName isEqualToString:@"wdyhq_icon"]){
        //我的优惠券
        CouponViewController    *vc6= [CouponViewController  new];
        [self.navigationController pushViewController:vc6   animated:YES];
    }else if([imageName isEqualToString:@"fxdyhq_icon"]){
        //分享得优惠券
        [ProgressUtil show];
        [self.presenter getShareCouponNumber];
    }else if([imageName isEqualToString:@"sz_icon"]){
        //设置
        SetUpController   *vc4 = [SetUpController new];
        [self.navigationController pushViewController:vc4   animated:YES];
    }else if([imageName isEqualToString:@"yssz_icon"]){
        //医生设置
        MDoctorSettingViewController   *vc7= [MDoctorSettingViewController  new];
        //传一个专家ID
        if(kCurrentUser.expertID){
            //kCurrentUser.expertID是在首页赋值的
            vc7.expertID = kCurrentUser.expertID;
        }else{
            //如果拿不到就走接口获取医生ID
//            [_presenter   getExperIDByUserID];
        }
//        vc7.expertID = _presenter.GBChilSource[0].ExperID;
        [self.navigationController pushViewController:vc7   animated:YES];
    }else if([imageName isEqualToString:@"bzfk_icon"]){
        //帮助反馈
        BSHelpAndFeedbackViewController  *vc1 = [BSHelpAndFeedbackViewController new];
        [self.navigationController pushViewController:vc1 animated:YES];

    }else if([imageName isEqualToString:@"wdbdyy_icon"]){
        //我绑定的医院
        HExpertAnswerViewController *vc =[HExpertAnswerViewController new];
        vc.hospitalType =@"MyBindHospital";
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([imageName isEqualToString:@"mine_doc"]){
        //我绑定的医生
        MyBindDoctorViewController *vc =[MyBindDoctorViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* sectionDataSource = self.dataSource[indexPath.section];
    NSDictionary* dic = sectionDataSource[indexPath.row];
    return [self.table cellHeightForIndexPath:indexPath model:dic keyPath:@"dic" cellClass:[MineTableViewCell class] contentViewWidth:[self cellContentViewWith]];


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == self.dataSource.count - 1){
        return 20;
    }
    
    return 0.01;
}

#pragma mark * collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.presenter.babyDataSource.count == 1 || self.presenter.babyDataSource.count == 0){
        return self.presenter.babyDataSource.count;
    }
    return self.presenter.babyDataSource.count + 3;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineHeaderCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    
    if(indexPath.item > (self.presenter.babyDataSource.count - 1) && self.presenter.babyDataSource.count != 0){
        cell.hidden = YES;
    }else{
        cell.hidden = NO;
        cell.baby = self.presenter.babyDataSource[indexPath.item];
    }
    
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 35, 0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 35;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    MBabyInfoViewController* babyInfo = [MBabyInfoViewController new];
//    babyInfo.baby = self.presenter.babyDataSource[indexPath.item];
//    NSLog(@"宝宝数据：%@",babyInfo.baby);
    
    
    GBArchivesRecordViewController  *babyInfo = [GBArchivesRecordViewController  new];
    babyInfo.type = GBArchivesRecordTypeFromCaseInfo;
    babyInfo.poptoClass = self.poptoClass;
    BabayArchList  *baby =  self.presenter.babyDataSource[indexPath.item];
    babyInfo.BabyList = baby;
    NSLog(@"数据2：%@",babyInfo.BabyList.sex);
    [self.navigationController pushViewController:babyInfo animated:YES];

}

#pragma mark * scroll代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UICollectionView class]]){

        UICollectionView* collectionView = (UICollectionView*)scrollView;
        
        CGPoint pInView = [self.collectionbgView convertPoint:collectionView.origin toView:collectionView];
        pInView.x += 40;

        // 获取这一点的indexPath
        NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:pInView];

//        WSLog(@"====%ld",indexPath.item);

        if(indexPath.item > (self.presenter.babyDataSource.count - 1)){
            NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//            [collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
            indexPath = lastIndexPath;
        }
        
        BabayArchList* baby = [self.presenter.babyDataSource objectAtIndex:indexPath.item];
        self.currentSelectBaby = baby;
        
        if(self.presenter.babyDataSource.count > 1 && ![self.heightTitleLabel.text isEqualToString:[NSString stringWithFormat:@"%.f cm",[baby.height floatValue]]]){
            isChangeBaby = YES;
        }

        
        self.heightTitleLabel.text = [NSString stringWithFormat:@"%.f cm",[baby.height floatValue]];
        self.weightTitleLabel.text = [NSString stringWithFormat:@"%.1f kg",[baby.weight floatValue]];
        [self.weightTitleLabel updateLayout];

        
        
        runOnBackground(^{
//            NSInteger today = [self generateDate:baby.birthDate];
//            WSLog(@" today === %ld",today);
            babyDateString = [baby.birthDate  format2String:@"yyyy-MM-dd"];
            runOnMainThread(^{
                [self.presenter getVaccineEventWithmonth:babyDateString];            });
        });

        
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UICollectionView class]]){
    
        UICollectionView* collectionView = (UICollectionView*)scrollView;
        
        CGPoint pInView = [self.collectionbgView convertPoint:collectionView.origin toView:collectionView];
        pInView.x += 40;
        
        // 获取这一点的indexPath
        NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:pInView];
        
        
        if(indexPath.item > (self.presenter.babyDataSource.count - 1)){
            NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        }
        
    }

}

#pragma mark * 加载所有宝宝代理
-(void)loadAllBabyComplete:(BOOL)success info:(NSString *)message{
    
    UIButton* addButton = (UIButton*)[self.collectionbgView viewWithTag:101];
    UIView* noBabyAddbgView = [self.collectionbgView viewWithTag:102];
    UIImageView* triangle = (UIImageView*)[self.collectionbgView.superview viewWithTag:103];
    
    addButton.hidden = self.presenter.responseStatus != 200;
    triangle.hidden = addButton.hidden;
    noBabyAddbgView.hidden = !addButton.hidden;

    [ProgressUtil dismiss];
    if(success){
        [self.headerCollection reloadData];
        
        if (self.presenter.babyDataSource.count==1) {
        BabayArchList* baby = self.presenter.babyDataSource[0];
        [self.presenter  setDefaultBaby:baby];
        }
        if(self.presenter.babyDataSource){
            
           NSString* childName = [DefaultChildEntity defaultChild].childName;
            WSLog(@"%@",childName);
            //滚动当前默认宝宝
            [self convertToDefaultbaby:childName];

        }
    }else{
//        [ProgressUtil showError:message];
    }
}

#pragma mark * 获取疫苗代理
-(void)loadVaccienComplete:(BOOL)success info:(NSString *)message{
    if(success){
        if(self.presenter.VaccineSource){
            VaccineEvent* vaccine = [self.presenter.VaccineSource firstObject];
            if(vaccine.VaccineName.length != 0){
                self.vaccineTitleLabel.text = vaccine.VaccineName;
            }
            [self.vaccineTitleLabel updateLayout];
        }
        
    }else{
        
    }
}

-(void)setDefaultBabyCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [_presenter getChildInfo];
    }
}

//- (void)setupScrollView{
//    
//    _scroll = [UIScrollView new];
//    _scroll.showsVerticalScrollIndicator = NO;
//    _scroll.userInteractionEnabled = YES;
//    _scroll.scrollEnabled = YES;
//    _scroll.backgroundColor =UIColorFromRGB(0xf2f2f2);
//    [self.view addSubview:_scroll];
//    
//    _containerView = [UIView new];
//    _containerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [_scroll addSubview:_containerView];
//    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
////    _scroll.sd_layout.topSpaceToView(self.view,0).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
//    _containerView.sd_layout.topSpaceToView(_scroll,-20).leftEqualToView(_scroll).rightEqualToView(_scroll);
//    
//
//    }
//
//- (void)setupHeaderView{
//    _headerbgView = [UIView new];
//    _headerbgView.backgroundColor = [UIColor  colorWithRed:107/255.0 green:211/255.0 blue:207/255.0 alpha:1];
//
////      [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
//    [_containerView addSubview:_headerbgView];
//    //头像
//    self.userImageView = [UIImageView new];
//    self.userImageView.image=[UIImage imageNamed:@"GB_iconView"];
//    self.userImageView.userInteractionEnabled = YES;
//    [_headerbgView addSubview:self.userImageView];
//    
//    _icon = [UIImageView new];
//    _icon.userInteractionEnabled = YES;
//    [self.userImageView addSubview:_icon];
//    NSString* headerImage = [NSString stringWithFormat:@"%@%@",ICON_URL,[DefaultChildEntity defaultChild].childImg];
//    NSURL* url = [NSURL URLWithString:headerImage];
//    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"GB_icon"]];
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
//    [_icon addGestureRecognizer:tap];
//    
////    NSArray* windows = [UIApplication sharedApplication].windows;
////    UIWindow *window = [windows objectAtIndex:0];
//    _managerView = [UIView  new];
//    _managerView.backgroundColor = [UIColor  clearColor];
//    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ManageTapGesture)];
//    [_managerView addGestureRecognizer:tap2];
//    [_headerbgView  addSubview:_managerView];
//    
//    //用户姓名
//    _userName = [UILabel  new];
//    _userName.font = [UIFont systemFontOfSize:18];
//    _userName.textColor = UIColorFromRGB(0xeeeeee);
//    _userName.textAlignment = NSTextAlignmentLeft;
//    _userName.numberOfLines = 1;
//    [_headerbgView addSubview:_userName];
// 
//
//    
//    //性别
//    _sexImageView = [UIImageView  new];
//    [_headerbgView addSubview:_sexImageView];
//    
//    
//    //宝宝
//    _baby = [UILabel new];
//    _baby.font = [UIFont systemFontOfSize:13];
//    _baby.textColor = UIColorFromRGB(0xeeeeee);
//    [_headerbgView addSubview:_baby];
//
//    
//
//    
//    //管理
//    _managerBtn = [UIButton  new];
//    _managerBtn.backgroundColor = [UIColor  clearColor];
//    [_managerBtn  setImage:[UIImage  imageNamed:@"_managerBtn"] forState:UIControlStateNormal];
//    [_managerBtn  addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
//    [_headerbgView  addSubview:_managerBtn];
//    
//    
//    
//    self.userImageView.sd_layout.topSpaceToView(_headerbgView,64).leftSpaceToView(_headerbgView,20).widthIs(k_userImageViewWidth).heightEqualToWidth();
//    
//    _icon.sd_layout.centerXEqualToView(_userImageView).centerYEqualToView(_userImageView).widthIs(132/2).heightEqualToWidth();
//    _icon.layer.cornerRadius = _icon.frame.size.height/2;
//    _icon.layer.masksToBounds = YES;
//    _managerView.sd_layout.topSpaceToView(_headerbgView,K_Yspace)
//    .leftSpaceToView(self.userImageView,15).widthIs(kScreenWidth-self.userImageView.frame.size.width-20-15).heightIs(k_userImageViewWidth);
//    _managerBtn.sd_layout.centerYEqualToView(self.userImageView).rightSpaceToView(_headerbgView,15).widthIs(36/2).heightEqualToWidth();
//    
//    _userName.sd_layout.topSpaceToView(_headerbgView,K_Yspace).leftSpaceToView(self.userImageView,15).rightSpaceToView(_managerBtn,0).heightIs(20);
//    
//    _sexImageView.sd_layout.topSpaceToView(_userName,k_sexYspace).leftSpaceToView(self.userImageView,15).widthIs(k_sexImageViewWidth).heightEqualToWidth();
//    
//    
//    _baby.sd_layout.topEqualToView(_sexImageView).leftSpaceToView(_sexImageView,5).minWidthIs(100).heightIs(k_babyHeight);
//    [_baby setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
//    
//
//    
//    _headerbgView.sd_layout.topEqualToView(_containerView).leftEqualToView(_containerView).rightEqualToView(_containerView);
//
//    [_headerbgView setupAutoHeightWithBottomView:_userImageView bottomMargin:15];
//
//}
//
//- (void)setupCollectionView{
//    
//
//    
//    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    CGFloat width = (kScreenWidth-1*2)/kColumn;
//    CGFloat height = width;
//    layout.itemSize = CGSizeMake(width,height);
//    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    _collection.scrollEnabled = NO;
//    _collection.delegate = self;
//    _collection.dataSource = self;
//    _collection.backgroundColor = [UIColor clearColor];
////    [_collection registerClass:[MineMenuCell class] forCellWithReuseIdentifier:@"menuCell"];
//    [_collection registerClass:[GBMineMenuCell class] forCellWithReuseIdentifier:@"menuCell"];
//    [_containerView  addSubview:_collection];
//    
//    CGFloat row = 0;
//    
//    if(self.imageArray.count < kColumn){
//        row = 1;
//    }else{
//        if(!(self.imageArray.count%3)){
//            //3的整数倍
//            row = self.imageArray.count/kColumn;
//        }else{
//            row = self.imageArray.count/kColumn+1;
//        }
//        
//    }
//    
//    
// CGFloat collectHeight = 1+1*(row-1)+ row*height ;
//    NSLog(@"高度：%f",collectHeight);
//    
//    _collection.sd_layout.topSpaceToView(_headerbgView,10).leftEqualToView(_containerView).rightEqualToView(_containerView).heightIs(collectHeight);
//    
//    [_containerView setupAutoHeightWithBottomView:_collection bottomMargin:0];
//    [_scroll setupAutoContentSizeWithBottomView:_containerView bottomMargin:0];
//
//
//}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//    return self.imageArray.count;
//}
//
//- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
////    MineMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
//    GBMineMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
//    NSString* imageName = self.imageArray[indexPath.item];
//    cell.menuImageView.image = [UIImage imageNamed:imageName];
//    NSString* titleName = self.titleArray[indexPath.item];
//    cell.menuTitle.text = titleName;
//    return cell;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(1, 0, 1,0);
//}
//

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 1;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//     _collection.userInteractionEnabled = YES;
//    NSString* imageName = self.imageArray[indexPath.item];
//    if([imageName isEqualToString:@"GBmine_appoint"]){
//        //我的预约
//        MMyAppointViewController* vc = [MMyAppointViewController new];
//        NSString* url = [NSString URLDecodedString:[ConfiguresEntity findConfigureValueWithKey:@"openmzyyurl2"]];
//        
//        vc.appointURL = [NSString stringWithFormat:@"%@?token=%@&username=%@&pass=%@",url,kCurrentUser.token,kCurrentUser.phone,kCurrentUser.userPasswd];
//        NSLog(@"url = %@",vc.appointURL);
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//
//        if([imageName isEqualToString:@"GBmine_help_feedback"]){
//            
//    BSHelpAndFeedbackViewController  *vc1 = [BSHelpAndFeedbackViewController new];
//        [self.navigationController pushViewController:vc1 animated:YES];
//            
//        }else if([imageName isEqualToString:@"GBmine_reply"]){
//            
//    MyReplyViewController    *vc2 = [MyReplyViewController new];
//        [self.navigationController pushViewController:vc2 animated:YES];
//            
//        }else if([imageName isEqualToString:@"GBmine_wallet"]){
//            
//        MDoctorWalletViewController    *vc3 = [MDoctorWalletViewController new];
//    [self.navigationController pushViewController:vc3 animated:YES];
//            
//        }else if([imageName isEqualToString:@"GBmine_setting"]){
//            
//         SetUpController   *vc4 = [SetUpController new];
//        [self.navigationController pushViewController:vc4   animated:YES];
//            
//        }else if ([imageName isEqualToString:@"GBmine_warning"]){
//            
//       MWarningViewController     *vc5 = [MWarningViewController new];
//        [self.navigationController pushViewController:vc5   animated:YES];
//            
//        }else if ([imageName isEqualToString:@"GBmine_coupon"]){
//           
//        CouponViewController    *vc6= [CouponViewController  new];
//        [self.navigationController pushViewController:vc6   animated:YES];
//            
//        }else if ([imageName isEqualToString:@"GBmine_doctor"]){
//         MDoctorSettingViewController   *vc7= [MDoctorSettingViewController  new];
//            vc7.expertID = _presenter.GBChilSource[0].ExperID;
//        [self.navigationController pushViewController:vc7   animated:YES];
//
//
//        }else if ([imageName isEqualToString:@"GBmine_share.jpg"]){
//            NSLog(@"分享");
//            [ProgressUtil show];
//            [self.presenter getShareCouponNumber];
//            
//        }
//  
//
//    }
//    
//}

//-(void)onComplete:(BOOL)success info:(NSString *)info{
//    if(success){
//        [ProgressUtil dismiss];
//        if(self.presenter.dataSource.count !=0){
//            MMedicalSerVicePackageViewController* myPackage = [MMedicalSerVicePackageViewController new];
//            myPackage.dataSorce = self.presenter.dataSource;
//            [self.navigationController pushViewController:myPackage animated:YES];
//        }else{
//            //您还没有购买过医疗服务
//            [self.navigationController pushViewController:[MMedicalNoSerViceViewController new] animated:YES];
//        }
//    }else{
//        [ProgressUtil showError:info];
//    }
//}

//-(void)onChangeChildAvaterCompleted:(NSString *)path{
//    [_icon setImage:[UIImage imageWithContentsOfFile:path]];
//    
//    //    [kdefaultCenter postNotificationName:Notification_updateChildAdvater object:nil userInfo:nil];
//    
//    kCurrentUser.needToUpdateChildInfo = YES;
//}

#pragma mark * 获取分享优惠码代理
- (void)onGetShareCouponNumberComplete:(BOOL)success info:(NSString*)message Coupon:(NSString *)coupon{
    if (success) {
        [ProgressUtil dismiss];
        
        
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        NSString *urlStr =URL_SHARE;
        
        
        if (imageArray) {
            NSString *text =@"";
            NSString  *String =[NSString stringWithFormat:@"输入优惠码【%@】免费向专家提问",coupon];
            
            NSString *title = String ;
            
            if(String.length > 40){
                title = [String substringWithRange:NSMakeRange(0, 40)];
            }
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:text               images:[UIImage imageNamed:@"share"]
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

        
    }else{
        [ProgressUtil showError:message];
    }
}

#pragma mark - 点击事件
#pragma mark *管理宝宝
- (void)managerAction{
//    MBabyManagerViewController* babyManager = [MBabyManagerViewController new];
//    babyManager.dataSource = self.presenter.babyDataSource;
//    babyManager.currentBabyName = self.currentSelectBaby.childName;
//    babyManager.currentUserName = self.currentSelectBaby.nickName;
//    [self.navigationController pushViewController:babyManager animated:YES];
    NSLog(@"%@",_currentSelectBaby.childName);
    
    [self  convertbaby:_currentSelectBaby.childName];
   
    
}


#pragma mark---切换宝宝
-(void)convertbaby:(NSString*) currentchildName{
    if ( self.presenter.babyDataSource.count ==1) {
        return;
    }

    int index = 0;
    for(int i = 0; i < self.presenter.babyDataSource.count; i++){
        BabayArchList* baby = [self.presenter.babyDataSource objectAtIndex:i];
        if([baby.childName isEqualToString:currentchildName]){
            index = i;
            break ;
        }
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index+1 inSection:0];
    
    
    if(indexPath.item > (self.presenter.babyDataSource.count - 1)){
        NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        indexPath = lastIndexPath;
    }
    
    BabayArchList* baby = [self.presenter.babyDataSource objectAtIndex:indexPath.item];
    
    self.currentSelectBaby = baby;
    
    if(self.presenter.babyDataSource.count > 1 && ![self.heightTitleLabel.text isEqualToString:[NSString stringWithFormat:@"%.f cm",[baby.height floatValue]]]){
        isChangeBaby = YES;
    }

    
    
    self.heightTitleLabel.text = [NSString stringWithFormat:@"%.f cm",[baby.height floatValue]];
    self.weightTitleLabel.text = [NSString stringWithFormat:@"%.1f kg",[baby.weight floatValue]];
    [self.weightTitleLabel updateLayout];
    
    runOnBackground(^{
        //                NSInteger today = [self generateDate:baby.birthDate];
        //                WSLog(@"today = %ld",today);
        babyDateString = [baby.birthDate  format2String:@"yyyy-MM-dd"];
        runOnMainThread(^{
            [self.presenter getVaccineEventWithmonth:babyDateString];
        });
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.headerCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        [self.headerCollection reloadData];
        
    });
    
}



#pragma mark * 添加宝宝
- (void)addBabyAction{
    ArchivesMainViewController * vc = [ArchivesMainViewController new];
    vc.poptoClass = [GBMineViewController class];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark * 点击身高
-(void)tapAction{
    
    HWViewController *vc = [HWViewController new];
    vc.bodyType = BodyTypeHeight;
    [self.navigationController pushViewController:vc animated:YES];


}
#pragma mark * 点击体重
-(void)tapAction2{
    
    HWViewController *vc = [HWViewController new];
    vc.bodyType = BodyTypeWeight;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark * 点击疫苗
-(void)tapAction3{
    
    WSLog(@"-===%@",[DefaultChildEntity defaultChild].birthDate);
    
    VaccinePlaneViewController* vaccine = [VaccinePlaneViewController new];
       vaccine.childBirtDay = babyDateString;
     NSLog(@"疫苗时间：%@",vaccine.childBirtDay);
    [self.navigationController  pushViewController:vaccine animated:YES];
    
}
#pragma mark - 懒加载
//-(NSArray *)imageArray{
//    if(!_imageArray){
//        NSMutableArray* array = [NSMutableArray arrayWithArray:@[@"GBmine_reply",@"GBmine_appoint",@"GBmine_warning",@"GBmine_wallet",@"GBmine_coupon",@"GBmine_setting",@"GBmine_doctor",@"GBmine_help_feedback",@"GBmine_share.jpg"]];
//
//        NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
//        BOOL  isDoctor = [[user1   objectForKey:[NSString stringWithFormat:@"%dIsdoctorMineView",kCurrentUser.userId]] boolValue];
//        if ([[NSString  stringWithFormat:@"%d",isDoctor]  isEqualToString:@"0"]) {
//            NSLog( @"移除1：%d",isDoctor);
//            
//            [array  removeObject:@"GBmine_doctor"];
//            
//        }
//    
//        NSString* configureValue = [ConfiguresEntity findConfigureValueWithKey:configureKey];
//        if(![configureValue isEqualToString:@"true"]){
//            //移除我的咨询
//            [array removeObject:@"GBmine_reply"];
//        }
//        
//        if([[ConfiguresEntity findConfigureValueWithKey:openMZYYKey] isEqualToString:@"false"]){
//            //移除我的预约
//            [array removeObject:@"GBmine_reply"];
//        }
//        
//        
//        _imageArray = array;
//    }
//    
//    return _imageArray;
//}
//
//-(NSArray *)titleArray{
//    if(!_titleArray){
//        NSMutableArray* array = [NSMutableArray arrayWithArray:@[@"咨询",@"预约",@"提醒",@"钱包",@"优惠券",@"设置",@"医生",@"帮助反馈",@"分享"]];
//        
//        NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
//        BOOL  isDoctor = [[user1   objectForKey:[NSString stringWithFormat:@"%dIsdoctorMineView",kCurrentUser.userId]] boolValue];
//        if ([[NSString  stringWithFormat:@"%d",isDoctor]  isEqualToString:@"0"]) {
//            NSLog( @"移除2：%d",isDoctor);
//            
//            [array  removeObject:@"医生"];
//            
//        }
//    
//        NSString* configureValue = [ConfiguresEntity findConfigureValueWithKey:configureKey];
//        if(![configureValue isEqualToString:@"true"]){
//            //移除我的咨询
//            [array removeObject:@"咨询"];
//        }
//        
//        if([[ConfiguresEntity findConfigureValueWithKey:openMZYYKey] isEqualToString:@"false"]){
//            //移除我的预约
//            [array removeObject:@"预约"];
//        }
//        
//        _titleArray = array;
//        
//    }
//    NSLog(@"_titleArray:%@",_titleArray);
//    return _titleArray;
//}

-(NSMutableArray<NSArray *> *)dataSource{
    if(!_dataSource){
        
//        NSMutableArray* section1 = [NSMutableArray arrayWithArray:@[@{@"title":@"我的帐号", @"icon":@"wdzh_icon"}, @{@"title":@"我的咨询", @"icon":@"zxkf_icon"}, @{@"title":@"我的预约", @"icon":@"wdyy_icon"},@{@"title":@"我的喜欢", @"icon":@"GB_Mine_Favorite"},@{@"title":@"我的服务", @"icon":@"wdfw_icon"}, @{@"title":@"我的提醒", @"icon":@"wdtx_icon"},@{@"title":@"我的医院",@"icon":@"wdbdyy_icon"},@{@"title":@"我的医生",@"icon":@"mine_doc"}]];
                NSMutableArray* section1 = [NSMutableArray arrayWithArray:@[@{@"title":@"我的帐号", @"icon":@"wdzh_icon"}, @{@"title":@"我的咨询", @"icon":@"zxkf_icon"}, @{@"title":@"我的预约", @"icon":@"wdyy_icon"},@{@"title":@"我的喜欢", @"icon":@"GB_Mine_Favorite"},@{@"title":@"我的服务", @"icon":@"wdfw_icon"},@{@"title":@"我的医院",@"icon":@"wdbdyy_icon"},@{@"title":@"我的医生",@"icon":@"mine_doc"}]];
        
        NSMutableArray* section2 = [NSMutableArray arrayWithArray:@[@{@"title":@"我的钱包", @"icon":@"wdqb_icon"}, @{@"title":@"我的优惠券", @"icon":@"wdyhq_icon"}, @{@"title":@"分享得优惠券", @"icon":@"fxdyhq_icon"}]];
        
        NSMutableArray* section3 = [NSMutableArray arrayWithArray:@[@{@"title":@"设置", @"icon":@"sz_icon"}, @{@"title":@"医生设置", @"icon":@"yssz_icon"}, @{@"title":@"帮助反馈", @"icon":@"bzfk_icon"}]];
        
        
        NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
        BOOL  isDoctor = [[user1   objectForKey:[NSString stringWithFormat:@"%ldIsdoctorMineView",(long)kCurrentUser.userId]] boolValue];
        if ([[NSString  stringWithFormat:@"%d",isDoctor]  isEqualToString:@"0"]) {
            //移除医生
            [section3  removeObjectAtIndex:1];
            
        }
        
        NSString* configureValue = [ConfiguresEntity findConfigureValueWithKey:configureKey];
        if(![configureValue isEqualToString:@"true"]){
            //移除我的咨询
            [section1 removeObjectAtIndex:1];
        }
        
        if([[ConfiguresEntity findConfigureValueWithKey:openMZYYKey] isEqualToString:@"false"]){
            //移除我的预约
            [section1 removeObjectAtIndex:2];
        }
        
        _dataSource = [NSMutableArray arrayWithObjects:section1,section2,section3, nil];
        
    }
    return _dataSource;
}


#pragma mark - 注册通知
- (void)registerNotification{
//    [kdefaultCenter addObserver:self selector:@selector(handleChangeBabyNotification:) name:Notification_ChangeBaby object:nil];//切换宝宝
    
//    [kdefaultCenter addObserver:self selector:@selector(synchronizeIcon:) name:Notification_synchronizeIcon object:nil];//同步头像
    
    //修改宝宝档案，同步更新默认宝宝名字
//    [kdefaultCenter addObserver:self selector:@selector(updateDefaultBabyInfo:) name:Notification_UpdateDefaultBabyInfo object:nil];
    
    //获取所有宝宝
    [kdefaultCenter addObserver:self selector:@selector(updateBabyArchList) name:Notification_Update_AllBaby object:nil];
    //同步切换宝宝
    [kdefaultCenter addObserver:self selector:@selector(convertBaby:) name:Notification_ConvertBaby object:nil];

    //删除宝宝
    [kdefaultCenter addObserver:self selector:@selector(deleteLinkBaby:) name:Notification_DeleteLinkBaby object:nil];


    
    
    
}

#pragma mark - 通知回调方法
#pragma mark * 更新宝宝列表
- (void)updateBabyArchList{
    [self.presenter loadAllBaby];
    
}
#pragma mark * 切换宝宝
- (void)convertBaby:(NSNotification*) notification{
    
    NSString* childName = [notification.userInfo objectForKey:@"name"];
    
    //滚动当前默认宝宝
    [self convertToDefaultbaby:childName];
}
#pragma mark * 删除关联宝宝
- (void)deleteLinkBaby:(NSNotification*) notification{
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* babyID = userInfo[@"babyID"];
    
    BabayArchList* tempBaby = nil;
    for(BabayArchList* babyList in self.presenter.babyDataSource){
        if(babyList.childID == [babyID integerValue]){
            //移除
            tempBaby = babyList;
            break;
        }
    }
    if(tempBaby){
        [self.presenter.babyDataSource removeObject:tempBaby];
        [self.headerCollection reloadData];
    }
    
    if(self.presenter.babyDataSource.count == 0){
        self.heightTitleLabel.text = @"0cm";
        self.weightTitleLabel.text = @"0kg";
        self.vaccineTitleLabel.text = @"暂无";
        
        kCurrentUser.needToUpdateChildInfo = YES;
    }
    
    //隐藏右上角添加宝宝按钮
    UIButton* addButton = (UIButton*)[self.collectionbgView viewWithTag:101];
    UIView* noBabyAddbgView = [self.collectionbgView viewWithTag:102];
    UIImageView* triangle = (UIImageView*)[self.collectionbgView.superview viewWithTag:103];
    
    addButton.hidden = self.presenter.babyDataSource.count == 0;
    triangle.hidden = addButton.hidden;
    noBabyAddbgView.hidden = !addButton.hidden;

    
}


///**
// *  修改宝贝
// */
//- (void)handleChangeBabyNotification:(NSNotification*) notice{
//    NSDictionary* userInfo = notice.userInfo;
//    
//    if(!userInfo) return ;//区别删除通知
//    BabayArchList* baby = userInfo[@"baby"];
//    _currentBabyName = baby.childName;
//    _baby.text = [NSString stringWithFormat:@"%@", baby.childName];
//    //修改宝宝头像
//    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,baby.childImg]] placeholderImage:[UIImage imageNamed:@"GB_icon"]];
//    
//}
//
///**
// *  同步头像
// *
// *  @param notice <#notice description#>
// */
//- (void)synchronizeIcon:(NSNotification*) notice{
//    NSString* headerImage = [NSString stringWithFormat:@"%@%@",ICON_URL,[DefaultChildEntity defaultChild].childImg];
//    NSURL* url = [NSURL URLWithString:headerImage];
//    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"GB_icon"]];
//    
//    //名字
//    NSString* currentBaby = [DefaultChildEntity defaultChild].childName;
//    if(currentBaby.length == 0){
//        currentBaby = @"无";
//        _currentBabyName = nil;
//    }else{
//        _currentBabyName = currentBaby;
//    }
//    _baby.text = [NSString stringWithFormat:@"%@",currentBaby ];
//  }
//
//- (void)deleteCurrentBaby:(NSNotification*) notice{
//    _icon.image = [UIImage imageNamed:@"GB_icon"];
//    _baby.text = @"无";
//    _currentBabyName = nil;
//    //更新数据默认宝宝数据
//    [DefaultChildEntity deleteDefaultChild];
//    
//    
//    //    [kdefaultCenter postNotificationName:Notification_ChangeBaby object:nil userInfo:nil];//同步首页删除当前宝宝
//    
//    kCurrentUser.needToUpdateChildInfo = YES;
//}
//
///**
// *  更新默认宝宝信息
// *
// *  @param notice <#notice description#>
// */
//- (void)updateDefaultBabyInfo:(NSNotification*) notice{
//    if(!notice.userInfo) return ;
//    NSDictionary* dic = notice.userInfo;
//    NSString* currentBaby = dic[@"name"];
//    if(currentBaby.length == 0){
//        currentBaby = @"无";
//        _currentBabyName = nil;
//    }else{
//        _currentBabyName = currentBaby;
//    }
//    _baby.text = [NSString stringWithFormat:@"%@",currentBaby ];
//    
//   }
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==1) {
//        ArchivesMainViewController * vc = [ArchivesMainViewController new];
//        vc.poptoClass = [MBabyManagerViewController class];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}




//#pragma mark - 监听手势
///**
// *  点击头像
// */
//- (void)handleTapGesture{
//    if (![DefaultChildEntity isHasDefaultChild]) {
//        [ProgressUtil showInfo:@"请添加宝贝信息再上传头像"];
//        return;
//    }
//    if ([DefaultChildEntity defaultChild].babyID){
//        CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
//        
//        //设置类型
//        manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
//        
//        //最多可选3张
//        manager.maxSelectedPhotoNumber = 1;
//        
//        //错误处理
//        if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
//            NSLog(@"设备不可用");
//            return;
//        }
//        
//        UIViewController *pickerVC=manager.imagePickerController;
//        WS(ws);
//        //选取结束
//        manager.finishPickingMedia=^(NSArray *medias){
//            
//            runOnBackground(^{
//                [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
//                    NSString * path = [photo.editedImage saveToLocal];
//                    
//                    
//                    [ws.presenter changeChildAvaterWithPath:path];
//                }];
//                
//            });
//            
//        };
//        [self.navigationController presentViewController:pickerVC animated:YES completion:nil];
//        
//    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"温馨提示" message:@"添加宝宝后,才能为宝宝上传头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//        
//        
//    }
//    
//}
////点击切换
//-(void)ManageTapGesture{
//
//    MBabyManagerViewController* babyManager = [MBabyManagerViewController new];
//    babyManager.currentBabyName = _currentBabyName;
//    babyManager.currentUserName = _currentUserName;
//    [self.navigationController pushViewController:babyManager animated:YES];
//}

#pragma mark - 私有方法
#pragma mark * 切换到默认宝宝
-(void)convertToDefaultbaby:(NSString*) childName{
    
    if(!childName || childName.length == 0){
//        [self.headerCollection reloadData];

        BabayArchList* baby = [self.presenter.babyDataSource firstObject];
        self.currentSelectBaby = baby;
        
        self.heightTitleLabel.text = [NSString stringWithFormat:@"%.f cm",[baby.height floatValue]];
        self.weightTitleLabel.text = [NSString stringWithFormat:@"%.1f kg",[baby.weight floatValue]];
        [self.weightTitleLabel updateLayout];
        
                    runOnBackground(^{
//                        NSInteger today = [self generateDate:baby.birthDate];
                babyDateString = [baby.birthDate  format2String:@"yyyy-MM-dd"];
                        runOnMainThread(^{
                    [self.presenter getVaccineEventWithmonth:babyDateString];
                        });
                    });
        
        return ;

    }
    
    int index = 0;
    for(int i = 0; i < self.presenter.babyDataSource.count; i++){
        BabayArchList* baby = [self.presenter.babyDataSource objectAtIndex:i];
        if([baby.childName isEqualToString:childName]){
            index = i;
            break ;
        }
    }
    
    
    
    BabayArchList* baby = [self.presenter.babyDataSource objectAtIndex:index];
    self.currentSelectBaby = baby;
    
    [self.presenter.babyDataSource exchangeObjectAtIndex:0 withObjectAtIndex:index];
    
//    [self.headerCollection reloadData];
    

    
    self.heightTitleLabel.text = [NSString stringWithFormat:@"%.f cm",[baby.height floatValue]];
    self.weightTitleLabel.text = [NSString stringWithFormat:@"%.1f kg",[baby.weight floatValue]];
    [self.weightTitleLabel updateLayout];
    


    
            runOnBackground(^{
//                NSInteger today = [self generateDate:baby.birthDate];
//                WSLog(@"today = %ld",today);
                babyDateString = [baby.birthDate  format2String:@"yyyy-MM-dd"];
                runOnMainThread(^{
                    [self.presenter getVaccineEventWithmonth:babyDateString];
                });
            });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.headerCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.headerCollection reloadData];
        
    });

    

}

- (CGFloat)cellContentViewWith{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(NSInteger)generateDate:(NSDate*) birthdDate{
    NSDate * date = birthdDate;
    NSDate* yearAfter18 = [birthdDate afterYear:18];
    NSUInteger count = 0;
    NSDate * today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
//    while ([date compare:yearAfter18] == NSOrderedAscending) {
////        NSString * dateStr = [date formatToChinese:birthdDate];
//        date = [date tomorrow];
//        count ++;
//        
//    }
    NSDateComponents *d = [cal components:NSCalendarUnitDay fromDate:birthdDate toDate:today options:0];
    count = d.day + 1;
    NSLog(@"次数：%ld",count);
    return count;



//    NSDate * date = _childEntity.birthDate;
//    NSDate * yearAfter18 = [_childEntity.birthDate afterYear:18];
//    _birthDatesForDate = [NSMutableArray new];
//    NSUInteger count = 0;
//    NSDate * today = [NSDate date];
//    //    NSLog(@"确定的时间4：%@",today);
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    while ([date compare:yearAfter18] == NSOrderedAscending) {
//        NSString * dateStr = [date formatToChinese:_childEntity.birthDate];
//        //        NSLog(@"确定的时间5：%@",dateStr);
//        AlertEntity * entity = [AlertEntity new];
//        entity.date = dateStr;
//        [_birthDates addObject:entity];
//        [_birthDatesForDate addObject:[date format2String:@"yyyy-MM-dd"]];
//        date = [date tomorrow];
//        //        NSLog(@"确定的时间6：%@",date);
//        
//        count ++;
//        
//    }
//    NSDateComponents *d = [cal components:NSCalendarUnitDay fromDate:_childEntity.birthDate toDate:today options:0];
//    count = d.day + 1;
//    NSLog(@"次数：%ld",count);
//    return count;
    
}



#pragma mark -
/**
 *  <#Description#>
 */
-(void)dealloc{
    
//    [kdefaultCenter removeObserver:self name:Notification_ChangeBaby object:nil];
//    
//    [kdefaultCenter removeObserver:self name:Notification_synchronizeIcon object:nil];
//    
//    [kdefaultCenter removeObserver:self name:Notification_DeleteCurrentBaby object:nil];
//    
    
    [kdefaultCenter removeObserver:self name:Notification_Update_AllBaby object:nil];

    [kdefaultCenter removeObserver:self name:Notification_ConvertBaby object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_DeleteLinkBaby object:nil];


    
    
}
//#pragma mark---获取当前孩子的个人信息
//-(void)onGetChildInfoComplete:(BOOL)success info:(NSString *)message{
//    if (success) {
//        [ProgressUtil  dismiss];
//        
//        GBChildEntity * child = _presenter.GBchildEntity;
//        
//        
//        NSString* currentBaby = child.Child_Name;
//        if(currentBaby.length == 0){
//            currentBaby = @"无";
//        }
//        _baby.text = [NSString stringWithFormat:@"%@",currentBaby ];
//        _currentBabyName = currentBaby;
//        
//        if (child.NickName.length==0) {
//            _userName.text = @"无";
//        }else{
//        
//          _userName.text = child.NickName;
//        
//        }
//        _currentUserName = _userName.text;
//
//    NSString* currentSex = child.Child_Sex;
//        NSLog(@"性别%@",currentSex);
//        if(currentSex.length == 0){
//            
//        _sexImageView.image =  nil;
//        }
//        if ([currentSex isEqualToString:@"1"]) {
//            //男
//            currentSex = @"nan";
//        _sexImageView.image = [UIImage  imageNamed:currentSex];
//        }
//        if ([currentSex isEqualToString:@"2"]) {
//            //女
//            currentSex = @"nv";
//    _sexImageView.image = [UIImage  imageNamed:currentSex];
//        }
//    
//          }
//            else{
//                
//                 _sexImageView.image =  nil;
//                [ProgressUtil  showError:message];
//        
//    }
//    
//}
//-(void)onGetgetExperIDComplete:(BOOL)success info:(NSString*)message{
//    if (success) {
//    }else{
//    
//        [ProgressUtil  showError:message];
//    }
//
//
//
//
//}

@end
