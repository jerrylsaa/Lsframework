//
//  HealthTeachViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthTeachViewController.h"
#import "ApiMacro.h"

@interface HealthTeachViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong)UIWebView *webView;



@end

@implementation HealthTeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupView{
    self.title = @"健康教育";
    
    [self setupWebView];
}

- (void)setupWebView{
    _webView = [UIWebView new];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,API_HTML_JKJY]]];
    _webView.delegate = self;
//    _webView.scrollView.scrollEnabled = NO;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    _webView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

}

- (void)backItemAction:(id)sender{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"健康教育"];
    

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"健康教育"];
    
}

@end
