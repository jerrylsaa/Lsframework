
//  HomeViewController.m
//  PublicHealth

//  Created by xuwenqi on 16/3/8.
//  Copyright © 2016年 zhonghong. All rights reserved.
// HealthFacts

#import "HomeViewController.h"
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
#import "HExpertAnswerViewController.h"

typedef enum : NSUInteger {
    ConsultDoctorBtn,
    GoToDoctorBtn,
    HealthTeachBtn,
    HealthServiceBtn,
    HealthRecordBtn,
    ExpertAnswerBtn
} BtnType;

@interface HomeViewController ()<HomePresenterDelegate, UIScrollViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (nonatomic, strong) HomePresenter * presenter;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (nonatomic, weak) UIView *assistLineV;
@property (nonatomic, weak) UIView *assistLineH;
@property (nonatomic, weak) UIImageView *iv_HomeBGI_Round;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;

@property (nonatomic, weak) UIButton *consultDoctorBtn;
@property (nonatomic, weak) UIButton *goToDoctorBtn;
@property (nonatomic, weak) UIButton *healthTeachBtn;
@property (nonatomic, weak) UIButton *healthServiceBtn;
@property (nonatomic, weak) UIButton *healthRecordBtn;
@property (nonatomic, weak) UIButton *expertAnswerBtn;

@property (weak, nonatomic) IBOutlet FPLabel *lbWeek;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat btnHeight;
@property (weak, nonatomic) IBOutlet FPLabel *lbYear;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
@property (weak, nonatomic) IBOutlet UILabel *lbCheckIn;
@property (weak, nonatomic) IBOutlet UIImageView *imageChildAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbBabyName;
@property (weak, nonatomic) IBOutlet UILabel *lbBirthDay;
@property (weak, nonatomic) IBOutlet UIImageView *imageSex;
@property (weak, nonatomic) IBOutlet UIButton *buttonHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnWeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *targetViewFullHeight;

@property (assign) NSInteger today;
@property (nonatomic,copy) NSMutableString *openUrl;
@property (nonatomic,copy) NSMutableDictionary *dataDic;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBackBarWithImage:nil];
    
    self.title = @"首页";
    
    [self initBackBarWithImage:[UIImage imageNamed:@"LeftDoctorBar"]];
    //    [self initRightBarWithImage:[UIImage imageNamed:@"SearchIcon"]];
    self.isHideTabbar = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildAdvetar:) name:@"UPDATECHILD" object:nil];
    //    [self  initRightBarWithImage:[UIImage imageNamed:@"EventCall"]];
    
    kCurrentUser.needToUpdateChildInfo = YES;
    
    
    [kCurrentUser addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew context:nil];
    [self checkOnline];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"token"]){
        [_presenter getChildInfo];
    }
}
//检测
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
    [alertView show];
    
}

- (void)alertViewRequiredAction:(NSString *)version with:(NSString *)updateContent{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"有可用的更新版本:%@",version] message:[NSString stringWithFormat:@"%@",updateContent] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag =1002;
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
        }
    }
    
}

- (IBAction)btnCheckInAction:(id)sender {
    [_presenter signToday];
}

-(void)backItemAction:(id)sender{
    
    JMChatViewController * vc  =[[JMChatViewController alloc] init];
    
    vc.conversationType = ConversationType_CUSTOMERSERVICE;
    
    vc.targetId = PUBLIC_SERVICE_KEY;
    
    [self.navigationController pushViewController:vc animated:YES];}


#pragma mark - 加载视图
-(void)setupView
{
    _presenter = [HomePresenter new];
    _presenter.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    _collectionView.collectionViewLayout = [HomeLayout new];
    
    self.btnHeight = (kScreenWidth-35*2-5)/2.0;
    
    self.heightConstraint.constant = 109+110+self.btnHeight*2+15+10+10;
    
    [self setupRoundImgView];
    
    [self setupAssistLine];
    
//        [self setupConsultDoctorBtn];
    
    [self setupGoToDoctorBtn];
    
    [self setupHealthTeachBtn];
    
    [self setupHealthServiceBtn];
    
    [self setupHealthRecordBtn];
    
    [self setupExpertAnswerBtn];
    
    
    [_presenter checkIsSignToady];
    _lbYear.text = [[NSDate date] format2String:@"yyyy"];
    _lbName.text = kCurrentUser.userName;
    //    [[UploadDemo new] uploadDemo];
    _imageChildAvatar.userInteractionEnabled = YES;
    [_imageChildAvatar setCornerRadius:39.];
    [_imageChildAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageChildAvatarTapAction:)]];
    _today = -1;
    
    
}

