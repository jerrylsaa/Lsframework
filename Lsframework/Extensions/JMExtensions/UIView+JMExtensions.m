//
//  UIView+JMExtensions.m
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UIView+JMExtensions.h"

@implementation UIView (JMExtensions)

-(void)makeCorner:(CGFloat) radio{

    CALayer * lay = self.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:radio];


}

-(void)makeCorner:(CGFloat) radio withBorderColor:(UIColor *) color andBorderWith:(CGFloat) width{
    [self makeCorner:radio];
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;

}



@end
