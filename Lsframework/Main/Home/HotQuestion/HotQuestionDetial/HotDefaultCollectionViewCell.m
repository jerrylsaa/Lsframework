//
//  HotDefaultCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/10/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDefaultCollectionViewCell.h"

@implementation HotDefaultCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self  setupSubView];
    }



    return self;
}

-(void)setupSubView{
    _defaultImageView = [UIImageView new];
    _defaultImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_defaultImageView];
    
    _defaultImageView.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthRatioToView(self.contentView,0.76).heightEqualToWidth();
}
@end
