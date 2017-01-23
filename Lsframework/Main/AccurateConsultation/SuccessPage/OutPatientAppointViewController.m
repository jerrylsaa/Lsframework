//
//  OutPatientAppointViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "OutPatientAppointViewController.h"
#import "FPNetwork.h"

@interface OutPatientAppointViewController ()<UIWebViewDelegate>{
    UIWebView* _webView;
}



@end

@implementation OutPatientAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门诊预约";
    [self initRightBarWithImage:[UIImage imageNamed:@"backHomeIcon"]];
    
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
    _webView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _webView.delegate = self;
    NSURL* url = [NSURL URLWithString:self.outPatientURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    //    urlStr = @"http://www.baidu.com/";//测试
    
    
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
    [MobClick beginLogPageView:@"门诊预约"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"门诊预约"];
    
}


@end
