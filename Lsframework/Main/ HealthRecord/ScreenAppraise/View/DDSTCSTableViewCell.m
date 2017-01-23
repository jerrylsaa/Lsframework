//
//  DDSTCSTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DDSTCSTableViewCell.h"
@interface DDSTCSTableViewCell (){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_firstLabel;
    UILabel *_secondLabel;

    
}

@end
@implementation DDSTCSTableViewCell

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
    _secondLabel.numberOfLines =0;
    _secondLabel.font =[UIFont systemFontOfSize:15];
    _secondLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_secondLabel];

    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    backgroundIV.sd_layout.topSpaceToView(_containerView,20).leftSpaceToView(_containerView,30).rightSpaceToView(_containerView,30).bottomSpaceToView(_containerView,0);
    _titleLabel.sd_layout.topSpaceToView(_containerView,40).centerXEqualToView(_containerView).autoHeightRatio(0).widthIs(225);
    _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _secondLabel.sd_layout.topSpaceToView(_firstLabel,5).leftSpaceToView(_containerView,45).bottomSpaceToView(_containerView,20).autoHeightRatio(0).widthIs(225);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_secondLabel] bottomMargin:20];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}

- (void)setDdstEntity:(DDSTEntity *)ddstEntity{
    _ddstEntity =ddstEntity;
    
    _titleLabel.text =@"测试项目";
    _firstLabel.text =[NSString stringWithFormat:@"儿童年龄(月)：%d",ddstEntity.MONTHAGE];;
    _secondLabel.text =[NSString stringWithFormat:@"评价：%@",ddstEntity.JUDGEMENT];
    //    _firstLabel.text =@"卡上的敬爱个的好几个👌1好几个会变得很就AV的扣进不去我看不懂话不好不回家比较好打保时捷的撒旦";
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end