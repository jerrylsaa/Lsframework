//
//  QCDoctorListTableViewCell.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "QCDoctorListTableViewCell.h"

@interface QCDoctorListTableViewCell (){
    UILabel* nameTitle;
    UILabel* departTitle;
    UILabel* onlineTitle;
    UILabel* phoneTitle;
    UILabel* fieldTitle;
    UILabel* patientTitle;
    UILabel* followTitle;
}

@property(nonatomic,retain)UIView* lineView;;

@end

@implementation QCDoctorListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    [self setupIconImageView];//头像
    [self setupPostLabel];//职称
    [self setupStarScrollView];//心
    [self setupNameLabel];//名字
    [self setupDepartment];//科室
    [self setupOnLineView];//在线
    [self setupPhoneView];//电话
    [self setupFieldView];//领域
    [self setupPatientView];//患者
    [self setupFollowView];//随访
    [self setupPositionView];//位置
    [self setupLineView];//分割线
    
    


}

#pragma mark - 头像
- (void)setupIconImageView{
    _icon=[UIImageView new];
    _icon.userInteractionEnabled=YES;
    _icon.image=[UIImage imageNamed:@"doctor_flower"];
    [self.contentView addSubview:_icon];
    _icon.sd_layout.topSpaceToView(self.contentView,15).heightIs(75).leftSpaceToView(self.contentView,20).widthEqualToHeight();
}
#pragma mark - 职称
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    _postLabel.numberOfLines = 0;
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
    _postLabel.clipsToBounds = YES;
    _postLabel.font = [UIFont systemFontOfSize:10];
    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_postLabel];
    [_icon updateLayout];
    _postLabel.sd_layout.centerYEqualToView(_icon).heightIs(40).centerXIs(_icon.right).widthIs(15);
    [_postLabel updateLayout];
    _postLabel.layer.cornerRadius = _postLabel.width/2.0f;

}
#pragma mark - 星级
- (void)setupStarScrollView{
    _start=[TQStarRatingView new];
    [self.contentView addSubview:_start];
    _start.sd_layout.topSpaceToView(_icon,10).heightIs(10).leftEqualToView(_icon).widthIs(75);

}
#pragma mark - 名字
- (void)setupNameLabel{
    nameTitle=[UILabel new];
    nameTitle.text=@"姓名";
    nameTitle.font=[UIFont systemFontOfSize:18];
    [self.contentView addSubview:nameTitle];
    nameTitle.sd_layout.topSpaceToView(self.contentView,25).heightIs(20).leftSpaceToView(_postLabel,15);
    [nameTitle setSingleLineAutoResizeWithMaxWidth:150];

    _nameLabel=[UILabel new];
    _nameLabel.font=nameTitle.font;
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout.topEqualToView(nameTitle).bottomEqualToView(nameTitle).leftSpaceToView(nameTitle,10).rightSpaceToView(self.contentView,0);
}
#pragma mark - 科室
- (void)setupDepartment{
    departTitle=[UILabel new];
    departTitle.text=@"科室";
    departTitle.font=[UIFont systemFontOfSize:14];
    departTitle.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:departTitle];
    departTitle.sd_layout.topSpaceToView(nameTitle,10).heightIs(15).leftSpaceToView(_postLabel,15).maxWidthIs(150);
    [departTitle setSingleLineAutoResizeWithMaxWidth:150];
    
    _departLabel=[UILabel new];
    _departLabel.font=departTitle.font;
    _departLabel.textColor=departTitle.textColor;
    [self.contentView addSubview:_departLabel];
    _departLabel.sd_layout.topEqualToView(departTitle).bottomEqualToView(departTitle).leftSpaceToView(departTitle,10).rightSpaceToView(self.contentView,0);
//    [_departLabel setSingleLineAutoResizeWithMaxWidth:200];
}
#pragma mark - 在线咨询
- (void)setupOnLineView{
    UIImageView* online=[UIImageView new];
    online.image=[UIImage imageNamed:@"doctor_online"];
    [self.contentView addSubview:online];
    online.sd_layout.topSpaceToView(departTitle,10).heightIs(15).leftEqualToView(departTitle).widthEqualToHeight();

    onlineTitle=[UILabel new];
    onlineTitle.text=@"在线咨询:";
    onlineTitle.font=[UIFont systemFontOfSize:14];
    onlineTitle.textColor=UIColorFromRGB(0x85d5f1);
    [self.contentView addSubview:onlineTitle];
    onlineTitle.sd_layout.topSpaceToView(departTitle,10).heightIs(15).leftSpaceToView(online,10).maxWidthIs(150);
    [onlineTitle setSingleLineAutoResizeWithMaxWidth:150];
    
    _onlineLabel=[UILabel new];
    _onlineLabel.text=@"50/次";
    _onlineLabel.font=onlineTitle.font;
    _onlineLabel.textColor=onlineTitle.textColor;
    [self.contentView addSubview:_onlineLabel];
    _onlineLabel.sd_layout.topEqualToView(onlineTitle).bottomEqualToView(onlineTitle).leftSpaceToView(onlineTitle,10).rightSpaceToView(self.contentView,0);
//    [_onlineLabel setSingleLineAutoResizeWithMaxWidth:200];
}
#pragma mark - 电话咨询
- (void)setupPhoneView{
    UIImageView* phone=[UIImageView new];
    phone.image=[UIImage imageNamed:@"doctor_phone"];
    [self.contentView addSubview:phone];
    phone.sd_layout.topSpaceToView(_onlineLabel,10).heightIs(15).leftEqualToView(departTitle).widthEqualToHeight();

    phoneTitle=[UILabel new];
    phoneTitle.text=@"电话咨询:";
    phoneTitle.font=[UIFont systemFontOfSize:14];
    phoneTitle.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:phoneTitle];
    phoneTitle.sd_layout.topSpaceToView(_onlineLabel,10).heightIs(15).leftSpaceToView(phone,10).maxWidthIs(150);
    [phoneTitle setSingleLineAutoResizeWithMaxWidth:150];
    
    _phoneLabel=[UILabel new];
    _phoneLabel.text=@"100/10min";
    _phoneLabel.font=phoneTitle.font;
    _phoneLabel.textColor=phoneTitle.textColor;
    [self.contentView addSubview:_phoneLabel];
    _phoneLabel.sd_layout.topEqualToView(phoneTitle).bottomEqualToView(phoneTitle).leftSpaceToView(phoneTitle,10).rightSpaceToView(self.contentView,0);
