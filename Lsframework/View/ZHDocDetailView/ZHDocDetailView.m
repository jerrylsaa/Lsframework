//
//  ZHDocDetailView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHDocDetailView.h"

@implementation ZHDocDetailView


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)initSubViews{
    
    _iconView = [UIImageView new];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconView];
    _iconView.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(self.height);
    _textLabel = [UILabel new];
    [self addSubview:_textLabel];
    _textLabel.sd_layout.leftSpaceToView(_iconView,5).topSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,5);
    _clickButton = [UIButton new];
    [_clickButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [_clickButton setBackgroundColor:[UIColor clearColor]];
//    [_clickButton setBackgroundImage:[self stretchableImageWithImageName:@"text_nor"] forState:UIControlStateHighlighted];
    [self addSubview:_clickButton];
    _clickButton.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0);
}

- (void)clickAction{
    if ([self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:self];
    }
}

- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}

@end
