//
//  HospitalCSCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalCSCell.h"
@interface HospitalCSCell (){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_firstLabel;
    UILabel *_secondLabel;
    UILabel *_thirdLabel;

}

@end
@implementation HospitalCSCell

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
    _thirdLabel.numberOfLines =0;
    _thirdLabel.font =[UIFont systemFontOfSize:15];
    _thirdLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_thirdLabel];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    backgroundIV.sd_layout.topSpaceToView(_containerView,20).leftSpaceToView(_containerView,30).rightSpaceToView(_containerView,30).bottomSpaceToView(_containerView,0);
    _titleLabel.sd_layout.topSpaceToView(_containerView,40).centerXEqualToView(_containerView).autoHeightRatio(0).widthIs(225);
    _firstLabel.sd_layout.topSpaceToView(_titleLabel,25).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _secondLabel.sd_layout.topSpaceToView(_firstLabel,5).leftSpaceToView(_containerView,45).autoHeightRatio(0).widthIs(225);
    _thirdLabel.sd_layout.topSpaceToView(_secondLabel,5).leftSpaceToView(_containerView,45).bottomSpaceToView(_containerView,20).autoHeightRatio(0).widthIs(225);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_thirdLabel] bottomMargin:20];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];


}

- (void)setGesellEntity:(GesellEntity *)gesellEntity{

    _gesellEntity =gesellEntity;

        if (gesellEntity.BEHAVIOR_ID ==1) {
            _titleLabel.text =@"适应性";
        }else if(gesellEntity.BEHAVIOR_ID ==2){
            _titleLabel.text =@"大运动";

        }else if(gesellEntity.BEHAVIOR_ID ==3){
            _titleLabel.text =@"精细运动";
            
        }else if(gesellEntity.BEHAVIOR_ID ==4){
            _titleLabel.text =@"语言";
            
        }else if(gesellEntity.BEHAVIOR_ID ==5){
            _titleLabel.text =@"社交";
            
        }
        _firstLabel.text =[NSString stringWithFormat:@"DA(月)：%.2f",gesellEntity.DA];
        _secondLabel.text =[NSString stringWithFormat:@"DQ：%.2f",gesellEntity.DQ];
        _thirdLabel.text =[NSString stringWithFormat:@"评价：%@",gesellEntity.JUDGEMENT];
//    _thirdLabel.text =@"卡机十大施工队杭师大吧时间的比较好吧2加班看见不健康不开机不看见不看见不大好吧2吧2好几百的痕迹不合并家会不会就不大好说被冻结后不结婚吧";


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
