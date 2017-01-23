//
//  GBFoodServiceCommitViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBFoodServiceCommitViewController.h"
#import "GBHealthServiceViewController.h"

#define KW_ProgressXspace  2
#define KW_ProgressTop  15
#define  x_Space     (kScreenWidth-54-15*3-KW_ProgressXspace*8)/9

@interface GBFoodServiceCommitViewController ()
@property(nonatomic,strong)UIScrollView  *scrollView;
@property(nonatomic,strong)UIView  *containerView;
@property(nonatomic,strong)UIButton  *progressOneBtn;
@property(nonatomic,strong)UIButton  *progressTwoBtn;
@property(nonatomic,strong)UIButton  *progressThreeBtn;
@property(nonatomic,strong)UIButton  *progressFourBtn;
@property(nonatomic,strong)UIButton  *progressFiveBtn;
@property(nonatomic,strong)UIButton  *lineOneBtn;
@property(nonatomic,strong)UIButton  *lineTwoBtn;
@property(nonatomic,strong)UIButton  *lineThreeBtn;
@property(nonatomic,strong)UIButton  *lineFourBtn;
@property(nonatomic,strong)UILabel  *statisticsLable;
@property(nonatomic,strong)UIImageView  *FootView;
@property(nonatomic,strong)UILabel  *Footlb;

@end

@implementation GBFoodServiceCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRightBarWithTitle:@"完成"];
    [self initLeftBarWithTitle:@""];

    // Do any additional setup after loading the view.
}
-(void)setupView{
    self.view.backgroundColor = [UIColor  whiteColor];
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_containerView];
    
    _progressOneBtn = [UIButton  new];
    [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_progressOneBtn];
    _lineOneBtn = [UIButton  new];
    [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineOneBtn];
    
    
    _progressTwoBtn = [UIButton  new];
    [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressTwoBtn];
    _lineTwoBtn = [UIButton  new];
    [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineTwoBtn];
    
    
    _progressThreeBtn = [UIButton  new];
    [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_progressThreeBtn];
    _lineThreeBtn = [UIButton  new];
    [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineThreeBtn];
    
    
    _progressFourBtn = [UIButton  new];
    [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressFourBtn];
    _lineFourBtn = [UIButton  new];
    [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineFourBtn];
    
    
    _progressFiveBtn = [UIButton  new];
    [_progressFiveBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressFiveBtn];
    _statisticsLable = [UILabel new];
    _statisticsLable.font = [UIFont systemFontOfSize:18];
    _statisticsLable.textColor = UIColorFromRGB(0xf06292);
    _statisticsLable.text = [NSString  stringWithFormat:@"%d/%d",_count,_count];
    [_containerView  addSubview:_statisticsLable];
    
    
    UIImageView  *topImageView = [UIImageView  new];
    topImageView.image = [UIImage  imageNamed:@"Star_Image"];
    [_containerView  addSubview:topImageView];
    
    _FootView = [UIImageView  new];
    _FootView.image = [UIImage imageNamed:@"centerImage"];
    CGFloat top = 30; // 顶端盖高度
    CGFloat bottom = 30 ; // 底端盖高度
    CGFloat left = 30; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _FootView.image = [_FootView.image  resizableImageWithCapInsets:insets  resizingMode:UIImageResizingModeStretch];
    
    
    [_containerView  addSubview:_FootView];
    
    UILabel  *Titlelb = [UILabel  new];
    Titlelb.numberOfLines = 1;
    Titlelb.backgroundColor = [UIColor clearColor];
    Titlelb.textColor = UIColorFromRGB(0x0bb6f8);
    Titlelb.font = [UIFont  systemFontOfSize:17];
    Titlelb.textAlignment = NSTextAlignmentCenter;
    Titlelb.text = @"测评结果";
    [_FootView  addSubview:Titlelb];
    
    
    _Footlb = [UILabel new];
    _Footlb.backgroundColor = [UIColor  clearColor];
    _Footlb.font = [UIFont systemFontOfSize:14];
    _Footlb.textColor = UIColorFromRGB(0x00a7a0);
//    _Footlb.text = @"您的测评已提交，请点击右上角完成-查看，您就可以查看测评结果。";
    _Footlb.text = _result;
    _Footlb.numberOfLines = 0 ;
    _Footlb.textAlignment = NSTextAlignmentLeft;
    [_FootView  addSubview:_Footlb];
    
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _containerView.sd_layout.topSpaceToView(_scrollView,0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
    
    _progressOneBtn.sd_layout.topSpaceToView(_containerView,KW_ProgressTop).leftSpaceToView(_containerView,25).widthIs(x_Space).heightIs(x_Space);
    _lineOneBtn.sd_layout.topSpaceToView(_containerView,KW_ProgressTop+x_Space/2).leftSpaceToView(_progressOneBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(1);
    _progressTwoBtn.sd_layout.topEqualToView(_progressOneBtn).leftSpaceToView(_lineOneBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(x_Space);
    _lineTwoBtn.sd_layout.topSpaceToView(_containerView,KW_ProgressTop+x_Space/2).leftSpaceToView(_progressTwoBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(1);
    _progressThreeBtn.sd_layout.topEqualToView(_progressOneBtn).leftSpaceToView(_lineTwoBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(x_Space);
    _lineThreeBtn.sd_layout.topSpaceToView(_containerView,KW_ProgressTop+x_Space/2).leftSpaceToView(_progressThreeBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(1);
    _progressFourBtn.sd_layout.topEqualToView(_progressOneBtn).leftSpaceToView(_lineThreeBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(x_Space);
    _lineFourBtn.sd_layout.topSpaceToView(_containerView,KW_ProgressTop+x_Space/2).leftSpaceToView(_progressFourBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(1);
    _progressFiveBtn.sd_layout.topEqualToView(_progressOneBtn).leftSpaceToView(_lineFourBtn,KW_ProgressXspace).widthIs(x_Space).heightIs(x_Space);
    
    _statisticsLable.sd_layout.topSpaceToView(_containerView,KW_ProgressTop+x_Space/2-15/2).leftSpaceToView(_progressFiveBtn,15).widthIs(54).heightIs(15);
    
    topImageView.sd_layout.topSpaceToView(_progressOneBtn,200/2).centerXIs(kScreenWidth/2.0).widthIs(180/2).heightIs(180/2);
    
    _FootView.sd_layout.topSpaceToView(topImageView,-1).centerXIs(kScreenWidth/2.0).widthIs(kFitWidthScale(530));

    Titlelb.sd_layout.topSpaceToView(_FootView,35).centerXIs(_FootView.size.width/2.0).widthIs(kScreenWidth).heightIs(17);
    
    _Footlb.sd_layout.topSpaceToView(Titlelb,30).centerXIs(_FootView.size.width/2.0).leftSpaceToView(_FootView,23).rightSpaceToView(_FootView,23).autoHeightRatio(0);
    
    [_FootView setupAutoHeightWithBottomView:_Footlb bottomMargin:30];
    [_containerView  setupAutoHeightWithBottomView:_FootView bottomMargin:10];
    
    [_scrollView  setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}
-(void)rightItemAction:(id)sender{
    
    UIViewController* back = nil;
    for(UIViewController* vc in self.navigationController.childViewControllers){
        if([vc isKindOfClass:[GBHealthServiceViewController class]]){
            back = vc;
            break;
        }
    }
    
    if(back){
        [self.navigationController popToViewController:back animated:NO];
    }
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
