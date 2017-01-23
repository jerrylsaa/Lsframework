//
//  ChildrenTwentyCSTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChildrenTwentyCSTableViewCell.h"
@interface ChildrenTwentyCSTableViewCell (){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_firstLabel;
    UILabel *_secondLabel;
    UILabel *_thirdLabel;
    UILabel *_fourthLabel;
    UILabel *_fifthLabel;

    UILabel *_sixthLabel;

    UILabel *_seventhLabel;

    UILabel *_eighthLabel;

    UILabel *_ninthLabel;
    UILabel *_tenthLabel;
    UILabel *_eleventhLabel;
    UILabel *_twelfthLabel;
    
    UILabel *_hospitalLabel;
    UILabel *_doctorLabel;
}
@end
@implementation ChildrenTwentyCSTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        self.backgroundColor =[UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.contentView.backgroundColor =[UIColor clearColor];
    _containerView = [UIView new];
    _containerView.backgroundColor =[UIColor clearColor];
    
    [self.contentView addSubview:_containerView];
    
    UIImageView *backgroundIV =[UIImageView new];
    backgroundIV.backgroundColor =[UIColor clearColor];
    backgroundIV.image =[UIImage imageNamed:@"HospitalCPBGIV"];
    [_containerView addSubview:backgroundIV];
    
    _titleLabel =[UILabel new];
    _titleLabel.textAlignment =NSTextAlignmentCenter;
    _titleLabel.font =[UIFont systemFontOfSize:16];
    _titleLabel.textColor =UIColorFromRGB(0x27b3ae);
    [_containerView addSubview:_titleLabel];
    
    _firstLabel =[UILabel new];
    _firstLabel.numberOfLines =0;
    _firstLabel.font =[UIFont systemFontOfSize:15];
    _firstLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_firstLabel];
    
    _secondLabel =[UILabel new];
    _secondLabel.numberOfLines =0;
    _secondLabel.font =[UIFont systemFontOfSize:15];
    _secondLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_secondLabel];
    
    _thirdLabel =[UILabel new];
    _thirdLabel.numberOfLines =0;
    _thirdLabel.font =[UIFont systemFontOfSize:15];
    _thirdLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_thirdLabel];
    
    _fourthLabel =[UILabel new];
    _fourthLabel.numberOfLines =0;
    _fourthLabel.font =[UIFont systemFontOfSize:15];
    _fourthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_fourthLabel];
    
    _fifthLabel =[UILabel new];
    _fifthLabel.numberOfLines =0;
    _fifthLabel.font =[UIFont systemFontOfSize:15];
    _fifthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_fifthLabel];
    
    _sixthLabel =[UILabel new];
    _sixthLabel.numberOfLines =0;
    _sixthLabel.font =[UIFont systemFontOfSize:15];
    _sixthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_sixthLabel];
    
    _seventhLabel =[UILabel new];
    _seventhLabel.numberOfLines =0;
    _seventhLabel.font =[UIFont systemFontOfSize:15];
    _seventhLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_seventhLabel];
    
    _eighthLabel =[UILabel new];
    _eighthLabel.numberOfLines =0;
    _eighthLabel.font =[UIFont systemFontOfSize:15];
    _eighthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_eighthLabel];

    _ninthLabel =[UILabel new];
    _ninthLabel.numberOfLines =0;
    _ninthLabel.font =[UIFont systemFontOfSize:15];
    _ninthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_ninthLabel];

    _tenthLabel =[UILabel new];
    _tenthLabel.numberOfLines =0;
    _tenthLabel.font =[UIFont systemFontOfSize:15];
    _tenthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_tenthLabel];

    _eleventhLabel =[UILabel new];
    _eleventhLabel.numberOfLines =0;
    _eleventhLabel.font =[UIFont systemFontOfSize:15];
    _eleventhLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_eleventhLabel];

    _twelfthLabel =[UILabel new];
    _twelfthLabel.numberOfLines =0;
    _twelfthLabel.font =[UIFont systemFontOfSize:15];
    _twelfthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_twelfthLabel];
    
    _hospitalLabel =[UILabel new];
    _hospitalLabel.font =[UIFont systemFontOfSize:15];
    _hospitalLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_hospitalLabel];

    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    backgroundIV.sd_layout.topSpaceToView(_containerView,20).leftSpaceToView(_containerView,30).rightSpaceToView(_containerView,30).bottomSpaceToView(_containerView,0);
    _titleLabel.sd_layout.topSpaceToView(_containerView,40).centerXEqualToView(_containerView).autoHeightRatio(0).widthIs(225);
    _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _secondLabel.sd_layout.topSpaceToView(_firstLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _thirdLabel.sd_layout.topSpaceToView(_secondLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _fourthLabel.sd_layout.topSpaceToView(_thirdLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _fifthLabel.sd_layout.topSpaceToView(_fourthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _sixthLabel.sd_layout.topSpaceToView(_fifthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _seventhLabel.sd_layout.topSpaceToView(_sixthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _eighthLabel.sd_layout.topSpaceToView(_seventhLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _ninthLabel.sd_layout.topSpaceToView(_eighthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _tenthLabel.sd_layout.topSpaceToView(_ninthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _eleventhLabel.sd_layout.topSpaceToView(_tenthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _twelfthLabel.sd_layout.topSpaceToView(_eleventhLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    
    _hospitalLabel.sd_layout.topSpaceToView(_twelfthLabel,15).leftSpaceToView(_containerView,45).bottomSpaceToView(_containerView,20).autoHeightRatio(0).widthIs(200);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_hospitalLabel] bottomMargin:20];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}

- (void)setChild20Entity:(ChildrenTwentyEntity *)child20Entity{
    _child20Entity =child20Entity;
    
    _titleLabel.text =@"测试项目";
    
    if (!(child20Entity.RESULT1 ==nil||[child20Entity.RESULT1 isEqualToString:@""])) {
        _firstLabel.text =[NSString stringWithFormat:@"1月份：%@",child20Entity.RESULT1];
    }else {
        _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT2 ==nil||[child20Entity.RESULT2 isEqualToString:@""])) {
        _secondLabel.text =[NSString stringWithFormat:@"2月份：%@",child20Entity.RESULT2];;
    }else {
        _secondLabel.sd_layout.topSpaceToView(_firstLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT3 ==nil||[child20Entity.RESULT3 isEqualToString:@""])) {
        _thirdLabel.text =[NSString stringWithFormat:@"3月份：%@",child20Entity.RESULT3];;
    }else {
        _thirdLabel.sd_layout.topSpaceToView(_secondLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT4 ==nil||[child20Entity.RESULT4 isEqualToString:@""])) {
        _fourthLabel.text =[NSString stringWithFormat:@"4月份：%@",child20Entity.RESULT4];;
    }else {
        _fourthLabel.sd_layout.topSpaceToView(_thirdLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT5 ==nil||[child20Entity.RESULT5 isEqualToString:@""])) {
        _fifthLabel.text =[NSString stringWithFormat:@"5月份：%@",child20Entity.RESULT5];;
    }else {
        _fifthLabel.sd_layout.topSpaceToView(_fourthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT6 ==nil||[child20Entity.RESULT6 isEqualToString:@""])) {
        _sixthLabel.text =[NSString stringWithFormat:@"6月份：%@",child20Entity.RESULT6];;
    }else {
        _sixthLabel.sd_layout.topSpaceToView(_fifthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT7 ==nil||[child20Entity.RESULT7 isEqualToString:@""])) {
        _seventhLabel.text =[NSString stringWithFormat:@"7月份：%@",child20Entity.RESULT7];;
    }else {
        _seventhLabel.sd_layout.topSpaceToView(_sixthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT8 ==nil||[child20Entity.RESULT8 isEqualToString:@""])) {
        _eighthLabel.text =[NSString stringWithFormat:@"8月份：%@",child20Entity.RESULT8];;
    }else {
        _eighthLabel.sd_layout.topSpaceToView(_seventhLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT9 ==nil||[child20Entity.RESULT9 isEqualToString:@""])) {
        _ninthLabel.text =[NSString stringWithFormat:@"9月份：%@",child20Entity.RESULT9];;
    }else {
        _ninthLabel.sd_layout.topSpaceToView(_eighthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT10 ==nil||[child20Entity.RESULT10 isEqualToString:@""])) {
        _tenthLabel.text =[NSString stringWithFormat:@"10月份：%@",child20Entity.RESULT10];;
    }else {
        _tenthLabel.sd_layout.topSpaceToView(_ninthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT11 ==nil||[child20Entity.RESULT11 isEqualToString:@""])) {
        _eleventhLabel.text =[NSString stringWithFormat:@"11月份：%@",child20Entity.RESULT11];;
    }else {
        _eleventhLabel.sd_layout.topSpaceToView(_tenthLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    
    if (!(child20Entity.RESULT12 ==nil||[child20Entity.RESULT12 isEqualToString:@""])) {
        _twelfthLabel.text =[NSString stringWithFormat:@"12月份：%@",child20Entity.RESULT12];;
    }else {
        _twelfthLabel.sd_layout.topSpaceToView(_eleventhLabel,0).leftSpaceToView(_containerView,45).heightIs(0).widthIs(200);
    }
    if (!(child20Entity.HName ==nil||[child20Entity.HName isEqualToString:@""])) {
        _hospitalLabel.text =[NSString stringWithFormat:@"测试医院：%@",child20Entity.HName];;
    }
    
//    _secondLabel.text =[NSString stringWithFormat:@"认知能力:%.2f",exlbEntity.rznl];
//    _thirdLabel.text =[NSString stringWithFormat:@"语言能力:%.2f",exlbEntity.yynl];
//    _fourthLabel.text =[NSString stringWithFormat:@"社交行为:%.2f",exlbEntity.sjxw];
//    _fifthLabel.text =[NSString stringWithFormat:@"粗大运动:%.2f",exlbEntity.cdyd];
//    
//    _sixthLabel.text =[NSString stringWithFormat:@"评价:%@",exlbEntity.result];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
