//
//  MMyAppointViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MMyAppointViewController.h"

@interface MMyAppointViewController ()<UIWebViewDelegate>{
    UIWebView* _webView;
}



@end

@implementation MMyAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预约";
    [self initRightBarWithImage:[UIImage imageNamed:@"backHomeIcon"]];
    
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
    _webView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _webView.delegate = self;
    NSString* urlStr = self.appointURL;
//    urlStr = @"http://www.baidu.com/";//测试
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];


    NSLog(@"====%@",self.appointURL);

}

- (void)rightItemAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backItemAction:(id)sender{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-预约界面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-预约界面"];
    
}


@end
