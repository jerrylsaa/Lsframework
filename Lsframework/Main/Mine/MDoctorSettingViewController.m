//
//  MDoctorSettingViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorSettingViewController.h"
#import "MDoctorSettingPresenter.h"
#define k_leftSpace    15
@interface MDoctorSettingViewController ()<MDoctorSettingPresenterDelegate,UITextFieldDelegate>{

    UIView  *_CouponView;
    UIView  *_callView;
    UIView  *_StatusView;
    UIView  *_PriceView;
    UIView  *_CouponCountView;
    UIView  *_PriceCountView;
    NSString  *Commitmessage;
    
    
}
@property(nonatomic,strong)UILabel  *CouponLb1;
@property(nonatomic,strong)UILabel  *CouponLb2;
@property(nonatomic,strong)UITextField  *CouponTextField;

@property(nonatomic,strong)UILabel  *callLb1;
//@property(nonatomic,strong)UILabel  *callLb2;

@property(nonatomic,strong)UILabel  *StatusLb1;
@property(nonatomic,strong)UILabel  *StatusLb2;
@property(nonatomic,strong)UILabel  *StatusLb3;
@property(nonatomic,strong)UIButton  *StatusBtn1;
@property(nonatomic,strong)UIButton  *StatusBtn2;

@property(nonatomic,strong)UILabel  *PriceLb1;
@property(nonatomic,strong)UILabel  *PriceLb2;
@property(nonatomic,strong)UITextField  *PriceTextField;

@property(nonatomic,strong)UILabel  *CouponCountLb; // 已消费的优惠券数量
@property(nonatomic,strong)UILabel  *PriceCountLb; // 已消费的优惠券金额
@property(nonatomic,strong)UIButton  *CommitBtn;
@property(nonatomic,retain) MDoctorSettingPresenter* presenter;
@end

