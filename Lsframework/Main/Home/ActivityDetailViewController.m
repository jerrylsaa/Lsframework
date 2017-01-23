//
//  ActivityDetailViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ActivityDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) UIWebView *webView;
@property (nonatomic ,strong) UIScrollView *scroll;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动详情";
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.delegate = self;
    _scroll.scrollEnabled = YES;
    [self.view addSubview:_scroll];

    _webView = [UIWebView new];
    _webView.scalesPageToFit =YES;
    _webView.scrollView.scrollEnabled = NO;
    NSLog(@"活动详情URL:%@",_url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSLog(@"%@",_url);
    _webView.delegate = self;
    [_webView loadRequest:request];
    [_scroll addSubview:_webView];
    _scroll.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _webView.sd_layout.leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0).topSpaceToView(_scroll,0).heightIs(400);
    
}

#pragma mark----webView相关
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressUtil show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressUtil dismiss];
    
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    _webView.sd_layout.heightIs(webViewHeight);
    
    [_scroll  setupAutoHeightWithBottomView:_webView bottomMargin:0];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [ProgressUtil dismiss];
    [ProgressUtil showError:error.localizedDescription];
}
#pragma mark----SCROLLVIEWDELEGATE相关
//拖动结束触发此方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"高度5\n%f",scrollView.contentOffset.y);
    
    
    //得到当前页面的JSContext，如果不在这里获得当前网页的context可能有问题
    JSContext *js = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //设置 js 代码中的method对象为控制器
    js[@"method"] = self;
    
    //在OC中执行js并取得js返回的数据
    //方式1 使用JSContext的对象方法执行JS脚本
    NSString *jsScript = @"document.title";     //获取网页标题
    //evaluateScript方法返回的是JSValue类型的对象，需要将类型转换为OC对象
    NSString *title = [js evaluateScript:jsScript].toString;
//    self.navigationItem.title = title;
    NSLog(@"evaluateScript --->  %@",title);
    
    //方式2 使用webView的对象方法执行js，该方法返回的数据类型始终是NSString，不管JS实际传递过来的是什么类型，
    //如JS传递过来的是10 那么该方法的返回值任然是字符串
    CGFloat  y = scrollView.contentOffset.y;
    NSString *myString2 = [NSString stringWithFormat:@"setScrollTop(%f)",y];
    
    
    [_webView stringByEvaluatingJavaScriptFromString:myString2];
    
}
//滑动结束出发此方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"高度6\n%f",scrollView.contentOffset.y);
    
    
    //得到当前页面的JSContext，如果不在这里获得当前网页的context可能有问题
    JSContext *js = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //设置 js 代码中的method对象为控制器
    js[@"method"] = self;
    
    //在OC中执行js并取得js返回的数据
    //方式1 使用JSContext的对象方法执行JS脚本
    NSString *jsScript = @"document.title";     //获取网页标题
    //evaluateScript方法返回的是JSValue类型的对象，需要将类型转换为OC对象
    NSString *title = [js evaluateScript:jsScript].toString;
//    self.navigationItem.title = title;
    NSLog(@"evaluateScript --->  %@",title);
    
    //方式2 使用webView的对象方法执行js，该方法返回的数据类型始终是NSString，不管JS实际传递过来的是什么类型，
    //如JS传递过来的是10 那么该方法的返回值任然是字符串
    CGFloat  y = scrollView.contentOffset.y;
    NSString *myString2 = [NSString stringWithFormat:@"setScrollTop(%f)",y];
    
    
    [_webView stringByEvaluatingJavaScriptFromString:myString2];
    
    
    
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
