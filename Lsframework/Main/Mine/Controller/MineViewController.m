//
//  MineViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineViewController.h"
#import "MineMenuCell.h"
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

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


#define kColumn 3

typedef NS_ENUM(NSInteger, PhotoSourceType) {
    PhotoSourceOnlyLiaryType = 1000,
    PhotoSourceCamerAndLibaryType
};

@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,MinePresenterDelegate
    ,UIAlertViewDelegate>{
    UIScrollView* _scroll;
    UIView* _containerView;
    
    UIView* _headerbgView;
    UIImageView* _icon;//头像
    UILabel* _account;//账号
    UIButton* _servicePackage;//医疗服务套餐
    UIView* _line;//分割线
    UILabel* _baby;//当前宝贝
    UIButton* _manager;//管理
    
    UICollectionView* _collection;
    
    CorePhotoPickerVCManager* _corePhotoManager;
    
    NSString* _currentBabyName;
}

@property(nonatomic,retain) UIImageView* userImageView;

@property(nonatomic,retain) NSArray* imageArray;

@property(nonatomic,retain) MinePresenter* presenter;

@property(nonatomic,retain) BabayArchList* currentBaby;

@property(nonatomic,retain) NSArray* vcArray;

@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBackBarWithImage:nil];
//    [self initRightBarWithTitle:@"分享"];
    
    self.presenter = [MinePresenter new];
    self.presenter.delegate = self;
    
    //注册通知
    [self registerNotification];

}

#pragma mark - 加载子视图
- (void)setupView{
    self.title = @"我的";
    
    [self setupScrollView];
    [self setupHeaderView];
    [self setupCollectionView];
    
//    _account.text = [NSString stringWithFormat:@"账号：%@",kCurrentUser.phone];
//    NSString* currentBaby = [DefaultChildEntity defaultChild].childName;
//    if(currentBaby.length == 0){
//        currentBaby = @"无";
//    }
//    _baby.text = [NSString stringWithFormat:@"当前宝贝：%@",currentBaby ];
//    _currentBabyName = currentBaby;


}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    if(self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    _account.text = [NSString stringWithFormat:@"账号：%@",kCurrentUser.phone];
    NSString* currentBaby = [DefaultChildEntity defaultChild].childName;
    if(currentBaby.length == 0){
        currentBaby = @"无";
    }
    _baby.text = [NSString stringWithFormat:@"当前宝贝：%@",currentBaby ];
    _currentBabyName = currentBaby;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    

}

- (void)setupScrollView{
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:_scroll];
    
    _containerView = [UIView new];
    [_scroll addSubview:_containerView];
    
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _containerView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
    
}

- (void)setupHeaderView{
    _headerbgView = [UIView new];
    _headerbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_containerView addSubview:_headerbgView];
    //头像
    self.userImageView = [UIImageView new];
    self.userImageView.userInteractionEnabled = YES;
    [_headerbgView addSubview:self.userImageView];
    
    NSString* headerImage = [NSString stringWithFormat:@"%@%@",ICON_URL,[DefaultChildEntity defaultChild].childImg];
    NSURL* url = [NSURL URLWithString:headerImage];
    [self.userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"doctor_icon"]];

    
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.image=[UIImage imageNamed:@"doctor_flower"];
    [_headerbgView addSubview:_icon];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [_icon addGestureRecognizer:tap];
    
    
    //账号
    _account = [UILabel new];
    _account.font = [UIFont systemFontOfSize:18];
//    _account.text = [NSString stringWithFormat:@"账号：%@",kCurrentUser.phone];
    _account.textColor = UIColorFromRGB(0x535353);
    [_headerbgView addSubview:_account];
    //医疗服务套餐
