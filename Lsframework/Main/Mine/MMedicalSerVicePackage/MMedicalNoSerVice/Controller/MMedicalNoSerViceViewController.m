//
//  MMedicalNoSerViceViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MMedicalNoSerViceViewController.h"

@interface MMedicalNoSerViceViewController ()

@end

@implementation MMedicalNoSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"我的医疗服务套餐";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel* title = [UILabel new];
    title.text = @"您还没有购买过医疗服务";
    title.textColor = RGB(83, 83, 83);
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    title.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).centerYEqualToView(self.view).autoHeightRatio(0);
}

@end
