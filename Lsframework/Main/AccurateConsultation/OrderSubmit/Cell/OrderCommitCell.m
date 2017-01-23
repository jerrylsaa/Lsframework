//
//  OrderCommitCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "OrderCommitCell.h"
#import "UIImage+Category.h"

@implementation OrderCommitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
//    _titleLabel=[UILabel new];
//    _titleLabel.font=[UIFont systemFontOfSize:18];
//    _titleLabel.textColor=UIColorFromRGB(0x666666);
//    _titleLabel.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:_titleLabel];
//    
//    _titleLabel.sd_layout.topSpaceToView(self,15).bottomSpaceToView(self,15).leftSpaceToView(self,0).rightSpaceToView(self,0);
    
    _title=[UIButton new];
    _title.titleLabel.font=[UIFont systemFontOfSize:18];
    _title.titleLabel.textColor=UIColorFromRGB(0x666666);
    [_title setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf2f2f2)] forState:UIControlStateNormal];
    [_title setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xdbdbdb)] forState:UIControlStateHighlighted];
    [_title setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [self addSubview:_title];
    _title.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).leftSpaceToView(self,0).rightSpaceToView(self,0);

    
}


@end
