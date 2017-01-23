//
//  ServiceTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    //headerview
    UIView* headerView=[UIView new];
    headerView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:headerView];
    
    //头像
    _iconImage=[UIImageView new];
    _iconImage.userInteractionEnabled=YES;
    [self.contentView addSubview:_iconImage];
    
    //标题
    _titleLabel=[UILabel new];
    _titleLabel.font=[UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor=UIColorFromRGB(0x62CEC0);
    [self.contentView addSubview:_titleLabel];
    
    //副标题
    _detailLabel=[UILabel new];
    _detailLabel.font=[UIFont systemFontOfSize:16];
    _detailLabel.textColor=UIColorFromRGB(0x535353);
    [self.contentView addSubview:_detailLabel];
    
    headerView.sd_layout.topSpaceToView(self.contentView,0).heightIs(15).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    CGFloat height = 85/2.0;
    if(kScreenHeight==480){
        height =50/2.0 ;
    }
    
    _iconImage.sd_layout.topSpaceToView(headerView,10).heightIs(150/2.0).leftSpaceToView(self.contentView,height).widthEqualToHeight();
    
    _titleLabel.sd_layout.topSpaceToView(headerView,26).heightIs(20).leftSpaceToView(_iconImage,20).maxWidthIs(200);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _detailLabel.sd_layout.topSpaceToView(_titleLabel,10).heightIs(16).leftEqualToView(_titleLabel).maxWidthIs(200);
    [_detailLabel setSingleLineAutoResizeWithMaxWidth:200];
    

    [self setupAutoHeightWithBottomView:_iconImage bottomMargin:10];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text=title;
}

-(void)setDetail:(NSString *)detail{
    _detail = detail;
    _detailLabel.text=detail;
}

-(void)setIconName:(NSString *)iconName{
    _iconName=iconName;
    _iconImage.image=[UIImage imageNamed:iconName];
}

@end
