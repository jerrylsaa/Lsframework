//
//  MAPhoneOutPatientCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAPhoneOutPatientCell.h"
#import "TQStarRatingView.h"
#import "ApiMacro.h"

@interface MAPhoneOutPatientCell (){
    UIView* _container;
    UILabel* _time;
    UILabel* _patitent;
    UILabel* _state;//状态
    UIView* _line;
    
    UIImageView* _headImageView;
    UIImageView* _icon;
    UILabel* _postLabel;
    TQStarRatingView* _start;
    UILabel* _nameLabel;
    UILabel* _hospitalLabel;
    UILabel* _departLabel;
    UILabel* _fieldLabel;

    UIView* _appointbgView;
    UIView* _appointLine;
    UILabel* _appointMode;//预约方式
}

@end

@implementation MAPhoneOutPatientCell

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
    _state.backgroundColor = RGB(85, 176, 215);
    _state.font = _time.font;
    _state.textColor = UIColorFromRGB(0xffffff);
    _state.textAlignment = NSTextAlignmentRight;
    [_container addSubview:_state];
    //分割线
    _line = [UIView new];
    _line.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [_container addSubview:_line];
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
    //医院
    _hospitalLabel=[UILabel new];
    _hospitalLabel.font= _departLabel.font;
    _hospitalLabel.textColor= _departLabel.textColor;
    [_container addSubview:_hospitalLabel];
    //领域
//    _fieldLabel=[UILabel new];
//    _fieldLabel.font=_departLabel.font;
//    _fieldLabel.textColor=_departLabel.textColor;
//    [_container addSubview:_fieldLabel];
    
//    _appointbgView = [UIView new];
//    _appointbgView.backgroundColor = UIColorFromRGB(0xffffff);
//    [_container addSubview:_appointbgView];
//    //预约方式分割线
//    _appointLine = [UIView new];
//    _appointLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
//    [_appointbgView addSubview:_appointLine];
//    //预约方式
//    _appointMode = [UILabel new];
//    _appointMode.font = _time.font;
//    _appointMode.textColor = _time.textColor;
//    [_appointbgView addSubview:_appointMode];
    
//    UIView* bottomLine = [UIView new];
//    bottomLine.backgroundColor = RGB(85, 176, 215);
//    [_container addSubview:bottomLine];
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

    _headImageView.sd_layout.leftSpaceToView(_container,20).topSpaceToView(_line,15).widthIs(80).heightEqualToWidth();
    _icon.sd_layout.leftSpaceToView(_container,20).topSpaceToView(_line,15).widthIs(80).heightEqualToWidth();
    [_headImageView updateLayout];
    _postLabel.sd_layout.centerYEqualToView(_headImageView).autoHeightRatio(0).centerXIs(_headImageView.right).widthIs(15);
    _postLabel.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _start.sd_layout.topSpaceToView(_headImageView,10).heightIs(10).leftEqualToView(_headImageView).widthIs(75);
    _nameLabel.sd_layout.topSpaceToView(_line,25).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _hospitalLabel.sd_layout.topSpaceToView(_nameLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_hospitalLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

    _departLabel.sd_layout.topSpaceToView(_hospitalLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_departLabel setSingleLineAutoResizeWithMaxWidth:200];

//    _fieldLabel.sd_layout.topSpaceToView(_departLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
//    [_fieldLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

    //预约
//    _appointbgView.sd_layout.topSpaceToView(_fieldLabel,5).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
//    _appointLine.sd_layout.topSpaceToView(_appointbgView,0).heightIs(1).rightSpaceToView(_appointbgView,0).leftSpaceToView(_appointbgView,0);
//    _appointMode.sd_layout.topSpaceToView(_appointLine,5).leftSpaceToView(_appointbgView,25).autoHeightRatio(0).rightSpaceToView(_appointbgView,10);
//    [_appointbgView setupAutoHeightWithBottomView:_appointMode bottomMargin:5];
    
//    bottomLine.sd_layout.leftSpaceToView(_container,0).rightSpaceToView(_container,0).topSpaceToView(_departLabel,15).heightIs(1);
//    bottombgView.sd_layout.topSpaceToView(bottomLine,0).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
    
    bottombgView.sd_layout.topSpaceToView(_departLabel,15).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);

    
    _container.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    [_container setupAutoHeightWithBottomView:bottombgView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];

}




-(void)setDoctor:(AppointDoctor *)doctor{
    _doctor = doctor;
    
    NSString* dateStr = [NSString stringWithFormat:@"%@%@",doctor.appointmentDate,doctor.appointmentTime];
    NSDate* tempDate = [NSDate format2DateWithStyle:@"yyyy-MM-ddHH:mm" withDateString:dateStr];
    
    NSString* timeStr = [tempDate format2String:@"yyyy/MM/dd/hh:MM"];
    _time.text = [NSString stringWithFormat:@"预约时间：%@",timeStr];
    [_time updateLayout];
    
    //患者
    _patitent.text = [NSString stringWithFormat:@"患者：%@",doctor.childName];
    
    //状态
//    NSString* stateStr = @"电话咨询";//mock数据
//    _state.text = stateStr;
    
    //头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,doctor.userImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    
    //职称
    _postLabel.text = [NSString stringWithFormat:@"%@",doctor.doctorTitle];
    //星级
    [_start setScore:doctor.starNum/10.f withAnimation:NO];
    //姓名
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",doctor.doctorName];
    //科室
    _departLabel.text = [NSString stringWithFormat:@"科室：%@",doctor.departName];
    //医院
    _hospitalLabel.text = [NSString stringWithFormat:@"医院：%@",doctor.hospitalName];
    //领域
    _fieldLabel.text = [NSString stringWithFormat:@"领域：%@",doctor.field];

    NSString* mode = nil;
    if(doctor.bespeakMode == 0){
    //暂定，你去找医生
        mode = [NSString stringWithFormat:@"你找医生：%@",doctor.bespeakAddress];
    }else if(doctor.bespeakMode == 1){
    //医生找你
        mode = [NSString stringWithFormat:@"医生找你：%@",doctor.bespeakAddress];
    }
    _appointMode.text = mode;
    
}

@end
