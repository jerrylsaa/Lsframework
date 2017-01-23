//
//  MoreFunctionCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//
#define xSpace ([[UIScreen mainScreen] bounds].size.width-3*kFitWidthScale(214))/4
#define ySpace  ([[UIScreen mainScreen] bounds].size.width-3*kFitWidthScale(214))/4
#define  k_width   kFitWidthScale(214)
#define  k_height  kFitHeightScale(214)

#import "MoreFunctionCollectionViewCell.h"
@implementation MoreFunctionCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super  initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
    
}
-(void)setupSubviews{
    self.imageView = [UIImageView new];
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    self.imageView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).widthIs(k_width).heightIs(k_height);
    
    [self.contentView  setupAutoHeightWithBottomView:self.imageView bottomMargin:0];
    
}

@end
