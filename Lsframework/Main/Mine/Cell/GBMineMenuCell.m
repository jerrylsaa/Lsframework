//
//  GBMineMenuCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//
#define x_titleSpace   10
#define imageHeight   64/2
#define titleHeight   36/2

#define x_heightSpace    (([[UIScreen mainScreen] bounds].size.width-1*2)/3-imageHeight-titleHeight-x_titleSpace)/2


#import "GBMineMenuCell.h"

@implementation GBMineMenuCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self   setupSubviews];
    }
    return self ;
}
-(void)setupSubviews{

    _bgImageView = [UIImageView  new];
    _bgImageView.backgroundColor = [UIColor  whiteColor];
    _bgImageView.userInteractionEnabled = YES;
    [self.contentView  addSubview:_bgImageView];

    _menuImageView = [UIImageView  new];
    _menuImageView.backgroundColor = [UIColor  clearColor];
    _menuImageView.userInteractionEnabled = YES;
    [self.bgImageView  addSubview:_menuImageView];
    
    _menuTitle = [UILabel  new];
    _menuTitle.textAlignment = NSTextAlignmentCenter;
    _menuTitle.font = [UIFont  systemFontOfSize:36/2];
    _menuTitle.textColor = UIColorFromRGB(0x666666);
    [self.bgImageView  addSubview:_menuTitle];
   
    
    _bgImageView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).widthIs((kScreenWidth-1*2)/3).heightEqualToWidth();
    _menuImageView.sd_layout.centerXEqualToView(_bgImageView).topSpaceToView(_bgImageView,x_heightSpace).widthIs(imageHeight).heightEqualToWidth();
    
    _menuTitle.sd_layout.topSpaceToView(_menuImageView,x_titleSpace).centerXEqualToView(_bgImageView).widthIs(titleHeight*4).heightIs(titleHeight);
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
