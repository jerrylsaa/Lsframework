//
//  FDDcotorListTableViewCell.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDDcotorListTableViewCell.h"
#import "TQStarRatingView.h"
#import "JMFoundation.h"
#import "ApiMacro.h"

@interface FDDcotorListTableViewCell (){
    
    UIView* _containerView;
    UIImageView* _headImageView;//头像背景花边
    UIImageView* _icon;
    UILabel* _postLabel;//职称
    TQStarRatingView* _start;//星级
    UILabel* _nameLabel;
    UILabel* _departLabel;
    UILabel* _fieldLabel;
    UILabel* _patientLabel;
    UILabel* _followLabel;
    
    UIImageView* _onlineImage;//在线
    UILabel* _onlineLabel;
    
    UIImageView* _applySucceedImage;//申请成功
    
    UILabel* _serviceOutdate;//服务到期
    
}

@end

@implementation FDDcotorListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self setupApplySucceedImageView];
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_start,_patientLabel,_followLabel] bottomMargin:10];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}

#pragma mark - 头像
- (void)setupHeaderImageView{
    CGFloat iconWidth = 80;
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [_containerView addSubview:_icon];
    _icon.sd_layout.leftSpaceToView(_containerView,20).topSpaceToView(_containerView,15).widthIs(iconWidth).heightEqualToWidth();

    _headImageView = [UIImageView new];
    _headImageView.userInteractionEnabled = YES;
    _headImageView.image=[UIImage imageNamed:@"doctor_flower"];
    [_containerView addSubview:_headImageView];
    _headImageView.sd_layout.leftEqualToView(_icon).topEqualToView(_icon).widthRatioToView(_icon,1).heightEqualToWidth();
}

#pragma mark - 职称
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
//    _postLabel.numberOfLines = 0;
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
//    _postLabel.clipsToBounds = YES;
    _postLabel.font = [UIFont systemFontOfSize:10];
    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_containerView addSubview:_postLabel];
    [_headImageView updateLayout];
    _postLabel.sd_layout.centerYEqualToView(_headImageView).autoHeightRatio(0).leftSpaceToView(_headImageView,-15/2.0).widthIs(15);
    _postLabel.sd_cornerRadiusFromWidthRatio = @0.5;
}

#pragma mark - 星级
- (void)setupStarScrollView{
    _start=[TQStarRatingView new];
    _start.userInteractionEnabled = NO;
    [_containerView addSubview:_start];
    _start.sd_layout.topSpaceToView(_headImageView,10).heightIs(10).leftEqualToView(_headImageView).widthIs(75);
}

#pragma mark - 名字
- (void)setupNameLabel{
    _nameLabel=[UILabel new];
    _nameLabel.textColor = RGB(83, 83, 83);
    _nameLabel.font=[UIFont systemFontOfSize:18];
    [_containerView addSubview:_nameLabel];
    _nameLabel.sd_layout.topSpaceToView(_containerView,25).autoHeightRatio(0).leftSpaceToView(_postLabel,15);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
}

#pragma mark - 科室
- (void)setupDepartment{
    _departLabel=[UILabel new];
    _departLabel.font=[UIFont systemFontOfSize:14];
    _departLabel.textColor=UIColorFromRGB(0x999999);
    [_containerView addSubview:_departLabel];
    _departLabel.sd_layout.topSpaceToView(_nameLabel,10).autoHeightRatio(0).leftEqualToView(_nameLabel);
    [_departLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
}

#pragma mark - 领域
- (void)setupFieldView{
    _fieldLabel=[UILabel new];
    _fieldLabel.font=_departLabel.font;
    _fieldLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_fieldLabel];
    _fieldLabel.sd_layout.topSpaceToView(_departLabel,10).autoHeightRatio(0).leftEqualToView(_nameLabel).rightSpaceToView(_containerView,0);
}
#pragma mark - 患者
- (void)setupPatientView{
    _patientLabel=[UILabel new];
    _patientLabel.font=_departLabel.font;
    _patientLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_patientLabel];
    _patientLabel.sd_layout.topSpaceToView(_fieldLabel,10).autoHeightRatio(0).leftEqualToView(_nameLabel);
    [_patientLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
}
#pragma mark - 随访
- (void)setupFollowView{
    _followLabel=[UILabel new];
    _followLabel.font=_departLabel.font;
    _followLabel.textColor=_departLabel.textColor;
    [_containerView addSubview:_followLabel];
    _followLabel.sd_layout.topEqualToView(_patientLabel).autoHeightRatio(0).leftSpaceToView(_patientLabel,20).rightSpaceToView(_containerView,0);
}

#pragma mark 在线/离线
- (void)setupOnlineView{
    _onlineImage = [UIImageView new];
    _onlineImage.userInteractionEnabled = YES;
    [_containerView addSubview:_onlineImage];
    _onlineImage.sd_layout.leftSpaceToView(_nameLabel,10).centerYEqualToView(_nameLabel).widthIs(15).heightEqualToWidth();
    
    _onlineLabel = [UILabel new];
    [_containerView addSubview:_onlineLabel];
    _onlineLabel.font = [UIFont systemFontOfSize:12];
    _onlineLabel.sd_layout.leftSpaceToView(_onlineImage,3).centerYEqualToView(_onlineImage).autoHeightRatio(0);
    [_onlineLabel setSingleLineAutoResizeWithMaxWidth:50];
}