//    _servicePackage = [UIButton new];
//    [_servicePackage setTitle:@"我的医疗服务套餐" forState:UIControlStateNormal];
//    _servicePackage.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_servicePackage setBackgroundImage:[UIImage imageNamed:@"mine_servicePackge"] forState:UIControlStateNormal];//400*60
//    [_servicePackage addTarget:self action:@selector(servicePackage) forControlEvents:UIControlEventTouchUpInside];
//    [_headerbgView addSubview:_servicePackage];
    //分割线
    _line = [UIView new];
    _line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_headerbgView addSubview:_line];
    //当前宝贝
    _baby = [UILabel new];
    _baby.font = _account.font;
//    _baby.text = @"当前宝贝：宝宝";
    _baby.textColor = _account.textColor;
    [_headerbgView addSubview:_baby];
    //管理
    _manager = [UIButton new];
    [_manager setTitle:@"管理" forState:UIControlStateNormal];
    [_manager setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
    [_manager addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerbgView addSubview:_manager];
    
    //添加约束
    self.userImageView.sd_layout.topSpaceToView(_headerbgView,15).leftSpaceToView(_headerbgView,20).widthIs(80).heightEqualToWidth();
    _icon.sd_layout.topSpaceToView(_headerbgView,15).leftSpaceToView(_headerbgView,20).widthIs(80).heightEqualToWidth();
    
    _account.sd_layout.topSpaceToView(_headerbgView,20).leftSpaceToView(_icon,15).widthIs(kScreenWidth).autoHeightRatio(0);
//    _servicePackage.sd_layout.topSpaceToView(_account,15).leftEqualToView(_account).rightSpaceToView(_headerbgView,130/2.0).heightIs(30);
//    _line.sd_layout.topSpaceToView(_servicePackage,20).leftEqualToView(_headerbgView).rightEqualToView(_headerbgView).heightIs(1);
    _line.sd_layout.topSpaceToView(_icon,20).leftEqualToView(_headerbgView).rightEqualToView(_headerbgView).heightIs(1);

    _baby.sd_layout.topSpaceToView(_line,15).leftEqualToView(_icon).autoHeightRatio(0).rightSpaceToView(_manager,0);
    _manager.sd_layout.topEqualToView(_baby).rightSpaceToView(_headerbgView,20).widthIs(50).heightIs(25);
    
    _headerbgView.sd_layout.topEqualToView(_containerView).leftEqualToView(_containerView).rightEqualToView(_containerView);
    [_headerbgView setupAutoHeightWithBottomView:_manager bottomMargin:15];
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat width = (kScreenWidth-45-30)/kColumn;
    CGFloat height = width;
    layout.itemSize = CGSizeMake(width,height);
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor clearColor];
    [_collection registerClass:[MineMenuCell class] forCellWithReuseIdentifier:@"menuCell"];
    [_containerView addSubview:_collection];
    
    CGFloat row = 0;
    
    if(self.imageArray.count < kColumn){
        row = 1;
    }else{
        if(!(self.imageArray.count%3)){
            //3的整数倍
            row = self.imageArray.count/kColumn;
        }else{
            row = self.imageArray.count/kColumn+1;
        }
 
    }
    
    
    
    
//    if(self.imageArray.count%2 && self.imageArray.count>kColumn){
//        //奇数
//        row = self.imageArray.count/kColumn+1;
//    }else{
//        //偶数
//        row = self.imageArray.count/kColumn;
//    }
    CGFloat collectHeight = 20+25*(row-1)+ row*height ;
    
//    NSInteger index = self.imageArray.count%kColumn;
//    if (index == 0) {
//        collectHeight = 20 + height * index + 25 * index == 1 ? 0 : (index - 1);
//    }else{
//        collectHeight = 20 + height * (index + 1) + 25 * index;
//    }
    
    _collection.sd_layout.topSpaceToView(_headerbgView,0).leftEqualToView(_containerView).rightEqualToView(_containerView).heightIs(collectHeight);
    
    [_containerView setupAutoHeightWithBottomView:_collection bottomMargin:0];
    [_scroll setupAutoContentSizeWithBottomView:_containerView bottomMargin:0];
    
}

