//
//  FDApplyDoctorViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDApplyDoctorViewController.h"
#import "TQStarRatingView.h"
#import "ZHDocDetailView.h"
#import "UILabel+VerticalAlignment.h"
#import "ZHCollectionView.h"
#import "JMFoundation.h"
#import "FDChoicePackageViewController.h"
#import "FDApplyDoctorPresenter.h"
#import "FDPackageChooseViewController.h"
#import "FDSuccessViewController.h"
#import "FDApplyDoctorTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

#define AC_FONT [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]
#define AC_FONT_SMALL [UIFont systemFontOfSize:(kScreenWidth == 320 ? 12 : 16)]

@interface FDApplyDoctorViewController ()<FDApplyDoctorPresenterDelegate>
{
    UIScrollView *_scrollView;
    
    UIImageView *_headImageView;
    TQStarRatingView *_scoleView;
    UILabel *_nameLabel;
    UILabel *_postLabel;
    UILabel *_departmennt;
    
    
    ZHDocDetailView *_niceView;
    ZHDocDetailView *_askView;
    UIView * _sep_1;
    ZHDocDetailView *_signPatientView;
    UIView * _sep_2;
    UIView * _sep_3;
    UIView * _sep_4;
    UIView * _sep_5;

    UIView* _packagebgView;
    UILabel* _packageLabel;
    UIImageView* _packageIndactor;
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    
    ZHCollectionView *_collectionView;
    
    UILabel *_tipsLabel;
    
    UIButton *_addDoctorButton;
    
    UIButton *_sampleInfoButton;
    UIButton *_appointmentButton;
    
//    FDApplyDoctorPresenter *_presenter;
    
    UILabel* _addressLabel;
    UILabel* _fieldLabel;
}

@property(nonatomic,retain) FDApplyDoctorPresenter* presenter;

@property(nonatomic,retain) Package* selectPackage;

@property(nonatomic,retain) UIView* babyView;

@end

@implementation FDApplyDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerNotification];
}

#pragma mark - 注册通知
- (void)registerNotification{
    [kdefaultCenter addObserver:self selector:@selector(selectPackageAction:) name:Notification_SelectPackage object:nil];
    [kdefaultCenter addObserver:self selector:@selector(addBabyComplete) name:Notification_Add_Baby_Complete object:nil];
}

- (void)setupView{
    self.title = @"家庭医生服务";
    _dataSource = [NSMutableArray array];
    self.presenter = [FDApplyDoctorPresenter new];
    self.presenter.delegate = self;
    
    [self setupScrollView];
    [self setupHeaderImageView];
    [self setupStarView];
    [self setupSampleInfoView];
    [self setupNameView];
    [self setupPostView];
    [self setDepartmentView];
    [self setNiceView];
    [self setupSignPatientView];
    [self setupTableView];
//    [self setupPackageView];
    [self addBabyView];
    [self setupTipsLabel];
    [self setupCommitButton];
    [self loadData];
    
}
#pragma mark scrollView
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
#pragma mark 头像
- (void)setupHeaderImageView{
    _headImageView = [UIImageView new];
//    _headImageView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_scrollView,15).widthIs(80).heightEqualToWidth();
}
#pragma mark 评分
- (void)setupStarView{
    _scoleView = [TQStarRatingView new];
    _scoleView.userInteractionEnabled = NO;
    [_scrollView addSubview:_scoleView];
    _scoleView.sd_layout.leftEqualToView(_headImageView).topSpaceToView(_headImageView,10).widthIs(80).heightIs(10);
}

#pragma mark - 简介
- (void)setupSampleInfoView{
    _sampleInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sampleInfoButton setTitle:@"简介" forState:UIControlStateNormal];
    _sampleInfoButton.clipsToBounds = YES;
    [_sampleInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sampleInfoButton setBackgroundImage:[UIImage imageNamed:@"book_doc_info"] forState:UIControlStateNormal];
    _sampleInfoButton.titleLabel.font = AC_FONT;
    [_sampleInfoButton addTarget:self action:@selector(sampleInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sampleInfoButton];
    _sampleInfoButton.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scoleView,20).widthIs(70).heightIs(25);
    _sampleInfoButton.sd_cornerRadius = @(25/2.0);
}

