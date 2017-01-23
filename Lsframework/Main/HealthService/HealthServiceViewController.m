//
//  HealthServiceViewController.m
//  FamilyPlatForm
//
//  Created by MAC on 16/5/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthServiceViewController.h"
#import "DefaultChildEntity.h"
#import "ApiMacro.h"
#import "ScreenAppraiseController.h"

@interface HealthServiceViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation HealthServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initRightBarWithTitle:@"查看"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"健康测评";
    _webView = [UIWebView new];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@userID=%ld&BabyID=%ld",BASE_DOMAIN,API_HTML_SERVICE,(long)kCurrentUser.userId,[[DefaultChildEntity defaultChild].babyID integerValue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSLog(@"%@",urlStr);
    _webView.delegate = self;
    [_webView loadRequest:request];
//    _webView.frame = CGRectMake(0, -44, kScreenWidth, kScreenHeight - 44);
    [self.view addSubview:_webView];
    _webView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}

- (void)backItemAction:(id)sender{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)rightItemAction:(id)sender{
    [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

@end
