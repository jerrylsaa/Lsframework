//
//  BabyFoodTIpsCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BabyFoodTIpsCell.h"
@interface BabyFoodTIpsCell (){
    
    UIView* _contanierView;
    
    UILabel* _titleLabel;
    
}

@end
@implementation BabyFoodTIpsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self){
        
        _contanierView = [UIView new];
        _contanierView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:_contanierView];
        
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.numberOfLines =0;
        _titleLabel.font = [UIFont  systemFontOfSize:14.0f];
        
        [_contanierView  addSubview: _titleLabel];
        
        _contanierView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
        
        _titleLabel.sd_layout.topSpaceToView(_contanierView,0).leftSpaceToView(_contanierView,15).rightSpaceToView(_contanierView,15).bottomSpaceToView(_contanierView,0).autoHeightRatio(0);
        [_contanierView setupAutoHeightWithBottomView:_titleLabel bottomMargin:0];
        [self setupAutoHeightWithBottomView:_contanierView bottomMargin:15];
        
    }
    return self ;
}

- (void)setMyTips:(BabyFoodTipsEntity *)myTips{
    _myTips =myTips;
    _titleLabel.text =[NSString stringWithFormat:@"%@:%@",myTips.TYPE_NAME,myTips.ADVICE];
}

@end
