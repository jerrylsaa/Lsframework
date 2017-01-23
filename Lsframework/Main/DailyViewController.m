//
//  DailyViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyViewController.h"
#import "DailyRemindPresenter.h"

@interface DailyViewController ()<DailyRemindPresenterDelegate>{

    NSString  *_Dailytime;
}
@property(nonatomic,strong)UIScrollView  *BackScrollView;
@property(nonatomic,strong)UILabel  *GuideLb;
@property(nonatomic,strong)UIImageView  *TimeImageView;
@property (nonatomic, strong)  UIButton *imageChildDay;
@property(nonatomic,strong)UIImageView  *CenterImageView;
@property(nonatomic,strong)UILabel  *DevelopmentTitle;
@property(nonatomic,strong)UILabel  *DevelopmentText;
@property(nonatomic,strong)UILabel  *HygienicMeasuresTitle;
@property(nonatomic,strong)UILabel  *HygienicMeasuresText;
@property(nonatomic,strong)DailyRemindPresenter  *presenter;

@end

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日提醒";
    
}
-(void)setupView{
    
    _presenter = [DailyRemindPresenter  new];
    _presenter.delegate = self;
    
    
    [_presenter  getDailyEventWithDay:self.time];

    _BackScrollView = [UIScrollView  new];
   [_BackScrollView setBackgroundColor:[UIColor  colorWithPatternImage:[UIImage  imageNamed:@"BackImage"]]];
    _BackScrollView.showsVerticalScrollIndicator = YES;
    _BackScrollView.scrollEnabled = YES;
    _BackScrollView.minimumZoomScale = 0.5;
    _BackScrollView.maximumZoomScale = 2.0;
    [self.view   addSubview:_BackScrollView];
    
    _TimeImageView = [UIImageView  new];
    _TimeImageView.image = [UIImage  imageNamed:@"DailyTime"];
    _TimeImageView.backgroundColor = [UIColor  clearColor];
    [_BackScrollView  addSubview:_TimeImageView];
    
    
    _imageChildDay = [UIButton  new];
    _imageChildDay.backgroundColor = [UIColor  clearColor];
    [_imageChildDay  setBackgroundImage:[UIImage  imageNamed:@"Daily_Time"] forState:UIControlStateNormal];
    _imageChildDay.titleLabel.textAlignment = NSTextAlignmentCenter;
    _imageChildDay.titleLabel.textColor  = [UIColor  whiteColor];
    _imageChildDay.titleLabel.numberOfLines = 2;
    _imageChildDay.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _imageChildDay.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_TimeImageView  addSubview:_imageChildDay];
    
    

    
    
    _GuideLb = [UILabel  new];
    _GuideLb.numberOfLines = 0;
    _GuideLb.font = [UIFont  systemFontOfSize:15];
    _GuideLb.backgroundColor = [UIColor  clearColor];
    _GuideLb.textColor = UIColorFromRGB(0x333333);
    _GuideLb.textAlignment = NSTextAlignmentLeft;
    [_BackScrollView  addSubview:_GuideLb];
    
    _CenterImageView = [UIImageView  new];
    _CenterImageView.image = [UIImage  imageNamed:@"centerImage"];
    CGFloat top = 30; // 顶端盖高度
    CGFloat bottom = 30 ; // 底端盖高度
    CGFloat left = 30; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _CenterImageView.image = [_CenterImageView.image  resizableImageWithCapInsets:insets  resizingMode:UIImageResizingModeStretch];
    

    _CenterImageView.backgroundColor = [UIColor  clearColor];
    _CenterImageView.userInteractionEnabled = YES;
    [_BackScrollView  addSubview:_CenterImageView];
    
    
    
    _DevelopmentTitle = [UILabel  new];
    _DevelopmentTitle.backgroundColor = [UIColor  clearColor];
    _DevelopmentTitle.text =@"发育指标";
    _DevelopmentTitle.textColor = UIColorFromRGB(0x0bb6f8);
    _DevelopmentTitle.textAlignment = NSTextAlignmentCenter;
    _DevelopmentTitle.numberOfLines = 1;
    _DevelopmentTitle.font = [UIFont  systemFontOfSize:16];
    [_CenterImageView  addSubview:_DevelopmentTitle];
    
    _DevelopmentText = [UILabel  new];
    _DevelopmentText.backgroundColor = [UIColor  clearColor];
    _DevelopmentText.textColor = UIColorFromRGB(0x666666);
    _DevelopmentText.textAlignment = NSTextAlignmentLeft;
        _DevelopmentText.numberOfLines = 0;
    _DevelopmentText.font = [UIFont  systemFontOfSize:16];
    [_CenterImageView  addSubview:_DevelopmentText];
    
    _HygienicMeasuresTitle = [UILabel  new];
    _HygienicMeasuresTitle.backgroundColor = [UIColor  clearColor];
    _HygienicMeasuresTitle.text =@"保健措施";
    _HygienicMeasuresTitle.textColor = UIColorFromRGB(0x0bb6f8);
    _HygienicMeasuresTitle.textAlignment = NSTextAlignmentCenter;
    _HygienicMeasuresTitle.numberOfLines = 1;
    _HygienicMeasuresTitle.font = [UIFont  systemFontOfSize:16];
    [_CenterImageView  addSubview:_HygienicMeasuresTitle];
    
    _HygienicMeasuresText = [UILabel  new];
    _HygienicMeasuresText.backgroundColor = [UIColor  clearColor];
    _HygienicMeasuresText.textColor = UIColorFromRGB(0x666666);
    _HygienicMeasuresText.textAlignment = NSTextAlignmentLeft;
    _HygienicMeasuresText.numberOfLines = 0;
    _HygienicMeasuresText.font = [UIFont  systemFontOfSize:16];
    [_CenterImageView  addSubview:_HygienicMeasuresText];
    
    

}

