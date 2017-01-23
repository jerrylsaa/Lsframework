//
//  HospitalScrAprCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalScrAprCell.h"

@implementation HospitalScrAprCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super  initWithFrame:frame]) {
        
        [self setupSubviews];
        
    }
    return self;
    
}
-(void)setupSubviews{
    self.imageView = [UIImageView new];
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    self.cellName = [UILabel  new];
    CGFloat  font = 16;
    if (kScreenHeight  <= 568) {
        font = 14;
    }
    
    self.cellName.font = [UIFont  systemFontOfSize:font];
    self.cellName.textAlignment = NSTextAlignmentLeft;
    self.cellName.numberOfLines = 0 ;
    self.cellName.backgroundColor = [UIColor  clearColor];
    self.cellName.textColor = UIColorFromRGB(0x129598);
    [self.imageView  addSubview:self.cellName];
    int  k_width = ([UIScreen mainScreen].bounds.size.width-55)/2;
    int  k_height = 0.375*k_width;
    
    self.imageView.sd_layout.topSpaceToView(self.contentView,0  ).leftSpaceToView(self.contentView,0).widthIs(self.contentView.self.width).heightIs(self.contentView.size.height);
    
    self.cellName.sd_layout.centerYEqualToView(self.imageView).leftSpaceToView(self.imageView,k_width*(60+5)/160).widthIs(k_width*(160-(60+5+20-10))/160).heightIs(0.75*k_height);
}

@end
