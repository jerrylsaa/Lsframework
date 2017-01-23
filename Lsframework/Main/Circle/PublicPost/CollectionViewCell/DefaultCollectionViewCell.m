//
//  DefaultCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DefaultCollectionViewCell.h"

@implementation DefaultCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        _defaultImageView = [UIImageView new];
        _defaultImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_defaultImageView];
        
        _defaultImageView.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthRatioToView(self.contentView,0.76).heightEqualToWidth();
        
        
    }
    return self ;
}


@end
