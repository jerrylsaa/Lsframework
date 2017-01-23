//
//  MAccountViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAccountViewController.h"
#import "MUserNameViewController.h"

@interface MAccountViewController ()

@end

@implementation MAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的帐号";
    self.view.backgroundColor = [UIColor whiteColor];

    //用户帐号
    UILabel* account = [UILabel new];
    account.font = [UIFont systemFontOfSize:18];
    account.textColor = UIColorFromRGB(0x535353);
    account.text = [NSString stringWithFormat:@"帐号：%@",kCurrentUser.phone];
    
    UILabel  *lineLb = [UILabel  new];
    lineLb.backgroundColor = UIColorFromRGB(0xdbdbdb);

    //用户昵称
    UILabel* nickName = [UILabel new];
    nickName.font = [UIFont systemFontOfSize:18];
    nickName.textColor = UIColorFromRGB(0x535353);
    nickName.text = (self.nickName != 0)? [NSString  stringWithFormat:@"昵称：%@",self.nickName]: [NSString  stringWithFormat:@"昵称：%@",@""];
    
    UIButton* editbt = [UIButton new];
    [editbt setTitle:@"点击编辑" forState:UIControlStateNormal];
    [editbt setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    [editbt addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view sd_addSubviews:@[account,lineLb,nickName,editbt]];
    
    //添加约束
    account.sd_layout.topSpaceToView(self.view,15).heightIs(20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20);
    lineLb.sd_layout.topSpaceToView(account,15).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(1);
    
    
    nickName.sd_layout.topSpaceToView(lineLb,15).heightIs(20).leftEqualToView(account).rightSpaceToView(self.view,90);
    
    editbt.sd_layout.centerYEqualToView(nickName).heightIs(20).rightSpaceToView(self.view,10).widthIs(80);
//    editbt.backgroundColor = [UIColor redColor];

    
//    _currentBaby.sd_layout.topSpaceToView(lineLb,15).autoHeightRatio(0).leftSpaceToView(_headerbgView,20).widthIs(300);

    
    
    

    
    
}

- (void)editAction{
    MUserNameViewController  *vc = [MUserNameViewController  new];
    vc.currentUserName = self.nickName;
    [self.navigationController  pushViewController:vc animated:YES];

}

@end
