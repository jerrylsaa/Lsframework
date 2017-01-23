//
//  FPLabel.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPLabel.h"

@implementation FPLabel


-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius;
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
