//
//  GBHealthServiceCommitViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBHealthServiceCommitViewController.h"
#import "GBHealthServiceViewController.h"
#import "GBhomeViewController.h"

#define KW_ProgressXspace  2
#define KW_ProgressTop  15
#define  x_Space     (kScreenWidth-54-15*3-KW_ProgressXspace*8)/9

@interface GBHealthServiceCommitViewController ()

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

@implementation GBHealthServiceCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRightBarWithTitle:@"完成"];
    [self initLeftBarWithTitle:@""];
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
    
    _FootView = [UIImageView  new];
    [_FootView  setImage:[UIImage imageNamed:@"CommitButton"]];
    [_containerView  addSubview:_FootView];
    
    _Footlb = [UILabel new];
    _Footlb.backgroundColor = [UIColor  clearColor];
    _Footlb.font = [UIFont systemFontOfSize:14];
    _Footlb.textColor = UIColorFromRGB(0x00a7a0);
    _Footlb.text = @"您的测评已提交，请点击右上角完成-查看，您就可以查看测评结果。";
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
    
    CGFloat top =  150/2.0;
    if(kScreenHeight == 480){
        top = 40.0 ;
    }

    _FootView.sd_layout.topSpaceToView(_progressOneBtn,top).centerXIs(kScreenWidth/2.0).widthIs(390/2.0).heightIs(556/2.0);
    CGFloat height = 270/2.0;
    if(kScreenHeight == 480){
        height = 270/2.0-(150/2.0-70);
        
    }

    _Footlb.sd_layout.topSpaceToView(_FootView,height).centerXIs(_FootView.size.width/2.0).widthIs(312/2.0).autoHeightRatio(0);
    
    [_containerView  setupAutoHeightWithBottomView:_FootView bottomMargin:10];
    [_scrollView  setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}
-(void)rightItemAction:(id)sender{
    
    UIViewController* back = nil;
    for(UIViewController* vc in self.navigationController.childViewControllers){
        if([vc isKindOfClass:[GBhomeViewController class]]){
            back = vc;
            break;
        }
    }
    
    if(back){
        [self.navigationController popToViewController:back animated:NO];
    }
}
-(void)backItemAction:(id)sender{

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