-(void)viewDidLayoutSubviews{
    [self configurationConstraint];
}

#pragma mark HomePresenterDelegate

-(void)onChangeChildAvaterCompleted:(NSString *)path{
    [_imageChildAvatar setImage:[UIImage imageWithContentsOfFile:path]];
    [kdefaultCenter postNotificationName:Notification_synchronizeIcon object:nil userInfo:nil];
}

-(void)onGetAlertWithDay:(NSUInteger)day{
    _lbAlert.text = _presenter.birthDates[day].alert;
}

-(void)onGetChildInfoComplete:(BOOL)success today:(NSInteger)today{
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            _today = today;
            [_collectionView reloadData];
            if (_presenter.birthDates.count > today) {
                
                UICollectionViewLayoutAttributes * attr = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:today inSection:0]];
                CGFloat x = [self targetOffest:attr.frame.origin.x];
                _collectionView.contentOffset = CGPointMake(x , 0);
                _today = today + 2;
            }
            
            [_presenter getAlertWithDay:_today - 2];
            
            ChildEntity * child = _presenter.childEntity;
            [_buttonHeight setTitle:[NSString stringWithFormat:@"%@cm", child.birthHeight] forState:UIControlStateNormal];
            [_btnWeight setTitle:[NSString stringWithFormat:@"%@kg", child.birthWeight] forState:UIControlStateNormal];
            _lbBirthDay.text = [child.birthDate format2String:@"yyyy-MM-dd"];
            _imageSex.image = [child.childSex isEqualToString:@"1"] ? [UIImage imageNamed:@"Sex_male"] : [UIImage imageNamed:@"Sex_Female"];
            _lbBabyName.text = [NSString stringWithFormat:@"宝宝：%@", child.childName];
            _lbWeek.text = [[NSDate date] weekFromBirthday:child.birthDate];
            _lbName.text = child.GUARGIAN_NAME;
            //设置头像
            UIImage* placeholderImage = nil;
            
            if(child.child_Img.length == 0){
                placeholderImage = [UIImage imageNamed:@"doctor_icon"];
            }
            [_imageChildAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,child.child_Img]] placeholderImage:placeholderImage];
            
            //更新我的首页宝宝名字
            
            _emptyView.hidden = YES;
            _topView.hidden = NO;
            _centerView.hidden = NO;
        });
        
    }else{
        _emptyView.hidden = NO;
        _topView.hidden = YES;
        _centerView.hidden = YES;
    }
    
}

-(void)onUpdateCompletion:(BOOL)success today:(NSInteger)today{
    [self onGetChildInfoComplete:success today:today];
}

-(CGFloat)targetOffest:(CGFloat)x{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
    //获得计算好的属性
    NSArray *attsArray = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    //计算collection中心点X
    CGFloat centerX = x + self.collectionView.frame.size.width / 2;
    
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    x += minSpace;
    return x;
}

-(void)onCheckIsSignToday:(BOOL)isSign{
    if (isSign) {
        _btnCheckIn.enabled = NO;
        _lbCheckIn.text = @"已签到";
    }
}

-(void)onSignToday:(BOOL)complete{
    if (complete) {
        _btnCheckIn.enabled = NO;
        _lbCheckIn.text = @"已签到";
        [ProgressUtil dismiss];
    }else{
        [ProgressUtil showError:@"签到失败，请重试。"];
    }
    
}

-(void)onLoadMoreDataComplete{
    
    [_collectionView reloadData];
}

#pragma mark SetupView

-(void)setupRoundImgView
{
    UIImageView *iv_HomeBGI_Round = [UIImageView new];
    
    iv_HomeBGI_Round.image = [UIImage imageNamed:@"HomeBgImg_Round"];
    
    [self.bottomView addSubview:iv_HomeBGI_Round];
    
    self.iv_HomeBGI_Round = iv_HomeBGI_Round;
    
}
-(void)setupAssistLine
{
    UIView *lineV = [UIView new];
    
    UIView *lineH = [UIView new];
    
    [self.bottomView addSubview:lineH];
    
    [self.bottomView addSubview:lineV];
    
    self.assistLineV = lineV;
    
    self.assistLineH = lineH;
}
-(void)setupConsultDoctorBtn
{
    UIButton *childRecordBtn = [UIButton new];
    
    [childRecordBtn setBackgroundImage:[UIImage imageNamed:@"ChildRecord"] forState:UIControlStateNormal];
    
    childRecordBtn.tag = ConsultDoctorBtn;
    
    [childRecordBtn addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:childRecordBtn];
    
    self.consultDoctorBtn = childRecordBtn;
}

