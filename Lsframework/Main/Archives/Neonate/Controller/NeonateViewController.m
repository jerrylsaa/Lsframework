//
//  NeonateViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//  新生儿

#import "NeonateViewController.h"
#import "FBRadioGroup.h"
#import "FPTextField.h"
#import "TaiChanImageView.h"
#import "SelectButtonImageView.h"
#import "FPButton.h"
#import "GestationViewController.h"
#import "MenuEntity.h"
#import "FPDropView.h"


@interface NeonateViewController ()<SelectButtonDelegate,UITextFieldDelegate,NeonatePresenterDelegate>{
    UIScrollView* _scrollView;
    FPTextField* _yunZhoutf;
    TaiChanImageView* _taiChanImageView;
    SelectButtonImageView* _souYunImageView;
    FPTextField* _taiShutf;
    FPTextField* _birthtf;
    FPTextField* _fenMiantf;
    UIButton* _backbt;
    UIButton* _nextbt;
    
    UITextField* _beiZhutf;
    
    BOOL _isFinish;

}
@property (weak, nonatomic) IBOutlet FBRadioGroup *radioGroup;

@property(nonatomic,retain) NeonatePresenter* presenter;

@end

@implementation NeonateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:@"完成"];

    
}
#pragma mark - 加载视图
-(void)setupView{
    self.title=@"新生儿及围产期";
    //scrollView
    self.presenter=[NeonatePresenter new];
    self.presenter.delegate=self;
    
    _scrollView=[UIScrollView new];
    _scrollView.showsVerticalScrollIndicator=NO;
//    _scrollView.bounces=NO;
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupYunZhoutextfield];
    [self setupTaiChanImageView];
    [self setupSouYunImageView];
    [self setupTaiShuImageView];
    [self setupFenMianImageView];
    [self setupBackAndNextButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBegin:) name:@"notice_textFieldBegin" object:nil];
}

#pragma mark * 孕周输入框
- (void)setupYunZhoutextfield{
    _yunZhoutf=[FPTextField new];
    _yunZhoutf.title=@"孕     周:";
    _yunZhoutf.unit=@"周";
//    _yunZhoutf.textAlignment = NSTextAlignmentCenter;
    _yunZhoutf.stopAnimation = YES;
    _yunZhoutf.textCenter = YES;
    _yunZhoutf.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_yunZhoutf];
    _yunZhoutf.sd_layout.topSpaceToView(_scrollView,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
}

#pragma mark * 胎产次
- (void)setupTaiChanImageView{
    _taiChanImageView=[TaiChanImageView new];
    _taiChanImageView.title=@"胎 产 次:";
    
    [_scrollView addSubview:_taiChanImageView];
    _taiChanImageView.sd_layout.topSpaceToView(_yunZhoutf,15).heightRatioToView(_yunZhoutf,1).leftEqualToView(_yunZhoutf).rightEqualToView(_yunZhoutf);
}

#pragma mark * 受孕情况
- (void)setupSouYunImageView{
    _souYunImageView=[SelectButtonImageView new];
    _souYunImageView.title=@"受孕情况:";
    _souYunImageView.listArray=@[@"自然怀孕",@"人工授精",@"体外助孕"];
    _souYunImageView.delegate=self;
    _souYunImageView.radioGroup.selection = 0;//默认第一个
    [_scrollView addSubview:_souYunImageView];
    _souYunImageView.sd_layout.topSpaceToView(_taiChanImageView,15).heightIs(208/2.0).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    //备注
    _beiZhutf=[UITextField new];
    _beiZhutf.placeholder=@"请注明";
    [_beiZhutf setValue:FileFontColor forKeyPath:@"_placeholderLabel.textColor"];
    _beiZhutf.textColor=FileFontColor;
    _beiZhutf.textAlignment=NSTextAlignmentCenter;
    _beiZhutf.hidden=YES;
    _beiZhutf.background=[UIImage imageNamed:@"beizhu"];
    [_souYunImageView addSubview:_beiZhutf];
    _beiZhutf.sd_layout.bottomSpaceToView(_souYunImageView,25/2.0).heightIs(25).leftSpaceToView(_souYunImageView,310/2.0).widthIs(230/2.0);
    
}

