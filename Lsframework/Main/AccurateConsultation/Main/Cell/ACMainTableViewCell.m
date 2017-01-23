//
//  ACMainTableViewCell.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACMainTableViewCell.h"
#import "TQStarRatingView.h"
#import "JMFoundation.h"
#import "ApiMacro.h"

@interface ACMainTableViewCell()
{
    UIImageView *_headImageView;//头像
    UIImageView *_photoFrame;//相框
    UILabel *_postLabel;//职位
    TQStarRatingView *_starView;//评分
    UILabel *_nameLabel;//姓名
    UIImageView *_onlineImage;//在线/离线头像
    UILabel *_onlineLabel;//在线/离线
    UILabel *_departmentLabel;//科室
    UILabel *_fieldLabel;//领域
    UILabel *_patientLabel;//患者
    UILabel *_followUpLabel;//随访
    
}

@end

@implementation ACMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
    
}

- (void)setupSubViews{
    
    [self setupHeaderImageView];
//    [self setupStarView];
    [self setupNameView];
//    [self setupOnlineView];
    [self setupDepartmentView];
    [self setupPostView];
    [self setupFieldView];
//    [self setupPatientView];
//    [self setupFollowupView];
    [self setupSep];
    
}
#pragma mark 头像
- (void)setupHeaderImageView{
    
    _headImageView = [UIImageView new];
    [self addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(self,20).topSpaceToView(self,25).widthIs(80).heightIs(80);
    
    _photoFrame = [UIImageView new];
    [self addSubview:_photoFrame];
    _photoFrame.sd_layout.leftSpaceToView(self,20).topSpaceToView(self,25).widthIs(80).heightIs(80);
}
#pragma mark 评分
- (void)setupStarView{
    _starView = [TQStarRatingView new];
    [self addSubview:_starView];
    _starView.sd_layout.leftSpaceToView(self,20).topSpaceToView(_headImageView,10).widthIs(80).heightIs(10);
}

#pragma mark 姓名
- (void)setupNameView{
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).topSpaceToView(self,25).heightIs(20);
}
//#pragma mark 在线/离线
//- (void)setupOnlineView{
//    _onlineImage = [UIImageView new];
//    [self addSubview:_onlineImage];
//    _onlineImage.sd_layout.leftSpaceToView(_nameLabel,17).topSpaceToView(self,27).widthIs(15).heightIs(15);
//    
//    _onlineLabel = [UILabel new];
//    [self addSubview:_onlineLabel];
//    _onlineLabel.font = [UIFont systemFontOfSize:12];
//    _onlineLabel.sd_layout.leftSpaceToView(_onlineImage,3).topSpaceToView(self,28).widthIs(48).heightIs(15);
//}

#pragma mark 科室
- (void)setupDepartmentView{
    _departmentLabel = [UILabel new];
    _departmentLabel.font = [UIFont systemFontOfSize:15];
    _departmentLabel.textColor = UIColorFromRGB(0x999999);
    _departmentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_departmentLabel];
    _departmentLabel.sd_layout.leftSpaceToView(_headImageView,20).topSpaceToView(_nameLabel,10).rightSpaceToView(self,10).heightIs(15);
}

#pragma mark 职称
- (void)setupPostView{
    _postLabel = [UILabel new];
    _postLabel.font = [UIFont systemFontOfSize:15];
    _postLabel.textColor = UIColorFromRGB(0x999999);
    _postLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_postLabel];
    _postLabel.sd_layout.leftSpaceToView(_headImageView,20).topSpaceToView(_departmentLabel,10).rightSpaceToView(self,10).heightIs(15);
    //    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    //    _postLabel.numberOfLines = 0;
    //    _postLabel.textColor = [UIColor whiteColor];
    //    _postLabel.textAlignment = NSTextAlignmentCenter;
    //    _postLabel.clipsToBounds = YES;
    //    _postLabel.font = [UIFont systemFontOfSize:11];
    //    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    [self addSubview:_postLabel];
    //    _postLabel.sd_layout.leftSpaceToView(self,90).widthIs(15);
    //    _postLabel.layer.cornerRadius = 7.5f;
}

