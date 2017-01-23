//
//  MAStopCarCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAStopCarCell.h"


@interface MAStopCarCell (){
    UIView* _container;
    UILabel* _time;
    UILabel* _patitent;
    UILabel* _state;//状态
    UIView* _line;
    
    UILabel* _hospital;
    UILabel* _phone;
    
}

@end

@implementation MAStopCarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
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
    _state.backgroundColor = RGB(247, 114, 118);
    _state.font = _time.font;
    _state.textColor = UIColorFromRGB(0xffffff);
    _state.textAlignment = NSTextAlignmentRight;
    [_container addSubview:_state];
    //分割线
    _line = [UIView new];
    _line.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [_container addSubview:_line];
    //医院
    _hospital = [UILabel new];
    _hospital.font = [UIFont systemFontOfSize:14];
    _hospital.textColor = UIColorFromRGB(0x999999);
    [_container addSubview:_hospital];
    //联系电话
    _phone = [UILabel new];
    _phone.font = _hospital.font;
    _phone.textColor = _hospital.textColor;
    [_container addSubview:_phone];
    //
    //背景
    UIView* bottombgView = [UIView new];
    bottombgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_container addSubview:bottombgView];


    //添加约束
    _time.sd_layout.topSpaceToView(_container,10).autoHeightRatio(0).leftSpaceToView(_container,25);
    [_time setSingleLineAutoResizeWithMaxWidth:300];

    _patitent.sd_layout.topSpaceToView(_time,5).autoHeightRatio(0).leftEqualToView(_time).widthIs(250);
    _state.sd_layout.topSpaceToView(_container,0).heightIs(20).rightSpaceToView(_container,0);
    [_state setSingleLineAutoResizeWithMaxWidth:150];

    _line.sd_layout.topSpaceToView(_patitent,5).leftSpaceToView(_container,0).rightSpaceToView(_container,0).heightIs(1);
    _hospital.sd_layout.topSpaceToView(_line,5).leftEqualToView(_time).rightSpaceToView(_container,0).autoHeightRatio(0);
    _phone.sd_layout.topSpaceToView(_hospital,5).leftEqualToView(_hospital).rightSpaceToView(_container,0).autoHeightRatio(0);
    bottombgView.sd_layout.topSpaceToView(_phone,5).heightIs(10).leftEqualToView(_container).rightEqualToView(_container);

    
    
    _container.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    [_container setupAutoHeightWithBottomView:bottombgView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];

    
    
    
}

-(void)setDoctor:(DoctorList *)doctor{
    _doctor = doctor;
    
    NSString* timeStr = @"申请时间：2016/02/11 09:00";
    _time.text = timeStr;
    [_time updateLayout];
    //患者
    NSString* patientStr = @"患者：张珊珊";
    _patitent.text = patientStr;
    //转态
    NSString* stateStr = @"泊车服务";
    _state.text = stateStr;

    //医院
    NSString* hospitalStr = @"医院：济南市儿童医院";
    _hospital.text = hospitalStr;
    
    //手机号
    NSString* phoneStr = @"联系电话：1388888888";
    _phone.text = phoneStr;
}


@end