-(void)setupGoToDoctorBtn
{
    UIButton *healthTeachBtn = [UIButton new];
    
    [healthTeachBtn setBackgroundImage:[UIImage imageNamed:@"HealthTeach"] forState:UIControlStateNormal];
    
    healthTeachBtn.tag = GoToDoctorBtn;
    
    [healthTeachBtn addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:healthTeachBtn];
    
    self.goToDoctorBtn = healthTeachBtn;
}

-(void)setupHealthTeachBtn
{
    
    UIButton *priNurseBtn = [UIButton new];
    
    [priNurseBtn setBackgroundImage:[UIImage imageNamed:@"PriNurse"] forState:UIControlStateNormal];
    
    priNurseBtn.tag = HealthTeachBtn;
    
    [priNurseBtn addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:priNurseBtn];
    
    self.healthTeachBtn = priNurseBtn;
    
}

-(void)setupHealthServiceBtn
{
    UIButton *healthCareSerViceBtn = [UIButton new];
    
    [healthCareSerViceBtn setBackgroundImage:[UIImage imageNamed:@"HealthCareSerVice"] forState:UIControlStateNormal];
    
    healthCareSerViceBtn.tag = HealthServiceBtn;
    
    [healthCareSerViceBtn addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:healthCareSerViceBtn];
    
    self.healthServiceBtn = healthCareSerViceBtn;
}

-(void)setupHealthRecordBtn
{
    UIButton *childVaccinumBtn = [UIButton new];
    
    [childVaccinumBtn setBackgroundImage:[UIImage imageNamed:@"ChildVaccinum"] forState:UIControlStateNormal];
    
    childVaccinumBtn.tag = HealthRecordBtn;
    
    [childVaccinumBtn addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:childVaccinumBtn];
    
    self.healthRecordBtn = childVaccinumBtn;
}

- (void)setupExpertAnswerBtn{
    UIButton *expertAnswer = [UIButton new];
    
    [expertAnswer setBackgroundImage:[UIImage imageNamed:@"ExpertAnswer"] forState:UIControlStateNormal];
    
    expertAnswer.tag = ExpertAnswerBtn;
    
    [expertAnswer addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:expertAnswer];
    
    self.expertAnswerBtn = expertAnswer;

}

-(void)configurationConstraint
{
    
    if (kScreenHeight >= 667) {
        self.targetViewFullHeight.constant = (kScreenHeight - 64 - 49);
    }
    
    self.iv_HomeBGI_Round.sd_layout
    .centerXEqualToView(self.bottomView)
    .centerYEqualToView(self.bottomView)
    .widthIs(self.btnHeight*2)
    .heightIs(self.btnHeight*2);
    
    self.assistLineV.sd_layout
    .topSpaceToView(self.bottomView, 0)
    .bottomSpaceToView(self.bottomView, 0)
    .centerXEqualToView(self.bottomView)
    .widthIs(10);
    
    self.assistLineH.sd_layout
    .leftSpaceToView(self.bottomView, 0)
    .rightSpaceToView(self.bottomView, 0)
    .centerYEqualToView(self.bottomView)
    .heightIs(10);
    
    //    self.consultDoctorBtn.sd_layout
    //    .rightSpaceToView(self.assistLineV, 0)
    //    .bottomSpaceToView(self.assistLineH, 0)
    //    .heightIs(self.btnHeight)
    //    .widthIs(self.btnHeight);
    
    self.goToDoctorBtn.sd_layout
    .leftSpaceToView(self.assistLineV, 0)
    .bottomSpaceToView(self.assistLineH, 0)
    .heightIs(self.btnHeight)
    .widthIs(self.btnHeight);
    
    //    self.goToDoctorBtn.sd_layout
    //    .centerXEqualToView(self.assistLineH)
    //    .bottomSpaceToView(self.assistLineH, 0)
    //    .heightIs(self.btnHeight)
    //    .widthIs(self.btnHeight);
    
    self.healthTeachBtn.sd_layout
    .topSpaceToView(self.assistLineH, 0)
    .rightSpaceToView(self.assistLineV, 0)
    .heightIs(self.btnHeight)
    .widthIs(self.btnHeight);
    
    self.healthServiceBtn.sd_layout
    .leftSpaceToView(self.assistLineV, 0)
    .topSpaceToView(self.assistLineH, 0)
    .heightIs(self.btnHeight)
    .widthIs(self.btnHeight);
    
    self.healthRecordBtn.sd_layout
    .rightSpaceToView(self.assistLineV, 0)
    .bottomSpaceToView(self.assistLineH, 0)
    .heightIs(self.btnHeight)
    .widthIs(self.btnHeight);
    
//        self.healthRecordBtn.sd_layout
//        .centerXEqualToView(self.bottomView)
//        .centerYEqualToView(self.bottomView)
//        .heightIs(self.btnHeight*0.9)
//        .widthIs(self.btnHeight*0.9);
    
    self.expertAnswerBtn.sd_layout
    .centerXEqualToView(self.bottomView)
    .centerYEqualToView(self.bottomView)
    .heightIs(self.btnHeight*0.9)
    .widthIs(self.btnHeight*0.9);

}

