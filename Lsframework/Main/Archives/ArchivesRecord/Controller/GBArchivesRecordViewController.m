//
//  GBArchivesRecordViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBArchivesRecordViewController.h"
#import "FPTextField.h"
#import "FPDatePicker.h"
#import "FPDropView.h"
#import "FPButton.h"
#import "NeonateViewController.h"
#import "NationEntity.h"
#import "NationalityEntity.h"
#import "MenuEntity.h"
#import "CorePhotoPickerVCManager.h"
#import <UIImageView+WebCache.h>
#import "GBArchivesRecordPresenter.h"
#import "GBMineViewController.h"
#import "NSDate+Category.h"


typedef NS_ENUM(NSInteger, PhotoSourceType) {
    PhotoSourceOnlyLiaryType = 1005,
    PhotoSourceCamerAndLibaryType
};

@interface GBArchivesRecordViewController ()<UITextFieldDelegate,GBArchivesRecordPresenterDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic)  UIScrollView *scroll;
@property (strong, nonatomic)  UIView *IconView;
@property (strong, nonatomic)  UIImageView *IconImageView;
@property (strong, nonatomic)  UILabel *IconBabyLb;

@property (strong, nonatomic)  UILabel *BabyInfoLb;
@property (strong, nonatomic)  FPTextField *tfName;
@property (strong, nonatomic)  FPTextField *tfDate;
@property (strong, nonatomic)  FPTextField *tfWeight;
@property (strong, nonatomic)  FPTextField *tfHeight;
@property (strong, nonatomic)  FPTextField *tfSex;

@property (strong, nonatomic)  UIButton *CommitBtn;

@property (nonatomic, strong) ChildForm * childForm;
@property (nonatomic, strong) GBArchivesRecordPresenter * presenter;

@property(nullable,nonatomic,retain) UIImage* childImage;


@end

@implementation GBArchivesRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

-(void)setupView{

    
    _presenter = [GBArchivesRecordPresenter new];
    _presenter.delegate = self;
    _childForm = [ChildForm new];
    
    _IconView = [UIView  new];
    _IconView.backgroundColor =  [UIColor  colorWithRed:107/255.0 green:211/255.0 blue:207/255.0 alpha:1];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [_IconView addGestureRecognizer:tap];
    

    [self.view  addSubview:_IconView];
    
    _IconImageView = [UIImageView  new];
    

//    _IconImageView.image = [UIImage  imageNamed:@"GB_MineICON"];
   [_IconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_BabyList.childImg]] placeholderImage:[UIImage imageNamed:@"GB_MineICON"]];
    
    _IconImageView.backgroundColor = [UIColor  clearColor];
    [_IconView  addSubview:_IconImageView];
    
    _IconBabyLb = [UILabel new];
    _IconBabyLb.backgroundColor = [UIColor clearColor];
    _IconBabyLb.textColor = [UIColor  whiteColor];
    _IconBabyLb.text = @"点击添加宝宝头像";
    _IconBabyLb.textAlignment = NSTextAlignmentCenter;
    _IconBabyLb.font = [UIFont  systemFontOfSize:17];
    [_IconView  addSubview:_IconBabyLb];
    
    
    UIView  *footView = [UIView  new];
    footView.backgroundColor = [UIColor  clearColor];
    [self.view  addSubview:footView];
    
    _scroll = [UIScrollView  new];
    _scroll.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_scroll];
    
    
    
    
    _BabyInfoLb = [UILabel  new];
    _BabyInfoLb.backgroundColor = [UIColor clearColor];
    _BabyInfoLb.textColor = [UIColor  colorWithRed:107/255.0 green:211/255.0 blue:207/255.0 alpha:1];
    _BabyInfoLb.text = @"宝宝基本信息";
    _BabyInfoLb.textAlignment = NSTextAlignmentLeft;
    _BabyInfoLb.font = _IconBabyLb.font ;
    [_scroll  addSubview:_BabyInfoLb];

    _tfName =[FPTextField  new];
    _tfName.title = @"姓名:  ";
    _tfWeight.font = [UIFont  systemFontOfSize:17];
    [_scroll  addSubview:_tfName];
    
    _tfDate =[FPTextField  new];
    _tfDate.title = @"出生日期:  ";
    _tfDate.rightIcon =  [UIImage  imageNamed:@"FPtextfield_top"];
    _tfDate.font = _tfWeight.font;
    _tfDate.delegate = self;
    [_scroll  addSubview:_tfDate];

    
    _tfWeight =[FPTextField  new];
    _tfWeight.title = @"体重:  ";
    _tfWeight.unit = @"kg";
    _tfWeight.font = _tfWeight.font;
    [_scroll  addSubview:_tfWeight];
    
    _tfHeight =[FPTextField  new];
    _tfHeight.title = @"身长:  ";
    _tfHeight.unit = @"cm";
    _tfHeight.font = _tfWeight.font;
    [_scroll  addSubview:_tfHeight];
    
    _tfSex =[FPTextField  new];
    _tfSex.title = @"性别:  ";
    _tfSex.delegate = self;
    _tfSex.rightIcon =  [UIImage  imageNamed:@"FPtextfield_top"];
    _tfSex.font = _tfWeight.font;
    [_scroll  addSubview:_tfSex];
    
    _CommitBtn = [UIButton  new];
    _CommitBtn.backgroundColor = UIColorFromRGB(0x52d8d2);
    
    
    if (_type == GBArchivesRecordTypeFromRegister) {
        self.title = @"添加宝宝";
       [_CommitBtn  setTitle:@"提交" forState:UIControlStateNormal];
        
        
        
    }else{
    self.title = @"个人档案";
    [_CommitBtn  setTitle:@"删除宝宝档案" forState:UIControlStateNormal];
     [self initRightBarWithTitle:@"保存"];
    }
    _CommitBtn.titleLabel.font = _tfWeight.font;
    _CommitBtn.titleLabel.textColor = [UIColor  whiteColor];
    _CommitBtn.titleLabel.textAlignment= NSTextAlignmentCenter;
    [_CommitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [_scroll  addSubview:_CommitBtn];
    
    
    _IconView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view);
    
