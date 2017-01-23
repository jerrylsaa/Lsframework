//
//  MAFaceConsultation.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAFaceConsultationCell.h"
#import "TQStarRatingView.h"

@interface MAFaceConsultationCell (){
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
    
    UILabel* _findLabel;
}

@end

@implementation MAFaceConsultationCell

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
    _headImageView.image=[UIImage imageNamed:@"doctor_icon"];
    [_container addSubview:_headImageView];
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.image=[UIImage imageNamed:@"doctor_flower"];
    [_container addSubview:_icon];
    //职称
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    //    _postLabel.numberOfLines = 0;
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
    //    _postLabel.clipsToBounds = YES;
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
    _fieldLabel=[UILabel new];
    _fieldLabel.font=_departLabel.font;
    _fieldLabel.textColor=_departLabel.textColor;
    [_container addSubview:_fieldLabel];
    
    UIView* bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [_container addSubview:bottomLine];
    
    _findLabel = [UILabel new];
    _findLabel.font = [UIFont systemFontOfSize:12];
    _findLabel.textColor = UIColorFromRGB(0x535353);
    [_container addSubview:_findLabel];
    
    UIView* bline = [UIView new];
    bline.backgroundColor = RGB(85, 176, 215);
    [_container addSubview:bline];

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
    [_hospitalLabel setSingleLineAutoResizeWithMaxWidth:300];

    _departLabel.sd_layout.topSpaceToView(_hospitalLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_departLabel setSingleLineAutoResizeWithMaxWidth:200];

    _fieldLabel.sd_layout.topSpaceToView(_departLabel,5).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_fieldLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

    bottomLine.sd_layout.leftSpaceToView(_container,0).rightSpaceToView(_container,0).topSpaceToView(_fieldLabel,10).heightIs(1);
    _findLabel.sd_layout.leftEqualToView(_headImageView).rightSpaceToView(_container,0).topSpaceToView(bottomLine,10).autoHeightRatio(0);

    bline.sd_layout.leftSpaceToView(_container,0).rightSpaceToView(_container,0).topSpaceToView(_findLabel,10).heightIs(1);

    bottombgView.sd_layout.topSpaceToView(bline,0).heightIs(10).leftSpaceToView(_container,0).rightSpaceToView(_container,0);
    
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
    NSString* stateStr = @"面诊";
    _state.text = stateStr;
    //头像
    
    //职称
    NSString* postStr = @"副主任";
    _postLabel.text = postStr;
    //星级
    [_start setScore:.4 withAnimation:NO];
    //姓名
    NSString* nameStr = @"姓名：单鸿";
    _nameLabel.text = nameStr;
    //科室
    NSString* departStr = @"科室：内科";
    _departLabel.text = departStr;
    //医院
    NSString* hospitalStr = @"医院：济南市儿童医院";
    _hospitalLabel.text = hospitalStr;
    //领域
    NSString* fieldStr = @"领域：腰椎间盘突出";
    _fieldLabel.text = fieldStr;
    //
    NSString* findStr = @"你找医生：儿童医院门诊楼1层402诊室";
    _findLabel.text = findStr;
}



@end
