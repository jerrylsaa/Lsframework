//
//  HealthServiceProductDetailViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthServiceProductDetailViewController.h"
#import "HSTextView.h"
#import "HHealthServicePresenter.h"
#import "MHSOderDetailViewController.h"

@interface HealthServiceProductDetailViewController ()<HHealthServicePresenterDelegate>
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView *mainIV;
@property (nonatomic,retain) UILabel *serviceNameLabel;
@property (nonatomic,retain) NSMutableArray *attLabelArr;


@property (nonatomic,retain) UILabel *serviceContentLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UIImageView *secondLine;
@property (nonatomic,retain) UIImageView *serviceWarnIV;
@property (nonatomic,retain) UIButton *commitBtn;
@property (nonatomic,assign) CGFloat imgHeight;
@property (nonatomic,assign) CGFloat imgWidth;

@property (nonatomic,retain) HSTextView *nameTV;
@property (nonatomic,retain) HSTextView *phoneTV;
@property (nonatomic,retain) HSTextView *emailTV;

@property (nonatomic,retain) HSTextView *addressTV;
@property (nonatomic,strong) HHealthServicePresenter *presenter;
@end

@implementation HealthServiceProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
}

- (void)setupView{
    self.title =@"套餐详情";
    
    _presenter =[HHealthServicePresenter new];
    _presenter.delegate =self;
    
    _scrollView =[UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
//    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);


    _mainIV =[UIImageView new];
    [_mainIV sd_setImageWithURL:[NSURL URLWithString:_serviceData.MAIN_PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [_scrollView addSubview:_mainIV];
    _mainIV.sd_layout.topSpaceToView(_scrollView,15).leftSpaceToView(_scrollView,15).widthIs(100).heightIs(80);
    
    _serviceNameLabel =[UILabel new];
    _serviceNameLabel.text =_serviceData.NAME;
    _serviceNameLabel.textColor =UIColorFromRGB(0x333333);
    _serviceNameLabel.font =[UIFont systemFontOfSize:16];
    [_scrollView addSubview:_serviceNameLabel];
    _serviceNameLabel.sd_layout.topSpaceToView(_scrollView,20).leftSpaceToView(_mainIV,15).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    
    _attLabelArr =[NSMutableArray array];
    

    for (int i=0; i<_attributesDataSource.count; i++) {
        HealthServiceDetailAttributes *att =_attributesDataSource[i];
        UILabel *attLabel =[UILabel new];
        attLabel.numberOfLines =0;
        NSString *str =[NSString stringWithFormat:@"%@：%@",att.NAME,att.VALUE];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range1=[str rangeOfString:[NSString stringWithFormat:@"%@",att.NAME]];
        NSRange range2=[str rangeOfString:[NSString stringWithFormat:@"：%@",att.VALUE]];

        [attributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:13.0]
         
                              range:range1];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0]
         
                              range:range1];
        
        [attributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:13.0]
         
                              range:range2];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithRed:0.3871 green:0.3871 blue:0.3871 alpha:1.0]
         
                              range:range2];
        
        
        
        attLabel.attributedText =attributedStr;
        

        [_scrollView addSubview:attLabel];
        [_attLabelArr addObject:attLabel];
        
        
        
        if (i==0) {
            attLabel.sd_layout.leftEqualToView(_serviceNameLabel).topSpaceToView(_serviceNameLabel,20).rightEqualToView(_serviceNameLabel).autoHeightRatio(0);
        }else{
            UILabel *lastAttLabe =_attLabelArr[i-1];
            attLabel.sd_layout.leftEqualToView(_serviceNameLabel).topSpaceToView(lastAttLabe,10).rightEqualToView(_serviceNameLabel).autoHeightRatio(0);
        }
    }
    
    UIImageView *firstLine =[UIImageView new];
    firstLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:firstLine];
    
    UILabel *lastAttLabe =[_attLabelArr lastObject];
    if (CGRectGetMaxY(_mainIV.frame)>=CGRectGetMaxY(lastAttLabe.frame)) {
        firstLine.sd_layout.topSpaceToView(_mainIV,25).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(1);
    }else{
        firstLine.sd_layout.topSpaceToView(lastAttLabe,25).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(1);
    }
    
    _serviceContentLabel =[UILabel new];
    _serviceContentLabel.text =_serviceData.DESCRIPTION;
    _serviceContentLabel.textColor =UIColorFromRGB(0x333333);
    _serviceContentLabel.numberOfLines =0;
    _serviceContentLabel.font =[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_serviceContentLabel];
    _serviceContentLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(firstLine,15).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    
    _priceLabel =[UILabel new];
    _priceLabel.text =[NSString stringWithFormat:@"¥%ld",[_serviceData.PRICE longValue]];
    _priceLabel.textColor =UIColorFromRGB(0x61d8d3);
    _priceLabel.font =[UIFont systemFontOfSize:18];
    [_scrollView addSubview:_priceLabel];
    _priceLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_serviceContentLabel,15).rightSpaceToView(_scrollView,15).heightIs(15);
    
    _secondLine =[UIImageView new];
    _secondLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_secondLine];
    _secondLine.sd_layout.topSpaceToView(_priceLabel,15).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).heightIs(5);
    
    
    _serviceWarnIV =[UIImageView new];
    [_scrollView addSubview:_serviceWarnIV];
    [ProgressUtil show];
    [_serviceWarnIV sd_setImageWithURL:[NSURL URLWithString:_serviceData.DES_PIC]  placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _serviceWarnIV.image =image;
        [[SDImageCache sharedImageCache] removeImageForKey:_serviceData.DES_PIC];
        CGFloat heights =(image.size.height/image.size.width)*(kScreenWidth-30.0f);
        NSLog(@"高度%f",heights);
        self.imgWidth =image.size.width;
        if (_imgWidth<(kScreenWidth-30.0f)) {
            self.imgHeight =image.size.height;
        }else{
            self.imgHeight =heights;
        }
    }];
    
    CGFloat height =(616.0f/647.0f)*(kScreenWidth-30.0f);
    _serviceWarnIV.sd_layout.topSpaceToView(_secondLine,15).leftSpaceToView(_scrollView,15).heightIs(height).widthIs(kScreenWidth-30.0f);
    
    _commitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"code_nor"] forState:UIControlStateNormal];
    [_commitBtn setTitle:@"购买服务" forState:UIControlStateNormal];
    _commitBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [_commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitBtn];
    
    _commitBtn.sd_layout.topSpaceToView(_serviceWarnIV,50).centerXEqualToView(_scrollView).heightIs(40).widthIs(260);
    [_scrollView setupAutoHeightWithBottomView:_commitBtn bottomMargin:25];