#pragma mark * 胎数
- (void)setupTaiShuImageView{
    _taiShutf=[FPTextField new];
    _taiShutf.title=@"胎        数:";
    _taiShutf.delegate = self;
    _taiShutf.textCenter = YES;
    _taiShutf.rightIcon = [UIImage imageNamed:@"pulldown"];
    [_scrollView addSubview:_taiShutf];
    _taiShutf.sd_layout.topSpaceToView(_souYunImageView,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    _birthtf=[FPTextField new];
    _birthtf.title=@"第";
    _birthtf.unit = @"个出生";
    _birthtf.stopAnimation = YES;
    _birthtf.textCenter = YES;
    _birthtf.keyboardType = UIKeyboardTypeNumberPad;
//    _birthtf.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_birthtf];
    _birthtf.sd_layout.topSpaceToView(_taiShutf,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
}

#pragma mark * 分娩方式
- (void)setupFenMianImageView{
    _fenMiantf=[FPTextField new];
    _fenMiantf.title=@"分娩方式:";
    _fenMiantf.textCenter = YES;
    _fenMiantf.delegate = self;
    _fenMiantf.rightIcon = [UIImage imageNamed:@"pulldown"];
    [_scrollView addSubview:_fenMiantf];
    _fenMiantf.sd_layout.topSpaceToView(_birthtf,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
}

#pragma mark * 上/下步按钮
- (void)setupBackAndNextButton{
    UIButton* backbt=[UIButton new];
    [backbt setBackgroundImage:[UIImage imageNamed:@"upstep_nor"] forState:UIControlStateNormal];
    [backbt setBackgroundImage:[UIImage imageNamed:@"upstep_sel"] forState:UIControlStateHighlighted];
    [backbt setTitle:@"上一步" forState:UIControlStateNormal];
    backbt.tag=300;
    [backbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:backbt];
    _backbt=backbt;
    backbt.sd_layout.topSpaceToView(_fenMiantf,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,kScreenWidth/2.0+10);

    UIButton* nextbt=[UIButton new];
    [nextbt setBackgroundImage:[UIImage imageNamed:@"downstep_nor"] forState:UIControlStateNormal];
    [nextbt setBackgroundImage:[UIImage imageNamed:@"downstep_sel"] forState:UIControlStateHighlighted];
    [nextbt setTitle:@"下一步" forState:UIControlStateNormal];
    nextbt.tag=301;
    [nextbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:nextbt];
    _nextbt=nextbt;
    nextbt.sd_layout.topSpaceToView(_fenMiantf,15).heightIs(40).rightSpaceToView(_scrollView,25).widthRatioToView(backbt,1);

    [_scrollView setupAutoContentSizeWithBottomView:backbt bottomMargin:100];
}

#pragma mark - 点击事件
/**
 *  点击上/下一步按钮
 *
 *  @param bt <#bt description#>
 */
- (void)clickAction:(UIButton*) bt{
    if (bt.tag == 300) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //孕周
        self.childForm.gestationalAge=_yunZhoutf.text;
        //胎产次
        self.childForm.fetusNum=_taiChanImageView.taitf.text;
        self.childForm.birthNum=_taiChanImageView.chantf.text;
        //受孕情况
        self.childForm.pregnancy=_souYunImageView.currentSelect;
        self.childForm.pregnancyMark=_beiZhutf.text;
        
        self.childForm.whichTire=_birthtf.text;
                
        [ProgressUtil show];
        [self.presenter commitNeonate:self.childForm];
    }
}

-(void)rightItemAction:(id)sender{
    _isFinish = YES;
    
    //孕周
    self.childForm.gestationalAge=_yunZhoutf.text;
    //胎产次
    self.childForm.fetusNum=_taiChanImageView.taitf.text;
    self.childForm.birthNum=_taiChanImageView.chantf.text;
    //受孕情况
    self.childForm.pregnancy=_souYunImageView.currentSelect;
    self.childForm.pregnancyMark=_beiZhutf.text;
    
    self.childForm.whichTire=_birthtf.text;
    
    [self.presenter commitNeonate:self.childForm];

    
    if (self.poptoClass) {
        UIViewController * back;
        for (UIViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:self.poptoClass]) {
                back = vc;
                break;
            }
        }
        if (back) {
            [self.navigationController popToViewController:back animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
    }

}

#pragma mark - 代理
/**
 *  展示备注
 *
 *  @param index <#index description#>
 */
-(void)showBeiZhuWith:(NSInteger)index{
//    [self keyboardDismiss];
//    _souYunImageView.image = [UIImage imageNamed:@"text_sel"];
//    
//    CGFloat oldHeight= 208/2.0;
//    CGFloat height = 35;
//    if(index==2){
//        [_beiZhutf becomeFirstResponder];
//        [UIView animateWithDuration:0.2f animations:^{
//            _beiZhutf.hidden=NO;
//            _souYunImageView.sd_layout.heightIs(oldHeight+height);
//            [_souYunImageView updateLayout];
//        }];
//        
//    }else{
//        if(_beiZhutf.hidden) return ;
//        
//        [UIView animateWithDuration:0.2f animations:^{
//            _beiZhutf.hidden=YES;
//            _beiZhutf.text = nil;
//            _souYunImageView.sd_layout.heightIs(oldHeight);
//            [_souYunImageView updateLayout];
//        }];
//    
//    }
//    if(_beiZhutf.hidden) return ;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WS(ws);
    __weak typeof(textField) weakTf = textField;
    
    if([textField isEqual:_taiShutf]){
        //胎数
        _souYunImageView.image = [UIImage imageNamed:@"text_nor"];

        NSArray *taishuArray = [MenuEntity findMenuEntity:393];
        NSArray *sortedArray = [taishuArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            NSInteger menuID = [MenuEntity findMenuEntityID:weakTf.text];
            ws.childForm.tireNum = menuID;
            [ws changeBirthText:weakTf.text];
            return YES;
        }];
        [dropView showInController:self parentView:textField];

    }else if([textField isEqual:_fenMiantf]){
        //分娩方式
        _souYunImageView.image = [UIImage imageNamed:@"text_nor"];

        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        NSArray* menuArray = [MenuEntity findMenuEntity:392];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in menuArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            NSInteger menuID = [MenuEntity findMenuEntityID:weakTf.text];
            ws.childForm.childBirth = menuID;
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }
    
    return NO;
}


-(void)onCommitComplete:(BOOL)success info:(NSString *)info{
    if(success){
        if(_isFinish){
        //完成

        }else{
            _isFinish = NO;
            [ProgressUtil dismiss];
            GestationViewController* gestation = [GestationViewController new];
            gestation.poptoClass = self.poptoClass;
            gestation.childForm = self.childForm;
            [self.navigationController pushViewController:gestation animated:YES];

        }
    }else{
        [ProgressUtil showError:info];
    }
}

- (void)vc_2_save:(Complete)block{
    //孕周
    self.childForm.gestationalAge=_yunZhoutf.text;
    //胎产次
    self.childForm.fetusNum=_taiChanImageView.taitf.text;
    self.childForm.birthNum=_taiChanImageView.chantf.text;
    self.childForm.pregnancy=_souYunImageView.currentSelect;
    self.childForm.pregnancyMark=_beiZhutf.text;
    
    self.childForm.whichTire=_birthtf.text;
    
    [ProgressUtil show];
    [self.presenter commitNeonate:self.childForm block:^(BOOL success, NSString *message) {
        block(success ,message);
    }];
}


#pragma mark - 通知回调
- (void)textFieldDidBegin:(NSNotification*) notification{
    
    _souYunImageView.image = [UIImage imageNamed:@"text_nor"];
}

#pragma mark - 公有方法
-(void)loadData:(ChildForm *)child{
    self.childForm = child;
    _yunZhoutf.text = child.gestationalAge;//孕周
    
    _taiChanImageView.taitf.text = child.fetusNum;//胎产次
    _taiChanImageView.chantf.text = child.birthNum;
    
    _souYunImageView.radioGroup.selection = child.pregnancy - 1;//受孕情况
    _souYunImageView.currentSelect = child.pregnancy;
    if(child.pregnancy == 3){
    //显示备注
        _beiZhutf.text = child.pregnancyMark;
        _beiZhutf.hidden=NO;
        CGFloat oldHeight= 208/2.0;
        CGFloat height = 35;
        _souYunImageView.sd_layout.heightIs(oldHeight+height);
        [_souYunImageView updateLayout];
    }
    
    //胎数
    _taiShutf.text = [MenuEntity findMenuName:child.tireNum];
    _birthtf.text = child.whichTire;
    
    //分娩方式
    _fenMiantf.text = [MenuEntity findMenuName:child.childBirth];
}


#pragma mark - 私有方法
- (void)keyboardDismiss{
    if([_taiChanImageView.taitf isFirstResponder]){
        [_taiChanImageView.taitf resignFirstResponder];
    }
    if([_taiChanImageView.chantf isFirstResponder]){
        [_taiChanImageView.chantf resignFirstResponder];
    }
    if([_yunZhoutf isFirstResponder]){
        [_yunZhoutf resignFirstResponder];
    }
    if([_taiShutf isFirstResponder]){
        [_taiShutf resignFirstResponder];
    }
    if([_birthtf isFirstResponder]){
        [_birthtf resignFirstResponder];
    }
    if([_beiZhutf isFirstResponder]){
        [_beiZhutf resignFirstResponder];
    }
}
/**
 *  设置第几个出生的顺序
 *
 *  @param TaiShu <#TaiShu description#>
 */
- (void)changeBirthText:(NSString*) TaiShu{
    
    if([TaiShu isEqualToString:@"单胎"]){
        _birthtf.text = @"1";
        _birthtf.enabled = NO;
    }else{
        _birthtf.text = nil;
        _birthtf.enabled = YES;
    }
}



- (void)hiddenButton{
    _backbt.hidden = YES;
    _nextbt.hidden = YES;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice_textFieldBegin" object:nil];
}


@end