_IconImageView.sd_layout.topSpaceToView(_IconView,15).centerXEqualToView(_IconView).widthIs(85).heightEqualToWidth();
    _IconImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
 _IconBabyLb.sd_layout.topSpaceToView(_IconImageView,15).leftEqualToView(_IconView).rightEqualToView(_IconView).heightIs(17);
    
    [_IconView  setupAutoHeightWithBottomView:_IconBabyLb bottomMargin:15];
    
    _scroll.sd_layout.topSpaceToView(_IconView,0).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,0);
    
    
    _BabyInfoLb.sd_layout.topSpaceToView(_scroll,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(17);
    
    CGFloat  Height = (kScreenWidth-50)*40/345;
    
    _tfName.sd_layout.topSpaceToView(_BabyInfoLb,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(Height);
    

    _tfDate.sd_layout.topSpaceToView(_tfName,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(Height);
    
    _tfWeight.sd_layout.topSpaceToView(_tfDate,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(Height);
    
    _tfHeight.sd_layout.topSpaceToView(_tfWeight,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(Height);
    
    _tfSex.sd_layout.topSpaceToView(_tfHeight,15).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).heightIs(Height);
    
    _CommitBtn.sd_layout.topSpaceToView(_tfSex,35).centerXEqualToView(_scroll).heightIs(Height).widthIs(kScreenWidth-50);
    _CommitBtn.layer.cornerRadius = Height/2;
    
    [_scroll  setupAutoHeightWithBottomView:_CommitBtn bottomMargin:30  ];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WS(ws);
    __weak UITextField * weakTf = textField;
    //    性别 国籍 民族 监护人身份为选择
    if ([textField isEqual:_tfDate]) {
        //出生日期
        FPDatePicker * datePicker = [FPDatePicker new];
        [datePicker showInView:self.view];
        [datePicker setMaxDate:[NSDate new]];
        [datePicker addDatePickerHandler:^(NSString *date, NSDate * d) {
            weakTf.text = date;
        }];
    }else if ([textField isEqual:_tfSex]){
        //性别
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = @[@"男", @"女"];
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            if (selection == 0) {
                ws.childForm.childSex = 1;
            }else{
                ws.childForm.childSex = 2;
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];
        
    }
    
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}


#pragma mark -
- (NSString *)findDicNameBy:(NSInteger)menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuId)];
    if (array.count > 0) {
        MenuEntity *entity = array[0];
        return entity.dictionaryName;
    }
    return @"";
}


