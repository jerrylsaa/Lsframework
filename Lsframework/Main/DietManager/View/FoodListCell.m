//
//  FoodListCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FoodListCell.h"
@interface FoodListCell (){
    
    UIView* _contanierView;
    UIImageView* _menuImageView;
    UILabel* _titleLabel;
    
}

@end
@implementation FoodListCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        _contanierView = [UIView new];
        _contanierView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:_contanierView];
        
        _menuImageView = [UIImageView new];
        _menuImageView.image =[UIImage imageNamed:@"foodListCellBG"];
        [_contanierView addSubview:_menuImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x61d8d3);
        if (kScreenWidth<569) {
            _titleLabel.font = [UIFont  systemFontOfSize:10.0f];
        }else{
            _titleLabel.font = [UIFont  systemFontOfSize:12.0f];
        }
        [_contanierView  addSubview: _titleLabel];
        
        _contanierView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
        _menuImageView.sd_layout.topSpaceToView(_contanierView,5).leftSpaceToView(_contanierView,0).rightSpaceToView(_contanierView,0).bottomSpaceToView(_contanierView,5);
        
        _titleLabel.sd_layout.topSpaceToView(_contanierView,0).leftSpaceToView(_contanierView,5).rightSpaceToView(_contanierView,5).bottomSpaceToView(_contanierView,0);
        
        
        
        
    }
    return self ;
}

- (void)setHotKeyEntity:(DMHotKeyEntity *)hotKeyEntity{
    _hotKeyEntity =hotKeyEntity;
    _titleLabel.text =hotKeyEntity.KEYWORD;
}
@end
