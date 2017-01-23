//
//  GBexpertTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBexpertTableViewCell.h"
#import "JMFoundation.h"
@interface   GBexpertTableViewCell(){
    UIView* _containerView;
    
    UIImageView  *_backRoundImageView;
    
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
    
    UIView* bottomLine;
}
@end
@implementation GBexpertTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    _containerView.userInteractionEnabled = YES;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.borderWidth = 1;
    _containerView.layer.cornerRadius = 10;
    _containerView.backgroundColor = UIColorFromRGB(0xffffff);
    _containerView.layer.borderColor =  UIColorFromRGB(0xe5e5e5).CGColor;
    [self.contentView addSubview:_containerView];
    
    
//    _backRoundImageView =[UIImageView new];
//    _backRoundImageView.userInteractionEnabled = YES;
//    _backRoundImageView.backgroundColor = [uic]
//    _iconbgImageView.layer.masksToBounds = YES;
//    _iconbgImageView.layer.borderWidth = 1;
//    _iconbgImageView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
//    [_containerView addSubview:_backRoundImageView];

    
    _iconbgImageView = [UIImageView new];
    _iconbgImageView.userInteractionEnabled = YES;
    _iconbgImageView.backgroundColor = UIColorFromRGB(0xffffff);
    _iconbgImageView.layer.masksToBounds = YES;
    _iconbgImageView.layer.borderWidth = 1;
    _iconbgImageView.layer.borderColor = UIColorFromRGB(0x37e0ce).CGColor;
    [_containerView addSubview:_iconbgImageView];
    
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [_containerView addSubview:_icon];
    
    _doctorName = [UILabel new];
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
    

    _questioncount = [UILabel new];
    _questioncount.textColor =  UIColorFromRGB(0x999999);
    _questioncount.font = _professionLabel.font;
    _questioncount.textAlignment = NSTextAlignmentLeft;
    [_containerView addSubview:_questioncount];
    
    _Answercount = [UILabel new];
    _Answercount.textColor =  UIColorFromRGB(0x999999);
    _Answercount.font = _professionLabel.font;
    _Answercount.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_Answercount];


    
    //    _fieldTitle = [UILabel new];
    //    _fieldTitle.textColor = UIColorFromRGB(0x61d8d3);
    //    _fieldTitle.text = @"领域：";
    //    _fieldTitle.textAlignment = NSTextAlignmentCenter;
    //    _fieldTitle.font = _introduceTitle.font;
    //    [_containerView addSubview:_fieldTitle];
    //
    //    _fieldLabel = [UILabel new];
    //    _fieldLabel.textColor = UIColorFromRGB(0x999999);
    //    _fieldLabel.font = _introduceLabel.font;
    //    [_containerView addSubview:_fieldLabel];
    
    bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:bottomLine];
    bottomLine.hidden = YES;
    
    _containerView.sd_layout.topSpaceToView(self.contentView,12.5).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15);
    _iconbgImageView.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,10).widthIs(50).heightEqualToWidth();
    _iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    _icon.sd_layout.centerXEqualToView(_iconbgImageView).centerYEqualToView(_iconbgImageView).widthIs(45).heightEqualToWidth();
    _icon.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _doctorName.sd_layout.topSpaceToView(_containerView,43/2.0).leftSpaceToView(_iconbgImageView,10).autoHeightRatio(0).rightSpaceToView(_containerView,0);
    _lineView.sd_layout.topSpaceToView(_doctorName,12).heightIs(1).leftEqualToView(_doctorName).widthIs(25);
    _professionLabel.sd_layout.centerYEqualToView(_lineView).autoHeightRatio(0).leftSpaceToView(_lineView,0).rightSpaceToView(_containerView,0);
    
    _introduceTitle.sd_layout.leftEqualToView(_iconbgImageView).rightEqualToView(_iconbgImageView).topSpaceToView(_iconbgImageView,15).autoHeightRatio(0);
    
    [_introduceTitle updateLayout];
    _introduceLabel.sd_layout.topEqualToView(_introduceTitle).leftSpaceToView(_introduceTitle,3).rightSpaceToView(_containerView,10).heightRatioToView(_introduceTitle,2).maxHeightIs(_introduceTitle.height * 2.0).minHeightIs(_introduceTitle.height).autoHeightRatio(0);
    
//   CGFloat  questionWidth = [JMFoundation calLabelHeight:_WordContentMessage.font andStr:_WordContentMessage.text withWidth:(kScreenWidth - 100)];
    CGFloat  questionWidth = [JMFoundation  calLabelWidth:_questioncount.font andStr:_questioncount.text withHeight:14];
    
    _questioncount.sd_layout.topSpaceToView(_introduceLabel,15).leftEqualToView(_iconbgImageView).widthIs(questionWidth).heightIs(14);
    CGFloat  AnswerWidth = [JMFoundation  calLabelWidth:_Answercount.font andStr:_Answercount.text withHeight:14];
    _Answercount.sd_layout.topEqualToView(_questioncount).rightSpaceToView(_containerView,15).widthIs(AnswerWidth).heightIs(14);
    //    _fieldTitle.sd_layout.leftEqualToView(_introduceTitle).rightEqualToView(_introduceTitle).topSpaceToView(_introduceLabel,5).autoHeightRatio(0);
    //
    //    [_fieldTitle updateLayout];
    //    _fieldLabel.sd_layout.topEqualToView(_fieldTitle).leftSpaceToView(_fieldTitle,3).rightEqualToView(_introduceLabel).maxHeightIs(_fieldTitle.height * 2.0).minHeightIs(_fieldTitle.height).autoHeightRatio(0);
    
    
    //    _fieldLabel.backgroundColor = [UIColor redColor];
    //    _introduceLabel.backgroundColor = [UIColor redColor];
    //    _fieldTitle.backgroundColor = [UIColor redColor];
    //    _introduceTitle.backgroundColor = [UIColor redColor];
    
    //    [_containerView setupAutoHeightWithBottomViewsArray:@[_fieldTitle,_fieldLabel] bottomMargin:10];
//    bottomLine.sd_layout.bottomSpaceToView(_containerView,0).leftSpaceToView(_containerView,10).rightSpaceToView(_containerView,0).heightIs(1);
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_questioncount,_Answercount] bottomMargin:10];
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    
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
    
    CGFloat  questionWidth = [JMFoundation  calLabelWidth:_questioncount.font andStr:_questioncount.text withHeight:14];
    
    CGFloat  AnswerWidth = [JMFoundation  calLabelWidth:_Answercount.font andStr:_Answercount.text withHeight:14];
    
    
    _questioncount.width =questionWidth;
    _Answercount.width =AnswerWidth;
    
    [_questioncount updateLayout];
    [_Answercount updateLayout];
    
}


-(void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    
    bottomLine.hidden = !showBottomLine;
}





@end