- (NSString *)format:(long)timeInv{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInv];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

- (NSString *)defaultNameBy:(NSInteger )menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"parentId" withValue:@(menuId)];
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *obj1, MenuEntity *obj2) {
        return [obj1.menuId compare:obj2.menuId];
    }];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (MenuEntity *entity in sortArray) {
        [titleArray addObject:entity.dictionaryName];
    }
    return titleArray[0];
}

#pragma mark---点击事件

#pragma mark  *添加宝宝头像
-(void)handleTapGesture{
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
        
         self.IconImageView.image = self.childImage;

        
    };
    UIViewController* imagePicker = manager.imagePickerController;
    [self presentViewController:imagePicker animated:YES completion:nil];
}




#pragma mark  *提交或删除档案
-(void)commit{
    [ProgressUtil show];
    if (_type == GBArchivesRecordTypeFromRegister) {
        
        _childForm.birthWeight = _tfWeight.text;
        _childForm.birthHeight = _tfHeight.text;
        _childForm.birthDate = _tfDate.text;
        _childForm.childName = _tfName.text;
        _childForm.childImage = self.childImage;
        NSLog(@"提交：%@---%@---%@---%@---%@",_childForm.birthWeight,_childForm.birthHeight,_childForm.birthDate,_childForm.childName,_childForm.childImage);
        
        WSLog(@"添加新的档案");
        [_presenter commitChildArchives:_childForm];

    }else{
        WSLog(@"删除档案");
        [_presenter deleteConnectBabyWithBabyID:[NSNumber  numberWithInteger:_BabyList.childID]];
        
    NSLog(@"提交：%@---%@---%@---%@---%@",_childForm.birthWeight,_childForm.birthHeight,_childForm.birthDate,_childForm.childName,_childForm.childImage);

        
    }
}

#pragma mark  *编辑档案时，导航栏保存按钮
-(void)rightItemAction:(id)sender{
    
    _childForm.birthWeight = _tfWeight.text;
    _childForm.birthHeight = _tfHeight.text;
    _childForm.birthDate = _tfDate.text;
    _childForm.childName = _tfName.text;
    _childForm.childImage = self.childImage;
    _childForm.childID = _BabyList.childID;
    
//    if ([_BabyList.sex  isEqualToString:@"男"]) {
//        _childForm.childSex  = 1;
//    }else if ([_BabyList.sex  isEqualToString:@"女"]){
//    _childForm.childSex  = 2;
//    }
    NSLog(@"%@",_BabyList.sex);
    NSLog(@"%d",_childForm.childSex);
    NSLog(@"%@",_childForm.childName);
    NSLog(@"%@",_childForm.birthWeight);
    
        if (!_childForm.childName || _childForm.childName.length == 0) {

            [ProgressUtil  showError:@"请填写姓名"];
            return;
        }
      if(_childForm.childName.length > 5){
          [ProgressUtil  showError:@"请输入少于5个字的名字"];
        return ;
    }

    
        if (_childForm.childSex == 0) {
           [ProgressUtil  showError:@"请选择性别"];
            return ;
        }
    
    
        if (!_childForm.birthDate || _childForm.birthDate.length == 0) {

            [ProgressUtil  showError:@"请选择出生日期"];
            return ;
        }else{
            NSTimeInterval birthTime = [NSDate compareDate:_childForm.birthDate];
            NSInteger year = birthTime/(60*60*24*365);
            if(year >= 18){
                [ProgressUtil  showError:@"请选择18岁以下出生日期"];
                return ;
            }
        }
        if(_childForm.birthWeight.length == 0) {
            _childForm.birthWeight = @"";
        }else{
            BOOL isNumber = [_childForm.birthWeight regexNumber] || [_childForm.birthWeight isPureNumber];
            if(!isNumber){

                [ProgressUtil  showError:@"出生体重请输入数字"];
                return ;
            }
        }
    
        if (_childForm.birthHeight.length == 0) {
            _childForm.birthHeight = @"";
        }else{
            BOOL isNumber = [_childForm.birthHeight regexNumber] || [_childForm.birthHeight isPureNumber];
            if(!isNumber){
                [ProgressUtil  showError:@"出生身长请输入数字"];
                return ;
            }
        }


    
    NSLog(@"提交111：%@---%@---%@---%@---%@",_childForm.birthWeight,_childForm.birthHeight,_childForm.birthDate,_childForm.childName,_childForm.childImage);

    WSLog(@"更新档案");
    [_presenter updateChildArchives:_childForm];
    


}