@implementation MDoctorSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"每日义诊设置";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self  setupView];
    NSLog(@"专家id：%@",self.expertID);
    _presenter = [MDoctorSettingPresenter  new];
    _presenter.delegate = self;
    
    
}
-(void)setupView{
    
    _CouponView = [UIView  new];
    _CouponView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_CouponView];
    
    
    _PriceView = [UIView  new];
    _PriceView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_PriceView];
    
    _CouponCountView = [UIView  new];
    _CouponCountView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_CouponCountView];
    
    _PriceCountView = [UIView  new];
    _PriceCountView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_PriceCountView];
    

    _StatusView = [UIView  new];
    _StatusView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_StatusView];

    
    _callView = [UIView  new];
    _callView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view  addSubview:_callView];
    
    
    _CommitBtn = [UIButton  new];
    _CommitBtn.backgroundColor = [UIColor  clearColor];
    [_CommitBtn  setBackgroundImage:[UIImage  imageNamed:@"GDoctor_settingClick"] forState:UIControlStateNormal];
    [_CommitBtn  addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_CommitBtn];
    CGFloat  height = 50;
    
    _CouponView.sd_layout.topSpaceToView(self.view,0).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);
    
    _PriceView.sd_layout.topSpaceToView(_CouponView,1).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);
    
    _CouponCountView.sd_layout.topSpaceToView(_PriceView,1).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);
    
    _PriceCountView.sd_layout.topSpaceToView(_CouponCountView,1).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);

    _StatusView.sd_layout.topSpaceToView(_PriceCountView,1).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);

    _callView.sd_layout.topSpaceToView(_StatusView,1).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(height);
    

    
    int  CommitTop = 80;
    if (kScreenHeight == 480) {
        CommitTop = 40 ;
    }
    
   _CommitBtn.sd_layout.topSpaceToView(_callView,CommitTop).centerXEqualToView(self.view).heightIs(kFitWidthScale(80)).widthIs(kFitWidthScale(710));
    

    [self  setupCouponView];
    [self  setupPriceView];
    [self  setupCouponCountView];
    [self  setupPriceCountView];
    [self  setupStatusView];
    [self  setupcallView];
    

}
-(void)setupCouponView{
    
    _CouponLb1 = [UILabel  new];
    _CouponLb1.backgroundColor = [UIColor  clearColor];
    _CouponLb1.textColor = [UIColor  blackColor];
//    _CouponLb1.text = @"优惠券使用张数:";
    _CouponLb1.text = @"每日义诊使用次数:";
    _CouponLb1.font = [UIFont  systemFontOfSize:18];
    _CouponLb1.textAlignment = NSTextAlignmentLeft;
    [_CouponView  addSubview:_CouponLb1];
    
    _CouponTextField = [UITextField  new];
    _CouponTextField.backgroundColor = [UIColor  clearColor];
    _CouponTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _CouponTextField.delegate =self;
      _CouponTextField.clearsOnBeginEditing = YES;
    _CouponTextField.textColor = _CouponLb1.textColor;
    _CouponTextField.font = [UIFont  boldSystemFontOfSize:20];
    _CouponTextField.keyboardType = UIKeyboardTypePhonePad;
    [_CouponView  addSubview:_CouponTextField];
    
    _CouponLb2 = [UILabel  new];
    _CouponLb2.backgroundColor = [UIColor  clearColor];
    _CouponLb2.textColor = _CouponLb1.textColor;
    _CouponLb2.text = @"次";
    _CouponLb2.font = [UIFont  systemFontOfSize:18];
    _CouponLb2.textAlignment = NSTextAlignmentLeft;
    [_CouponView  addSubview:_CouponLb2];
    
    
_CouponLb1.sd_layout.centerYEqualToView(_CouponView).leftSpaceToView(_CouponView,k_leftSpace).widthIs(kJMWidth(_CouponLb1)).heightIs(18);
    
_CouponTextField.sd_layout.centerYEqualToView(_CouponView).leftSpaceToView(_CouponLb1,5).widthIs(20).heightIs(20);

_CouponLb2.sd_layout.centerYEqualToView(_CouponView).leftSpaceToView(_CouponTextField,5).widthIs(18).heightIs(18);

}
-(void)setupPriceView{
    
    _PriceLb1 = [UILabel  new];
    _PriceLb1.backgroundColor = [UIColor  clearColor];
    _PriceLb1.textColor = [UIColor  blackColor];
    _PriceLb1.text = @"咨询问题价格:";
    _PriceLb1.font = [UIFont  systemFontOfSize:18];
    _PriceLb1.textAlignment = NSTextAlignmentLeft;
    [_PriceView  addSubview:_PriceLb1];
    
    _PriceTextField = [UITextField  new];
    _PriceTextField.backgroundColor = [UIColor  clearColor];
    _PriceTextField.textColor = _PriceLb1.textColor;
    _PriceTextField.font =  _CouponTextField.font;
    _PriceTextField.delegate =self;
    _PriceTextField.clearsOnBeginEditing = YES;
    _PriceTextField.keyboardType = UIKeyboardTypePhonePad;
    _PriceTextField.textAlignment = NSTextAlignmentCenter;
    
    
    
    [_PriceView  addSubview:_PriceTextField];
    
    _PriceLb2 = [UILabel  new];
    _PriceLb2.backgroundColor = [UIColor  clearColor];
    _PriceLb2.textColor = _PriceLb1.textColor;
    _PriceLb2.textAlignment = NSTextAlignmentLeft;
    _PriceLb2.text = @"元";
    _PriceLb2.font = [UIFont  systemFontOfSize:18];
    
    [_PriceView  addSubview:_PriceLb2];
    
    
    _PriceLb1.sd_layout.centerYEqualToView(_PriceView).leftSpaceToView(_PriceView,k_leftSpace).widthIs(kJMWidth(_PriceLb1)).heightIs(18);
    
    _PriceTextField.sd_layout.centerYEqualToView(_PriceView).leftSpaceToView(_PriceLb1,5).widthIs(20).heightIs(20);
    
    _PriceLb2.sd_layout.centerYEqualToView(_PriceView).leftSpaceToView(_PriceTextField,5).widthIs(18).heightIs(18);
    
    
    
}
-(void)setupCouponCountView{
    
    _CouponCountLb = [UILabel  new];
    _CouponCountLb.backgroundColor = [UIColor  clearColor];
    _CouponCountLb.textColor = [UIColor  blackColor];
    _CouponCountLb.text = @"已使用免费义诊数量:  次";
    _CouponCountLb.font = [UIFont  systemFontOfSize:18];
    _CouponCountLb.textAlignment = NSTextAlignmentLeft;
    [_CouponCountView  addSubview:_CouponCountLb];
    
    
    _CouponCountLb.sd_layout.centerYEqualToView(_CouponCountView).leftSpaceToView(_CouponCountView,k_leftSpace).heightIs(18).widthIs(kScreenWidth);
    
    
    
}
-(void)setupPriceCountView{
    
    _PriceCountLb = [UILabel  new];
    _PriceCountLb.backgroundColor = [UIColor  clearColor];
    _PriceCountLb.textColor = [UIColor  blackColor];
    
    _PriceCountLb.text = @"已消费免费义诊金额:  元";
    _PriceCountLb.font = [UIFont  systemFontOfSize:18];
    _PriceCountLb.textAlignment = NSTextAlignmentLeft;
    [_PriceCountView  addSubview:_PriceCountLb];
    
    _PriceCountLb.sd_layout.centerYEqualToView(_PriceCountView).leftSpaceToView(_PriceCountView,k_leftSpace).heightIs(18).widthIs(kScreenWidth);;
    
    
}
-(void)setupStatusView{
    _StatusLb1= [UILabel  new];
    _StatusLb1.backgroundColor = [UIColor  clearColor];
    _StatusLb1.textColor = [UIColor  blackColor];
    _StatusLb1.text = @"坐诊状态：";
    _StatusLb1.font = [UIFont  systemFontOfSize:18];
    _StatusLb1.textAlignment = NSTextAlignmentLeft;
    [_StatusView  addSubview:_StatusLb1];
    
    _StatusBtn1 = [UIButton  new];
    _StatusBtn1.backgroundColor = [UIColor  clearColor];
    [_StatusBtn1  setBackgroundImage:[UIImage  imageNamed:@"GDoctor_settingUnSelect"] forState:UIControlStateNormal];
    [_StatusBtn1  setBackgroundImage:[UIImage  imageNamed:@"GDoctor_settingSelect"] forState:UIControlStateSelected];
    _StatusBtn1.tag = 100;
    [_StatusBtn1  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_StatusView  addSubview:_StatusBtn1];
    
    _StatusLb2= [UILabel  new];
    _StatusLb2.backgroundColor = [UIColor  clearColor];
    _StatusLb2.textColor = [UIColor  blackColor];
    _StatusLb2.text = @"值班中";
    _StatusLb2.font = [UIFont  systemFontOfSize:18];
    _StatusLb2.textAlignment = NSTextAlignmentLeft;
    [_StatusView  addSubview:_StatusLb2];
    
    _StatusBtn2 = [UIButton  new];
    _StatusBtn2.backgroundColor = [UIColor  clearColor];
    [_StatusBtn2  setBackgroundImage:[UIImage  imageNamed:@"GDoctor_settingUnSelect"] forState:UIControlStateNormal];
    [_StatusBtn2  setBackgroundImage:[UIImage  imageNamed:@"GDoctor_settingSelect"] forState:UIControlStateSelected];
    
    [_StatusBtn2  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_StatusView  addSubview:_StatusBtn2];
    
    _StatusLb3= [UILabel  new];
    _StatusLb3.backgroundColor = [UIColor  clearColor];
    _StatusLb3.textColor = [UIColor  blackColor];
    _StatusLb3.text = @"休假中";
    _StatusLb3.font = [UIFont  systemFontOfSize:18];
    _StatusLb3.textAlignment = NSTextAlignmentLeft;
    [_StatusView  addSubview:_StatusLb3];
    
    
    _StatusLb1.sd_layout.centerYEqualToView(_StatusView).leftSpaceToView(_StatusView,k_leftSpace).widthIs(kJMWidth(_StatusLb1)).heightIs(18);
    
    _StatusBtn1.sd_layout.centerYEqualToView(_StatusView).leftSpaceToView(_StatusLb1,k_leftSpace).widthIs(30/2).heightIs(32/2);
    
    _StatusLb2.sd_layout.centerYEqualToView(_StatusView).leftSpaceToView(_StatusBtn1,k_leftSpace).widthIs(kJMWidth(_StatusLb2)).heightIs(18);
    
    _StatusBtn2.sd_layout.centerYEqualToView(_StatusView).leftSpaceToView(_StatusLb2,40/2).widthIs(30/2).heightIs(32/2);
    
    _StatusLb3.sd_layout.centerYEqualToView(_StatusView).leftSpaceToView(_StatusBtn2,k_leftSpace).widthIs(kJMWidth(_StatusLb3)).heightIs(18);

    
}
-(void)setupcallView{
    _callLb1 = [UILabel  new];
    _callLb1.backgroundColor = [UIColor  clearColor];
    _callLb1.textColor = [UIColor  redColor];
    _callLb1.text = @"温馨提示:每日免费义诊的使用次数是0-100次，如:使用3次表示每日有3次表示每日有3位用户可免费向您提问,使用0次表示用户需要向你付费提问。";
    _callLb1.font = [UIFont  systemFontOfSize:14];
    _callLb1.numberOfLines = 0;
    _callLb1.textAlignment = NSTextAlignmentLeft;
    [_callView  addSubview:_callLb1];
    
    CGFloat Height = [JMFoundation  calLabelHeight:_callLb1.font andStr:_callLb1.text withWidth:kScreenWidth-20];
    _callView.height = Height;
    [_callView  updateLayout];
    
    
    _callLb1.sd_layout.centerXEqualToView(_callView).centerYEqualToView(_callView).heightIs(Height).widthIs(kScreenWidth-20);

    
    
}