#pragma mark 姓名
- (void)setupNameView{
    _nameLabel = [UILabel new];
    _nameLabel.font = AC_FONT;
    _nameLabel.textColor = UIColorFromRGB(0x666666);
    [_scrollView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).rightSpaceToView(_scrollView,25).topEqualToView(_headImageView).autoHeightRatio(0);
}

#pragma mark 职称
- (void)setupPostView{
    _postLabel = [UILabel new];
    _postLabel.font = AC_FONT;
    _postLabel.textColor = UIColorFromRGB(0x999999);
    [_scrollView addSubview:_postLabel];
    _postLabel.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_nameLabel,5).autoHeightRatio(0);
}

#pragma mark 科室
- (void)setDepartmentView{
    _departmennt = [UILabel new];
    _departmennt.font = AC_FONT;
    _departmennt.textColor = _postLabel.textColor;
    [_scrollView addSubview:_departmennt];
    _departmennt.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_postLabel,5).autoHeightRatio(0);
}

#pragma mark 好评、咨询
- (void)setNiceView{
    _niceView = [ZHDocDetailView new];
    [_scrollView addSubview:_niceView];
    _niceView.sd_layout.leftSpaceToView(_scrollView,115).topSpaceToView(_departmennt,27).widthIs((kScreenWidth - 115)/2).heightIs(20);
    [_niceView initSubViews];
    _niceView.iconView.image = [UIImage imageNamed:@"ac_nice"];
    _niceView.textLabel.textColor = UIColorFromRGB(0x999999);
    _niceView.textLabel.font = AC_FONT_SMALL;
    
    _askView = [ZHDocDetailView new];
    [_scrollView addSubview:_askView];
    _askView.sd_layout.leftSpaceToView(_niceView,0).topSpaceToView(_departmennt,27).widthIs((kScreenWidth - 115)/2).heightIs(20);
    [_askView initSubViews];
    _askView.iconView.image = [UIImage imageNamed:@"ac_ask"];
    _askView.textLabel.textColor = UIColorFromRGB(0x999999);
    _askView.textLabel.font = AC_FONT_SMALL;

    
    _sep_1 = [UIView new];
    _sep_1.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scrollView addSubview:_sep_1];
    _sep_1.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_niceView,10).rightSpaceToView(_scrollView,0).heightIs(1);

}

#pragma mark 签约患者
- (void)setupSignPatientView{
    _signPatientView = [ZHDocDetailView new];
    [_scrollView addSubview:_signPatientView];
    _signPatientView.sd_layout.leftEqualToView(_nameLabel).rightSpaceToView(_scrollView,0).topSpaceToView(_sep_1,10).heightIs(20);
    [_signPatientView initSubViews];
    _signPatientView.iconView.image = [UIImage imageNamed:@"signPatient"];
    _signPatientView.textLabel.textColor = UIColorFromRGB(0x999999);
    _signPatientView.textLabel.font = AC_FONT_SMALL;
    
     _sep_2 = [UIView new];
    _sep_2.backgroundColor = _sep_1.backgroundColor;
    [_scrollView addSubview:_sep_2];
    _sep_2.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_signPatientView,10).rightSpaceToView(_scrollView,0).heightIs(1);

    
}

#pragma mark 执业地点/擅长领域/
- (void)setupTableView{
    
    _addressLabel = [UILabel new];
    _addressLabel.font = AC_FONT;
    _addressLabel.textColor = RGB(81, 81, 81);
    [_scrollView addSubview:_addressLabel];
    
    _sep_3 = [UIView new];
    _sep_3.backgroundColor = _sep_1.backgroundColor;
    [_scrollView addSubview:_sep_3];

    _fieldLabel = [UILabel new];
    _fieldLabel.font = _addressLabel.font;
    _fieldLabel.textColor = _addressLabel.textColor;
    [_scrollView addSubview:_fieldLabel];
    
    _sep_4 = [UIView new];
    _sep_4.backgroundColor = _sep_1.backgroundColor;
    [_scrollView addSubview:_sep_4];

    _addressLabel.sd_layout.topSpaceToView(_sep_2,10).autoHeightRatio(0).leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20);
    _sep_3.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_addressLabel,10).rightSpaceToView(_scrollView,0).heightIs(1);

    _fieldLabel.sd_layout.topSpaceToView(_sep_3,10).autoHeightRatio(0).leftEqualToView(_addressLabel).rightEqualToView(_addressLabel);
    _sep_4.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_fieldLabel,10).rightSpaceToView(_scrollView,0).heightIs(1);

    
}

