//
//  HealthCaseInfoViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthCaseInfoViewController.h"

@interface HealthCaseInfoViewController ()

@end

@implementation HealthCaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"健康方案详细信息";
    
    [self setupTitleView];
}

- (void)setupTitleView{
    UIView* bgView = [UIView new];
    bgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    bgView.layer.borderWidth = 1;
    UIColor* color = UIColorFromRGB(0xdbdbdb);
    bgView.layer.borderColor = color.CGColor;
    [self.view addSubview:bgView];
    
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.textColor = UIColorFromRGB(0x999999);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.healthCase.healthyContent;
    [bgView addSubview:titleLabel];
    
    titleLabel.sd_layout.topSpaceToView(bgView,10).leftSpaceToView(bgView,5).rightSpaceToView(bgView,0);
    titleLabel.autoHeightRatioValue = @0;
    
    bgView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view);
    [bgView setupAutoHeightWithBottomView:titleLabel bottomMargin:50];
    
}





@end