//    [_scrollView setupAutoContentSizeWithBottomView:_commitBtn bottomMargin:25];
    
}

- (void)commitAction:(UIButton *)btn {
    NSNumber *num =_stocksDataSource[0].AMOUNT;
    NSLog(@"%@",num);
    if ([_stocksDataSource[0].AMOUNT integerValue]<=0) {
        [ProgressUtil showInfo:@"该服务已售罄"];
        return;
    }
#pragma 打点统计*首页--健康服务-->购买服务

    [BasePresenter  EventStatisticalDotTitle:DotHealthTeachPay Action:DotEventEnter  Remark:nil];

    _nameTV = [HSTextView new];
    _nameTV.textView.textColor =UIColorFromRGB(0x333333);
    _nameTV.backgroundColor = [UIColor whiteColor];
    _nameTV.textView.font = [UIFont systemFontOfSize:15];
    _nameTV.layer.masksToBounds = YES;
    _nameTV.layer.cornerRadius = 5;
    _nameTV.layer.borderWidth = 1;
    _nameTV.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    
    NSString *str =@"*姓名：";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[str rangeOfString:@"*"];
    NSRange range2=[str rangeOfString:@"姓名："];
    
    [attributedStr addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range1];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
     
                           value:[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0]
     
                           range:range1];
    
    [attributedStr addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range2];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
     
                           value:UIColorFromRGB(0x666666)
     
                           range:range2];
    
    _nameTV.attPlaceholderStr =attributedStr;
    
    _nameTV.attPlaceholderStr =attributedStr;
    [_scrollView addSubview:_nameTV];
    
    
    _phoneTV = [HSTextView new];
    _phoneTV.textView.textColor =UIColorFromRGB(0x333333);
    _phoneTV.backgroundColor = [UIColor whiteColor];
    _phoneTV.textView.font = [UIFont systemFontOfSize:15];
    _phoneTV.layer.masksToBounds = YES;
    _phoneTV.layer.cornerRadius = 5;
    _phoneTV.layer.borderWidth = 1;
    _phoneTV.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    
    NSString *str2 =@"*电话：";
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
    NSRange range11=[str2 rangeOfString:@"*"];
    NSRange range22=[str2 rangeOfString:@"电话："];
    
    [attributedStr2 addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:15.0]
     
                          range:range11];
    
    [attributedStr2 addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0]
     
                          range:range11];
    
    [attributedStr2 addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:15.0]
     
                          range:range22];
    
    [attributedStr2 addAttribute:NSForegroundColorAttributeName
     
                          value:UIColorFromRGB(0x666666)
     
                          range:range22];
    
    _phoneTV.attPlaceholderStr =attributedStr2;
    [_scrollView addSubview:_phoneTV];
    
    _emailTV = [HSTextView new];
    _emailTV.textView.textColor =UIColorFromRGB(0x333333);
    _emailTV.backgroundColor = [UIColor whiteColor];
    _emailTV.textView.font = [UIFont systemFontOfSize:15];
    _emailTV.layer.masksToBounds = YES;
    _emailTV.layer.cornerRadius = 5;
    _emailTV.layer.borderWidth = 1;
    _emailTV.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    
    NSString *str4 =@"*Email：";
    NSMutableAttributedString *attributedStr4 = [[NSMutableAttributedString alloc]initWithString:str4];
    NSRange range1111=[str4 rangeOfString:@"*"];
    NSRange range2222=[str4 rangeOfString:@"Email："];
    
    [attributedStr4 addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range1111];
    
    [attributedStr4 addAttribute:NSForegroundColorAttributeName
     
                           value:[UIColor colorWithRed:0.3258 green:0.3258 blue:0.3258 alpha:1.0]
     
                           range:range1111];
    
    [attributedStr4 addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range2222];
    
    [attributedStr4 addAttribute:NSForegroundColorAttributeName
     
                           value:UIColorFromRGB(0x666666)
     
                           range:range2222];
    
    _emailTV.attPlaceholderStr =attributedStr4;
    [_scrollView addSubview:_emailTV];
    
    
    _addressTV = [HSTextView new];
    _addressTV.textView.textColor =UIColorFromRGB(0x333333);
    _addressTV.backgroundColor = [UIColor whiteColor];
    _addressTV.textView.font = [UIFont systemFontOfSize:15];
    _addressTV.layer.masksToBounds = YES;
    _addressTV.layer.cornerRadius = 5;
    _addressTV.layer.borderWidth = 1;
    _addressTV.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    
    NSString *str3 =@"*地址：";
    NSMutableAttributedString *attributedStr3 = [[NSMutableAttributedString alloc]initWithString:str3];
    NSRange range111=[str3 rangeOfString:@"*"];
    NSRange range222=[str3 rangeOfString:@"地址："];
    
    [attributedStr3 addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range111];
    
    [attributedStr3 addAttribute:NSForegroundColorAttributeName
     
                           value:[UIColor colorWithRed:0.3272 green:0.8197 blue:0.7875 alpha:1.0]
     
                           range:range111];
    
    [attributedStr3 addAttribute:NSFontAttributeName
     
                           value:[UIFont systemFontOfSize:15.0]
     
                           range:range222];
    
    [attributedStr3 addAttribute:NSForegroundColorAttributeName
     
                           value:UIColorFromRGB(0x666666)
     
                           range:range222];
    
    _addressTV.attPlaceholderStr =attributedStr3;
    [_scrollView addSubview:_addressTV];
    
    [_commitBtn sd_clearAutoLayoutSettings];
    [_commitBtn removeFromSuperview];
    
    UIButton *submitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"code_nor"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
    
    _nameTV.sd_layout.topSpaceToView(_serviceWarnIV,25).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(40);
    _phoneTV.sd_layout.topSpaceToView(_nameTV,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(40);
    _emailTV.sd_layout.topSpaceToView(_phoneTV,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(40);
    _addressTV.sd_layout.topSpaceToView(_emailTV,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(200);
    submitBtn.sd_layout.topSpaceToView(_addressTV,50).centerXEqualToView(_scrollView).heightIs(40).widthIs(260);


    
    [_scrollView setupAutoHeightWithBottomView:submitBtn bottomMargin:25];
    [_scrollView updateLayout];
    
    [ProgressUtil show];
    [_presenter loadMyUserInfo];
}

- (void)onLoadMyUserInfoComplete:(BOOL) success message:(NSString* _Nullable) info{
    if (success) {
        _nameTV.textView.text =_presenter.myUserInfoAddress.NAME;
        _phoneTV.textView.text =_presenter.myUserInfoAddress.PHONE;
        _emailTV.textView.text =_presenter.myUserInfoAddress.EMAIL;
        _addressTV.textView.text =_presenter.myUserInfoAddress.ADDRESS;
        [ProgressUtil dismiss];
    }else{
        //ADDRESS为空
        if (_presenter.myUserInfoAddress.ADDRESS==nil) {
             [ProgressUtil dismiss];
        }
//
    }
}


- (void)submitAction:(UIButton *)btn{
    if (_nameTV.textView.text==nil||_nameTV.textView.text.length==0||[_nameTV.textView.text isEqualToString:@""]) {
        [ProgressUtil showError:@"请填写姓名"];
        return;
    }
    if (_phoneTV.textView.text==nil||_phoneTV.textView.text.length==0||[_phoneTV.textView.text isEqualToString:@""]) {
        [ProgressUtil showError:@"请填写电话"];
        return;
    }
    if (_addressTV.textView.text==nil||_addressTV.textView.text.length==0||[_addressTV.textView.text isEqualToString:@""]) {
        [ProgressUtil showError:@"请填写地址"];
        return;
    }
    
    
    if (_emailTV.textView.text ==nil) {
        [_presenter createGoodsOrderWithName:_nameTV.textView.text Phone:_phoneTV.textView.text Address:_addressTV.textView.text Email:nil StocksID:_stocksDataSource[0].ID StocksNum:@(1)];
    }else{
        [_presenter createGoodsOrderWithName:_nameTV.textView.text Phone:_phoneTV.textView.text Address:_addressTV.textView.text Email:_emailTV.textView.text StocksID:_stocksDataSource[0].ID StocksNum:@(1)];
    }
    
#pragma 打点统计*首页--健康服务-->确认提交
    [BasePresenter  EventStatisticalDotTitle:DotHealthTeachCommit Action:DotEventEnter  Remark:nil];

    
}

- (void)setImgHeight:(CGFloat)imgHeight{
    _imgHeight =imgHeight;
    NSLog(@"%f",imgHeight);
    [_serviceWarnIV sd_clearAutoLayoutSettings];
    if (_imgWidth<(kScreenWidth-30.0f)) {
        _serviceWarnIV.size =CGSizeMake(_imgWidth, imgHeight);

        _serviceWarnIV.sd_layout.topSpaceToView(_secondLine,15).centerXEqualToView(_scrollView).heightIs(imgHeight).widthIs(_imgWidth);
    }else {
        _serviceWarnIV.size =CGSizeMake(kScreenWidth-30.0f, imgHeight);

        _serviceWarnIV.sd_layout.topSpaceToView(_secondLine,15).leftSpaceToView(_scrollView,15).heightIs(imgHeight).widthIs(kScreenWidth-30.0f);

    }
    [_serviceWarnIV updateLayout];
    [_scrollView setupAutoHeightWithBottomView:_commitBtn bottomMargin:25];
    [_scrollView updateLayout];
    [ProgressUtil dismiss];
}

- (void)createHealthServiceOderComplete:(BOOL) success message:(NSString* _Nullable) info{
    if (success) {
        [ProgressUtil showSuccess:@"订单提交成功"];
        MHSOderDetailViewController *vc=[MHSOderDetailViewController new];
        vc.myOderListEntity =_presenter.oderDetailDataSource;
        vc.myAddressEntity =_presenter.oderAddressDataSource;
        vc.mainIVUrl =_serviceData.MAIN_PIC;
        vc.serviceName =_serviceData.NAME;
        [self.navigationController pushViewController:vc animated:YES];
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
