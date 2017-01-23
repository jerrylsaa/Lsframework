//
//  SelectFamilyDoctorTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SelectFamilyDoctorTableViewCell.h"
#import "TQStarRatingView.h"
#import "JMFoundation.h"
#import "ApiMacro.h"

#define kSpace 10

@interface SelectFamilyDoctorTableViewCell (){

    UIView* _containerView;
    UIImageView* _icon;
    UIImageView* _headImageView;//头像
    UILabel* _postLabel;//职称
    TQStarRatingView* _start;//星级
    UILabel* _nameLabel;
    UILabel* _departLabel;
    UILabel* _fieldLabel;
    UILabel* _patientLabel;
    UILabel* _followLabel;
    UILabel* _signPatient;//签约患者
    
    UIImageView* _onlineImage;//在线
    UILabel* _onlineLabel;
    
//    UIImageView* _applySucceedImage;
}

@end

@implementation SelectFamilyDoctorTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    [self setupHeaderImageView];
    [self setupPostLabel];
    [self setupStarScrollView];
    [self setupNameLabel];
    [self setupDepartment];
    [self setupFieldView];
    [self setupPatientView];
    [self setupFollowView];
    [self setupOnlineView];

    [self setupSignPatient];
}

#pragma mark - 头像
- (void)setupHeaderImageView{
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [_containerView addSubview:_icon];
    
    _headImageView = [UIImageView new];
    _headImageView.userInteractionEnabled = YES;
    _headImageView.image=[UIImage imageNamed:@"doctor_flower"];
    [_containerView addSubview:_headImageView];
    
    _icon.sd_layout.leftSpaceToView(_containerView,20).topSpaceToView(_containerView,15).widthIs(80).heightEqualToWidth();
    _headImageView.sd_layout.centerXEqualToView(_icon).centerYEqualToView(_icon).widthIs(80).heightEqualToWidth();
}

#pragma mark - 职称
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
    _postLabel.font = [UIFont systemFontOfSize:10];
    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_containerView addSubview:_postLabel];
    
    _postLabel.sd_layout.centerYEqualToView(_headImageView).leftSpaceToView(_headImageView,-15/2.0).widthIs(15).autoHeightRatio(0);
    _postLabel.sd_cornerRadiusFromWidthRatio = @0.5;
}

#pragma mark - 星级
- (void)setupStarScrollView{
    _start=[TQStarRatingView new];
    _start.userInteractionEnabled = NO;
    [_containerView addSubview:_start];
    _start.sd_layout.topSpaceToView(_headImageView,10).heightIs(10).leftEqualToView(_headImageView).widthIs(90);
}

#pragma mark - 名字
- (void)setupNameLabel{
    _nameLabel=[UILabel new];
    _nameLabel.textColor = RGB(83, 83, 83);
    _nameLabel.font=[UIFont systemFontOfSize:18];
    [_containerView addSubview:_nameLabel];
    _nameLabel.sd_layout.topSpaceToView(_containerView,25).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
}

#pragma mark - 科室
- (void)setupDepartment{
    _departLabel=[UILabel new];
    _departLabel.font=[UIFont systemFontOfSize:14];
    _departLabel.textColor=UIColorFromRGB(0x999999);
    [_containerView addSubview:_departLabel];
    _departLabel.sd_layout.topSpaceToView(_nameLabel,5).autoHeightRatio(0).leftEqualToView(_nameLabel).rightSpaceToView(_containerView,10);
}

#pragma mark - 领域
- (void)setupFieldView{
    _fieldLabel=[UILabel new];
    _fieldLabel.font=_departLabel.font;
    _fieldLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_fieldLabel];
    _fieldLabel.sd_layout.topSpaceToView(_departLabel,5).autoHeightRatio(0).leftEqualToView(_nameLabel).rightSpaceToView(_containerView,10);
}
#pragma mark - 患者
- (void)setupPatientView{
    _patientLabel=[UILabel new];
    _patientLabel.font=_departLabel.font;
    _patientLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_patientLabel];
    _patientLabel.sd_layout.topSpaceToView(_fieldLabel,5).autoHeightRatio(0).leftEqualToView(_nameLabel);
    [_patientLabel setSingleLineAutoResizeWithMaxWidth:200];
    
}
#pragma mark - 随访
- (void)setupFollowView{
    _followLabel=[UILabel new];
    _followLabel.font=_departLabel.font;
    _followLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_followLabel];
    _followLabel.sd_layout.topEqualToView(_patientLabel).autoHeightRatio(0).leftSpaceToView(_patientLabel,10).rightSpaceToView(_containerView,10);
}

#pragma mark 在线/离线
- (void)setupOnlineView{
    _onlineImage = [UIImageView new];
    _onlineImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_onlineImage];
    _onlineImage.sd_layout.leftSpaceToView(_nameLabel,17).topEqualToView(_nameLabel).widthIs(15).heightIs(15);
    
    _onlineLabel = [UILabel new];
    [self.contentView addSubview:_onlineLabel];
    _onlineLabel.font = [UIFont systemFontOfSize:12];
    _onlineLabel.sd_layout.leftSpaceToView(_onlineImage,3).bottomEqualToView(_onlineImage).widthIs(48).heightIs(15);
}

#pragma mark - 签约患者
- (void)setupSignPatient{
    _signPatient=[UILabel new];
    _signPatient.font=_departLabel.font;
    _signPatient.textColor=_departLabel.textColor;
    [_containerView addSubview:_signPatient];
    _signPatient.sd_layout.topSpaceToView(_patientLabel,5).autoHeightRatio(0).leftEqualToView(_nameLabel).rightSpaceToView(_containerView,10);

    [_containerView setupAutoHeightWithBottomView:_signPatient bottomMargin:10];
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}

-(void)setDoctor:(DoctorList *)doctor{
    _doctor = doctor;
    //头像
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,doctor.UserImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    //职称
    NSString* text = doctor.ProfessionalName;
    _postLabel.text=text;
    //星级
    [_start setScore:doctor.StarNum/10.0f withAnimation:YES];
    //姓名
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",doctor.UserName];
    [_nameLabel updateLayout];
    
    //科室
    _departLabel.text=[NSString stringWithFormat:@"科室：%@",doctor.DepartName];
    //领域
    _fieldLabel.text = [NSString stringWithFormat:@"领域：%@",doctor.Field];
    //患者
    _patientLabel.text = [NSString stringWithFormat:@"患者：%ld例",doctor.PatientNum];
    //随访
    _followLabel.text = [NSString stringWithFormat:@"随访：%ld例",doctor.FollowUp];
    
    //在线
    BOOL isHidden;
    if([doctor.OnLineState integerValue] == 0){
        isHidden = NO;
        _onlineImage.image = [UIImage imageNamed:@"offline"];
        _onlineLabel.text = @"离线";
        _onlineLabel.textColor = UIColorFromRGB(0x858585);//离线0x858585颜色
    }else if([doctor.OnLineState integerValue] == 1){
        isHidden = NO;
        _onlineImage.image = [UIImage imageNamed:@"online"];
        _onlineLabel.text = @"在线";
        _onlineLabel.textColor = UIColorFromRGB(0x85d5f1);//离线0x858585颜色
    }else{
        isHidden = YES;
    }
    _onlineImage.hidden = isHidden;
    _onlineLabel.hidden = isHidden;

    
    //签约患者
    _signPatient.text = [NSString stringWithFormat:@"签约患者：%@例",doctor.num];
    
}



@end
