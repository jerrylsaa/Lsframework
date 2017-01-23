//
//  BabayCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BabayCollectionViewCell.h"


@interface BabayCollectionViewCell (){
    UIImageView* _iconbgImageView;
}

@end

@implementation BabayCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        _icon = [UIImageView new];
        _icon.userInteractionEnabled = YES;
        [self.contentView addSubview:_icon];
        
        _iconbgImageView = [UIImageView new];
        _iconbgImageView.userInteractionEnabled = YES;
        _iconbgImageView.image = [UIImage imageNamed:@"GB_ICON-Background"];
        [self.contentView addSubview:_iconbgImageView];
        
        _name = [UILabel new];
        _name.font = [UIFont systemFontOfSize:16];
        _name.textColor = UIColorFromRGB(0x535353);
        _name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_name];
        
        _icon.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightEqualToWidth();
        _icon.sd_cornerRadiusFromWidthRatio = @0.5;
        _iconbgImageView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightEqualToWidth();
        _iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;

        _name.sd_layout.topSpaceToView(_icon,0).leftEqualToView(self.contentView).rightEqualToView(self.contentView).autoHeightRatio(0);
        
//        [self setupAutoHeightWithBottomView:_name bottomMargin:0];
        
        
    }
    return self ;
}




@end