#pragma mark - 选择套餐
- (void)setupPackageView{
    _sep_5 = [UIView new];
    _sep_5.backgroundColor = _sep_1.backgroundColor;
    [_scrollView addSubview:_sep_5];
    _sep_5.sd_layout.topSpaceToView(_fieldLabel,10).heightIs(1).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    

    _packagebgView = [UIView new];
    _packagebgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scrollView addSubview:_packagebgView];
    
    UITapGestureRecognizer* babyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPackage)];
    [_packagebgView addGestureRecognizer:babyTap];
    
    _packageLabel = [UILabel new];
    _packageLabel.font = _fieldLabel.font;
    _packageLabel.textColor = _fieldLabel.textColor;
    [_packagebgView addSubview:_packageLabel];
    
    _packageIndactor = [UIImageView new];
    _packageIndactor.userInteractionEnabled = YES;
    _packageIndactor.image = [UIImage imageNamed:@"mine_indactor"];
    [_packagebgView addSubview:_packageIndactor];
    
    
    _packageLabel.sd_layout.topSpaceToView(_packagebgView,10).leftSpaceToView(_packagebgView,20).autoHeightRatio(0);
    [_packageLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _packageIndactor.sd_layout.centerYEqualToView(_packageLabel).heightIs(37/2.0).rightSpaceToView(_packagebgView,25).widthIs(21/2.0);
    
    _packagebgView.sd_layout.topSpaceToView(_sep_5,0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    [_packagebgView setupAutoHeightWithBottomViewsArray:@[_packageLabel,_packageIndactor] bottomMargin:10];
}

#pragma mark 添加baby
- (void)addBabyView{
    UIView *babyView = [UIView new];
    _babyView = babyView;
    babyView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:babyView];

//    babyView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_packagebgView,0);
    
        babyView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_sep_4,0);
    
    UILabel *babyTips_1 = [UILabel new];
    babyTips_1.text = @"请添加您的宝贝";
    babyTips_1.textColor = RGB(81, 81, 81);
    babyTips_1.font = AC_FONT;
    [babyView addSubview:babyTips_1];
    babyTips_1.sd_layout.leftSpaceToView(babyView,10).topSpaceToView(babyView,10).autoHeightRatio(0);
    [babyTips_1 setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    
    UILabel *babyTips_2 = [UILabel new];
    babyTips_2.textColor = UIColorFromRGB(0x999999);
    babyTips_2.font = [UIFont systemFontOfSize:12];
    babyTips_2.textAlignment = NSTextAlignmentRight;
    babyTips_2.text = @"完善宝宝信息以便医生更快的通过申请";
    [babyView addSubview:babyTips_2];
    babyTips_2.sd_layout.rightSpaceToView(babyView,10).centerYEqualToView(babyTips_1).autoHeightRatio(0);
    [babyTips_2 setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    //collectionview
    _collectionView = [ZHCollectionView new];
    _collectionView.popToClass = [self class];
    _collectionView.backgroundColor = [UIColor clearColor];
    [babyView addSubview:_collectionView];
    _collectionView.sd_layout.leftSpaceToView(babyView,0).rightSpaceToView(babyView,0).topSpaceToView(babyTips_1,10).heightIs(100);
    
    [babyView setupAutoHeightWithBottomView:_collectionView bottomMargin:10];
}

#pragma mark - 提示语
- (void)setupTipsLabel{
    
    _tipsLabel = [UILabel new];
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.textColor = [UIColor redColor];
    _tipsLabel.text = @"* 温馨提示：提交成功后，医生将在七天内进行审核。审核成功后，您将在首页事件提醒中收到通知，刷新医生界面就会看到您添加的家庭医生。请您在申请成功后七天内付款。否则您申请的家庭医生资格将被取消，并影响您下次申请家庭医生成功率。";
    [_scrollView addSubview:_tipsLabel];
    _tipsLabel.sd_layout.leftSpaceToView(_scrollView,10).rightSpaceToView(_scrollView,10).topSpaceToView(_babyView,10).autoHeightRatio(0);
}

#pragma mark - 提交按钮
- (void)setupCommitButton{
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(FDACommitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:commitButton];
    commitButton.sd_layout.leftSpaceToView(_scrollView,10).rightSpaceToView(_scrollView,10).topSpaceToView(_tipsLabel,15).heightIs(40);
    [_scrollView setupAutoContentSizeWithBottomView:commitButton bottomMargin:30];
}


#pragma mark 加载数据
- (void)loadData{
    __block __weak ZHCollectionView *weakCollect = _collectionView;
    [self.presenter loadBabyData:^(BOOL success, NSArray *babyArray) {
        weakCollect.babyArray = [NSMutableArray arrayWithArray:babyArray];
        [weakCollect reloadData];
    }];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.doctor.UserImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    
    [_scoleView setScore:self.doctor.StarNum/10.0 withAnimation:YES];
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.doctor.UserName];
    _postLabel.text = [NSString stringWithFormat:@"职称：%@",self.doctor.ProfessionalName];
    _departmennt.text = [NSString stringWithFormat:@"科室：%@",self.doctor.DepartName];
    _niceView.textLabel.text = [NSString stringWithFormat:@"好评:%@",self.doctor.PraiseNum];//
    _askView.textLabel.text = [NSString stringWithFormat:@"咨询:%@例",self.doctor.ConsultNum];//
    _signPatientView.textLabel.text = [NSString stringWithFormat:@"签约患者：%@",self.doctor.num];
    
    NSString* address = [NSString stringWithFormat:@"执业地点：%@",self.doctor.HName];
    NSString* field = [NSString stringWithFormat:@"擅长领域：%@",self.doctor.Field];
    _addressLabel.text = address;
    _fieldLabel.text = field;
    [_addressLabel updateLayout];
    
    _packageLabel.text = @"请选择家庭医生套餐服务：";
    
}

