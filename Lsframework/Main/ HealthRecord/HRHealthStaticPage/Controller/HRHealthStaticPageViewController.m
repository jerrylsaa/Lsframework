//
//  HRHealthStaticPageViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HRHealthStaticPageViewController.h"

@interface HRHealthStaticPageViewController ()<UIWebViewDelegate>{
    UIWebView* _webView;
}


@end

@implementation HRHealthStaticPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    _webView = [UIWebView new];
    
    [self.view addSubview:_webView];
    
    self.title =@"报告详情";
    _webView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    

    _webView.delegate = self;
    
    
    NSString* urlStr = self.staticPageURL;
    
//    urlStr = @"http://www.baidu.com/";//测试
    
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}


#pragma mark - 代理
- (void)backItemAction:(id)sender{
    if ([self.pageType isEqualToString:@"ChildrenHospitalAppointment"]|[self.pageType isEqualToString:@"MyAppoitment"]|[self.pageType isEqualToString:@"MyWarning"]) {

    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }}
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}


@end
