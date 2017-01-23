//
//  HMenuCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HMenuCollectionViewCell.h"

#define kColumn 3
#define KW   33
#define KW_WIDTH    ([[UIScreen mainScreen] bounds].size.width-KW*4)/kColumn


@interface HMenuCollectionViewCell (){

    UIView* _contanierView;
    UIImageView* _menuImageView;
    UILabel* _titleLabel;
    
}

@end

@implementation HMenuCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        _contanierView = [UIView new];
        [self.contentView addSubview:_contanierView];
        
        _menuImageView = [UIImageView new];
        _menuImageView.userInteractionEnabled = YES;
        [_contanierView addSubview:_menuImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.font = [UIFont  systemFontOfSize:midFont];
        [_contanierView  addSubview: _titleLabel];

        _contanierView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        _menuImageView.sd_layout.topSpaceToView(_contanierView,15).centerXEqualToView(_contanierView).widthIs(_imageHeight).heightIs(_imageHeight);
        
        _titleLabel.sd_layout.topSpaceToView(_menuImageView,15).leftEqualToView(_contanierView).rightEqualToView(_contanierView).heightIs(14);
        
        [_contanierView setupAutoHeightWithBottomView:_titleLabel bottomMargin:15];
        
        
    }
    return self ;
}

-(void)initCellWith:(NSDictionary *)dic{

    _menuImageView.image = [UIImage imageNamed:dic[@"image"]];
    _titleLabel.text = dic[@"title"];
}

- (void)setImageHeight:(CGFloat)imageHeight{
    _imageHeight =imageHeight;
    
    _menuImageView.sd_layout.topSpaceToView(_contanierView,15).centerXEqualToView(_contanierView).widthIs(_imageHeight).heightIs(_imageHeight);}

@end
