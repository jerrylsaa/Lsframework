//
//  WeightInputViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "WeightInputViewController.h"
#import "WeightScrollView.h"
#import "HWViewController.h"
@interface WeightInputViewController ()<UIScrollViewDelegate, UITextViewDelegate>


@end

@implementation WeightInputViewController{
    WeightScrollView *_scrollView;
    UITextView *_textFiled;
    float   weightMinX;


}
-(void)setupView{
    
    self.title = @"记录体重";
    [self initRightBarWithTitle:@"保存"];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIImageView  *centerbackImageView = [UIImageView  new];
    centerbackImageView.image = [UIImage  imageNamed:@"centerbackImage"];
    [self.view  addSubview:centerbackImageView];
    
    
    _scrollView = [WeightScrollView new];
    _scrollView.backgroundColor = [UIColor  clearColor];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    [_scrollView  createWeightScorllMinruler:0 showType:TypeWeightText];
    weightMinX = 0;   //设置设置的起始值
    [self.view  addSubview:_scrollView];
    
    

    UIImageView  *backImageView = [UIImageView  new];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage  imageNamed:@"topbackImage"];
    [self.view  addSubview:backImageView];
    
    UIImageView  *textImageView = [UIImageView  new];
    textImageView.userInteractionEnabled = YES;
    textImageView.image = [UIImage  imageNamed:@"textImageView"];
    [backImageView  addSubview:textImageView];
    
    
    _textFiled = [UITextView  new];
    _textFiled.userInteractionEnabled = NO;
    _textFiled.textAlignment = NSTextAlignmentCenter;
    _textFiled.textColor = [UIColor whiteColor];
    _textFiled.backgroundColor = [UIColor clearColor];
    _textFiled.font = [UIFont systemFontOfSize:60];
    _textFiled.delegate = self;
    _textFiled.textContainer.maximumNumberOfLines = 1;
    _textFiled.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    [textImageView addSubview:_textFiled];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:UITextViewTextDidChangeNotification object:nil];
    
    
    UILabel  *unitlb = [UILabel new];
    unitlb.textColor = [UIColor  whiteColor];
    unitlb.text = @"公斤";
    unitlb.font = [UIFont  systemFontOfSize:15];
    unitlb.textAlignment = NSTextAlignmentCenter;
    [textImageView  addSubview:unitlb];
    
    
    UILabel  *linelb = [UILabel  new];
    linelb.backgroundColor = [UIColor  redColor];
    [self.view   addSubview:linelb];
    
    
    centerbackImageView.sd_layout.topSpaceToView(self.view,399*kScreenWidth/750).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(250*kScreenWidth/750);
    
 _scrollView.sd_layout.topSpaceToView(self.view,399*kScreenWidth/750+6).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(100);
    
    CGFloat  ySpace = 17.7;
    if (kScreenHeight == 667) {
        //6
       ySpace  = 16;
    }else if (kScreenHeight == 568){
        //5
        ySpace = 14;
    
    }else if (kScreenHeight == 480){
        //4
        ySpace = 14;
    }
    
    backImageView.sd_layout.topSpaceToView(_scrollView,-399*kScreenWidth/750-100-6+ySpace).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(399*kScreenWidth/750);

    textImageView.sd_layout.bottomSpaceToView(backImageView,30/2+30/2).centerXEqualToView(backImageView).widthIs(400/2).heightIs(200/2);
    
    CGFloat textSpace = 15;
    
    _textFiled.sd_layout.topSpaceToView(textImageView,0).leftSpaceToView(textImageView,textSpace).rightSpaceToView(textImageView,textSpace).heightIs(80);
    //_textFiled高度必须大于65才能居中
    unitlb.sd_layout.topSpaceToView(_textFiled,(textImageView.size.height-_textFiled.size.height-15)/2).leftSpaceToView(textImageView,textSpace).rightSpaceToView(textImageView,textSpace).heightIs(15);
    
    linelb.sd_layout.topSpaceToView(self.view ,399*kScreenWidth/750+10).centerXEqualToView(self.view).widthIs(1).heightIs(kScreenHeight-399*kScreenWidth/750-10);
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float number = scrollView.contentOffset.x;
//    float  number2 =  [self  notRounding:number afterPoint:0];
//    int Xoffset = (int)number2;
//    
//    NSLog(@"滑动%f----%f---%d----%d---%d",number,number2,Xoffset,Xoffset/10,Xoffset%10);

    _textFiled.text = [NSString stringWithFormat:@"%.1f",(number / 100) * 1 + weightMinX];
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    float number = scrollView.contentOffset.x;
    float  number2 =  [self  notRounding:number afterPoint:0];
    int Xoffset = (int)number2;
    
    if (Xoffset<10) {
        if (Xoffset>5) {
            [scrollView setContentOffset:CGPointMake(10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
    }else if (Xoffset >10 && Xoffset <100){
        if (Xoffset%10 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }else if (Xoffset >100 && Xoffset <1000){
        
        if (Xoffset%100 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }else if (Xoffset >1000 && Xoffset <3000){
        
        if (Xoffset%1000 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }
    
    
//    NSLog(@"结束滑动%f----%f---%d----%d---%d",number,number2,Xoffset,Xoffset/10,Xoffset%10);
    
    _textFiled.text = [NSString stringWithFormat:@"%.1f",(number / 100) * 1 + weightMinX];

    

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float number = scrollView.contentOffset.x;
    float  number2 =  [self  notRounding:number afterPoint:0];
    int Xoffset = (int)number2;
    
    if (Xoffset<10) {
        if (Xoffset>5) {
            [scrollView setContentOffset:CGPointMake(10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
    }else if (Xoffset >10 && Xoffset <100){
        if (Xoffset%10 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }else if (Xoffset >100 && Xoffset <1000){
        
        if (Xoffset%100 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }else if (Xoffset >1000 && Xoffset <3000){
        
        if (Xoffset%1000 >5) {
            [scrollView setContentOffset:CGPointMake((Xoffset/10+1)*10, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake((Xoffset/10)*10, 0) animated:YES];
        }
    }
    
    
//    NSLog(@"结束拖动%f----%f---%d----%d---%d",number,number2,Xoffset,Xoffset/10,Xoffset%10);
    
    _textFiled.text = [NSString stringWithFormat:@"%.1f",(number / 100) * 1 + weightMinX];
    



}
-(float )notRounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    
    return [[NSString stringWithFormat:@"%@",roundedOunces] floatValue];
    
}

#pragma mark --- textFieldDelegate

//- (void)change:(NSNotification *)noti{
//    UITextField * tF = noti.object;
//    NSString *textString = tF.text;
//    if ([tF.text floatValue] <=30  && [tF.text floatValue] >=0) {
//        _scrollView.contentOffset = CGPointMake(([tF.text floatValue] - weightMinX)*100, 0);
//        _textFiled.text = textString;
//        
//    
//    }else{
//    
////        [ProgressUtil showError:@"请输入30kg以内的体重"];
////        
////        _scrollView.contentOffset = CGPointMake(([@"0" floatValue] - weightMinX)*100, 0);
////        _textFiled.text = @"0";
////
////        return;
//    
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _textFiled.text = self.weightTextField;
    _scrollView.contentOffset = CGPointMake(([_textFiled.text floatValue] - weightMinX)*100, 0);

}

-(void)rightItemAction:(id)sender{

    if ([_textFiled.text floatValue]>30 ||[_textFiled.text floatValue]<0) {
        [ProgressUtil showError:@"请输入30kg以内的体重"];
        
        return;
    }

    [self.delegate  WeightText:_textFiled.text];
    
    UIViewController* back = nil;
    for(UIViewController* vc in self.navigationController.childViewControllers){
        if([vc isKindOfClass:[HWViewController class]]){
            back = vc;
            break;
        }
    }
    
    if(back){
        [self.navigationController popToViewController:back animated:NO];
    }

    
    


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
