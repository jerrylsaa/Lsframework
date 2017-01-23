//
//  FPButton.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPButton.h"
#import "UIImage+Category.h"

@implementation FPButton


-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    [self setBackgroundImage:[UIImage imageWithColor:_backgroundColor] forState:UIControlStateNormal];
}

-(void)setBackgroundLightColor:(UIColor *)backgroundLightColor{
    _backgroundLightColor = backgroundLightColor;
    [self setBackgroundImage:[UIImage imageWithColor:_backgroundLightColor] forState:UIControlStateHighlighted];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

@end
