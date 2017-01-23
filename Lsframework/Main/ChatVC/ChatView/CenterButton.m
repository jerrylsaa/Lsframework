//
//  CenterButton.m
//  PrimaryHealthCloud
//
//  Created by Tom on 15/3/26.
//  Copyright (c) 2015年 BOSHCC. All rights reserved.
//

#import "CenterButton.h"

@implementation CenterButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self titleLabel].frame;
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = (self.frame.size.height - frame.size.height) / 2;
    self.imageView.center = center;
    
    
    frame.origin.x = 0;
    frame.origin.y =self.frame.size.height - self.titleLabel.frame.size.height - 5;
    
    //self.imageView.frame.size.height + self.imageView.frame.origin.y;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}




@end
