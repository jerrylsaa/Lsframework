//
//  ZHProgressView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHProgressView.h"

@interface ZHProgressView ()<FinishDelegate>

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) LDProgressView *progressView;

@property(nullable,nonatomic,retain) UILabel* title;


@end

@implementation ZHProgressView


- (void)show{
  
    [self setupSubViews];
    
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)setupSubViews{
    _alphaView = [UIView new];
    _alphaView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    _alphaView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:_alphaView];
    UILabel *tipLabel =[UILabel new];
    tipLabel.text =@"正在加载中请稍后······";
    tipLabel.textColor =[UIColor whiteColor];
    tipLabel.font =[UIFont boldSystemFontOfSize:14.0f];
    tipLabel.textAlignment =NSTextAlignmentCenter;
    tipLabel.frame =CGRectMake(0, (kScreenHeight/2.0f)+40, kScreenWidth, 25);
    [_alphaView addSubview:tipLabel];
//    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, _alphaView.centerY-11-30, kScreenWidth-40, 15)];
    
    NSLog(@"%@",NSStringFromCGRect(self.rect));
    
    
    
    
    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(30, (kScreenHeight/2.0f)-15, kScreenWidth-60, 30)];
    
    
    
//    _progressView.type = LDProgressGradient;
    _progressView.delegate = self;
//    _progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
    _progressView.color = UIColorFromRGB(0x61d8d3);
    _progressView.background = UIColorFromRGB(0x005955);
    _progressView.borderRadius =@5;
    _progressView.flat = @YES;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @YES;
    [_alphaView addSubview:_progressView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressView.frame)+5, kScreenWidth, 20)];
    _title.text = @"语音上传中...";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14];
    [_alphaView addSubview:_title];
    
    [self newTimer];
    
}

- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
//    NSLog(@"11112222====%f",_progressValue);
}

- (void)newTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)refresh{
    _progressView.progress = _progressValue;
}

- (void)finish{
    [_progressView removeFromSuperview];
    [_title removeFromSuperview];
    [_alphaView removeFromSuperview];
    
    [_timer invalidate];
    _timer = nil;

}



@end