-(void)viewDidLayoutSubviews{
    [self configurationConstraint];
}


-(void)configurationConstraint{
    
    
  
    
    int  k_imageChildDaytop = (169-105)/2;
    CGFloat   imageChildSize = 15;
    if (kScreenHeight == 480) {
        
        //4s
        k_imageChildDaytop = (169-105)/2*480/667;
        imageChildSize = 12;
    }
    if (kScreenHeight == 568) {
        //5s
        k_imageChildDaytop = (169-105)/2*568/667;
        
        imageChildSize = 12.5;
    }
    if (kScreenHeight == 736) {
        //6p
            k_imageChildDaytop = (169-105)/2*736/667;
            imageChildSize = 16;
        
    }
    
    _imageChildDay.titleLabel.font = [UIFont  systemFontOfSize:imageChildSize];
    
    
    _BackScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _TimeImageView.sd_layout.topSpaceToView(_BackScrollView,0).leftSpaceToView(_BackScrollView,20/2).widthIs(kFitWidthScale(109)).heightIs(kFitHeightScale(169));
    
    
    _imageChildDay.sd_layout.topSpaceToView(_TimeImageView,k_imageChildDaytop).leftSpaceToView(_TimeImageView,0).widthIs(kFitWidthScale(110)).heightIs(kFitHeightScale(110));

    
    _GuideLb.sd_layout.topSpaceToView(_BackScrollView,60/2).leftSpaceToView(_TimeImageView,20/2).rightSpaceToView(_BackScrollView,20/2).autoHeightRatio(0);
    
    _CenterImageView.sd_layout.topSpaceToView(_GuideLb,90/2).centerXEqualToView(_BackScrollView).widthIs(kFitWidthScale(595));
    
    
    _DevelopmentTitle.sd_layout.topSpaceToView(_CenterImageView,60/2).centerXEqualToView(_CenterImageView).widthIs([JMFoundation calLabelWidth:_DevelopmentTitle]).heightIs(16);
    
    _DevelopmentText.sd_layout.topSpaceToView(_DevelopmentTitle,35/2).leftSpaceToView(_CenterImageView,20/2).rightSpaceToView(_CenterImageView,20/2).autoHeightRatio(0);
    
    _HygienicMeasuresTitle.sd_layout.topSpaceToView(_DevelopmentText,60/2).centerXEqualToView(_CenterImageView).widthIs([JMFoundation calLabelWidth:_HygienicMeasuresTitle]).heightIs(16);
    
    _HygienicMeasuresText.sd_layout.topSpaceToView(_HygienicMeasuresTitle,35/2).leftSpaceToView(_CenterImageView,20/2).rightSpaceToView(_CenterImageView,20/2).autoHeightRatio(0);
    
    [_CenterImageView setupAutoHeightWithBottomView:_HygienicMeasuresText bottomMargin:60/2];
    
    [_BackScrollView setupAutoHeightWithBottomView:_CenterImageView bottomMargin:60/2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_GuideLb.text.length ==0 ) {
        _BackScrollView.hidden = YES;
    }else{
     _BackScrollView.hidden = NO;
    
    }
   
    [MobClick beginLogPageView:@"每日提醒"];
    
    }
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"每日提醒"];
    
}

- (void)onGetDailyEventWithCompletion:(BOOL) success Day:(NSUInteger)day{
    
    if (success) {
        if (_presenter.DailySource.count != 0) {
            
            _Dailytime = _presenter.DailySource[0].TimeDesc;

[_imageChildDay  setTitle:_Dailytime forState:UIControlStateNormal];

    _GuideLb.text = _presenter.DailySource[0].Guidelanguage;
    
NSString   *HygienicMeasuresText = [NSString stringWithFormat:@"%@", [_presenter.DailySource[0].HygienicMeasures  stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
 _HygienicMeasuresText.text =HygienicMeasuresText;
          
            
NSString   *DevelopmentText = [NSString stringWithFormat:@"%@", [_presenter.DailySource[0].DevelopmentIndex  stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
_DevelopmentText.text =  DevelopmentText;
           
            [_GuideLb  updateLayout];
            [_HygienicMeasuresText  updateLayout];
            [_DevelopmentText  updateLayout];
            _BackScrollView.hidden = NO;
            
        }
    }else{
        
    }
    
    
    
    
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
