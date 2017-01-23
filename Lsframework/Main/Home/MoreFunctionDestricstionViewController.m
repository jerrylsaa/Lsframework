//
//  MoreFunctionDestricstionViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreFunctionDestricstionViewController.h"

@interface MoreFunctionDestricstionViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView *webView;
@end

@implementation MoreFunctionDestricstionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _Mfucation.title;
    _webView = [UIWebView new];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_Mfucation.URL]];
    NSLog(@"%@",_Mfucation.URL);
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    _webView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}
#pragma mark----webView相关
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressUtil show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressUtil dismiss];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [ProgressUtil dismiss];
    [ProgressUtil showError:error.localizedDescription];
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
