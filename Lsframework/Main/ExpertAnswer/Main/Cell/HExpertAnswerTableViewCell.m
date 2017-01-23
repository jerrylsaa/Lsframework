//
//  HExpertAnswerTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HExpertAnswerTableViewCell.h"
#import "JMFoundation.h"

@interface HExpertAnswerTableViewCell (){
    UIView* _containerView;
    
    UIImageView* _iconbgImageView;
    UIImageView* _icon;
    UILabel* _doctorName;
    UIView* _lineView;
    UILabel* _professionLabel;
    
    UILabel* _introduceTitle;
    UILabel* _introduceLabel;
    
    UILabel* _fieldTitle;
    UILabel* _fieldLabel;
    UILabel* _questioncount;
    UILabel* _Answercount;
    UILabel * _AvgTimeLabel;

}

@end

@implementation HExpertAnswerTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    _containerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:_containerView];
    
    _iconbgImageView = [UIImageView new];
    _iconbgImageView.userInteractionEnabled = YES;
    _iconbgImageView.backgroundColor = UIColorFromRGB(0xffffff);
    _iconbgImageView.layer.masksToBounds = YES;
    _iconbgImageView.layer.borderWidth = 1;
    _iconbgImageView.layer.borderColor = UIColorFromRGB(0x37e0ce).CGColor;
    [_containerView addSubview:_iconbgImageView];
    
    _statusImageView = [UIImageView new];
    _statusImageView.userInteractionEnabled = YES;
    _statusImageView.backgroundColor = [UIColor  clearColor];
    [_containerView   addSubview:_statusImageView];
    
    _moreStatusImageView = [UIImageView new];
//    _moreStatusImageView.backgroundColor = [UIColor  clearColor];
    [_containerView   addSubview:_moreStatusImageView];

    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [_containerView addSubview:_icon];
    
    _doctorName = [UILabel new];
//    _doctorName.backgroundColor = [UIColor clearColor];
    _doctorName.textColor = UIColorFromRGB(0x333333);
    _doctorName.font = [UIFont systemFontOfSize:18];
    [_containerView addSubview:_doctorName];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorFromRGB(0x999999);
    [_containerView addSubview:_lineView];
    
    _professionLabel = [UILabel new];
    _professionLabel.textColor = UIColorFromRGB(0x999999);
    _professionLabel.font = [UIFont systemFontOfSize:14];
    [_containerView addSubview:_professionLabel];

    _introduceTitle = [UILabel new];
    _introduceTitle.textColor = _doctorName.textColor;
    _introduceTitle.text = @"简介：";
    _introduceTitle.textAlignment = NSTextAlignmentCenter;
    _introduceTitle.font = [UIFont systemFontOfSize:sbigFont];
    [_containerView addSubview:_introduceTitle];
    
    _introduceLabel = [UILabel new];
    _introduceLabel.textColor = _doctorName.textColor;
    _introduceLabel.font = _introduceTitle.font;
    [_containerView addSubview:_introduceLabel];

    _fieldTitle = [UILabel new];
    _fieldTitle.textColor = UIColorFromRGB(0x61d8d3);
    _fieldTitle.text = @"领域：";
    _fieldTitle.textAlignment = NSTextAlignmentCenter;
    _fieldTitle.font = _introduceTitle.font;
    [_containerView addSubview:_fieldTitle];
    
    _fieldLabel = [UILabel new];
    _fieldLabel.textColor = UIColorFromRGB(0x999999);
    _fieldLabel.font = _introduceLabel.font;
    [_containerView addSubview:_fieldLabel];
    
    _questioncount = [UILabel new];
    _questioncount.textColor =  UIColorFromRGB(0x999999);
    _questioncount.font = _professionLabel.font;
    _questioncount.textAlignment = NSTextAlignmentLeft;
    [_containerView addSubview:_questioncount];
    
    _Answercount = [UILabel new];
    _Answercount.textColor =  UIColorFromRGB(0x999999);
    _Answercount.font = _professionLabel.font;
//    _Answercount.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_Answercount];
    
    _AvgTimeLabel = [UILabel new];
//    _AvgTimeLabel.backgroundColor = [UIColor clearColor];
    _AvgTimeLabel.textColor =  UIColorFromRGB(0x999999);
    _AvgTimeLabel.font = _professionLabel.font;
    _AvgTimeLabel.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_AvgTimeLabel];


