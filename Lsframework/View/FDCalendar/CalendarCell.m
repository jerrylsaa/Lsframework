//
//  CalendarCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CalendarCell.h"


@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTitles];
    }
    return self;
}

- (void)setupTitles{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _monthLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 60, 25)];
    _monthLabel.text = @"月";
    _monthLabel.backgroundColor = [UIColor clearColor];
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_monthLabel];
}

- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    if (_isCurrent == YES) {
        _titleLabel.textColor = [UIColor whiteColor];
        _monthLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = UIColorFromRGB(0x71CAEE);
    }else{
        _titleLabel.textColor = [UIColor blackColor];
        _monthLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
