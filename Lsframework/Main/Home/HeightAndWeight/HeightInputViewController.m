//
//  HeightInputViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HeightInputViewController.h"
#import "WeightScrollView.h"
#import "HWViewController.h"

@interface HeightInputViewController ()<UIScrollViewDelegate,UITextViewDelegate>


@end

@implementation HeightInputViewController{
    WeightScrollView *_scrollView;
    UITextView *_textFiled;
    float   HeightMinX;
    
    
}
-(void)setupView{
    
    self.title = @"记录身高";
    [self initRightBarWithTitle:@"保存"];

    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _scrollView = [WeightScrollView new];
    _scrollView.backgroundColor = [UIColor  whiteColor];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    [_scrollView  createWeightScorllMinruler:120 showType:TypeHeightText];
    HeightMinX = 120;   //设置设置的起始值
    [self.view  addSubview:_scrollView];
    
    
    UIImageView  *textImageView = [UIImageView  new];
    textImageView.userInteractionEnabled = YES;
    textImageView.image = [UIImage  imageNamed:@"textHeightImageView"];
    [self.view  addSubview:textImageView];

    
    _textFiled = [UITextView  new];
    _textFiled.userInteractionEnabled = NO;
    _textFiled.textAlignment = NSTextAlignmentCenter;
    _textFiled.textColor = [UIColor whiteColor];
    _textFiled.backgroundColor = [UIColor clearColor];
    CGFloat textSpace = 15;
    CGFloat  textFont = 60*(kFitHeightScale(200)-2*textSpace)/80;
    _textFiled.font = [UIFont systemFontOfSize:textFont];
    _textFiled.delegate = self;
    _textFiled.textContainer.maximumNumberOfLines = 1;
    _textFiled.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    [textImageView addSubview:_textFiled];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:UITextViewTextDidChangeNotification object:nil];
    
    
    UILabel  *unitlb = [UILabel new];
    unitlb.backgroundColor = [UIColor  clearColor];
    unitlb.textColor = [UIColor  whiteColor];
    unitlb.text = @"厘米";
    unitlb.font = [UIFont  systemFontOfSize:15];
    unitlb.textAlignment = NSTextAlignmentCenter;
    [textImageView  addSubview:unitlb];
    
    
    UILabel  *linelb = [UILabel  new];
    linelb.backgroundColor = [UIColor  redColor];
    [self.view   addSubview:linelb];

    

 _scrollView.sd_layout.topSpaceToView(self.view,50).widthIs(113).bottomSpaceToView(self.view,50).leftSpaceToView(self.view,0);
    CGFloat textImageHeight = kFitHeightScale(216)+50-41;
    if (kScreenHeight>=470 &&kScreenHeight<=490) {
        // 4
        textImageHeight = (kFitHeightScale(216)-4)*480/736+14+30;
    }
    if (kScreenHeight>=660 &&kScreenHeight<=670) {
        // 6
        textImageHeight = (kFitHeightScale(216)-4)*667/736+14;
    }
    
    if (kScreenHeight>=730 &&kScreenHeight<=740) {
        // 6plus
      textImageHeight = kFitHeightScale(216)-4;
    }
    
 textImageView.sd_layout.topSpaceToView(self.view,textImageHeight).leftSpaceToView(_scrollView,(kScreenWidth-113-kFitWidthScale(425))/2).widthIs(kFitWidthScale(425)).heightIs(kFitHeightScale(200));
    
    
    linelb.sd_layout.topSpaceToView(self.view,kFitHeightScale(216)+50).leftSpaceToView(_scrollView,-113).rightSpaceToView(textImageView,0).heightIs(1);
    
    
    
    
    _textFiled.sd_layout.topSpaceToView(textImageView,0).leftSpaceToView(textImageView,textSpace+12).rightSpaceToView(textImageView,textSpace).heightIs(kFitHeightScale(200)-textSpace);
    
    //_textFiled高度必须大于65才能居中
    unitlb.sd_layout.topSpaceToView(_textFiled,-20).leftSpaceToView(textImageView,textSpace+12).rightSpaceToView(textImageView,textSpace).heightIs(35);


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float number = scrollView.contentOffset.y;
//    float  number2 =  [self  notRounding:number afterPoint:0];
//    int Xoffset = (int)number2;
//
//
    _textFiled.text = [NSString stringWithFormat:@"%.1f",(HeightMinX-(number / 100) * 1)];
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float number = scrollView.contentOffset.y;
    float  number2 =  [self  notRounding:number afterPoint:0];
    int Xoffset = (int)number2;
    
    if (Xoffset<10) {
        if (Xoffset>5) {
            [scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
    }else if (Xoffset >10 && Xoffset <100){
        if (Xoffset%10 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10)*10) animated:YES];
        }
    }else if (Xoffset >100 && Xoffset <1000){
        
        if (Xoffset%100 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10)*10) animated:YES];
        }
    }else if (Xoffset >1000 && Xoffset <8000){
        
        if (Xoffset%1000 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake( 0,(Xoffset/10)*10) animated:YES];
        }
    }
    
    
//    NSLog(@"结束滑动%f----%f---%d----%d---%d",number,number2,Xoffset,Xoffset/10,Xoffset%10);
    
    _textFiled.text = [NSString stringWithFormat:@"%.1f",(HeightMinX-(number / 100) * 1)];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float number = scrollView.contentOffset.y;
    float  number2 =  [self  notRounding:number afterPoint:0];
    int Xoffset = (int)number2;
    
    if (Xoffset<10) {
        if (Xoffset>5) {
            [scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
    }else if (Xoffset >10 && Xoffset <100){
        if (Xoffset%10 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10)*10) animated:YES];
        }
    }else if (Xoffset >100 && Xoffset <1000){
        
        if (Xoffset%100 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10)*10) animated:YES];
        }
    }else if (Xoffset >1000 && Xoffset <8000){
        
        if (Xoffset%1000 >5) {
            [scrollView setContentOffset:CGPointMake(0, (Xoffset/10+1)*10) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake( 0,(Xoffset/10)*10) animated:YES];
        }
    }
    
    
//    NSLog(@"结束滑动%f----%f---%d----%d---%d",number,number2,Xoffset,Xoffset/10,Xoffset%10);
    
    _textFiled.text = [NSString stringWithFormat:@"%.1f",(HeightMinX-(number / 100) * 1)];

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
//    if ([tF.text floatValue] <=120  && [tF.text floatValue] >=40) {
//        _scrollView.contentOffset = CGPointMake(0,(HeightMinX-[tF.text floatValue] )*100);
//        _textFiled.text = textString;
//        
//        
//    }else{
//        
////        [ProgressUtil showInfo:@"请输入40-120cm以内的身高"];
//
//
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _textFiled.text = self.heightTextField;
    NSLog(@"身高：%@",_textFiled.text);
    _scrollView.contentOffset = CGPointMake(0,(HeightMinX-[_textFiled.text floatValue])*100);
    
}

-(void)rightItemAction:(id)sender{
    
    if ([_textFiled.text floatValue]<40 ||[_textFiled.text floatValue]>120) {
         [ProgressUtil showError:@"请输入40-120cm以内的身高"];
        
        return;
    }
    [self.delegate  HeightText:_textFiled.text];
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
