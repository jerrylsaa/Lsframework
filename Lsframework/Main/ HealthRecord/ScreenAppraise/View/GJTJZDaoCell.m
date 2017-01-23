//
//  GJTJZDaoCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GJTJZDaoCell.h"
@interface GJTJZDaoCell (){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_firstLabel;
    UILabel *_hospitalLabel;
    
}
@end
@implementation GJTJZDaoCell

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

    
    _hospitalLabel =[UILabel new];
    _hospitalLabel.font =[UIFont systemFontOfSize:15];
    _hospitalLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_hospitalLabel];
    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    backgroundIV.sd_layout.topSpaceToView(_containerView,20).leftSpaceToView(_containerView,30).rightSpaceToView(_containerView,30).bottomSpaceToView(_containerView,0);
    _titleLabel.sd_layout.topSpaceToView(_containerView,40).centerXEqualToView(_containerView).autoHeightRatio(0).widthIs(225);
    _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    
    
    _hospitalLabel.sd_layout.topSpaceToView(_firstLabel,15).leftSpaceToView(_containerView,45).bottomSpaceToView(_containerView,20).autoHeightRatio(0).widthIs(225);
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_hospitalLabel] bottomMargin:20];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}

- (void)setXllbEntity:(XLLBEntity *)xllbEntity{
    _xllbEntity =xllbEntity;
    _titleLabel.text =@"医生指导";
    _firstLabel.text =[NSString stringWithFormat:@"医生指导意见：%@",xllbEntity.Doctor_Result];
    
    _hospitalLabel.text =[NSString stringWithFormat:@"测试医院：%@",xllbEntity.HName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
