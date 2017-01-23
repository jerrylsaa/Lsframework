//
//  OnlineApplyCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "OnlineApplyCell.h"
#import "TQStarRatingView.h"


@interface OnlineApplyCell (){
    UIView* _container;
    UILabel* _time;
    UILabel* _patitent;
    UILabel* _state;//状态
    UIView* _line;
    UILabel* _unit;//单位，例如：100元/10次

    
    UIImageView* _headImageView;
    UIImageView* _icon;
    UILabel* _postLabel;
    TQStarRatingView* _start;
    UILabel* _nameLabel;
    UILabel* _departLabel;
    UILabel* _fieldLabel;
    UILabel* _patientLabel;
    UILabel* _followLabel;
    
    UIView* _payContainer;
    UIButton* _paybt;
    UILabel* _consultation;
    
    UIView* _bottombgView;

    
}

@end

@implementation OnlineApplyCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _container = [UIView new];
    [self.contentView addSubview:_container];
    //申请时间
    _time = [UILabel new];
    _time.font = [UIFont systemFontOfSize:12];
    _time.textColor = UIColorFromRGB(0x535353);
    [_container addSubview:_time];
    //患者
    _patitent = [UILabel new];
    _patitent.font = _time.font;
    _patitent.textColor = _time.textColor;
    [_container addSubview:_patitent];
    //状态
    _state = [UILabel new];
    _state.backgroundColor = UIColorFromRGB(0xbbbbbb);
    _state.font = _time.font;
    _state.textColor = UIColorFromRGB(0xffffff);
    _state.textAlignment = NSTextAlignmentRight;
    [_container addSubview:_state];
    //分割线
    _line = [UIView new];
    _line.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [_container addSubview:_line];
    
    //单位
    _unit = [UILabel new];
    _unit.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _unit.font = _time.font;
    _unit.textColor = UIColorFromRGB(0x535353);
    _unit.textAlignment = NSTextAlignmentRight;
    [_container addSubview:_unit];
    _unit.hidden = YES;

    
    //头像
    _headImageView = [UIImageView new];
    _headImageView.userInteractionEnabled = YES;
    [_container addSubview:_headImageView];
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.image=[UIImage imageNamed:@"doctor_flower"];
    [_container addSubview:_icon];
    //职称
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
    _postLabel.font = [UIFont systemFontOfSize:10];
    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_container addSubview:_postLabel];
    //星级
    _start=[TQStarRatingView new];
    _start.userInteractionEnabled = NO;
    [_container addSubview:_start];
    //姓名
    _nameLabel=[UILabel new];
    _nameLabel.textColor = UIColorFromRGB(0x535353);
    _nameLabel.font=[UIFont systemFontOfSize:18];
    [_container addSubview:_nameLabel];
    //科室
    _departLabel=[UILabel new];
    _departLabel.font=[UIFont systemFontOfSize:14];
    _departLabel.textColor=UIColorFromRGB(0x999999);
    [_container addSubview:_departLabel];
    //领域
    _fieldLabel=[UILabel new];
    _fieldLabel.font=[UIFont systemFontOfSize:14];
    _fieldLabel.textColor=UIColorFromRGB(0x999999);
    [_container addSubview:_fieldLabel];
    //患者
    _patientLabel=[UILabel new];
    _patientLabel.font=[UIFont systemFontOfSize:14];
    _patientLabel.textColor = UIColorFromRGB(0x999999);
    [_container addSubview:_patientLabel];
    //随访
    _followLabel=[UILabel new];
    _followLabel.font=[UIFont systemFontOfSize:14];
    _followLabel.textColor=UIColorFromRGB(0x999999);
    [_container addSubview:_followLabel];
    
    //支持背景
    _payContainer = [UIView new];
    [_container addSubview:_payContainer];
    
    //支付下划线
    UIView* payLine = [UIView new];
    payLine.backgroundColor = _line.backgroundColor;
    [_payContainer addSubview:payLine];
    //支付按钮
    _paybt = [UIButton new];
    [_paybt setBackgroundColor:UIColorFromRGB(0xff8887)];
    [_paybt setTitle:@"立即支付" forState:UIControlStateNormal];
    [_paybt addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [_payContainer addSubview:_paybt];
    //
    _consultation=[UILabel new];
    _consultation.textColor = _nameLabel.textColor;
    _consultation.font= _nameLabel.font;
    [_payContainer addSubview:_consultation];
    
    //背景
    _bottombgView = [UIView new];
    _bottombgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_container addSubview:_bottombgView];
    
    
    
    
    //添加约束
    _time.sd_layout.topSpaceToView(_container,10).autoHeightRatio(0).leftSpaceToView(_container,25);
    [_time setSingleLineAutoResizeWithMaxWidth:300];
    _patitent.sd_layout.topSpaceToView(_time,5).autoHeightRatio(0).leftEqualToView(_time).widthIs(250);
    _state.sd_layout.topSpaceToView(_container,0).heightIs(20).rightSpaceToView(_container,0);
    [_state setSingleLineAutoResizeWithMaxWidth:150];
    _line.sd_layout.topSpaceToView(_patitent,5).leftSpaceToView(_container,0).rightSpaceToView(_container,0).heightIs(1);
    _unit.sd_layout.topSpaceToView(_line,0).heightIs(20).rightSpaceToView(_container,0);

    _headImageView.sd_layout.leftSpaceToView(_container,20).topSpaceToView(_line,15).widthIs(80).heightEqualToWidth();
    _icon.sd_layout.leftSpaceToView(_container,20).topSpaceToView(_line,15).widthIs(80).heightEqualToWidth();
    
    _postLabel.sd_layout.centerYEqualToView(_headImageView).leftSpaceToView(_headImageView,-15/2.0).widthIs(15).autoHeightRatio(0);
    _postLabel.sd_cornerRadiusFromWidthRatio = @0.5;
    _start.sd_layout.topSpaceToView(_headImageView,5).heightIs(10).leftEqualToView(_headImageView).widthIs(75);
    
    _nameLabel.sd_layout.topSpaceToView(_line,25).autoHeightRatio(0).leftSpaceToView(_postLabel,15).rightSpaceToView(_container,0);
    _departLabel.sd_layout.topSpaceToView(_nameLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15).rightEqualToView(_nameLabel);
    _fieldLabel.sd_layout.topSpaceToView(_departLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15).rightEqualToView(_nameLabel);
    
    _patientLabel.sd_layout.topSpaceToView(_fieldLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_patientLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _followLabel.sd_layout.topEqualToView(_patientLabel).autoHeightRatio(0).leftSpaceToView(_patientLabel,15).rightSpaceToView(_container,15);
    
    
    payLine.sd_layout.topSpaceToView(_payContainer,0).leftSpaceToView(_payContainer,0).rightSpaceToView(_payContainer,0).heightIs(1);
    _paybt.sd_layout.topSpaceToView(payLine,0).heightIs(50).rightSpaceToView(_payContainer,0).widthIs(100);
    _consultation.sd_layout.centerYEqualToView(_paybt).autoHeightRatio(0).leftSpaceToView(_payContainer,20);
    [_consultation setSingleLineAutoResizeWithMaxWidth:300];
    
    _payContainer.sd_layout.topSpaceToView(_followLabel,5).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
    [_payContainer setupAutoHeightWithBottomViewsArray:@[_paybt,_consultation] bottomMargin:0];
    

}