#pragma mark - 代理
-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil showSuccess:@"添加成功"];
        //
        [kdefaultCenter postNotificationName:Notification_UpdateFamilyDoctor object:nil userInfo:nil];
        
        FDSuccessViewController* success = [FDSuccessViewController new];
        success.doctor = self.doctor;
        [self.navigationController pushViewController:success animated:YES];
    }else{
        [ProgressUtil showError:message];
    }
}

#pragma mark - 点击事件
- (void)FDACommitAction{
    if(!self.selectPackage){
//    //提示选择套餐
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请选择套餐" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return ;
    }
    //判断是否选择孩子
    if(!_collectionView.currentChild){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请选择宝贝" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;
    }
    
    
    [ProgressUtil show];
    
    NSInteger packageID = [self.selectPackage.fapackageID integerValue];
    
//    ChildEntity* child = [_collectionView.selectBabyArray firstObject];
    ChildEntity* child = _collectionView.currentChild;
    NSInteger babyID = child.childID;
    
//    NSInteger doctorID = 7;//测试
    NSInteger doctorID = [self.doctor.DoctorID integerValue];
    
    [self.presenter commitFamilyDoctor:doctorID babyID:babyID packageID:packageID];

}
- (void)sampleInfoAction{
    NSLog(@"简介");
}

#pragma mark - 套餐手势
- (void)handleTapPackage{
    FDPackageChooseViewController* package = [FDPackageChooseViewController new];
    package.doctorID = [self.doctor.DoctorID integerValue];
    [self.navigationController pushViewController:package animated:YES];
}

#pragma mark - 通知回调
/**
 *  选择套餐
 */
- (void)selectPackageAction:(NSNotification*) notice{
    NSDictionary* userInfo = notice.userInfo;
    Package* p = [userInfo objectForKey:@"package"];
    self.selectPackage = p;
    _packageLabel.text = [NSString stringWithFormat:@"选择家庭医生套餐服务：%@元套餐",p.fapackagePrice];

    
}
- (void)addBabyComplete{
    __block __weak ZHCollectionView *weakCollect = _collectionView;
    [self.presenter loadBabyData:^(BOOL success, NSArray *babyArray) {
        weakCollect.babyArray = [NSMutableArray arrayWithArray:babyArray];
        [weakCollect reloadData];
    }];
}


-(void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_SelectPackage object:nil];
    [kdefaultCenter removeObserver:self name:Notification_Add_Baby_Complete object:nil];
}

@end
