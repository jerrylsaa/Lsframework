//
//  PostNotiController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PostNotiController.h"
#import "ToggleView.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
@interface PostNotiController ()<ToggleViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic,retain) ToggleView *switchView;

@end

@implementation PostNotiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"消息提醒";
    _tipLabel.text =@"*温馨提示:关闭消息推送后,将不能收到健康知识、活动等通知";
    
    _switchView =[[ToggleView alloc]initWithFrame:CGRectMake(0, 0, 60, 50) toggleViewType:ToggleViewTypeNoLabel toggleBaseType:ToggleBaseTypeChangeImage toggleButtonType:ToggleButtonTypeChangeImage];
    
    _switchView.toggleDelegate = self;
    
    [self loadSetting];

//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    BOOL isPostNoti = YES;
//    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys: @(isPostNoti), @"isPostNoti",nil];
//    [user registerDefaults:defaultValues];
//    
//    if ([user boolForKey:@"isPostNoti"]) {
//        switchView.selectedButton =0;
//    }
//    if (![user boolForKey:@"isPostNoti"]) {
//        switchView.selectedButton =1;
//    }
    _switchView.translatesAutoresizingMaskIntoConstraints =NO;
    [self.postView addSubview:_switchView];
    [self.postView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView(60)]-(35)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_switchView)]];
    [self.postView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_switchView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_switchView)]];
}

- (void)loadSetting{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId]};
    
    [[FPNetwork POST:@"GetPrivacy" withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            NSLog(@"%@",response.data);
            NSDictionary *dataDict =((NSArray *)response.data)[0];
            NSLog(@"%@",[dataDict objectForKey:@"Message"]);
            if ([[dataDict objectForKey:@"Message"] boolValue]==YES) {
                _switchView.selectedButton=0;
            }
            if ([[dataDict objectForKey:@"Message"] boolValue]==NO) {
                _switchView.selectedButton=1;
            }
            
        }else{
            [ProgressUtil showError:response.message];
            
        }
    }];
    
}

- (void)selectLeftButton{
    NSLog(@"点击开启按钮");
    
    NSDictionary * params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"PrivacyType":@"Message",@"PrivacyState":@"1"};
    
    [[FPNetwork POST:@"EditPrivacy" withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            [ProgressUtil showInfo:response.message];
//            BOOL isPostNoti = YES;
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setBool:isPostNoti forKey:@"isPostNoti"];

        }else{
            [ProgressUtil showError:response.message];
            
        }
    }];

}
- (void)selectRightButton{
    NSLog(@"点击关闭按钮");
    
    NSDictionary * params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"PrivacyType":@"Message",@"PrivacyState":@"0"};
    
    [[FPNetwork POST:@"EditPrivacy" withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            [ProgressUtil showInfo:response.message];
//            BOOL isPostNoti = NO;
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setBool:isPostNoti forKey:@"isPostNoti"];
        }else{
            [ProgressUtil showError:response.message];
            
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
