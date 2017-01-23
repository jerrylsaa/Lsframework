//
//  MBabyInfoViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MBabyInfoViewController.h"
#import "CorePhotoPickerVCManager.h"
#import "MBabyInfoPresenter.h"
#import "PersonFileViewController.h"
#import <UIImageView+WebCache.h>
#import "ChildForm.h"

typedef NS_ENUM(NSInteger, PhotoSourceType) {
    PhotoSourceOnlyLiaryType = 1000,
    PhotoSourceCamerAndLibaryType
};

@interface MBabyInfoViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,MBabyInfoPresenterDelegate>{
    UIScrollView* _scroll;
    UIView* _headerbgView;
//    UIImageView* _iconImageView;
    UIImageView* _iconbgImageView;
    UILabel* _name;
    UIImageView* _sex;
    UILabel* _nation;
    UILabel* _birth;
    
    UIView* _doctorbgView;
    UILabel* _doctorLabel;
    
    UIView* _babyFilebgView;
    UILabel* _babyFile;
    UIImageView* _babyIndcator;
    
    UIButton* _deletebt;
}

@property(nonatomic,retain) UIImageView* iconImageView;

@property(nonatomic,retain) MBabyInfoPresenter* presenter;

@property(nullable,nonatomic,retain) UIImage* childImage;

@end

@implementation MBabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [MBabyInfoPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    NSInteger babyID = self.baby.childID;
    [self.presenter getBabyInfo:babyID];
    
    [self registerNotification];
}

#pragma mark - 注册通知
- (void)registerNotification{
    [kdefaultCenter addObserver:self selector:@selector(updateBabyDetailInfo:) name:Notification_UpdateBabyDetailInfo object:nil];
}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"宝贝详情";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupHedarView];
    [self setupDoctorView];
    [self setupBabyFileView];
    [self setupDeleteButton];
}

- (void)setupHedarView{
    _headerbgView = [UIView new];
    _headerbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scroll addSubview:_headerbgView];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.userInteractionEnabled = YES;
    [_headerbgView addSubview:self.iconImageView];
    
    _iconbgImageView = [UIImageView new];
    _iconbgImageView.userInteractionEnabled = YES;
    _iconbgImageView.image = [UIImage imageNamed:@"GB_ICON-Background"];
    [_headerbgView addSubview:_iconbgImageView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [_iconbgImageView addGestureRecognizer:tap];
    
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = UIColorFromRGB(0x535353);
    [_headerbgView addSubview:_name];
    
    _sex = [UIImageView new];
    [_headerbgView addSubview:_sex];
    
    _nation = [UILabel new];
    _nation.font = _name.font;
    _nation.textColor = _name.textColor;
    [_headerbgView addSubview:_nation];
    
    _birth = [UILabel new];
    _birth.font = _nation.font;
    _birth.textColor = _nation.textColor;
    [_headerbgView addSubview:_birth];

    self.iconImageView.sd_layout.topSpaceToView(_headerbgView,15).leftSpaceToView(_headerbgView,20).widthIs(80).heightEqualToWidth();
    self.iconImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    _iconbgImageView.sd_layout.topSpaceToView(_headerbgView,15).leftSpaceToView(_headerbgView,20).widthIs(80).heightEqualToWidth();
    _iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;

    _name.sd_layout.topEqualToView(self.iconImageView).autoHeightRatio(0).leftSpaceToView(self.iconImageView,15);
    [_name setSingleLineAutoResizeWithMaxWidth:150];
    _nation.sd_layout.topSpaceToView(_name,15).autoHeightRatio(0).leftEqualToView(_name).rightEqualToView(_headerbgView);
    _birth.sd_layout.topSpaceToView(_nation,15).autoHeightRatio(0).leftEqualToView(_name).rightEqualToView(_headerbgView);
    _sex.sd_layout.centerYEqualToView(_name).heightIs(14).widthEqualToHeight().leftSpaceToView(_name,10);
    
//    _name.text = @"姓名：张三";
//    _sex.image = [UIImage imageNamed:@"mine_male"];
//    _nation.text = @"国籍：中国";
//    _birth.text = @"生日：2010/01/02";
//    _doctorLabel.text = @"家庭医生：有/无";

    
    _headerbgView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_headerbgView setupAutoHeightWithBottomViewsArray:@[self.iconImageView,_iconbgImageView,_birth] bottomMargin:15];
}