//    [_phoneLabel setSingleLineAutoResizeWithMaxWidth:200];
}
#pragma mark - 领域
- (void)setupFieldView{
    fieldTitle=[UILabel new];
    fieldTitle.text=@"领域:";
    fieldTitle.font=[UIFont systemFontOfSize:14];
    fieldTitle.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:fieldTitle];
    fieldTitle.sd_layout.topSpaceToView(phoneTitle,10).heightIs(15).leftSpaceToView(_postLabel,15).maxWidthIs(250);
    [fieldTitle setSingleLineAutoResizeWithMaxWidth:250];
    
    _fieldLabel=[UILabel new];
    _fieldLabel.font=fieldTitle.font;
    _fieldLabel.textColor=fieldTitle.textColor;
    _fieldLabel.text=@"腰椎间盘突出";
    [self.contentView addSubview:_fieldLabel];
    _fieldLabel.sd_layout.topEqualToView(fieldTitle).bottomEqualToView(fieldTitle).leftSpaceToView(fieldTitle,10).rightSpaceToView(self.contentView,0);
//    [_fieldLabel setSingleLineAutoResizeWithMaxWidth:300];
}
#pragma mark - 患者
- (void)setupPatientView{
    patientTitle=[UILabel new];
    patientTitle.text=@"患者:";
    patientTitle.font=[UIFont systemFontOfSize:14];
    patientTitle.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:patientTitle];
    patientTitle.sd_layout.topSpaceToView(fieldTitle,10).heightIs(15).leftSpaceToView(_postLabel,15);
    [patientTitle setSingleLineAutoResizeWithMaxWidth:100];
    
    _patientLabel=[UILabel new];
    _patientLabel.font=patientTitle.font;
    _patientLabel.textColor=patientTitle.textColor;
    _patientLabel.text=@"100例";
    [self.contentView addSubview:_patientLabel];
    _patientLabel.sd_layout.topEqualToView(patientTitle).bottomEqualToView(patientTitle).leftSpaceToView(patientTitle,10);
    [_patientLabel setSingleLineAutoResizeWithMaxWidth:100];
    
}
#pragma mark - 随访
- (void)setupFollowView{
    followTitle=[UILabel new];
    followTitle.text=@"随访:";
    followTitle.font=[UIFont systemFontOfSize:14];
    followTitle.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:followTitle];
    followTitle.sd_layout.topSpaceToView(fieldTitle,10).heightIs(15).leftSpaceToView(_patientLabel,15);
    [followTitle setSingleLineAutoResizeWithMaxWidth:100];

    _followLabel=[UILabel new];
    _followLabel.font=followTitle.font;
    _followLabel.textColor=followTitle.textColor;
    _followLabel.text=@"50例";
    [self.contentView addSubview:_followLabel];
    _followLabel.sd_layout.topEqualToView(followTitle).bottomEqualToView(followTitle).leftSpaceToView(followTitle,10).rightSpaceToView(self.contentView,0);
 }
#pragma mark - 位置
- (void)setupPositionView{
    UIImageView* position=[UIImageView new];
    position.image=[UIImage imageNamed:@"doctor_position"];
    [self.contentView addSubview:position];
    
    _postionLabel=[UILabel new];
    _postionLabel.font=[UIFont systemFontOfSize:12];
    _postionLabel.text=@"100m";
    _postionLabel.textColor=UIColorFromRGB(0x999999);
    [self.contentView addSubview:_postionLabel];
    
    _postionLabel.sd_layout.topSpaceToView(self.contentView,10).heightIs(10).rightSpaceToView(self.contentView,10);
    [_postionLabel setSingleLineAutoResizeWithMaxWidth:150];
    position.sd_layout.centerYEqualToView(_postionLabel).heightIs(15).rightSpaceToView(_postionLabel,5).widthIs(13);
}
#pragma mark - 分割线
- (void)setupLineView{
    _lineView=[UIView new];
    _lineView.backgroundColor=UIColorFromRGB(0x68c0de);
    [self.contentView addSubview:_lineView];
    _lineView.sd_layout.topSpaceToView(_followLabel,15).heightIs(1).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    //cell高度自适应
    [self setupAutoHeightWithBottomView:_lineView bottomMargin:1];

}

-(void)setDoctor:(DoctorList *)doctor{
    _doctor=doctor;
    //头像
    //职称
    _postLabel.text=doctor.ProfessionalName;
    //星级
    //    NSLog(@"star=%ld",doctor.StarNum);
    [_start setScore:.4 withAnimation:YES];
    //姓名
    _nameLabel.text=doctor.UserName;

    //科室
    _departLabel.text=doctor.DepartName;
    //在线咨询
    //电话咨询
    //领域
    //患者
    //随访
    //距离

}












@end