-(void)vc_GB_Save:(Complete)block{
    _childForm.birthWeight = _tfWeight.text;
    _childForm.birthHeight = _tfHeight.text;
    _childForm.birthDate = _tfDate.text;
    _childForm.childName = _tfName.text;
    [_presenter commitChildArchives:_childForm complete:^(BOOL success ,NSString *message) {
        block(success ,message);
    }];
}

-(void)loadData{
    
    _tfWeight.text = [NSString  stringWithFormat:@"%@",_BabyList.weight];
    _tfHeight.text = [NSString  stringWithFormat:@"%@",_BabyList.height];
    _tfDate.text = [_BabyList.birthDate  format2String:@"yyyy-MM-dd"];
    _tfName.text = _BabyList.childName;
    
    _tfSex.text = _BabyList.sex;
    WS(ws);
    if ([_BabyList.sex  isEqualToString:@"男"]) {
        ws.childForm.childSex = 1;
    }else if ([_BabyList.sex  isEqualToString:@"女"]){
        ws.childForm.childSex  = 2;
    }

    
}

#pragma mark---提交信息完成
-(void)onCommitGBChildArchivesComplete:(BOOL) success info:(NSString*)info{
    
    if (success) {
        [ProgressUtil dismiss];
        
        kCurrentUser.needToUpdateChildInfo = YES;
        NSString* str= [NSString stringWithUTF8String:object_getClassName(self.poptoClass)];
        if (self.childImage == nil) {
            NSLog(@"没有图片");
            if([str isEqualToString:@"MBabyManagerViewController"] || [str isEqualToString:@"GBMineViewController"]){
            
                        //更新我的首页headrCollection
                        [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
                        
        }

         
        }else{
        NSLog(@"有图片  %@",self.childImage);
        
        }
    
            if ([str isEqualToString:@"FDApplyDoctorViewController"]){
            //更新添加医生模块，添加宝宝通知
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Add_Baby_Complete object:nil];
        }
        
    NSLog(@"宝宝 ID%@----tupian %@",[NSNumber  numberWithInteger:_childForm.childID],self.childImage);
        if(self.childImage != nil){
    [self.presenter updateChildAvaterWithImage:self.childImage andChildID:[NSNumber  numberWithInteger:_childForm.childID]];
            NSLog(@"调用上传图片");
        }else{
        NSLog(@"不调用上传图片");
            
    GBMineViewController  *vc = [GBMineViewController  new];
            
    [self.navigationController  pushViewController:vc animated:YES];
        }
    }else{
        [ProgressUtil showError:info];
    }
}
#pragma mark * 更新宝宝头像回调
-(void)updateChildAvater:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        //同步更新宝宝头像
        
        //更新我的首页headrCollection
        [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
        GBMineViewController  *vc = [GBMineViewController  new];
        
    [self.navigationController  pushViewController:vc animated:YES];
        
    }else{
        self.childImage = nil;
        [ProgressUtil showError:info];
    }
}

-(void)deleteOnCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        NSDictionary* userInfo = @{@"babyID":@(_BabyList.childID)};
        
        kCurrentUser.needToUpdateChildInfo = YES;
        
        [kdefaultCenter postNotificationName:Notification_DeleteLinkBaby object:nil userInfo:userInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_type == GBArchivesRecordTypeFromRegister) {
        NSLog(@"将要显示，从注册");
    }else{
        [self  loadData];
        NSLog(@"将要显示，从编辑");
    NSLog(@"%@---%@---%@---%@---%@---%@",_tfWeight.text,_tfHeight.text,_tfDate.text,_tfName.text,_tfSex.text,self.childImage);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