- (void)setupDoctorView{
    _doctorbgView = [UIView new];
    _doctorbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scroll addSubview:_doctorbgView];
    _doctorLabel = [UILabel new];
    _doctorLabel.font = _name.font;
    _doctorLabel.textColor = _name.textColor;
    [_doctorbgView addSubview:_doctorLabel];

    _doctorLabel.sd_layout.topSpaceToView(_doctorbgView,15).leftSpaceToView(_doctorbgView,20).autoHeightRatio(0);
    [_doctorLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    _doctorbgView.sd_layout.topSpaceToView(_headerbgView,15).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_doctorbgView setupAutoHeightWithBottomView:_doctorLabel bottomMargin:15];
    
}

- (void)setupBabyFileView{
    _babyFilebgView = [UIView new];
    _babyFilebgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scroll addSubview:_babyFilebgView];
    
    UITapGestureRecognizer* babyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBabyFile)];
    [_babyFilebgView addGestureRecognizer:babyTap];
    
    _babyFile = [UILabel new];
    _babyFile.font = _name.font;
    _babyFile.textColor = _name.textColor;
    [_babyFilebgView addSubview:_babyFile];
    
    _babyIndcator = [UIImageView new];
    _babyIndcator.userInteractionEnabled = YES;
    _babyIndcator.image = [UIImage imageNamed:@"mine_indactor"];
    [_babyFilebgView addSubview:_babyIndcator];

    
    _babyFile.sd_layout.topSpaceToView(_babyFilebgView,15).leftSpaceToView(_babyFilebgView,20).autoHeightRatio(0);
    [_babyFile setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _babyIndcator.sd_layout.centerYEqualToView(_babyFile).heightIs(37/2.0).rightSpaceToView(_babyFilebgView,25).widthIs(21/2.0);
    
    _babyFilebgView.sd_layout.topSpaceToView(_doctorbgView,15).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_babyFilebgView setupAutoHeightWithBottomViewsArray:@[_babyFile,_babyIndcator] bottomMargin:15];
    
    _babyFile.text = @"宝贝档案";

}

- (void)setupDeleteButton{
    _deletebt = [UIButton new];
    [_deletebt setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [_deletebt setTitle:@"删除宝贝信息" forState:UIControlStateNormal];
    [_deletebt addTarget:self action:@selector(deleteBabayAction) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:_deletebt];
    
    _deletebt.sd_layout.topSpaceToView(_babyFilebgView,150/2.0).heightIs(40).leftSpaceToView(_scroll,20).rightSpaceToView(_scroll,20);
    [_scroll setupAutoContentSizeWithBottomView:_deletebt bottomMargin:0];
}

#pragma mark - 代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //确定

        [ProgressUtil show];
        [self.presenter deleteConnectBaby];
    }else{
        //取消
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    CorePhotoPickerVCManager* manager = [CorePhotoPickerVCManager new];
    if(actionSheet.tag == PhotoSourceOnlyLiaryType){
        if(buttonIndex == 0){
            //相册
            manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeSinglePhoto ;
        }else{
            return ;
        }
    }else if(actionSheet.tag == PhotoSourceCamerAndLibaryType){
        if(buttonIndex==0){
            //拍照
            manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeCamera ;
        }else if(buttonIndex==1){
            //相册
            manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeSinglePhoto ;
        }else{
            return ;
        }
    }
    WS(ws);
    manager.finishPickingMedia = ^ (NSArray* medias){
        //
        CorePhoto* corePhoto = [medias firstObject];
        ws.childImage = corePhoto.editedImage;
        
        [ws.presenter updateChildAvaterWithImage:corePhoto.editedImage andChildID:@(ws.presenter.babyInfo.childId)];
        
    };
    UIViewController* imagePicker = manager.imagePickerController;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)onCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        NSLog(@"===%ld",self.presenter.babyInfo.childNation);
        
        //头像
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,self.presenter.babyInfo.childImg]];
        [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"GB_icon"]];

        //姓名
        _name.text = [NSString stringWithFormat:@"姓名：%@",self.presenter.babyInfo.childName];
        [_name updateLayout];
        
        UIImage* sexImage = self.presenter.babyInfo.childSex == 1? [UIImage imageNamed:@"mine_male"]: [UIImage imageNamed:@"mine_female"];
        _sex.image = sexImage;

        //国籍
        _nation.text = @"国籍：中国";//暂时写死
        NSString* doctorNums = @"家庭医生：无";
        if(self.presenter.babyInfo.familyDoctor >0 ){
            doctorNums = @"家庭医生：有";
        }
        _doctorLabel.text = doctorNums;
        
        NSDate* birth = self.presenter.babyInfo.birthDate;
        _birth.text = [NSString stringWithFormat:@"生日：%@",[birth format2String:@"yyyy/MM/dd"]];

    }else{
        [ProgressUtil showError:info];
    }
}

