//
//  HelfPriceCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HelfPriceCell.h"

@interface HelfPriceCell ()


@property(nonatomic, strong) UIButton *deleteButton;

@end

@implementation HelfPriceCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}


- (void)setupSubView{
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    _imageView.sd_layout.leftSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(50).heightIs(45);
    _imageView.sd_cornerRadius = @2.5;
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"circle_del_icon1"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    _deleteButton.sd_layout.rightSpaceToView(self,0).topSpaceToView(self,0).widthIs(15).heightIs(15);
    
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (void)setIsDelete:(BOOL)isDelete{
    if (isDelete == YES) {
        _deleteButton.hidden = NO;
        _imageView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
        _imageView.layer.borderWidth = 1.f;
    }else{
        _deleteButton.hidden = YES;
        _imageView.layer.borderColor = [UIColor clearColor].CGColor;
        _imageView.layer.borderWidth = 0.f;
    }
}

- (void)deleteAction{
    if (self.delegate) {
        [self.delegate deleteImageAtIndexPath:self.sd_indexPath];
    }
}

@end