#pragma mark - actions

-(void)imageChildAvatarTapAction:(id)sender{
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

-(void)btnMethod:(UIButton *)btn
{
    switch (btn.tag) {
            
        case ConsultDoctorBtn:{
            
            //            /跳转到咨询医生界面
            //             [self.navigationController pushViewController:[ConsultationDoctorViewController new] animated:YES];
            
            //直接跳转到免费咨询界面
            [self.navigationController pushViewController:[CaseInfoViewController new] animated:YES];
            NSLog(@"ConsultDoctorBtn");
            
        }
            break;
        case GoToDoctorBtn:{
            [self.navigationController pushViewController:[MedicalServiceViewController new] animated:YES];
            
            NSLog(@"GoToDoctorBtn");
            
        }
            break;
        case HealthTeachBtn:{
            
            NSLog(@"HealthTeachBtn");
            [self.navigationController pushViewController:[HealthTeachViewController new] animated:YES];
            
        }
            break;
        case HealthServiceBtn:{
            NSLog(@"HealthServiceBtn");
            [self.navigationController pushViewController:[HealthServiceViewController  new] animated:YES];
            
        }
            break;
        case HealthRecordBtn:{
            
            //            NSLog(@"HealthRecordBtn");
            //            [self.navigationController pushViewController:[FollowUpMainViewController new] animated:YES];
            NSArray *entityArray = [DefaultChildEntity MR_findAll];
            if (entityArray.count > 0) {
                DefaultChildEntity *entity = entityArray.lastObject;
                if ([entity.babyID intValue] != 0) {
                    [self.navigationController pushViewController:[[SFHealthRecordViewController alloc] init] animated:YES];
                }else{
                    [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
                }
            }else{
                [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
            }
        }
            break;
        case ExpertAnswerBtn:{
            [self.navigationController pushViewController:[HExpertAnswerViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}
- (IBAction)btnAddChildAction:(id)sender {
    ArchivesMainViewController * vc = [ArchivesMainViewController new];
    //    vc.type = ArchivesRecordTypeFromCaseInfo;
    //    vc.poptoClass = [HomeViewController class];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)rightItemAction:(id)sender{
    EventRemindViewController * vc = [EventRemindViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击导航栏右侧按钮跳转到事件提醒界面
//- (IBAction)btnEventRemidAction:(id)sender {

//}

#pragma mark - 通知回调

- (void)updateChildAdvetar:(NSNotification*) notice{
    [_presenter updateChildInfo];
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _presenter.birthDates.count + 4;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.item < 2){
        cell.hidden = YES;
    }else if (indexPath.item > [self collectionView:collectionView numberOfItemsInSection:0] - 3){
        cell.hidden = YES;
    }else{
        cell.hidden = NO;
        NSUInteger index = indexPath.item - 2;
        cell.lbDate.text = _presenter.birthDates[index].date;
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth / 5 - 5, kScreenWidth / 5 );
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_today == indexPath.item) {
        HomeDailyRecordViewController * vc = [HomeDailyRecordViewController new];
        vc.dailyType = DailyRecordTypeCurrent;
        vc.date = [[NSDate date] format2String:@"yyyy-MM-dd"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    NSUInteger index = indexPathNow.item - 2;
    if (index < _presenter.birthDates.count){
        NSLog(@"Change %lu", (unsigned long)index);
        if (_presenter.birthDates[index].alert) {
            _lbAlert.text = _presenter.birthDates[index].alert;
        }else{
            [_presenter getAlertWithDay:index];
        }
        
    }
}

#pragma mark life

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (kCurrentUser.needToUpdateChildInfo) {
        [_presenter getChildInfo];
        kCurrentUser.needToUpdateChildInfo = NO;
    }
    
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - 

-(void)dealloc{
    [kCurrentUser removeObserver:self forKeyPath:@"token"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