- (void)setDoctor:(MineApplyFamilyDoctorEntity *)doctor{
    //申请时间
    NSDate* applyTime = doctor.applyTime;
    NSString* applyStr = [applyTime format2String:@"yyyy/MM/dd HH:mm"];
    NSString* timeStr = [NSString stringWithFormat:@"申请时间：%@", applyStr];
    if(timeStr.length ==0){
        timeStr = @"申请时间：";
    }
    _time.text = timeStr;
    [_time updateLayout];
    
    //患者
    NSString* patientStr = [NSString stringWithFormat:@"患者：%@",doctor.babyName];
    if(patientStr.length ==0 ){
        patientStr = @"患者：";
    }
    _patitent.text = patientStr;
    
    //头像
    _headImageView.image=[UIImage imageNamed:@"doctor_icon"];
    
    //职称
    if(doctor.duties.length ==0){
        _postLabel.hidden = YES;
    }else{
        _postLabel.hidden = NO;
        
        NSString* postStr = doctor.duties;
        _postLabel.text = postStr;
        
    }
    
    //姓名
    NSString* nameStr = [NSString stringWithFormat:@"姓名：%@",doctor.doctorName];
    if(nameStr.length == 0){
        nameStr = @"姓名：";
    }
    _nameLabel.text = nameStr;
    
    //科室
    NSString* departStr = [NSString stringWithFormat:@"科室：%@",doctor.departName];
    _departLabel.text = departStr;
    
    //领域
    NSString* fieldStr = [NSString stringWithFormat:@"领域：%@",doctor.field];
    if(fieldStr.length == 0){
        fieldStr = @"领域：";
    }
    _fieldLabel.text = fieldStr;
    
//    if(![doctor.orderState intValue]){
//        //展示字符按钮
//        [_payContainer setHidden:NO];
//        _bottombgView.sd_layout.topSpaceToView(_payContainer,0).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
//    }else{
//        //隐藏
//        [_payContainer setHidden:YES];
//        _bottombgView.sd_layout.topSpaceToView(_patientLabel,5).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
//    }
    
    [_payContainer setHidden:YES];
    _bottombgView.sd_layout.topSpaceToView(_patientLabel,5).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);

    
    _container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    [_container setupAutoHeightWithBottomView:_bottombgView bottomMargin:10];
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    
    if([doctor.orderState intValue] == 0){
        //待支付
        _state.text = @"待支付";
        _state.backgroundColor = RGB(95, 204, 196);
        
    }else if([doctor.orderState intValue] == 1){
        //待沟通
        _state.text = @"待沟通";
        _state.backgroundColor = RGB(95, 204, 196);
    }else if([doctor.orderState intValue] == 2){
        //正在沟通
        _state.text = @"正在沟通";
        _state.backgroundColor = RGB(85, 176, 215);
        
    }else if([doctor.orderState intValue] == 3){
        //以沟通
        
    }else if([doctor.orderState intValue] == 4){
        //分诊未通过
        _state.text = @"分诊未通过";
        _state.backgroundColor =  UIColorFromRGB(0xbbbbbb);
        
    }
    
    //套餐价格
    NSString* price = [NSString stringWithFormat:@"付费咨询：%@",doctor.chargeStandard];
    if(doctor.chargeStandard == 0){
        price = @"付费咨询：";
    }
    _consultation.text = price;
    [_consultation updateLayout];
    
    //星级
    [_start setScore:doctor.starNum/10.0f withAnimation:NO];
    //患者
    NSString* patientNumStr = [NSString stringWithFormat: @"患者：%ld例",doctor.patientNum];
    _patientLabel.text = patientNumStr;
    
    //随访
    NSString* follow = [NSString stringWithFormat:@"随访：%ld例",doctor.followUp];
    _followLabel.text = follow;
    
    
}

#pragma mark - 点击事件

- (void)payAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(commitPay)]){
        [self.delegate commitPay];
    }
}



@end
