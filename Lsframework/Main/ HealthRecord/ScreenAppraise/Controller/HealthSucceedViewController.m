//
//  HealthSucceedViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/4.
//  Copyright © 2016年 梁继明. All rights reserved.
//
#define y_space     20
#define yy_space     10


#import "HealthSucceedViewController.h"

@interface HealthSucceedViewController (){
    UIImageView* _backImageView;
    UIImageView* _headerImageView;
    UIImageView* _MidImageView;
    UIImageView* _FootImageView;
    UILabel *_FootLb;
    int   k_Headtop;
    int   k_Footop;
    int   k_Midtop;
    int   Tanktop;
    int   k_Bootom;
    
    int  headerImageWidth;
    int  headerImageHeight;
    int  MidImageWidth;
    int  MidImageHeight;
    int  FootImageWidth;
    int  FootImageHeight;
    int  FootLbWidth;
    int   FootLbHeight;
    CGFloat   FootLbFont;
    CGFloat   DetailLbFont;
    CGFloat   TankLbFont;
    int  DetailSpace;
    int  DetailYSpace;
}
@property(nonatomic,retain) NSMutableArray* subtitleLabelArray;
@property(nonatomic,retain) NSMutableArray* titleLabelArray;
@end

@implementation HealthSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测评结果";
    
}
-(NSMutableArray *)subtitleLabelArray{
    if(!_subtitleLabelArray){
        _subtitleLabelArray=[NSMutableArray array];
    }
    return _subtitleLabelArray;
}
-(void)setupView{
    _backImageView=[UIImageView new];
    _backImageView.image=[UIImage imageNamed:@"BackImageView"];
    [self.view addSubview:_backImageView];
    
    _backImageView.sd_layout.topSpaceToView(self.view,0).centerXEqualToView(self.view).centerYEqualToView(self.view).heightIs(kScreenHeight).widthIs(kScreenWidth);
    
    [self setupHedaerImageView];
    
}

-(void)setupHedaerImageView{
    
    
    headerImageWidth = kFitWidthScale(460);
    headerImageHeight = kFitHeightScale(172);
    MidImageWidth = kFitWidthScale(500);
    MidImageHeight = kFitHeightScale(720);
    FootImageWidth = kFitWidthScale(180);
    FootImageHeight = kFitHeightScale(170);
    
    FootLbWidth = kFitWidthScale(200);
    FootLbHeight = kFitHeightScale(85);
    
    FootLbFont = 17*kScreenWidth/375;
    
    DetailLbFont = 14*kScreenWidth/375;
    
    DetailSpace  = 14 *kScreenWidth/375;
    
    TankLbFont = 18*kScreenWidth/375;
    
    
    k_Headtop = 60;
    k_Footop = 41;
    k_Midtop = 218/2;
    k_Bootom = 60/2 ;
    DetailYSpace = 120/2;
    if (kScreenHeight==568){
        
        k_Footop =  35;
        DetailYSpace = 40;
        DetailLbFont = 15*kScreenWidth/375;
        DetailSpace  = 15 *kScreenWidth/375;
        
        
    }else if (kScreenHeight==480){
        
        k_Headtop = 60-y_space;
        k_Midtop = 218/2-y_space;
        k_Footop = 41-y_space+7;
        k_Bootom = 60/2-y_space+5 ;
        
        FootLbWidth = 75;
        FootLbHeight = 32;
        FootLbFont = 13;
        
        DetailYSpace = 30;
        DetailLbFont = 15*kScreenWidth/375;
        DetailSpace  = 15 *kScreenWidth/375;
        
        
        
    }
    
    _MidImageView=[UIImageView new];
    _MidImageView.image=[UIImage imageNamed:@"MidImageView"];
    [_backImageView addSubview:_MidImageView];
    
    _headerImageView=[UIImageView new];
    _headerImageView.image=[UIImage imageNamed:@"HeadImageView"];
    [_backImageView addSubview:_headerImageView];
    
    _FootLb = [UILabel new];
    _FootLb.text = _FootText;
    _FootLb.textAlignment = NSTextAlignmentCenter;
    _FootLb.textColor =  [UIColor  whiteColor];
    //    _FootLb.backgroundColor = [UIColor  redColor];
    //     _FootLb.adjustsFontSizeToFitWidth = YES;
    _FootLb.font = [UIFont  boldSystemFontOfSize:FootLbFont];
    _FootLb.numberOfLines = 2;
    [_headerImageView  addSubview:_FootLb];
    
    
    _FootImageView=[UIImageView new];
    _FootImageView.image=[UIImage imageNamed:@"FootImageView"];
    [_MidImageView addSubview:_FootImageView];
    
    
    UILabel* TankLb= [UILabel new];
    TankLb.textColor = UIColorFromRGB(0xfd82c7);
    TankLb.text = @"谢谢！";
    TankLb.font = [UIFont  boldSystemFontOfSize:TankLbFont];
    TankLb.textAlignment = NSTextAlignmentCenter;
    [_MidImageView  addSubview:TankLb];
    
    
    if (kScreenHeight == 480) {
        if (self.subtitleArray.count<=3) {
            Tanktop = 50-yy_space;
        }
        if (self.subtitleArray.count == 4) {
            Tanktop = 50 - 10-yy_space;
        }
        if (self.subtitleArray.count == 5) {
            Tanktop = 50 - 20-yy_space;
        }
        if (self.subtitleArray.count == 6) {
            Tanktop = 50 - 30 -yy_space;
        }
        
    }else{
        
        if (self.subtitleArray.count<=3) {
            Tanktop = 50;
        }
        if (self.subtitleArray.count == 4) {
            Tanktop = 50 - 10;
        }
        if (self.subtitleArray.count == 5) {
            Tanktop = 50 - 20;
        }
        if (self.subtitleArray.count == 6) {
            Tanktop = 50 - 30;
        }
    }
    
    
    
    
    
    _MidImageView.sd_layout.topSpaceToView(_backImageView,k_Midtop).centerXEqualToView(_backImageView).heightIs(MidImageHeight).widthIs(MidImageWidth);
    
    _headerImageView.sd_layout.topSpaceToView(_backImageView,k_Headtop).centerXEqualToView(_backImageView).heightIs(headerImageHeight).widthIs(headerImageWidth);
    
    _FootImageView.sd_layout.bottomSpaceToView(_MidImageView,k_Bootom).centerXEqualToView(_MidImageView).heightIs(FootImageHeight).widthIs(FootImageWidth);
    
    _FootLb.sd_layout.topSpaceToView(_headerImageView,k_Footop).centerXEqualToView(_headerImageView).widthIs(FootLbWidth).heightIs(FootLbHeight);
    
    TankLb.sd_layout.bottomSpaceToView(_FootImageView,Tanktop).leftEqualToView(_MidImageView).rightEqualToView(_MidImageView).heightIs(TankLbFont);
    
    
    for(int i=0;i<self.subtitleArray.count;++i){
        UILabel* detail=[UILabel new];
        detail.textColor=UIColorFromRGB(0x666666);
        detail.font=[UIFont boldSystemFontOfSize:DetailLbFont];
        detail.textAlignment=NSTextAlignmentCenter;
        detail.text=self.subtitleArray[i];
        [_MidImageView addSubview:detail];
        [self.subtitleLabelArray addObject:detail];
        
        detail.sd_layout.topSpaceToView(_MidImageView,DetailYSpace+i*(2*DetailSpace-3)).heightIs(DetailLbFont).leftEqualToView(_MidImageView).rightEqualToView(_MidImageView);
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
