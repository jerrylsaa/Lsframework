//
//  HomeMoreViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HomeMoreViewController.h"

@interface HomeMoreViewController ()

@property (nonatomic, strong) UIView *selectView;

@end

@implementation HomeMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    
}
- (void)setupSelectView{
    
    _selectView = [UIView new];
    _selectView.width = kScreenWidth/3;
    _selectView.height = 34;
    _selectView.backgroundColor = [UIColor whiteColor];
    
    
    
}



@end