//    _containerView.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,5).rightSpaceToView(self.contentView,5);
//    
//    _statusImageView.sd_layout.topEqualToView(_containerView).rightSpaceToView(_containerView,10).widthIs(kFitWidthScale(139)).heightIs(kFitHeightScale(62));
//    
//    _iconbgImageView.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,10).widthIs(50).heightEqualToWidth();
//    _iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
//    _icon.sd_layout.centerXEqualToView(_iconbgImageView).centerYEqualToView(_iconbgImageView).widthIs(45).heightEqualToWidth();
//    _icon.sd_cornerRadiusFromWidthRatio = @(0.5);
//    
//    CGFloat  doctorNameWidth = [JMFoundation  calLabelWidth:_doctorName];
//    
//    _doctorName.sd_layout.topSpaceToView(_containerView,43/2.0).leftSpaceToView(_iconbgImageView,10).autoHeightRatio(0).widthIs(doctorNameWidth);
//    
//    
////    _moreStatusImageView.sd_layout.bottomSpaceToView(_doctorName,-17).leftSpaceToView(_doctorName,10).widthIs(126/2).heightIs(26/2);
//    _moreStatusImageView.sd_layout.centerYEqualToView(_doctorName).leftSpaceToView(_doctorName,10).widthIs(126/2).heightIs(26/2);
//    
//    _lineView.sd_layout.topSpaceToView(_doctorName,12).heightIs(1).leftEqualToView(_doctorName).widthIs(25);
//    _professionLabel.sd_layout.centerYEqualToView(_lineView).autoHeightRatio(0).leftSpaceToView(_lineView,0).rightSpaceToView(_containerView,0);
//    
//    _introduceTitle.sd_layout.leftEqualToView(_iconbgImageView).rightEqualToView(_iconbgImageView).topSpaceToView(_iconbgImageView,15).autoHeightRatio(0);
//    
//    [_introduceTitle updateLayout];
//    _introduceLabel.sd_layout.topEqualToView(_introduceTitle).leftSpaceToView(_introduceTitle,3).rightSpaceToView(_containerView,10).heightRatioToView(_introduceTitle,2).maxHeightIs(_introduceTitle.height * 2.0).minHeightIs(_introduceTitle.height).autoHeightRatio(0);
//    
//    _fieldTitle.sd_layout.leftEqualToView(_introduceTitle).rightEqualToView(_introduceTitle).topSpaceToView(_introduceLabel,5).autoHeightRatio(0);
//    
//    [_fieldTitle updateLayout];
//    _fieldLabel.sd_layout.topEqualToView(_fieldTitle).leftSpaceToView(_fieldTitle,3).rightEqualToView(_introduceLabel).maxHeightIs(_fieldTitle.height * 2.0).minHeightIs(_fieldTitle.height).autoHeightRatio(0);
//    
//    
//    CGFloat  questionWidth = [JMFoundation  calLabelWidth:_questioncount.font andStr:_questioncount.text withHeight:14];
//    
//    _questioncount.sd_layout.topSpaceToView(_fieldLabel,15).leftEqualToView(_iconbgImageView).widthIs(questionWidth).heightIs(14);
//    CGFloat  AnswerWidth = [JMFoundation  calLabelWidth:_Answercount.font andStr:_Answercount.text withHeight:14];
//    _Answercount.sd_layout.topEqualToView(_questioncount).leftSpaceToView(_questioncount,15).widthIs(AnswerWidth).heightIs(14);
//    _AvgTimeLabel.sd_layout.topEqualToView(_questioncount).rightSpaceToView(_containerView,15).widthIs(kJMWidth(_AvgTimeLabel)).heightIs(14);
//    
//    [_containerView setupAutoHeightWithBottomViewsArray:@[_questioncount,_Answercount,_AvgTimeLabel] bottomMargin:10];
//    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    
}

- (void)setExpertAnswer:(ExpertAnswerEntity *)expertAnswer{
    _expertAnswer = expertAnswer;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:expertAnswer.imageUrl] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    
    _doctorName.text = expertAnswer.doctorName;
    
    _professionLabel.text = [NSString stringWithFormat:@"%@ %@",expertAnswer.doctorTitle,expertAnswer.HospitalName];//医生职称
    
    NSString* introduce = expertAnswer.introduce;
//    introduce = @"";
    _introduceLabel.text = introduce;
    
    //医生领域
    NSString* field = expertAnswer.domain.length != 0? expertAnswer.domain: @"";
    _fieldLabel.text = field;
    _questioncount.text = [NSString  stringWithFormat:@"收到提问 %@",expertAnswer.consultCount];
    
    _Answercount.text = [NSString  stringWithFormat:@"已回答 %@",expertAnswer.anwerCount];

    
    if ([expertAnswer.AvgTime integerValue] == 0) {
        _AvgTimeLabel.hidden = YES;
        _AvgTimeLabel.sd_layout.topEqualToView(_questioncount).rightSpaceToView(_containerView,15).widthIs(0).heightIs(0);
    }else{
    _AvgTimeLabel.text = [NSString stringWithFormat:@"%@小时内回复",expertAnswer.AvgTime];
    }