#pragma  mark 领域
- (void)setupFieldView{
    _fieldLabel = [UILabel new];
    _fieldLabel.font = _departmentLabel.font;
    _fieldLabel.textColor = _departmentLabel.textColor;
    [self addSubview:_fieldLabel];
    _fieldLabel.sd_layout.leftSpaceToView(_headImageView,20).topSpaceToView(_postLabel,10).rightSpaceToView(self,10).heightIs(15);
}

//#pragma mark 患者
//- (void)setupPatientView{
//    _patientLabel = [UILabel new];
//    _patientLabel.font = _fieldLabel.font;
//    _patientLabel.textColor = _fieldLabel.textColor;
//    [self addSubview:_patientLabel];
//    _patientLabel.sd_layout.leftSpaceToView(_postLabel,15).topSpaceToView(_fieldLabel,10).widthIs((self.width - 125)/2).heightIs(15);
//}
//#pragma mark 随访
//- (void)setupFollowupView{
//    _followUpLabel = [UILabel new];
//    _followUpLabel.font = _patientLabel.font;
//    _followUpLabel.textColor = _patientLabel.textColor;
//    [self addSubview:_followUpLabel];
//    _followUpLabel.sd_layout.leftSpaceToView(_patientLabel,0).topSpaceToView(_fieldLabel,10).widthIs((self.width - 125)/2).heightIs(15);
//}
#pragma mark 分割线
- (void)setupSep{
    UIView *sep = [UIView new];
    sep.backgroundColor = UIColorFromRGB(0x68c0de);
    [self addSubview:sep];
    sep.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,0).heightIs(1);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_doctor.UserImg]] placeholderImage:[UIImage imageNamed:@"HomeAvater"]];
//    _headImageView.contentMode = UIViewContentModeCenter;
    _headImageView.clipsToBounds = YES;
    _photoFrame.image = [UIImage imageNamed:@"flowerHead"];
    _starView.userInteractionEnabled = NO;
    [_starView setScore:self.doctor.StarNum/10.f withAnimation:YES];
    
//    CGFloat height = [JMFoundation calLabelHeight:[UIFont systemFontOfSize:11] andStr:self.doctor.ProfessionalName withWidth:15];
//    if (height < 80) {
//        height = height + 5;
//    }else{
//        height = 80;
//    }
//    _postLabel.height = height;
//    _postLabel.centerY = _headImageView.centerY;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",self.doctor.UserName];
//    CGFloat width_name = [self calLabelHeight:[UIFont systemFontOfSize:18] andStr:_nameLabel.text withHeight:25];
//    CGFloat max_width = self.width - 115 - 75;
//    if (width_name < max_width) {
//        width_name = width_name;
//    }else{
//        width_name = max_width;
//    }
//    _nameLabel.width = width_name;
//    _onlineImage.left = _nameLabel.right + 17;
//    _onlineLabel.left = _onlineImage.right + 3;
    
//    if (self.doctor.TextState == 1) {
//        _onlineImage.image = [UIImage imageNamed:@"online"];
//        _onlineLabel.text = @"在线";
//        _onlineLabel.textColor = UIColorFromRGB(0x85d5f1);
//    }else{
//        _onlineImage.image = [UIImage imageNamed:@"offline"];
//        _onlineLabel.text = @"离线";
//        _onlineLabel.textColor = UIColorFromRGB(0x999999);
//    }
    
    _departmentLabel.text = [NSString stringWithFormat:@"科室：%@",self.doctor.DepartName];
    _postLabel.text = [NSString stringWithFormat:@"职称:%@",self.doctor.ProfessionalName];
    _fieldLabel.text = [NSString stringWithFormat:@"领域：%@",self.doctor.Field];
//    _patientLabel.text = [NSString stringWithFormat:@"患者：%ld例",(long)self.doctor.PatientNum];
//    _followUpLabel.text = [NSString stringWithFormat:@"随访：%ld例",(long)self.doctor.FollowUp];

}



- (CGFloat)calLabelHeight:(UIFont *)fontSize andStr:(NSString *)str withHeight:(CGFloat)height{
    NSDictionary *attribute = @{NSFontAttributeName: fontSize};
    
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.width;
}

@end