#pragma mark - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
    NSString* imageName = self.imageArray[indexPath.item];
    cell.menuImageView.image = [UIImage imageNamed:imageName];
    
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 45/2.0, 0, 45/2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString* imageName = self.imageArray[indexPath.item];
    if([imageName isEqualToString:@"mine_appoint"]){
     //我的预约
        MMyAppointViewController* vc = [MMyAppointViewController new];
        NSString* url = [NSString URLDecodedString:[ConfiguresEntity findConfigureValueWithKey:@"openmzyyurl2"]];
        
        vc.appointURL = [NSString stringWithFormat:@"%@?token=%@&username=%@&pass=%@",url,kCurrentUser.token,kCurrentUser.phone,kCurrentUser.userPasswd];
        NSLog(@"url = %@",vc.appointURL);

        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController* vc = nil;
        if([imageName isEqualToString:@"mine_help_feedback"]){
            vc = [BSHelpAndFeedbackViewController new];
        }else if([imageName isEqualToString:@"mine_reply"]){
            vc = [MyReplyViewController new];
        }else if([imageName isEqualToString:@"mine_wallet"]){
            vc = [MDoctorWalletViewController new];
        }else if([imageName isEqualToString:@"mine_setting"]){
            vc = [SetUpController new];
        }else if ([imageName isEqualToString:@"mine_warning"]){
            vc = [MWarningViewController new];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }

}


-(void)onComplete:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        if(self.presenter.dataSource.count !=0){
            MMedicalSerVicePackageViewController* myPackage = [MMedicalSerVicePackageViewController new];
            myPackage.dataSorce = self.presenter.dataSource;
            [self.navigationController pushViewController:myPackage animated:YES];
        }else{
        //您还没有购买过医疗服务
            [self.navigationController pushViewController:[MMedicalNoSerViceViewController new] animated:YES];
        }
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)onChangeChildAvaterCompleted:(NSString *)path{
    [self.userImageView setImage:[UIImage imageWithContentsOfFile:path]];
    
//    [kdefaultCenter postNotificationName:Notification_updateChildAdvater object:nil userInfo:nil];
    
    kCurrentUser.needToUpdateChildInfo = YES;
}

#pragma mark - 懒加载
-(NSArray *)imageArray{
    if(!_imageArray){
        NSMutableArray* array = [NSMutableArray arrayWithArray:@[@"mine_help_feedback",@"mine_reply",@"mine_wallet",@"mine_appoint",@"mine_warning",@"mine_setting"]];
        
        NSString* configureValue = [ConfiguresEntity findConfigureValueWithKey:configureKey];
        if(![configureValue isEqualToString:@"true"]){
        //移除我的咨询
            [array removeObject:@"mine_reply"];
        }

        if([[ConfiguresEntity findConfigureValueWithKey:openMZYYKey] isEqualToString:@"false"]){
        //移除我的预约
            [array removeObject:@"mine_appoint"];
        }
        
        _imageArray = array;
    }
    return _imageArray;
}


#pragma mark - 注册通知
- (void)registerNotification{
    [kdefaultCenter addObserver:self selector:@selector(handleChangeBabyNotification:) name:Notification_ChangeBaby object:nil];//切换宝宝
    
    [kdefaultCenter addObserver:self selector:@selector(synchronizeIcon:) name:Notification_synchronizeIcon object:nil];//同步头像
    
    [kdefaultCenter addObserver:self selector:@selector(deleteCurrentBaby:) name:Notification_DeleteCurrentBaby object:nil];//删除当前宝宝
    
    //修改宝宝档案，同步更新默认宝宝名字
    [kdefaultCenter addObserver:self selector:@selector(updateDefaultBabyInfo:) name:Notification_UpdateDefaultBabyInfo object:nil];

    
    
    
}

