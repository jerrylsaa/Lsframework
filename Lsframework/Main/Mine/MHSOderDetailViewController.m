//
//  MHSOderDetailViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHSOderDetailViewController.h"
#import "MHealthServicePresenter.h"
#import "MHealthServiceOderViewController.h"
#import "AliPayUtil.h"

@interface MHSOderDetailViewController ()<UIActionSheetDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_locationIV;
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
    UIImageView *_firstLine;
    UIImageView *_mainIV;
    UILabel *_serviceNameLabel;
    UILabel *_totalPriceLabel;
    UIImageView *_secondLine;
    UILabel *_payPriceTipLabel;
    UILabel *_payPriceShowLabel;
    UILabel *_payDateTipLabel;
    UILabel *_payDateShowLabel;
    UIButton *_cancelBtn;
    UIButton *_payBtn;
    NSTimer *_timer;
}
@property (nonatomic,strong) MHealthServicePresenter *presenter;
@end

@implementation MHSOderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];

}

- (void)setupView{
    self.title =@"服务详情";
    
    _presenter =[MHealthServicePresenter new];
    _presenter.delegate =self;
    
    _scrollView =[UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    //    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    _locationIV =[UIImageView new];
    _locationIV.image =[UIImage imageNamed:@"location_icon"];
    [_scrollView addSubview:_locationIV];
    
    _nameLabel =[UILabel new];
    _nameLabel.font =[UIFont systemFontOfSize:14];
    _nameLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_nameLabel];
    
    _phoneLabel =[UILabel new];
    _phoneLabel.textAlignment =NSTextAlignmentRight;
    _phoneLabel.font =[UIFont systemFontOfSize:14];
    _phoneLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_phoneLabel];
    
    _addressLabel =[UILabel new];
    _addressLabel.numberOfLines =0;
    _addressLabel.font =[UIFont systemFontOfSize:14];
    _addressLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_addressLabel];
    
    _firstLine =[UIImageView new];
    _firstLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_firstLine];
    
    _mainIV =[UIImageView new];
    [_scrollView addSubview:_mainIV];
    
    _serviceNameLabel =[UILabel new];
    _serviceNameLabel.numberOfLines =0;
    _serviceNameLabel.font =[UIFont systemFontOfSize:14];
    _serviceNameLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_serviceNameLabel];
    
    _totalPriceLabel =[UILabel new];
    _totalPriceLabel.textAlignment =NSTextAlignmentRight;
    _totalPriceLabel.font =[UIFont systemFontOfSize:14];
    _totalPriceLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_totalPriceLabel];
    
    _secondLine =[UIImageView new];
    _secondLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_secondLine];
    
    _payPriceTipLabel =[UILabel new];
    _payPriceTipLabel.text =@"应付金额";
    _payPriceTipLabel.font =[UIFont systemFontOfSize:14];
    _payPriceTipLabel.textColor =UIColorFromRGB(0x767676);
    [_scrollView addSubview:_payPriceTipLabel];
    
    _payPriceShowLabel =[UILabel new];
    _payPriceShowLabel.textAlignment =NSTextAlignmentRight;
    _payPriceShowLabel.font =[UIFont systemFontOfSize:14];
    _payPriceShowLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_payPriceShowLabel];
    
    _payDateTipLabel =[UILabel new];
    _payDateTipLabel.text =@"购买时间";
    _payDateTipLabel.font =[UIFont systemFontOfSize:14];
    _payDateTipLabel.textColor =UIColorFromRGB(0x767676);
    [_scrollView addSubview:_payDateTipLabel];
    
    _payDateShowLabel =[UILabel new];
    _payDateShowLabel.textAlignment =NSTextAlignmentRight;
    _payDateShowLabel.font =[UIFont systemFontOfSize:14];
    _payDateShowLabel.textColor =UIColorFromRGB(0x666666);
    [_scrollView addSubview:_payDateShowLabel];
    
    _cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"cancleBackG"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_cancelBtn];
    
    _payBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setImage:[UIImage imageNamed:@"payBackG"] forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_payBtn];

    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _locationIV.sd_layout.topSpaceToView(_scrollView,15).leftSpaceToView(_scrollView,15).widthIs(18).heightIs(18);
    _nameLabel.sd_layout.centerYEqualToView(_locationIV).leftSpaceToView(_locationIV,10).widthIs(120).heightIs(20);
    _phoneLabel.sd_layout.centerYEqualToView(_locationIV).rightSpaceToView(_scrollView,15).widthIs(120).heightIs(20);
    _addressLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_nameLabel,15).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    _firstLine.sd_layout.topSpaceToView(_addressLabel,15).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).heightIs(10);
    _mainIV.sd_layout.topSpaceToView(_firstLine,15).leftSpaceToView(_scrollView,15).widthIs(100).heightIs(80);
    _serviceNameLabel.sd_layout.leftSpaceToView(_mainIV,15).topEqualToView(_mainIV).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    _totalPriceLabel.sd_layout.topSpaceToView(_serviceNameLabel,15).rightSpaceToView(_scrollView,15).widthIs(120).heightIs(20);
    if (CGRectGetMaxY(_mainIV.frame)>=CGRectGetMaxY(_totalPriceLabel.frame)) {
        _secondLine.sd_layout.topSpaceToView(_mainIV,25).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(1);
    }else{
        _secondLine.sd_layout.topSpaceToView(_totalPriceLabel,25).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(1);
    }
    
    _payPriceTipLabel.sd_layout.topSpaceToView(_secondLine,20).leftSpaceToView(_scrollView,15).widthIs(120).heightIs(20);
    _payPriceShowLabel.sd_layout.topSpaceToView(_secondLine,20).rightSpaceToView(_scrollView,15).widthIs(200).heightIs(20);
    _payDateTipLabel.sd_layout.topSpaceToView(_payPriceTipLabel,10).leftSpaceToView(_scrollView,15).widthIs(120).heightIs(20);
    _payDateShowLabel.sd_layout.topSpaceToView(_payPriceShowLabel,10).rightSpaceToView(_scrollView,15).widthIs(200).heightIs(20);
    _payBtn.sd_layout.rightSpaceToView(_scrollView,15).topSpaceToView(_payDateShowLabel,160).widthIs(87).heightIs(32);
    _cancelBtn.sd_layout.rightSpaceToView(_payBtn,15).topSpaceToView(_payDateShowLabel,160).widthIs(87).heightIs(32);
    
    [_scrollView setupAutoHeightWithBottomView:_cancelBtn bottomMargin:25];
    if (_myOderListEntity!=nil&&_myDetailEntity!=nil&&_myAddressEntity!=nil) {
        _serviceNameLabel.text =_myDetailEntity.NAME;
        
        [_mainIV sd_setImageWithURL:[NSURL URLWithString:_myDetailEntity.MAIN_PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        
        _totalPriceLabel.text =[NSString stringWithFormat:@"¥%@",_myOderListEntity.TOTAL_PRICE];
        _payPriceShowLabel.text =[NSString stringWithFormat:@"¥%@",_myOderListEntity.PAY_PRICE];
//        _payDateShowLabel.text =_myOderListEntity.CREATE_TIME;
        _payDateShowLabel.text =_myOderListEntity.Time;
        _nameLabel.text =_myAddressEntity.NAME;
        _phoneLabel.text =_myAddressEntity.PHONE;
        _addressLabel.text =_myAddressEntity.ADDRESS;
        
    }else if (_myOderListEntity!=nil&&_myAddressEntity!=nil){
        _serviceNameLabel.text =_serviceName;
        
        [_mainIV sd_setImageWithURL:[NSURL URLWithString:_mainIVUrl] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        
        _totalPriceLabel.text =[NSString stringWithFormat:@"¥%@",_myOderListEntity.TOTAL_PRICE];
        _payPriceShowLabel.text =[NSString stringWithFormat:@"¥%@",_myOderListEntity.PAY_PRICE];
//        _payDateShowLabel.text =_myOderListEntity.CREATE_TIME;
        _payDateShowLabel.text =_myOderListEntity.Time;
        _nameLabel.text =_myAddressEntity.NAME;
        _phoneLabel.text =_myAddressEntity.PHONE;
        _addressLabel.text =_myAddressEntity.ADDRESS;
    }
    
    if ([_myOderListEntity.STATE integerValue]==1) {
//        _stateLabel.text =@"待付款";
        _payBtn.hidden =NO;
        _cancelBtn.hidden =NO;
        
    }else if([_myOderListEntity.STATE integerValue]==2){
//        _stateLabel.text =@"已付款";
        
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;
        
    }else if([_myOderListEntity.STATE integerValue]==16){
//        _stateLabel.text =@"已完成";
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;
        
    }else if([_myOderListEntity.STATE integerValue]==32){
//        _stateLabel.text =@"已取消";
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;
        
    }
    _payDateShowLabel.width = kJMWidth(_payDateShowLabel);
    [_payDateShowLabel  updateLayout];
    [_scrollView updateLayout];

}

- (void)setMyOderListEntity:(MHealthServiceOderListEntity *)myOderListEntity{
    _myOderListEntity =myOderListEntity;
    _totalPriceLabel.text =[NSString stringWithFormat:@"¥%@",myOderListEntity.TOTAL_PRICE];
    _payPriceShowLabel.text =[NSString stringWithFormat:@"¥%@",myOderListEntity.PAY_PRICE];
//    _payDateShowLabel.text =myOderListEntity.CREATE_TIME;
    _payDateShowLabel.text = myOderListEntity.Time;
    [_scrollView updateLayout];
}

- (void)setMyDetailEntity:(MHSOderDetailEntity *)myDetailEntity{
    _myDetailEntity =myDetailEntity;
    _serviceNameLabel.text =myDetailEntity.NAME;
    [_mainIV sd_setImageWithURL:[NSURL URLWithString:myDetailEntity.MAIN_PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [_scrollView updateLayout];

}

- (void)setMyAddressEntity:(MHSOderAddressEntity *)myAddressEntity{
    _myAddressEntity =myAddressEntity;
    
    _nameLabel.text =myAddressEntity.NAME;
    _phoneLabel.text =myAddressEntity.PHONE;
    _addressLabel.text =myAddressEntity.ADDRESS;
    [_scrollView updateLayout];
}

- (void)payAction:(UIButton *)btn{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
    sheet.tag = 1000;
    [sheet showInView:self.view];
}

- (void)cancelAction:(UIButton *)btn{
    [ProgressUtil show];

    [_presenter cancelOderWithOderID:_myOderListEntity.ID];
}

- (void)cancelOderComplete:(BOOL) success message:(NSString* _Nullable) info{
    if (success) {
        [ProgressUtil showSuccess:info];
        [self.navigationController pushViewController:[MHealthServiceOderViewController new] animated:YES];

    }else{
        [ProgressUtil showError:info];
        [self.navigationController pushViewController:[MHealthServiceOderViewController new] animated:YES];

    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        NSLog(@"支付宝");
        
        WS(ws);
        NSString *title =[NSString stringWithFormat:@"掌上儿保-%@",_serviceNameLabel.text];
        CGFloat price=[_myOderListEntity.PAY_PRICE floatValue];
        
        [AliPayUtil payWithTitle:title withDetail:@"详情" withOrderNum:_myOderListEntity.ORDER_NO withPrice:price healthServiceCallback:^(NSDictionary*dict){
            //支付成功调用，订单支付成功接口，并且调用插入咨询表的接口
            NSString* payStatus = dict[@"resultStatus"];
            if([payStatus isEqualToString:@"9000"]){
                NSLog(@"支付成功");
                [ProgressUtil showSuccess:@"支付成功"];
                
                
            }else if([payStatus isEqualToString:@"6001"]){
                NSLog(@"用户中途取消支付");
                
                [ProgressUtil showInfo:@"用户取消支付"];
            }else if([payStatus isEqualToString:@"6002"]){
                
                NSLog(@"网络连接出错");
                [ProgressUtil showInfo:@"网络连接出错"];
            }else if([payStatus isEqualToString:@"4000"]){
                
                NSLog(@"订单支付失败");
                [ProgressUtil showInfo:@"订单支付失败"];
            }else{
                
                NSLog(@"正在处理中");
            }
            [ProgressUtil show];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
            

        }];
        
        
    
    
        
        
    }else if(buttonIndex ==1){
        NSLog(@"微信");
    
        [ProgressUtil show];
        [_presenter getWxPayParamsWithOderID:_myOderListEntity.ID];
        
    }else if(buttonIndex ==2){
        NSLog(@"取消");
        
    }
}

-(void)timerFire:(id)userinfo {
    [_timer invalidate];
    
    [ProgressUtil dismiss];

    [self.navigationController pushViewController:[MHealthServiceOderViewController new] animated:YES];
}

- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString* _Nullable) message Url:(NSString * _Nullable)url{
    if (success) {
        [ProgressUtil showSuccess:@"支付成功"];
        [ProgressUtil show];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    }else{
        [ProgressUtil showInfo:message];

        [ProgressUtil show];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