#pragma mark - 申请成功
- (void)setupApplySucceedImageView{
    _applySucceedImage = [UIImageView new];
    _applySucceedImage.userInteractionEnabled = YES;
    _applySucceedImage.image = [UIImage imageNamed:@"doctor_applySuccess"];
    _applySucceedImage.hidden = YES;
    [_containerView addSubview:_applySucceedImage];
    _applySucceedImage.sd_layout.topSpaceToView(_containerView,0).heightIs(50).widthEqualToHeight().rightSpaceToView(_containerView,0);
    
    //服务到期
    _serviceOutdate = [UILabel new];
    _serviceOutdate.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _serviceOutdate.textColor = UIColorFromRGB(0x888888);
    _serviceOutdate.font = [UIFont systemFontOfSize:14];
    _serviceOutdate.textAlignment = NSTextAlignmentCenter;
    _serviceOutdate.hidden = YES;
    [_containerView addSubview:_serviceOutdate];
    
    _serviceOutdate.sd_layout.topSpaceToView(_containerView,0).autoHeightRatio(0).rightSpaceToView(_containerView,5);
    [_serviceOutdate setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
}


-(void)setDoctor:(FamilyDoctorEntity *)doctor{
    _doctor = doctor;
    
    //头像
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,doctor.userImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    
    //职称
//    NSString* text = @"专家教授";
    _postLabel.text=doctor.profession;
    
    //星级
    CGFloat star = doctor.starNum;
    [_start setScore:star/10.0f withAnimation:YES];
    
    //姓名
    _nameLabel.text=[NSString stringWithFormat:@"姓名: %@",doctor.userName];
    [_nameLabel updateLayout];
    
    //在线
    BOOL isHidden;
    if([doctor.onLineState integerValue] == 0){
        isHidden = NO;
        _onlineImage.image = [UIImage imageNamed:@"offline"];
        _onlineLabel.text = @"离线";
        _onlineLabel.textColor = UIColorFromRGB(0x858585);//离线0x858585颜色
    }else if([doctor.onLineState integerValue] == 1){
        isHidden = NO;
        _onlineImage.image = [UIImage imageNamed:@"online"];
        _onlineLabel.text = @"在线";
        _onlineLabel.textColor = UIColorFromRGB(0x85d5f1);//离线0x858585颜色
    }else{
        isHidden = YES;
    }
    _onlineImage.hidden = isHidden;
    _onlineLabel.hidden = isHidden;


    
    //科室
    _departLabel.text = [NSString stringWithFormat:@"科室: %@",doctor.departName];

    //领域
    _fieldLabel.text = [NSString stringWithFormat:@"领域: %@",doctor.field];
    
    //患者
    _patientLabel.text = [NSString stringWithFormat:@"患者: %ld例",doctor.patientNum];
    
    //随访
    _followLabel.text = [NSString stringWithFormat:@"随访: %ld例",doctor.followUp];
    
    //订单状态
    if(doctor.orderState == 0){
    //申请成功
        _applySucceedImage.hidden = NO;
        _serviceOutdate.hidden = YES;

    }else if(doctor.orderState == 1){
    //已付款
        
    }else if(doctor.orderState == 2){
    //已通过
        _applySucceedImage.hidden = YES;
        _serviceOutdate.hidden = NO;
        NSDate* endTime = doctor.packageEndTime;
        _serviceOutdate.text = [NSString stringWithFormat:@"%@服务到期",[endTime format2String:@"yyyy年MM月dd日"]];

    }else if(doctor.orderState == 3){
    //已取消
        
    }else if(doctor.orderState == 4){
    //已退款
        
    }
    
//    //服务到期时间
//    if(doctor.packageEndTime){
//        _serviceOutdate.hidden = NO;
//        NSDate* endTime = doctor.packageEndTime;
//        _serviceOutdate.text = [NSString stringWithFormat:@"%@服务到期",[endTime format2String:@"yyyy年MM月dd日"]];
//    }else{
//        _serviceOutdate.hidden = YES;
//    }

    
    
    

//    //申请状态
//    if(doctor.orderState){
//    //申请成功
//        _applySucceedImage.hidden = NO;
//        _serviceOutdate.hidden = YES;
//    }else{
//    //服务到期
//        _applySucceedImage.hidden = YES;
//        _serviceOutdate.hidden = NO;
//        NSDate* endTime = doctor.packageEndTime;
//        _serviceOutdate.text = [NSString stringWithFormat:@"%@服务到期",[endTime format2String:@"yyyy年MM月dd日"]];
//    }
    
    
    
    
//    //申请成功
//    if(doctor.applySuccess){
//        _applySucceedImage.hidden = NO;
//        _serviceOutdate.hidden = YES;
//    }else{
//        _applySucceedImage.hidden = YES;
//    }
//    
//    //服务到期
//    if(doctor.serviceOutdate && doctor.serviceOutdate.length !=0){
//        _serviceOutdate.hidden = NO;
//        _applySucceedImage.hidden = YES;
//        _serviceOutdate.text = doctor.serviceOutdate;
//    }else{
//        _serviceOutdate.hidden = YES;
//    }
    
}








@end
