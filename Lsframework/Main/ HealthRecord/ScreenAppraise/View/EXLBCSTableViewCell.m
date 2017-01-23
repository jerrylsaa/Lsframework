//
//  EXLBCSTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "EXLBCSTableViewCell.h"
@interface EXLBCSTableViewCell (){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_firstLabel;
    UILabel *_secondLabel;
    UILabel *_thirdLabel;
    UILabel *_fourthLabel;
    UILabel *_fifthLabel;
    UILabel *_sixthLabel;
}

@end
@implementation EXLBCSTableViewCell

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
    _firstLabel.font =[UIFont systemFontOfSize:15];
    _firstLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_firstLabel];
    
    _secondLabel =[UILabel new];
    _secondLabel.font =[UIFont systemFontOfSize:15];
    _secondLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_secondLabel];
    
    _thirdLabel =[UILabel new];
    _thirdLabel.font =[UIFont systemFontOfSize:15];
    _thirdLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_thirdLabel];
    
    _fourthLabel =[UILabel new];
    _fourthLabel.font =[UIFont systemFontOfSize:15];
    _fourthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_fourthLabel];
    
    _fifthLabel =[UILabel new];
    _fifthLabel.font =[UIFont systemFontOfSize:15];
    _fifthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_fifthLabel];
    
    _sixthLabel =[UILabel new];
    _sixthLabel.numberOfLines=0;
    _sixthLabel.font =[UIFont systemFontOfSize:15];
    _sixthLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_sixthLabel];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    backgroundIV.sd_layout.topSpaceToView(_containerView,20).leftSpaceToView(_containerView,30).rightSpaceToView(_containerView,30).bottomSpaceToView(_containerView,0);
    _titleLabel.sd_layout.topSpaceToView(_containerView,40).centerXEqualToView(_containerView).autoHeightRatio(0).widthIs(225);
    _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _secondLabel.sd_layout.topSpaceToView(_firstLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _thirdLabel.sd_layout.topSpaceToView(_secondLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _fourthLabel.sd_layout.topSpaceToView(_thirdLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _fifthLabel.sd_layout.topSpaceToView(_fourthLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _sixthLabel.sd_layout.topSpaceToView(_fifthLabel,5).leftSpaceToView(_containerView,45).bottomSpaceToView(_containerView,20).autoHeightRatio(0).widthIs(200);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_sixthLabel] bottomMargin:20];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}

- (void)setExlbEntity:(EXLBEntity *)exlbEntity{
    _exlbEntity =exlbEntity;
    
    _titleLabel.text =@"测试项目";
    
    _firstLabel.text =[NSString stringWithFormat:@"精细运动：%.2f",exlbEntity.jxyd];
    _secondLabel.text =[NSString stringWithFormat:@"认知能力：%.2f",exlbEntity.rznl];
    _thirdLabel.text =[NSString stringWithFormat:@"语言能力：%.2f",exlbEntity.yynl];
    _fourthLabel.text =[NSString stringWithFormat:@"社交行为：%.2f",exlbEntity.sjxw];
    _fifthLabel.text =[NSString stringWithFormat:@"粗大运动：%.2f",exlbEntity.cdyd];
    
    _sixthLabel.text =[NSString stringWithFormat:@"评价：%@",exlbEntity.result];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
