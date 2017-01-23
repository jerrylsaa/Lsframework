//
//  AppointInfoViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppointInfoViewController.h"
#import "SignSuccessViewController.h"
#import "ScanQRCodeViewController.h"
#import "LCTextView.h"
#import "AppointInfoPresenter.h"

@interface AppointInfoViewController ()<ScanQRCodeViewControllerDelegate,UIAlertViewDelegate,AppointInfoPresenterDelegate>{
    UIScrollView* _scroll;
    
    UIView* _appointInfobgView;
    UILabel* _appointData;
    UILabel* _appointTime;
    UILabel* _appointPeople;
    UILabel* _appointPlace;
    UILabel* _connect;
    UILabel* _appointWay;
    
    UIButton* _resetAppoint;
    UIButton* _cancelAppoint;
    
    UIButton* _treatment;
    UIButton* _untreatment;
    
    LCTextView* _lcTextView;
    
    UIButton* _commitBt;
    UIButton* _cancelBt;
    
}

@property(nonatomic,retain) UIView* textViewbg;
@property(nonatomic,retain) AppointInfoPresenter* presenter;

@end

@implementation AppointInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [AppointInfoPresenter new];
    self.presenter.delegate = self;

}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"预约详细信息";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self setupScrollView];
    [self setupInfoView];
    [self setupButton];
    [self setupTextView];
}

