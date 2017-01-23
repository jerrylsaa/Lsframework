//
//  navigTitleView.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "navigTitleView.h"

@implementation navigTitleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
