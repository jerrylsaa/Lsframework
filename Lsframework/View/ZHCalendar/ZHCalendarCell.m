//
//  ZHCalendarCell.m
//  Date
//
//  Created by 中弘科技 on 16/4/2.
//  Copyright © 2016年 中弘科技. All rights reserved.
//

#import "ZHCalendarCell.h"


@implementation ZHCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [UILabel new];
        self.title.font = [UIFont systemFontOfSize:20];
        self.title.frame = CGRectMake(0, 0, kScreenWidth/7, kScreenWidth/7);
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //首次创建确定是否可点击
    if (self.enableSelect == YES) {
        self.title.textColor = [UIColor blackColor];
        if (self.isCurrent == YES) {
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_select"]];
        }else{
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_enable"]];;
        }
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor blackColor];
    }
}
- (void)setEnableSelect:(BOOL)enableSelect{
    _enableSelect = enableSelect;
    self.userInteractionEnabled = enableSelect;
    
}
- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    //复用时对其状态进行改变
    if (self.isCurrent == YES) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_select"]];
        self.title.textColor = [UIColor whiteColor];
    }else{
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_enable"]];;
        self.title.textColor = [UIColor blackColor];
    }
}


@end
