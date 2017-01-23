//
//  ScanQRCodeViewController.m
//  EyeHealthForDoctor
//
//  Created by tom on 16/4/15.
//  Copyright © 2016年 eyevision. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>



@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)AVCaptureMetadataOutput *captureOutput;

@property (nonatomic, strong)AVCaptureSession *captureSession;

@property (nonatomic) BOOL lastResult;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *fluxView;

@property (nonatomic, strong)AVCaptureMetadataOutput *captureMetadataOutput;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startReading];
    CGFloat width = kScreenWidth - 80;
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(40, (kScreenHeight - width) / 2, width, 1);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    layer.position = CGPointMake(40, (kScreenHeight - width) / 2);
    layer.anchorPoint = CGPointMake(0, 0);
    
    [self.view.layer addSublayer:layer];
    
    UILabel *topTipLabel=[UILabel new];
    topTipLabel.text =@"将二维码放入框内将自动扫描";
    topTipLabel.font =[UIFont systemFontOfSize:14.0f];
    topTipLabel.textColor =[UIColor whiteColor];
    topTipLabel.textAlignment =NSTextAlignmentCenter;
    topTipLabel.frame =CGRectMake(0, (kScreenHeight/2.0)-150, kScreenWidth,25);
    [self.view addSubview:topTipLabel];
    
    UILabel *bottomTipLabel=[UILabel new];
    bottomTipLabel.text =@"关注医生、医院请直接扫描";
    bottomTipLabel.font =[UIFont systemFontOfSize:14.0f];
    bottomTipLabel.textColor =[UIColor whiteColor];
    bottomTipLabel.textAlignment =NSTextAlignmentCenter;
    bottomTipLabel.frame =CGRectMake(0, (kScreenHeight/2.0)+120, kScreenWidth,25);
    [self.view addSubview:bottomTipLabel];
    
    CGPoint point = layer.position;
    
    //keyPayh:所填参数就是动画需要改变的属性,例如position  既是UIView的动画
    CABasicAnimation *basicPosition = [CABasicAnimation animationWithKeyPath:@"position.y"];
    //设置初始值
    basicPosition.fromValue = @(point.y);
    //设置结束值
    basicPosition.toValue = @(point.y + width);
    
    [basicPosition setAutoreverses:YES];
    //设置动画执行时间
    [basicPosition setDuration:1.6];
    //设置动画执行次数
    [basicPosition setRepeatCount:MAXFLOAT];
    
    //将创建好的CALayer动画添加到viewAnimation的layer层上
    [layer addAnimation:basicPosition forKey:nil];
}


- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)startReading{
    _lastResult = YES;
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:_captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("kScanQRCodeQueueName", NULL);
    [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [_captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_videoPreviewLayer setFrame:[[UIScreen mainScreen] bounds]];
    CGFloat width = kScreenWidth - 80;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[[UIScreen mainScreen] bounds]];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(40, (kScreenHeight - width) / 2, width, width)]];
    
//    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:__MainScreenFrame]];
    
    path.usesEvenOddFillRule = YES;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor= [UIColor blackColor].CGColor;  //其他颜色都可以，只要不是透明的
    shapeLayer.fillRule=kCAFillRuleEvenOdd;
    self.fluxView.layer.mask = shapeLayer;
    [_captureMetadataOutput setRectOfInterest:CGRectMake((kScreenHeight - width) / 2 / kScreenHeight, 40 / kScreenWidth, width / kScreenHeight, width / kScreenWidth)];

    // 开始会话
    [_captureSession startRunning];
    
    [self.view bringSubviewToFront:_fluxView];
    
    [self.view bringSubviewToFront:_btnBack];
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResult) {
        return;
    }
    _lastResult = NO;
    if (_delegate)[_delegate onScanDone:result];
    [self.navigationController popViewControllerAnimated:YES];
    // 以下处理了结果，继续下次扫描
    _lastResult = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:animated];
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