- (void)setupScrollView{
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setupInfoView{
    _appointInfobgView = [UIView new];
    _appointInfobgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scroll addSubview:_appointInfobgView];
    
    //日期
    _appointData = [UILabel new];
    _appointData.textColor = UIColorFromRGB(0x535353);
    UIFont* font = kScreenWidth == 320? [UIFont systemFontOfSize:14]: [UIFont systemFontOfSize:18];
    _appointData.font = font;
    [_appointInfobgView addSubview:_appointData];
    //时间
    _appointTime = [UILabel new];
    _appointTime.textColor = _appointData.textColor;
    _appointTime.font = _appointData.font;
    [_appointInfobgView addSubview:_appointTime];
    //人
    _appointPeople = [UILabel new];
    _appointPeople.textColor = _appointData.textColor;
    _appointPeople.font = _appointData.font;
    [_appointInfobgView addSubview:_appointPeople];
    //地点
    _appointPlace = [UILabel new];
    _appointPlace.textColor = _appointData.textColor;
    _appointPlace.font = _appointData.font;
    [_appointInfobgView addSubview:_appointPlace];
    //联系方式
    _connect = [UILabel new];
    _connect.textColor = _appointData.textColor;
    _connect.font = _appointData.font;
    [_appointInfobgView addSubview:_connect];
    //预约方式
    _appointWay = [UILabel new];
    _appointWay.textColor = _appointData.textColor;
    _appointWay.font = _appointData.font;
    [_appointInfobgView addSubview:_appointWay];
    
    //分割线
    UIView* line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_appointInfobgView addSubview:line];

    //修改预约
    _resetAppoint = [UIButton new];
    [_resetAppoint setBackgroundImage:[UIImage imageNamed:@"doctor_resetAppoint"] forState:UIControlStateNormal];
    [_resetAppoint setTitle:@"修改预约" forState:UIControlStateNormal];
    [_resetAppoint addTarget:self action:@selector(resetAppointAction) forControlEvents:UIControlEventTouchUpInside];
    [_appointInfobgView addSubview:_resetAppoint];
    
    //取消预约
    _cancelAppoint = [UIButton new];
    [_cancelAppoint setBackgroundImage:[UIImage imageNamed:@"doctor_cancelAppoint"] forState:UIControlStateNormal];
    [_cancelAppoint setTitle:@"取消预约" forState:UIControlStateNormal];
    [_cancelAppoint setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [_cancelAppoint addTarget:self action:@selector(cancelAppointAction) forControlEvents:UIControlEventTouchUpInside];
    [_appointInfobgView addSubview:_cancelAppoint];

    //添加约束
    CGFloat space = 20;
    _appointData.sd_layout.topSpaceToView(_appointInfobgView,30).leftSpaceToView(_appointInfobgView,10).autoHeightRatio(0);
    [_appointData setSingleLineAutoResizeWithMaxWidth:300];
    
    _appointTime.sd_layout.topSpaceToView(_appointData,space).leftEqualToView(_appointData).autoHeightRatio(0);
    [_appointTime setSingleLineAutoResizeWithMaxWidth:300];
    
    _appointPeople.sd_layout.topSpaceToView(_appointTime,space).leftEqualToView(_appointData).autoHeightRatio(0);
    [_appointPeople setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _appointPlace.sd_layout.topSpaceToView(_appointPeople,space).leftEqualToView(_appointData).autoHeightRatio(0);
    [_appointPlace setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _connect.sd_layout.topSpaceToView(_appointPlace,space).leftEqualToView(_appointData).autoHeightRatio(0);
    [_connect setSingleLineAutoResizeWithMaxWidth:300];
    
    _appointWay.sd_layout.topSpaceToView(_connect,space).leftEqualToView(_appointData).autoHeightRatio(0);
    [_appointWay setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    line.sd_layout.topSpaceToView(_appointWay,15).leftEqualToView(_appointData).rightSpaceToView(_appointInfobgView,10).heightIs(1);
    
    
    _appointInfobgView.sd_equalWidthSubviews = @[_resetAppoint,_cancelAppoint];
    _resetAppoint.sd_layout.topSpaceToView(line,10).leftSpaceToView(_appointInfobgView,75).heightIs(40);
    _cancelAppoint.sd_layout.topSpaceToView(line,10).leftSpaceToView(_resetAppoint,25).rightSpaceToView(_appointInfobgView,75).heightIs(40);
    
    _appointInfobgView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_appointInfobgView setupAutoHeightWithBottomView:_resetAppoint bottomMargin:10];
    
    
    _appointData.text = [NSString stringWithFormat:@"预约日期：%@",self.appointManager.bespeakDate];
    [_appointData updateLayout];
    
    _appointTime.text = [NSString stringWithFormat:@"预约时间：%@",self.appointManager.bespeakTime];
    _appointPeople.text = [NSString stringWithFormat:@"预 约 人：%@  %@  %@",self.appointManager.doctorName,self.appointManager.academicTitle,self.appointManager.departName];
    
    _appointPlace.text = [NSString stringWithFormat:@"预约地点：%@",self.appointManager.bespeakAddress];
    _connect.text = [NSString stringWithFormat:@"联系方式：%@",self.appointManager.bespeakLinkPhone];
    _appointWay.text = [NSString stringWithFormat:@"预约方式：%@",self.appointManager.bespeakMode];
}

- (void)setupButton{
    //已就诊
    _treatment = [UIButton new];
    [_treatment setBackgroundImage:[UIImage imageNamed:@"doctor_treatment"] forState:UIControlStateNormal];
    [_treatment setTitle:@"已就诊" forState:UIControlStateNormal];
    [_treatment addTarget:self action:@selector(treatmentAppointAction) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:_treatment];
    
    //未就诊
    _untreatment = [UIButton new];
    [_untreatment setBackgroundImage:[UIImage imageNamed:@"doctor_untreatment"] forState:UIControlStateNormal];
    [_untreatment setTitle:@"未就诊" forState:UIControlStateNormal];
    [_untreatment setTitleColor:UIColorFromRGB(0xEDB644) forState:UIControlStateNormal];
    [_untreatment addTarget:self action:@selector(untreatmentAppointAction) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:_untreatment];
    
    
    _treatment.sd_layout.topSpaceToView(_appointInfobgView,40).heightIs(40).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25);
    _untreatment.sd_layout.topSpaceToView(_treatment,20).heightIs(40).leftEqualToView(_treatment).rightEqualToView(_treatment);
    
    [_scroll setupAutoContentSizeWithBottomView:_untreatment bottomMargin:10];
}

- (void)setupTextView{
    UIView* textViewbg = [UIView new];
    textViewbg.backgroundColor = [UIColor clearColor];
    textViewbg.hidden = YES;
    [_scroll addSubview:textViewbg];
    self.textViewbg = textViewbg;
    
    _lcTextView = [LCTextView new];
    _lcTextView.font = [UIFont systemFontOfSize:16];
    _lcTextView.placeholder = @"请说明未就诊原因";
    _lcTextView.placeholderColor = UIColorFromRGB(0x888888);
    _lcTextView.backgroundColor = UIColorFromRGB(0xffffff);
    [textViewbg addSubview:_lcTextView];
    
    //提交按钮
     _commitBt= [UIButton new];
    [_commitBt setBackgroundImage:[UIImage imageNamed:@"downstep_nor"] forState:UIControlStateNormal];
    [_commitBt setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [textViewbg addSubview:_commitBt];
    
    //取消按钮
    _cancelBt= [UIButton new];
    [_cancelBt setBackgroundImage:[UIImage imageNamed:@"upstep_nor"] forState:UIControlStateNormal];
    [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBt addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [textViewbg addSubview:_cancelBt];

    //添加约束
    _lcTextView.sd_layout.topEqualToView(textViewbg).heightIs(150).leftEqualToView(textViewbg).rightEqualToView(textViewbg);
    
    textViewbg.sd_equalWidthSubviews = @[_commitBt,_cancelBt];
    _commitBt.sd_layout.topSpaceToView(_lcTextView,20).leftSpaceToView(textViewbg,25).heightIs(40);
    _cancelBt.sd_layout.topEqualToView(_commitBt).leftSpaceToView(_commitBt,10).rightSpaceToView(textViewbg,25).heightIs(40);
    
    textViewbg.sd_layout.topSpaceToView(_untreatment,50).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [textViewbg setupAutoHeightWithBottomView:_commitBt bottomMargin:10];
    
//    [_scroll setupAutoContentSizeWithBottomView:self.textViewbg bottomMargin:10];

    
}

#pragma mark - 点击事件

/**
 *  修改预约
 */
- (void)resetAppointAction{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"联系医助修改预约" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    alertView.tag = 201;
    [alertView show];
}
/**
 *  取消预约
 */
- (void)cancelAppointAction{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"联系医助取消预约" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    alertView.tag = 202;
    [alertView show];

}
/**
 *  已就诊
 */
- (void)treatmentAppointAction{
//    [self.navigationController pushViewController:[SignSuccessViewController new] animated:YES];
    
//    [self presentViewController:[ScanQRCodeViewController new] animated:YES completion:nil];
    
    ScanQRCodeViewController* scanQR = [ScanQRCodeViewController new];
    scanQR.delegate = self;
    
    [self.navigationController pushViewController:scanQR animated:YES];
}

/**
 *  未就诊
 */
- (void)untreatmentAppointAction{

    [UIView animateWithDuration:0.2 animations:^{
        self.textViewbg.hidden = NO;
    }];
    
    [_scroll setupAutoContentSizeWithBottomView:self.textViewbg bottomMargin:10];
    [_scroll layoutSubviews];
    [_scroll scrollsToTop];
}
/**
 *  提交
 */
- (void)commitAction{
    [ProgressUtil show];
    [self.presenter commitCancelAppointInfo:_lcTextView.text AppointID:self.appointManager.keyID];
}
/**
 *  取消
 */
- (void)cancelAction{
    [UIView animateWithDuration:0.2 animations:^{
        self.textViewbg.hidden = YES;
    }completion:^(BOOL finished) {
    }];
    [_scroll setupAutoContentSizeWithBottomView:_untreatment bottomMargin:10];
    [_scroll layoutSubviews];

}

#pragma mark - 代理

-(void)onScanDone:(NSString *)qrCode{
    NSLog(@"%@",qrCode);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 201){
    //修改预约
        if(buttonIndex == 0){
            //联系客服打电话
            NSLog(@"打电话");
            
            NSString* phone=[NSString stringWithFormat:@"tel://%@",@"10086"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
    }else if(alertView.tag == 202){
    //取消预约
        if(buttonIndex == 0){
            //联系客服打电话
            NSLog(@"打电话");
            
            NSString* phone=[NSString stringWithFormat:@"tel://%@",@"10086"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
    }
    
}
-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:message];
    }
}





@end