#pragma mark - 通知回调方法
/**
 *  修改宝贝
 */
- (void)handleChangeBabyNotification:(NSNotification*) notice{
    NSDictionary* userInfo = notice.userInfo;
    
    if(!userInfo) return ;//区别删除通知
    
    BabayArchList* baby = userInfo[@"baby"];
    _currentBabyName = baby.childName;
    _baby.text = [NSString stringWithFormat:@"当前宝贝：%@", baby.childName];
    
    //修改宝宝头像
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,baby.childImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
}

/**
 *  同步头像
 *
 *  @param notice <#notice description#>
 */
- (void)synchronizeIcon:(NSNotification*) notice{
    NSString* headerImage = [NSString stringWithFormat:@"%@%@",ICON_URL,[DefaultChildEntity defaultChild].childImg];
    NSURL* url = [NSURL URLWithString:headerImage];
    [self.userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    
    //名字
    NSString* currentBaby = [DefaultChildEntity defaultChild].childName;
    if(currentBaby.length == 0){
        currentBaby = @"无";
        _currentBabyName = nil;
    }else{
        _currentBabyName = currentBaby;
    }
    _baby.text = [NSString stringWithFormat:@"当前宝贝：%@",currentBaby ];


}

- (void)deleteCurrentBaby:(NSNotification*) notice{
    self.userImageView.image = [UIImage imageNamed:@"doctor_icon"];
    _baby.text = @"当前宝贝：无";
    _currentBabyName = nil;
    
    //更新数据默认宝宝数据
    [DefaultChildEntity deleteDefaultChild];
    

//    [kdefaultCenter postNotificationName:Notification_ChangeBaby object:nil userInfo:nil];//同步首页删除当前宝宝
    
    kCurrentUser.needToUpdateChildInfo = YES;
}

/**
 *  更新默认宝宝信息
 *
 *  @param notice <#notice description#>
 */
- (void)updateDefaultBabyInfo:(NSNotification*) notice{
    if(!notice.userInfo) return ;
    NSDictionary* dic = notice.userInfo;
    NSString* currentBaby = dic[@"name"];
    if(currentBaby.length == 0){
        currentBaby = @"无";
        _currentBabyName = nil;
    }else{
        _currentBabyName = currentBaby;
    }
    _baby.text = [NSString stringWithFormat:@"当前宝贝：%@",currentBaby ];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        ArchivesMainViewController * vc = [ArchivesMainViewController new];
        vc.poptoClass = [MBabyManagerViewController class];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - 点击事件
/**
 *  分享
 *
 *  @param sender <#sender description#>
 */
-(void)rightItemAction:(id)sender{
    NSLog(@"分享");
    [self share];
}
/**
 *  我的医疗服务套餐
 */
- (void)servicePackage{
    [ProgressUtil show];
    [self.presenter getMyServicePackage];
    
}
/**
 *  管理
 */
- (void)managerAction{
    MBabyManagerViewController* babyManager = [MBabyManagerViewController new];
    babyManager.currentBabyName = _currentBabyName;
    [self.navigationController pushViewController:babyManager animated:YES];
    
}

#pragma mark - 监听手势
/**
 *  点击头像
 */
- (void)handleTapGesture{
    if (![DefaultChildEntity isHasDefaultChild]) {
        [ProgressUtil showInfo:@"请添加宝贝信息再上传头像"];
        return;
    }
    if ([DefaultChildEntity defaultChild].babyID){
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
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"温馨提示" message:@"添加宝宝后,才能为宝宝上传头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }

}


#pragma mark -
/**
 *  <#Description#>
 */
-(void)dealloc{
    
    [kdefaultCenter removeObserver:self name:Notification_ChangeBaby object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_synchronizeIcon object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_DeleteCurrentBaby object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_UpdateDefaultBabyInfo object:nil];

    
}

#pragma mark share

-(void)share{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"ac_ask"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
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





@end