-(void)selectBtnClick:(UIButton*)btn{
    
    if (btn == _StatusBtn1) {
        _StatusBtn1.selected = YES;
        _StatusBtn2.selected=NO;
    }    if (btn == _StatusBtn2) {
        _StatusBtn2.selected = YES;
        _StatusBtn1.selected = NO;
    }
    
}
-(void)commit{

    if ([_CouponTextField.text integerValue] >100) {
        [ProgressUtil  showInfo:@"请输入一百以内的优惠券张数"];
        return;
    }
    
    if ([_PriceTextField.text integerValue] >999) {
        [ProgressUtil  showInfo:@"请输入1000以内的价格"];
        return;
    }

    if (_PriceTextField.text.length ==0) {
        [ProgressUtil  showInfo:@"请输入价格"];
        return;
    }
    if (_CouponTextField.text.length ==0) {
        [ProgressUtil  showInfo:@"请输入优惠券张数"];
        return;
    }

    
    
    NSInteger  IsVacation;
    if (_StatusBtn1.selected == YES) {
        
        IsVacation = 0;
    }else if (_StatusBtn2.selected == YES){
    
      IsVacation = 1;
    
    }
    
    NSLog(@"休假：%d",IsVacation);
    NSLog(@"金额：%@",_PriceTextField.text);
    NSLog(@"券数：%@",_CouponTextField.text);
    
    NSNumber  *Count = [NSNumber  numberWithInteger:[_CouponTextField.text integerValue]];
    
    NSNumber  *price = [NSNumber  numberWithInteger:[_PriceTextField.text integerValue]];
    
    [_presenter  SetExpertDoctorCouponCountWithExpertID:self.expertID Count:Count];
    [_presenter  SetExpertDoctorIsVacationWithExpertID:self.expertID IsVacation:[NSNumber  numberWithInteger:IsVacation]];
    [_presenter  SetExpertDoctorPriceWithExpertID:self.expertID price:price];
    
    

}

