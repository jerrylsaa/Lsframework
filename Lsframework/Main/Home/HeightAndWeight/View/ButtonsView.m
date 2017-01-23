//
//  ButtonsView.m
//  FamilyPlatForm
//
//  Created by MAC on 16/9/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ButtonsView.h"
#import "UIImage+Category.h"

@interface ButtonsView ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation ButtonsView

- (instancetype)init{
    if (self = [super init]) {
        _index = 1;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    _preButton = [UIButton new];
    [_preButton setTitle:@"上一岁" forState:UIControlStateNormal];
    [_preButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_preButton setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [_preButton addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_preButton];
    
    _nextButton = [UIButton new];
    [_nextButton setTitle:@"下一岁" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];
    
    _ageLabel = [UILabel new];
    _ageLabel.textAlignment = NSTextAlignmentCenter;
    _ageLabel.textColor = MainColor;
    _ageLabel.text = @"1岁";
    [self addSubview:_ageLabel];
    
    [self setSd_equalWidthSubviews:@[_preButton,_ageLabel,_nextButton]];
    _preButton.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0);
    _ageLabel.sd_layout.leftSpaceToView(_preButton,0).topEqualToView(_preButton).bottomEqualToView(_preButton);
    _nextButton.sd_layout.leftSpaceToView(_ageLabel,0).topEqualToView(_ageLabel).bottomEqualToView(_ageLabel).rightSpaceToView(self,0);
    _preButton.sd_cornerRadius = @5;
    _nextButton.sd_cornerRadius = @5;
}
- (void)preAction{
    if (_index == 1) {
        [ProgressUtil showInfo:@"没有更早的时间了"];
    }else{
        _index --;
        _ageLabel.text = [NSString stringWithFormat:@"%d岁",_index];
        [self.delegate selectIndex:_index];
    }
}
- (void)nextAction{
    _index ++;
    _ageLabel.text = [NSString stringWithFormat:@"%d岁",_index];
    [self.delegate selectIndex:_index];
}

@end