-(void)deleteOnCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        NSDictionary* userInfo = @{@"babyID":@(self.presenter.babyInfo.childId)};
        
        kCurrentUser.needToUpdateChildInfo = YES;
        
        [kdefaultCenter postNotificationName:Notification_DeleteLinkBaby object:nil userInfo:userInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:info];
    }
}
#pragma mark * 更新宝宝头像回调
-(void)updateChildAvater:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        self.iconImageView.image = self.childImage;
        
        //同步更新宝宝头像
        //更新宝贝列表
        [kdefaultCenter postNotificationName:Notification_UpdateBabyList object:nil userInfo:nil];
        
        //更新我的首页headrCollection
        [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];

        
    }else{
        self.childImage = nil;
        [ProgressUtil showError:info];
    }
}

#pragma mark - 通知回调
/**
 *  更新宝宝详情
 *
 *  @param notice <#notice description#>
 */
- (void)updateBabyDetailInfo:(NSNotification*) notice{
    NSDictionary* dic = notice.userInfo;
    ChildForm* child = dic[@"userInfo"];
    NSInteger babyID = child.childID;
    
    //更新本页信息
    [self.presenter getBabyInfo:babyID];
    
    if(babyID == [[DefaultChildEntity defaultChild].babyID integerValue]){
        //同步更新我的首页
        [kdefaultCenter postNotificationName:Notification_UpdateDefaultBabyInfo object:nil userInfo:@{@"name":child.childName,@"babyID":@(child.childID)}];
        
    }else{
        //更新所有宝宝列表
        [kdefaultCenter postNotificationName:Notification_UpdateDefaultBabyInfo object:nil userInfo:nil];
    }
    
}


#pragma mark - 点击事件
#pragma mark * 删除宝宝
- (void)deleteBabayAction{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认删除当前宝贝信息?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

/**
 *  点击宝贝档案
 */
- (void)handleTapBabyFile{
    PersonFileViewController* per = [PersonFileViewController new];
    per.babyID = self.baby.childID;
    per.updateBabyInfo = YES;
    [self.navigationController pushViewController:per animated:YES];
}

#pragma mark - 监听手势回调
#pragma mark * 修改头像
- (void)handleTapGesture{
    UIActionSheet* sheet;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",nil];
        sheet.tag = PhotoSourceOnlyLiaryType;
    }else{
        sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
        sheet.tag = PhotoSourceCamerAndLibaryType;
    }
    
    [sheet showInView:self.view];
}


#pragma mark - 

-(void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_UpdateBabyDetailInfo object:nil];
}






@end