//    CGFloat  questionWidth = [JMFoundation  calLabelWidth:_questioncount.font andStr:_questioncount.text withHeight:14];
//    
//    CGFloat  AnswerWidth = [JMFoundation  calLabelWidth:_Answercount.font andStr:_Answercount.text withHeight:14];
//    
//    
//    _questioncount.width =questionWidth;
//    _Answercount.width =AnswerWidth;
//    
//    _AvgTimeLabel.width = kJMWidth(_AvgTimeLabel);
//    
//    [_AvgTimeLabel updateLayout];
//    [_questioncount updateLayout];
//    [_Answercount updateLayout];
    
    
//    CGFloat  doctorNameWidth = [JMFoundation  calLabelWidth:_doctorName];
//    
//    _doctorName.width = doctorNameWidth;
//    
//    [_moreStatusImageView  updateLayout];
    

    if ([expertAnswer.IsVacation isEqual:@1] ) {
        //休假中
        _statusImageView.image = [UIImage  imageNamed:@"CouponUN"];
    }else{
        if ([expertAnswer.DayUseCouponCount integerValue] >0) {
            //优惠券
            _moreStatusImageView.image = [UIImage  imageNamed:@"Freeclinic2"];
            if ([expertAnswer.IsDuty isEqual:@1]) {
                _statusImageView.image = [UIImage  imageNamed:@"doctor_duty"];
            }else {
                _statusImageView.image =nil;
                
            }
        }else{
            if ([expertAnswer.IsDuty isEqual:@1]) {
                _statusImageView.image = [UIImage  imageNamed:@"doctor_duty"];
            }else {
                _statusImageView.image = nil;
                
            }
        }
    }

    _containerView.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,5).rightSpaceToView(self.contentView,5);
    
    _statusImageView.sd_layout.topEqualToView(_containerView).rightSpaceToView(_containerView,10).widthIs(kFitWidthScale(139)).heightIs(kFitHeightScale(62));
    
    _iconbgImageView.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,10).widthIs(50).heightEqualToWidth();
    _iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    _icon.sd_layout.centerXEqualToView(_iconbgImageView).centerYEqualToView(_iconbgImageView).widthIs(45).heightEqualToWidth();
    _icon.sd_cornerRadiusFromWidthRatio = @(0.5);
    
//    CGFloat  doctorNameWidth = [JMFoundation  calLabelWidth:_doctorName];
    
    _doctorName.sd_layout.topSpaceToView(_containerView,43/2.0).leftSpaceToView(_iconbgImageView,10).autoHeightRatio(0).widthIs(kJMWidth(_doctorName));
    
    
    //    _moreStatusImageView.sd_layout.bottomSpaceToView(_doctorName,-17).leftSpaceToView(_doctorName,10).widthIs(126/2).heightIs(26/2);
    _moreStatusImageView.sd_layout.centerYEqualToView(_doctorName).leftSpaceToView(_doctorName,10).widthIs(126/2).heightIs(26/2);
    
    _lineView.sd_layout.topSpaceToView(_doctorName,12).heightIs(1).leftEqualToView(_doctorName).widthIs(25);
    _professionLabel.sd_layout.centerYEqualToView(_lineView).autoHeightRatio(0).leftSpaceToView(_lineView,0).rightSpaceToView(_containerView,0);
    
    _introduceTitle.sd_layout.leftEqualToView(_iconbgImageView).rightEqualToView(_iconbgImageView).topSpaceToView(_iconbgImageView,15).autoHeightRatio(0);
    
    [_introduceTitle updateLayout];
    _introduceLabel.sd_layout.topEqualToView(_introduceTitle).leftSpaceToView(_introduceTitle,3).rightSpaceToView(_containerView,10).heightRatioToView(_introduceTitle,2).maxHeightIs(_introduceTitle.height * 2.0).minHeightIs(_introduceTitle.height).autoHeightRatio(0);
    
    _fieldTitle.sd_layout.leftEqualToView(_introduceTitle).rightEqualToView(_introduceTitle).topSpaceToView(_introduceLabel,5).autoHeightRatio(0);
    
    [_fieldTitle updateLayout];
    _fieldLabel.sd_layout.topEqualToView(_fieldTitle).leftSpaceToView(_fieldTitle,3).rightEqualToView(_introduceLabel).maxHeightIs(_fieldTitle.height * 2.0).minHeightIs(_fieldTitle.height).autoHeightRatio(0);
    
    _questioncount.sd_layout.topSpaceToView(_fieldLabel,15).leftEqualToView(_iconbgImageView).widthIs(kJMWidth(_questioncount)).heightIs(14);

    _Answercount.sd_layout.topEqualToView(_questioncount).leftSpaceToView(_questioncount,15).widthIs(kJMWidth(_Answercount)).heightIs(14);
    _AvgTimeLabel.sd_layout.topEqualToView(_questioncount).rightSpaceToView(_containerView,15).widthIs(kJMWidth(_AvgTimeLabel)).heightIs(14);
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_questioncount,_Answercount,_AvgTimeLabel] bottomMargin:10];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}




@end