-(void)onCompletion:(BOOL)success info:(NSString*)message{

    if (success) {
         [self.navigationController  popViewControllerAnimated:YES];
        [ProgressUtil  showSuccess:@"设置成功"];
    }
}
-(void)onGetExpertDoctorCompletion:(BOOL)success info:(NSString*)message{

    if (success) {
        _CouponTextField.text = [NSString  stringWithFormat:@"%@",_presenter.dataSource[0].DayUseCouponCount];
        
        _PriceTextField.text = [NSString  stringWithFormat:@"%@",_presenter.dataSource[0].Price];
    
        _CouponTextField.width = [JMFoundation  calLabelWidth:_CouponTextField.font andStr:_CouponTextField.text withHeight:20];
        [_CouponTextField  updateLayout];
        [_CouponLb2  updateLayout];
        
        _PriceTextField.width = [JMFoundation  calLabelWidth:_PriceTextField.font andStr:_PriceTextField.text withHeight:20];
        [_PriceTextField  updateLayout];
        [_PriceLb2  updateLayout];
        

        if ([[NSString  stringWithFormat:@"%@",_presenter.dataSource[0].IsVacation] isEqualToString:@"0"] ) {
            _StatusBtn1.selected = YES;
        }else{
            _StatusBtn2.selected = YES;
        }
        
        
        
        
    }else{
    
        [ProgressUtil  showError:message];
    }
}

-(void)onGetExpertConsumptionInfoCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        _CouponCountLb.text = [NSString  stringWithFormat:@"已使用免费义诊数量: %@ 次",_presenter.CouponCount];
        
        _PriceCountLb.text = [NSString  stringWithFormat:@"已消耗免费义诊金额: %@ 元",_presenter.CouponTotalMoney];
        NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:_CouponCountLb.text];
        
        [Str addAttribute:NSFontAttributeName
                    value:[UIFont  systemFontOfSize:18]
                    range:NSMakeRange(9,[NSString  stringWithFormat:@"%@",_presenter.CouponCount].length+1)];
        _CouponCountLb.attributedText = Str;

        NSMutableAttributedString *Str1 = [[NSMutableAttributedString alloc] initWithString:_PriceCountLb.text];
        
        [Str1 addAttribute:NSFontAttributeName
                    value:[UIFont  systemFontOfSize:18]
                    range:NSMakeRange(9,[NSString  stringWithFormat:@"%@",_presenter.CouponTotalMoney].length+1)];
        _PriceCountLb.attributedText = Str1;
        
        [_CouponCountLb  updateLayout];
        [_PriceCountLb  updateLayout];
        
        if (_presenter.CouponCount != nil) {
            [ProgressUtil  dismiss];
        }

        
    }else{
        
        [ProgressUtil  showError:message];
    }




}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-医生设置界面"];
    [_presenter  GetExpertDoctorIsVacationAndCountWithExpertID:self.expertID];
    
    [_presenter   GetExpertConsumptionInfoWithExpert_ID:self.expertID];
    
    if (_presenter.CouponCount == nil) {
        [ProgressUtil  show];
    }else{
        [ProgressUtil  dismiss];
        
    }


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-医生设置界面"];
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Check for non-numeric characters
 
    // Check for total length
    
    if ([textField  isEqual:_CouponTextField]) {
    NSString  *text = [textField.text  stringByReplacingCharactersInRange:range withString:string];
        
        if (_CouponTextField.text.length == 0) {
            _CouponTextField.width = 20;
            [_CouponTextField  updateLayout];
            [_CouponLb2  updateLayout];
            
            
        }else{
            _CouponTextField.width = [JMFoundation  calLabelWidth:_CouponTextField.font andStr:text withHeight:20];
            [_CouponTextField  updateLayout];
            [_CouponLb2  updateLayout];
        }
    }
    
    if ([textField  isEqual:_PriceTextField]) {
    NSString  *text = [textField.text  stringByReplacingCharactersInRange:range withString:string];
        
        if (_PriceTextField.text.length == 0) {
            _PriceTextField.width = 20;
            [_PriceTextField  updateLayout];
            [_PriceLb2  updateLayout];
            
            
        }else{
            _PriceTextField.width = [JMFoundation  calLabelWidth:_PriceTextField.font andStr:text withHeight:20];
            [_PriceTextField  updateLayout];
            [_PriceLb2  updateLayout];
        }
    }


    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 3) return NO;//限制长度
    return YES;
    
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    if ([textField  isEqual:_CouponTextField]) {
        
        if (_CouponTextField.text.length == 0) {
            _CouponTextField.width = 20;
            [_CouponTextField  updateLayout];
            [_CouponLb2  updateLayout];
   
            
        }else{
        _CouponTextField.width = [JMFoundation  calLabelWidth:_CouponTextField.font andStr:_CouponTextField.text withHeight:20];
            [_CouponTextField  updateLayout];
            [_CouponLb2  updateLayout];
        }
    
    }
    
    
    if ([textField  isEqual:_PriceTextField]) {
        
        if (_PriceTextField.text.length == 0) {
            _PriceTextField.width = 20;
            [_PriceTextField  updateLayout];
            [_PriceLb2  updateLayout];
            
            
        }else{
            _PriceTextField.width = [JMFoundation  calLabelWidth:_PriceTextField.font andStr:_PriceTextField.text withHeight:20];
            [_PriceTextField  updateLayout];
            [_PriceLb2  updateLayout];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
