//
//  SingleFlowView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SingleFlowView.h"

@implementation SingleFlowView

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel=[UILabel new];
    _titleLabel.textColor=UIColorFromRGB(0x666666);
    _titleLabel.font=[UIFont systemFontOfSize:18];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _imageView=[UIImageView new];
    _imageView.image=[UIImage imageNamed:@"narrow"];
    [self addSubview:_imageView];
    
    _titleLabel.sd_layout.topSpaceToView(self,0).heightIs(20).leftSpaceToView(self,0).rightSpaceToView(self,0);
    
    _imageView.sd_layout.topSpaceToView(_titleLabel,10).heightIs(20).centerXEqualToView(self).widthEqualToHeight();
}

-(void)setIsHiddenNarrow:(BOOL)isHiddenNarrow{
    _isHiddenNarrow=isHiddenNarrow;
    _imageView.hidden=isHiddenNarrow;
}


@end
