//
//  VaccineViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineViewController.h"

@interface VaccineViewController ()
@property(nonatomic,strong)UIView  *BackView;
@property(nonatomic,strong)UILabel  *NameLb;
@property(nonatomic,strong)UILabel  *TimeLb;
@property(nonatomic,strong)UIImageView  *CenterImageView;
@property(nonatomic,strong)UIScrollView  *CenterScrollView;
@property(nonatomic,strong)UIImageView  *EventImageView;
@property(nonatomic,strong)UILabel  *EffectLb;
@property(nonatomic,strong)UILabel  *ProgramLb;
@property(nonatomic,strong)UILabel  *ContraindicationLb;
@property(nonatomic,strong)UILabel  *PossibleReactionsLb;

@end

@implementation VaccineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"疫苗接种提醒";
    
}
-(void)setupView{
    _BackView = [UIView  new];
    [_BackView setBackgroundColor:[UIColor  colorWithPatternImage:[UIImage  imageNamed:@"BackImage"]]];
    [self.view  addSubview:_BackView];
    
    _NameLb = [UILabel  new];
    _NameLb.backgroundColor = [UIColor  clearColor];
    _NameLb.text = self.Name;
    _NameLb.textColor = UIColorFromRGB(0x333333);
    _NameLb.textAlignment = NSTextAlignmentCenter;
    _NameLb.font = [UIFont  boldSystemFontOfSize:20];
    [_BackView  addSubview:_NameLb];
    
    _TimeLb = [UILabel  new];
    _TimeLb.backgroundColor = [UIColor  clearColor];
    _TimeLb.text = [NSString stringWithFormat:@"距注射疫苗时间： %@天",self.time];
    _TimeLb.textColor = UIColorFromRGB(0x5d4037);
    
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距注射疫苗时间： %@天",self.time]];
        [Str addAttribute:NSForegroundColorAttributeName
                    value:UIColorFromRGB(0xf7a922)
                    range:NSMakeRange(0, 8)];
    _TimeLb.attributedText = Str;
    _TimeLb.textAlignment = NSTextAlignmentCenter;
    _TimeLb.font = [UIFont  boldSystemFontOfSize:18];
    [_BackView  addSubview:_TimeLb];
    
    _CenterImageView = [UIImageView  new];
    _CenterImageView.image = [UIImage  imageNamed:@"centerImage"];
    _CenterImageView.backgroundColor = [UIColor  clearColor];
    _CenterImageView.userInteractionEnabled = YES;
    [_BackView  addSubview:_CenterImageView];
    
    
    UIView  *CenterView = [UIView  new];
    CenterView.backgroundColor = [UIColor clearColor];
    [_CenterImageView  addSubview:CenterView];

    _EventImageView = [UIImageView  new];
    _EventImageView.image = [UIImage  imageNamed:@"topImage"];
    _EventImageView.backgroundColor = [UIColor  clearColor];
    [CenterView  addSubview:_EventImageView];

    
    _CenterScrollView = [UIScrollView new];
    _CenterScrollView.showsVerticalScrollIndicator = YES;
    _CenterScrollView.scrollEnabled = YES;
    _CenterScrollView.minimumZoomScale = 0.5;
    _CenterScrollView.maximumZoomScale = 2.0;
    _CenterScrollView.backgroundColor = [UIColor  clearColor];
    [CenterView   addSubview:_CenterScrollView];
    
    [self  setupScrollview];
    
    
    
    
    _BackView.sd_layout.topSpaceToView(self.view, 0).centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(kScreenWidth).heightIs(kScreenHeight);
    int  k_Nametop = 90/2;
    int  k_Timetop = 30/2;
    int  k_Centertop = 40/2;
    if (kScreenHeight == 480) {
        
          k_Nametop = 90/2-25;
          k_Timetop = 30/2-5;
          k_Centertop = 40/2-5;
 
    }
    if (kScreenHeight == 568) {
        
        k_Nametop = (90-15)/2;
        k_Timetop = 30/2-5;
        k_Centertop = 40/2-5;
        
    }
    
    _NameLb.sd_layout.topSpaceToView(_BackView,k_Nametop).centerXEqualToView(_BackView).widthIs(kScreenWidth).autoHeightRatio(0);
    
    _TimeLb.sd_layout.topSpaceToView(_NameLb,k_Timetop).centerXEqualToView(_BackView).widthIs(kScreenWidth).autoHeightRatio(0);
    
    _CenterImageView.sd_layout.topSpaceToView(_TimeLb,k_Centertop).centerXEqualToView(_BackView).widthIs(kFitWidthScale(595)).heightIs(kFitHeightScale(834));
    
    
    CenterView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _EventImageView.sd_layout.topSpaceToView(CenterView,55/2).centerXEqualToView(CenterView).widthIs(kFitWidthScale(140)).heightIs(kFitHeightScale(141));

     _CenterScrollView.sd_layout.topSpaceToView(_EventImageView,35/2).leftSpaceToView(CenterView,0).rightSpaceToView(CenterView,0).bottomSpaceToView(CenterView,55/2);
    
}
-(void)setupScrollview{
    _EffectLb = [UILabel  new];
    _EffectLb.backgroundColor = [UIColor  clearColor];
    _EffectLb.text = [NSString stringWithFormat:@"作用：%@",self.Effect];
    _EffectLb.textColor = UIColorFromRGB(0x666666);
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:_EffectLb.text];
    [Str addAttribute:NSForegroundColorAttributeName
                value:UIColorFromRGB(0x29b6f6)
                range:NSMakeRange(0, 3)];
    _EffectLb.attributedText = Str;
    _EffectLb.textAlignment = NSTextAlignmentLeft;
    _EffectLb.numberOfLines = 0;
    _EffectLb.font = [UIFont  systemFontOfSize:16];
    [_CenterScrollView  addSubview:_EffectLb];
    
    
    _ProgramLb = [UILabel  new];
    _ProgramLb.backgroundColor = [UIColor  clearColor];
    _ProgramLb.text = [NSString stringWithFormat:@"免疫程序：%@",self.Program];
    _ProgramLb.numberOfLines = 0;
    _ProgramLb.textColor = UIColorFromRGB(0x666666);
    NSMutableAttributedString *Str1 = [[NSMutableAttributedString alloc] initWithString:_ProgramLb.text];
    [Str1 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x29b6f6)
                 range:NSMakeRange(0, 5)];
    _ProgramLb.attributedText = Str1;
    _ProgramLb.textAlignment = NSTextAlignmentLeft;
    _ProgramLb.font = _EffectLb.font;
    [_CenterScrollView  addSubview:_ProgramLb];
    

    
    _ContraindicationLb = [UILabel  new];
    _ContraindicationLb.backgroundColor = [UIColor  clearColor];
    _ContraindicationLb.text = [NSString stringWithFormat:@"接种禁忌症：%@",self.Contraindication];
    _ContraindicationLb.textColor =  UIColorFromRGB(0x666666);
    NSMutableAttributedString *Str2 = [[NSMutableAttributedString alloc] initWithString:_ContraindicationLb.text];
    [Str2 addAttribute:NSForegroundColorAttributeName
                value:UIColorFromRGB(0xd32f2f)
                range:NSMakeRange(0, 6)];
    _ContraindicationLb.attributedText = Str2;
    _ContraindicationLb.textAlignment = NSTextAlignmentLeft;
    _ContraindicationLb.numberOfLines = 0;
    _ContraindicationLb.font = _EffectLb.font;
    [_CenterScrollView  addSubview:_ContraindicationLb];


    _PossibleReactionsLb = [UILabel  new];
    _PossibleReactionsLb.backgroundColor = [UIColor  clearColor];
    _PossibleReactionsLb.text = [NSString stringWithFormat:@"可能发生的反应：%@",self.PossibleReactions];
    _PossibleReactionsLb.textColor = UIColorFromRGB(0x666666);
    NSMutableAttributedString *Str3 = [[NSMutableAttributedString alloc] initWithString: _PossibleReactionsLb.text];
    [Str3 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0xd32f2f)
                 range:NSMakeRange(0, 8)];
    _PossibleReactionsLb.attributedText = Str3;
    _PossibleReactionsLb.textAlignment = NSTextAlignmentLeft;
    _PossibleReactionsLb.numberOfLines = 0;
    _PossibleReactionsLb.font = _EffectLb.font;
    [_CenterScrollView  addSubview:_PossibleReactionsLb];
    
    

    
    _EffectLb.sd_layout.topSpaceToView(_CenterScrollView,0).leftSpaceToView(_CenterScrollView,40/2).rightSpaceToView(_CenterScrollView,40/2).autoHeightRatio(0);
    
    _ProgramLb.sd_layout.topSpaceToView(_EffectLb,30/2).leftSpaceToView(_CenterScrollView,40/2).rightSpaceToView(_CenterScrollView,40/2).autoHeightRatio(0);
    
    _ContraindicationLb.sd_layout.topSpaceToView(_ProgramLb,30/2).leftSpaceToView(_CenterScrollView,40/2).rightSpaceToView(_CenterScrollView,40/2).autoHeightRatio(0);
    
    _PossibleReactionsLb.sd_layout.topSpaceToView(_ContraindicationLb,30/2).leftSpaceToView(_CenterScrollView,40/2).rightSpaceToView(_CenterScrollView,40/2).autoHeightRatio(0);
    


    [_CenterScrollView  setupAutoHeightWithBottomView:_PossibleReactionsLb bottomMargin:55/2];
    
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"疫苗提醒"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"疫苗提醒"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
