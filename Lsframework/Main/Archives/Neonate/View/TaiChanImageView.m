//
//  TaiChanImageView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TaiChanImageView.h"

NSString* const leftstr=@"第";
NSString* const rightstr1=@"胎";
NSString* const rightstr2=@"产";

@interface TaiChanImageView ()<UITextFieldDelegate>{
    UILabel* _titleLabel;

    UIView* _firtView;
    UILabel* _leftTaiLabel;
    UILabel* _rightTaiLabel;
    
    UIView* _secondView;
    UILabel* _leftChanLabel;
    UILabel* _rightChanLabel;

}

@end

@implementation TaiChanImageView

-(instancetype)init{
    self= [super init];
    if(self){
        self.userInteractionEnabled=YES;
        self.image=[UIImage imageNamed:@"input_nor"];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    //标题
    _titleLabel=[UILabel new];
    _titleLabel.font=[UIFont systemFontOfSize:17];
    _titleLabel.textColor=FileFontColor;
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.topSpaceToView(self,12).bottomSpaceToView(self,12).leftSpaceToView(self,25).widthIs(150);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    //第几胎
    _firtView = [UIView new];
    [self addSubview:_firtView];
    
    _leftTaiLabel=[UILabel new];
    _leftTaiLabel.font=[UIFont systemFontOfSize:17];
    _leftTaiLabel.textColor=FileFontColor;
    _leftTaiLabel.text = leftstr;
    [_firtView addSubview:_leftTaiLabel];
    
    _taitf=[NTextField new];
    _taitf.background=[UIImage imageNamed:@"tf"];
    _taitf.textColor=_leftTaiLabel.textColor;
    _taitf.delegate=self;
    _taitf.keyboardType = UIKeyboardTypeNumberPad;
    _taitf.textAlignment=NSTextAlignmentCenter;
    [_firtView addSubview:_taitf];
    
    _rightTaiLabel=[UILabel new];
    _rightTaiLabel.font=_leftTaiLabel.font;
    _rightTaiLabel.textColor=_leftTaiLabel.textColor;
    _rightTaiLabel.text = rightstr1;
    [_firtView addSubview:_rightTaiLabel];

    //第几产
    _secondView = [UIView new];
    [self addSubview:_secondView];
    
    _leftChanLabel=[UILabel new];
    _leftChanLabel.font=[UIFont systemFontOfSize:17];
    _leftChanLabel.textColor=FileFontColor;
    _leftChanLabel.text = leftstr;
    [_secondView addSubview:_leftChanLabel];
    
    _chantf=[NTextField new];
    _chantf.background=[UIImage imageNamed:@"tf"];
    _chantf.textColor=_leftChanLabel.textColor;
    _chantf.delegate=self;
    _chantf.keyboardType = UIKeyboardTypeNumberPad;

    _chantf.textAlignment=NSTextAlignmentCenter;
    [_secondView addSubview:_chantf];
    
    _rightChanLabel=[UILabel new];
    _rightChanLabel.font=_leftChanLabel.font;
    _rightChanLabel.text = rightstr2;
    _rightChanLabel.textColor=_leftChanLabel.textColor;
    [_secondView addSubview:_rightChanLabel];

    //添加约束
    _leftTaiLabel.sd_layout.topSpaceToView(_firtView,0).bottomSpaceToView(_firtView,0).leftSpaceToView(_firtView,0);
    [_leftTaiLabel setSingleLineAutoResizeWithMaxWidth:100];
    _taitf.sd_layout.centerYEqualToView(_leftTaiLabel).heightRatioToView(_firtView,1).leftSpaceToView(_leftTaiLabel,0).widthIs(40);
    _rightTaiLabel.sd_layout.topEqualToView(_leftTaiLabel).bottomEqualToView(_leftTaiLabel).leftSpaceToView(_taitf,0);
    [_rightTaiLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    CGFloat width =30;
    if(kScreenWidth == 320){
        width = 10;
    }
    _firtView.sd_layout.centerYEqualToView(_titleLabel).heightIs(25).leftSpaceToView(_titleLabel,width);
    [_firtView setupAutoWidthWithRightView:_rightTaiLabel rightMargin:0];

    _leftChanLabel.sd_layout.topSpaceToView(_secondView,0).bottomSpaceToView(_secondView,0).leftSpaceToView(_secondView,0);
    [_leftChanLabel setSingleLineAutoResizeWithMaxWidth:100];
    _chantf.sd_layout.centerYEqualToView(_leftChanLabel).heightRatioToView(_secondView,1).leftSpaceToView(_leftChanLabel,0).widthIs(40);
    _rightChanLabel.sd_layout.topEqualToView(_leftChanLabel).bottomEqualToView(_leftChanLabel).leftSpaceToView(_chantf,0);
    [_rightChanLabel setSingleLineAutoResizeWithMaxWidth:100];
    _secondView.sd_layout.centerYEqualToView(_titleLabel).heightIs(25).leftSpaceToView(_firtView,width);
    [_secondView setupAutoWidthWithRightView:_rightChanLabel rightMargin:0];

}

-(void)setTitle:(NSString *)title{
    _title=title;
    _titleLabel.text=title;
    [_titleLabel updateLayout];
}

#pragma mark - 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.image=[UIImage imageNamed:@"input_sel"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notice_textFieldBegin" object:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.image=[UIImage imageNamed:@"input_nor"];
}




@end
