//
//  FPCheckButton.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPCheckButton.h"

@interface FPCheckButton()

@property (nonatomic) CGFloat imageWidth;

@end

@implementation FPCheckButton


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _titleCenter = NO;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat width = [self.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    CGFloat titleX = self.frame.size.width - width + 5;
    
    if (_titleCenter) {
        titleX = (self.frame.size.width - _imageWidth - 5) / 2 + _imageWidth + 5 - width / 2;
    }
    
    CGFloat titleY = contentRect.origin.y;
    CGFloat titleW = width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageH = self.currentImage.size.height;
    return CGRectMake(0, (contentRect.size.height - imageH) / 2, imageW, imageH);
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    _imageWidth = image.size.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
