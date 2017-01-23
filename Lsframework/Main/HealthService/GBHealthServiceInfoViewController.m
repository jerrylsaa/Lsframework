//
//  GBHealthServiceInfoViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//


#import "GBHealthServiceInfoViewController.h"
#import "GBHealthServiceCommitViewController.h"
#import "GBHealthServiceInfooPresenter.h"
#import "DefaultChildEntity.h"
#import "ScreenAppraiseController.h"
#import "FoodDetailService.h"
#import "GBFoodServiceCommitViewController.h"
#import "GBHealthSucceedViewController.h"

#define KW_ProgressXspace  2
#define KW_ProgressTop  15
#define KW_selectBtnWidth  28 
#define k_QuestionWidth    172/2
#define k_QuestionLeft    (kScreenWidth-k_QuestionWidth*2)/4
#define  x_Space     (kScreenWidth-54-15*3-KW_ProgressXspace*8)/9
@interface GBHealthServiceInfoViewController ()<GBHealthServiceInfoPresenterDelegate>
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

@property(nonatomic,strong)UILabel  *numberLable;
@property(nonatomic,strong)UILabel  *contentLable;

@property(nonatomic,strong)UIButton  *selectOneBtn;
@property(nonatomic,strong)UIButton  *selectTwoBtn;
@property(nonatomic,strong)UIButton  *selectThreeBtn;
@property(nonatomic,strong)UIButton  *selectFourBtn;
@property(nonatomic,strong)UIButton  *selectFiveBtn;


@property(nonatomic,strong)UILabel  *selectOneLable;
@property(nonatomic,strong)UILabel  *selectTwoLable;
@property(nonatomic,strong)UILabel  *selectThreeLable;
@property(nonatomic,strong)UILabel  *selectFourLable;
@property(nonatomic,strong)UILabel  *selectFiveLable;

@property(nonatomic,strong)UIButton  *nextQuestionBtn;
@property(nonatomic,strong)UIButton  *lastQuestionBtn;

@property(nonatomic,strong)UIView  *commitView;
@property(nonatomic,strong)UIButton  *commitBtn;
@property(nonatomic,assign)NSInteger  number;
@property(nonatomic,strong)UIImageView  *remindingImageView;
@property(nonatomic,assign)NSNumber  *CurrentValue;
@property(nonatomic,assign)NSInteger  count;
@property(nonatomic,assign)NSInteger  titleIndex;
@property(nonatomic,copy)NSString  *str;
@property(nonatomic,assign)BOOL   enable;
@property(nonatomic,retain)GBHealthServiceInfooPresenter *presenter;

@end

@implementation GBHealthServiceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)setupView{

    _number = 0;
    _presenter = [GBHealthServiceInfooPresenter  new];
    _presenter.delegate = self;
    [ProgressUtil  show];
    if (_type == GBHealthServiceInfoTypeFromNormal) {
        //健康测评
//    [self initRightBarWithTitle:@"查看"];
  [_presenter   loadHealthServiceInfoWithTid:_healthService.TID];
    }else if (_type == GBHealthServiceInfoTypeFromFood){
    //饮食行为测评
    [_presenter   loadFoodServiceInfoWithTid:_TypeID];
    }
    self.view.backgroundColor = [UIColor  whiteColor];
    
    [self   setupProgressView];
    [self   setupContentView];
    [self   setupOptionsView];
    [self    setupNextView];
    [self   setupCommintView];
    
}
-(void)setupProgressView{
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_containerView];
    
    _progressOneBtn = [UIButton  new];
    [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressnormalBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_progressOneBtn];
    _lineOneBtn = [UIButton  new];
    [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"NolineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineOneBtn];
    
    
    _progressTwoBtn = [UIButton  new];
    [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressnormalBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressTwoBtn];
    _lineTwoBtn = [UIButton  new];
    [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"NolineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineTwoBtn];
    
    
    _progressThreeBtn = [UIButton  new];
    [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressnormalBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_progressThreeBtn];
    _lineThreeBtn = [UIButton  new];
    [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"NolineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineThreeBtn];
    
    
    _progressFourBtn = [UIButton  new];
    [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressnormalBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressFourBtn];
    _lineFourBtn = [UIButton  new];
    [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"NolineBtn"] forState:UIControlStateNormal];
    [_containerView  addSubview:_lineFourBtn];
    
    
    _progressFiveBtn = [UIButton  new];
    [_progressFiveBtn setBackgroundImage:[UIImage  imageNamed:@"progressnormalBtn"] forState:UIControlStateNormal];
    [_containerView addSubview:_progressFiveBtn];
    _statisticsLable = [UILabel new];
    _statisticsLable.font = [UIFont systemFontOfSize:18];
    _statisticsLable.textColor = UIColorFromRGB(0xf06292);
    //    _statisticsLable.text = @"1/";
    [_containerView  addSubview:_statisticsLable];
    
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

    
    
}
-(void)setupContentView{
    
    _numberLable = [UILabel  new];
    _numberLable.font = [UIFont  systemFontOfSize:15];
    _numberLable.textColor = UIColorFromRGB(0x666666);
    [_containerView addSubview:_numberLable];
    
    _contentLable = [UILabel  new];
    _contentLable.font = _numberLable.font;
    _contentLable.numberOfLines = 0;
    _contentLable.textColor = _numberLable.textColor;
    _contentLable.textAlignment = NSTextAlignmentLeft;
    [_containerView  addSubview:_contentLable];
    
    _numberLable.sd_layout.topSpaceToView(_statisticsLable,45).leftSpaceToView(_containerView,15).maxWidthIs(28).heightIs(15);
    [_numberLable  setSingleLineAutoResizeWithMaxWidth:28];
    _contentLable.sd_layout.topSpaceToView(_statisticsLable,45).leftSpaceToView(_numberLable,10).widthIs(kScreenWidth-_numberLable.size.width-15-10-15).autoHeightRatio(0);

}
-(void)setupOptionsView{
    _selectOneBtn = [UIButton  new];
    [_selectOneBtn  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectOneBtn setBackgroundImage:[UIImage  imageNamed:@"NoSelectBtn"] forState:UIControlStateNormal];
    [_selectOneBtn setBackgroundImage:[UIImage  imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    [_containerView  addSubview:_selectOneBtn];
    _selectTwoBtn = [UIButton  new];

    [_selectTwoBtn  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectTwoBtn setBackgroundImage:[UIImage  imageNamed:@"NoSelectBtn"] forState:UIControlStateNormal];
    [_selectTwoBtn setBackgroundImage:[UIImage  imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    
    [_containerView addSubview:_selectTwoBtn];
    
    _selectThreeBtn = [UIButton  new];

    [_selectThreeBtn  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectThreeBtn setBackgroundImage:[UIImage  imageNamed:@"NoSelectBtn"] forState:UIControlStateNormal];
    [_selectThreeBtn setBackgroundImage:[UIImage  imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    
    [_containerView  addSubview:_selectThreeBtn];
    
    _selectFourBtn = [UIButton  new];

    [_selectFourBtn  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectFourBtn setBackgroundImage:[UIImage  imageNamed:@"NoSelectBtn"] forState:UIControlStateNormal];
    [_selectFourBtn setBackgroundImage:[UIImage  imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    [_containerView  addSubview:_selectFourBtn];
    

    _selectFiveBtn = [UIButton  new];

    [_selectFiveBtn  addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectFiveBtn setBackgroundImage:[UIImage  imageNamed:@"NoSelectBtn"] forState:UIControlStateNormal];
    [_selectFiveBtn setBackgroundImage:[UIImage  imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    [_containerView addSubview:_selectFiveBtn];
    
    _selectOneLable = [UILabel  new];
    _selectOneLable.numberOfLines = 2;
    _selectOneLable.textColor = _numberLable.textColor;
    _selectOneLable.font = [UIFont  systemFontOfSize:14];
    _selectOneLable.textAlignment = NSTextAlignmentLeft;
    
    [_containerView  addSubview:_selectOneLable];
    
    _selectTwoLable = [UILabel  new];
    _selectTwoLable.numberOfLines = 2;
    _selectTwoLable.textColor = _numberLable.textColor;
    _selectTwoLable.font = _selectOneLable.font;
    _selectTwoLable.textAlignment = NSTextAlignmentLeft;
    
    [_containerView  addSubview:_selectTwoLable];
    
    _selectThreeLable = [UILabel  new];
    _selectThreeLable.numberOfLines = 2;
    _selectThreeLable.textColor = _numberLable.textColor;
    _selectThreeLable.font = _selectOneLable.font;
    
    _selectThreeLable.textAlignment = NSTextAlignmentLeft;
    
    [_containerView addSubview:_selectThreeLable];
    
    _selectFourLable = [UILabel  new];
    _selectFourLable.numberOfLines = 2;
    _selectFourLable.textColor = _numberLable.textColor;
    _selectFourLable.font = _selectOneLable.font;
    _selectFourLable.textAlignment = NSTextAlignmentLeft;
    [_containerView addSubview:_selectFourLable];
    
    _selectFiveLable = [UILabel  new];
    _selectFiveLable.numberOfLines = 2;
    _selectFiveLable.font = _selectOneLable.font;
    _selectFiveLable.textColor = _numberLable.textColor;
    _selectFiveLable.textAlignment = NSTextAlignmentLeft;
    [_containerView addSubview:_selectFiveLable];
    
    _selectOneBtn.sd_layout.topSpaceToView(_contentLable,20).leftEqualToView(_contentLable).widthIs(KW_selectBtnWidth).heightEqualToWidth(0);
    _selectOneLable.sd_layout.centerYEqualToView(_selectOneBtn).leftSpaceToView(_selectOneBtn,10).widthIs(kScreenWidth-_selectOneBtn.size.width-64).autoHeightRatio(0);
    
    _selectTwoBtn.sd_layout.topSpaceToView(_selectOneLable,10).leftEqualToView(_contentLable).widthIs(KW_selectBtnWidth).heightEqualToWidth(0);

    
    _selectTwoLable.sd_layout.centerYEqualToView(_selectTwoBtn).leftSpaceToView(_selectOneBtn,10).widthIs(kScreenWidth-_selectOneBtn.size.width-64).autoHeightRatio(0);
    
    _selectThreeBtn.sd_layout.topSpaceToView(_selectTwoLable,10).leftEqualToView(_contentLable).widthIs(KW_selectBtnWidth).heightEqualToWidth(0);

    _selectThreeLable.sd_layout.centerYEqualToView(_selectThreeBtn).leftSpaceToView(_selectOneBtn,10).widthIs(kScreenWidth-_selectOneBtn.size.width-64).autoHeightRatio(0);
    
    _selectFourBtn.sd_layout.topSpaceToView(_selectThreeLable,10).leftEqualToView(_contentLable).widthIs(KW_selectBtnWidth).heightEqualToWidth(0);
    
    _selectFourLable.sd_layout.centerYEqualToView(_selectFourBtn).leftSpaceToView(_selectOneBtn,10).widthIs(kScreenWidth-_selectOneBtn.size.width-64).autoHeightRatio(0);
    
    _selectFiveBtn.sd_layout.topSpaceToView(_selectFourLable,10).leftEqualToView(_contentLable).widthIs(KW_selectBtnWidth).heightEqualToWidth(0);
    
    _selectFiveLable.sd_layout.centerYEqualToView(_selectFiveBtn).leftSpaceToView(_selectFiveBtn,10).widthIs(kScreenWidth-_selectFiveBtn.size.width-64).autoHeightRatio(0);
}

-(void)setupNextView{
    _lastQuestionBtn = [UIButton  new];
    [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"NolastQuestionBtn"] forState:UIControlStateNormal];
    _lastQuestionBtn.tag = 106;
    [_lastQuestionBtn  addTarget:self action:@selector(QuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView  addSubview:_lastQuestionBtn];
    
    _nextQuestionBtn = [UIButton  new];
    [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
    _nextQuestionBtn.tag = 107;
    [_nextQuestionBtn  addTarget:self action:@selector(QuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView  addSubview:_nextQuestionBtn];
    
    CGFloat top =60;
    if(kScreenHeight == 480){
        top = 40;
    }

    _nextQuestionBtn.sd_layout.topSpaceToView(_selectFiveLable,top).rightSpaceToView(_containerView,k_QuestionLeft).widthIs(k_QuestionWidth).heightIs(76/2);
    
    _lastQuestionBtn.sd_layout.topSpaceToView(_selectFiveLable,top).leftSpaceToView(_containerView,k_QuestionLeft).rightSpaceToView(_nextQuestionBtn,2*k_QuestionLeft).heightIs(76/2);
    
    
    
}
-(void)setupCommintView{
    _commitView = [UIView  new];
    [_containerView  addSubview:_commitView];
    
    _commitBtn = [UIButton  new];
    [_commitBtn  setBackgroundImage: [UIImage  imageNamed:@"commitBtn"] forState:UIControlStateNormal];
    [_commitBtn  addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [_commitView  addSubview:_commitBtn];
    
    CGFloat top =50;
    if(kScreenWidth == 320){
        top = 30;
    }

    _commitView.sd_layout.topSpaceToView(_nextQuestionBtn,top).centerXIs(kScreenWidth/2).widthIs(458/2).heightIs(76/2);
    _commitBtn.sd_layout.topSpaceToView(_commitView,0).centerXEqualToView(_commitView).widthIs(458/2).heightIs(76/2);
    [_containerView setupAutoHeightWithBottomView:_commitView bottomMargin:10];
    [_scrollView  setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    
}
#pragma mark--  健康测评加载完成
-(void)onComplete:(BOOL) success info:(NSString*) info{
    if (success) {
        _enable  = NO;
        self.commitView.hidden = YES;
        [ProgressUtil dismiss];
        if (self.presenter.dataSource.count !=0) {
            if (self.presenter.dataSource[0].QuestTitle.length==0) {
            _statisticsLable.hidden = YES;
            _lastQuestionBtn.userInteractionEnabled = NO;
                _numberLable.hidden = YES;
            }else{

            }
            _statisticsLable.text = [NSString stringWithFormat:@"1/%ld",self.presenter.dataSource.count];
            NSArray  *array  = [NSArray  array];
            array = self.presenter.dataSource;
            HealthServiceInfo  *model = array[0];
            _contentLable.text = model.QuestDescript;
            _numberLable.text = @"1.";
            _titleIndex = 1;
            if (model.Content3.length == 0){
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
                _selectFourLable.hidden = YES;
                _selectFourBtn.hidden = YES;
                _selectThreeBtn.hidden = YES;
                _selectThreeLable.hidden = YES;
            }else  if (model.Content4.length == 0) {
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                
                _selectFourLable.hidden = YES;
                _selectFourBtn.hidden = YES;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
            }else  if (model.Content5.length == 0) {
                
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                _selectFourLable.text = model.Content4;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
            }
            else{

                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                _selectFourLable.text = model.Content4;
                _selectFiveLable.text = model.Content5;
            }
            [self.numberLable  updateLayout];
            [self.contentLable  updateLayout];
            
        }else{
            self.view.hidden = YES;
            [self.navigationController  popViewControllerAnimated:YES];
            [ProgressUtil  showInfo:@"当前没有问题"];
        }
        
    }else{
        [ProgressUtil showError:info];
    }
}
#pragma mark--  饮食行为测评加载完成
- (void)FoodSericeComplete:(BOOL) success info:(NSString*) info{

    if (success) {
        _enable  = NO;
        self.commitView.hidden = YES;
        [ProgressUtil dismiss];
        if (self.presenter.FoodSource.count !=0) {
            if (self.presenter.FoodSource[0].Type_ID == nil) {
                _statisticsLable.hidden = YES;
                _lastQuestionBtn.userInteractionEnabled = NO;
                _numberLable.hidden = YES;
            }else{
                
            }
            _statisticsLable.text = [NSString stringWithFormat:@"1/%ld",self.presenter.FoodSource.count];
            NSArray  *array  = [NSArray  array];
            array = self.presenter.FoodSource;
          FoodDetailService  *model = array[0];
            _contentLable.text = model.QuestDescript;
            _numberLable.text = @"1.";
            _titleIndex = 1;
            if (model.Content3.length == 0){
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
                _selectFourLable.hidden = YES;
                _selectFourBtn.hidden = YES;
                _selectThreeBtn.hidden = YES;
                _selectThreeLable.hidden = YES;
            }else  if (model.Content4.length == 0) {
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                
                _selectFourLable.hidden = YES;
                _selectFourBtn.hidden = YES;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
            }else  if (model.Content5.length == 0) {
                
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                _selectFourLable.text = model.Content4;
                _selectFiveBtn.hidden = YES;
                _selectFiveLable.hidden = YES;
            }
            else{
                
                _selectOneLable.text = model.Content1;
                _selectTwoLable.text = model.Content2;
                _selectThreeLable.text = model.Content3;
                _selectFourLable.text = model.Content4;
                _selectFiveLable.text = model.Content5;
            }
            [self.numberLable  updateLayout];
            [self.contentLable  updateLayout];
            
        }else{
            self.view.hidden = YES;
            [self.navigationController  popViewControllerAnimated:YES];
            [ProgressUtil  showInfo:@"当前没有问题"];
        }
        
    }else{
        [ProgressUtil showError:info];
    }



}

#pragma mark--点击事件----
-(void)selectBtnClick:(UIButton*)btn{
    if (btn == _selectOneBtn) {
        _selectOneBtn.selected = YES;
        _selectTwoBtn.selected=NO;
        _selectThreeBtn.selected=NO;
        _selectFourBtn.selected=NO;
        _selectFiveBtn.selected=NO;
    }    if (btn == _selectTwoBtn) {
        _selectOneBtn.selected = NO;
        _selectTwoBtn.selected=YES;
        _selectThreeBtn.selected=NO;
        _selectFourBtn.selected=NO;
        _selectFiveBtn.selected=NO;
    }    if (btn == _selectThreeBtn) {
        _selectOneBtn.selected = NO;
        _selectTwoBtn.selected=NO;
        _selectThreeBtn.selected=YES;
        _selectFourBtn.selected=NO;
        _selectFiveBtn.selected=NO;
    }    if (btn == _selectFourBtn) {
        _selectOneBtn.selected = NO;
        _selectTwoBtn.selected=NO;
        _selectThreeBtn.selected=NO;
        _selectFourBtn.selected=YES;
        _selectFiveBtn.selected=NO;
    }    if (btn == _selectFiveBtn) {
        _selectOneBtn.selected = NO;
        _selectTwoBtn.selected=NO;
        _selectThreeBtn.selected=NO;
        _selectFourBtn.selected=NO;
        _selectFiveBtn.selected=YES;
    }

    if(_type == GBHealthServiceInfoTypeFromNormal){
    HealthServiceInfo *model = self.presenter.dataSource[_titleIndex-1];
    _str = [NSString  stringWithFormat:@"%@",model.ID];
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    //记录按钮的选中状态
    if (btn == _selectOneBtn) {
        [userDefaults setObject:@"1" forKey:_str];
        [userDefaults  synchronize];
    }else if ( btn == _selectTwoBtn){
        [userDefaults setObject:@"2" forKey:_str];
        [userDefaults  synchronize];
    }else if (btn == _selectThreeBtn){
        [userDefaults setObject:@"3" forKey:_str];
        [userDefaults  synchronize];
    }else if ( btn == _selectFourBtn){
        [userDefaults setObject:@"4" forKey:_str];
        [userDefaults  synchronize];
    }else if (btn == _selectFiveBtn){
        [userDefaults setObject:@"5" forKey:_str];
        [userDefaults  synchronize];
    }else{
        [userDefaults setObject:@"0" forKey:_str];
        [userDefaults  synchronize];
    }
    //记录当前title 选中的value值
    if(_selectOneBtn.isSelected ==YES){
        _CurrentValue = model.value1;
        [userDefaults  setObject:model.value1 forKey:model.QuestTitle];
    }
    if (_selectTwoBtn.isSelected == YES) {
        _CurrentValue = model.value2;
        [userDefaults  setObject:model.value2 forKey:model.QuestTitle];
    }
    if (_selectThreeBtn.isHidden == NO && _selectThreeBtn.isSelected == YES) {
        _CurrentValue = model.value3;
        [userDefaults  setObject:model.value3 forKey:model.QuestTitle];    }    if (_selectFourBtn.isHidden == NO && _selectFourBtn.isSelected == YES) {
            _CurrentValue = model.value4;
            [userDefaults  setObject:model.value4 forKey:model.QuestTitle];    }    if (_selectFiveBtn.isHidden == NO && _selectFiveBtn.isSelected == YES) {
                _CurrentValue = model.value5;
                [userDefaults  setObject:model.value5 forKey:model.QuestTitle];    }
    NSString  *String = [userDefaults  objectForKey:model.QuestTitle];
    _nextQuestionBtn.userInteractionEnabled = YES;
    _enable = YES;
    //进度条
    if (model.QuestTitle.length == 0) {
    }else{
        float  a = self.presenter.dataSource.count;
        float  b = _titleIndex/a;
        if (b>=0.2) {
            [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
        } if(b>=0.4){
            [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
        } if(b>=0.6){
            [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
        } if(b>=0.8){
            [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
        }if(b==1.0){
            [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            [_progressFiveBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
        }
    }
    }else if (_type == GBHealthServiceInfoTypeFromFood){
    
        NSLog(@"选中饮食行为测评按钮");
        FoodDetailService *model = self.presenter.FoodSource[_titleIndex-1];
        _str = [NSString  stringWithFormat:@"%@",model.Type_ID];
        NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
        //记录按钮的选中状态
        if (btn == _selectOneBtn) {
            [userDefaults setObject:@"1" forKey:_str];
            [userDefaults  synchronize];
        }else if ( btn == _selectTwoBtn){
            [userDefaults setObject:@"2" forKey:_str];
            [userDefaults  synchronize];
        }else if (btn == _selectThreeBtn){
            [userDefaults setObject:@"3" forKey:_str];
            [userDefaults  synchronize];
        }else if ( btn == _selectFourBtn){
            [userDefaults setObject:@"4" forKey:_str];
            [userDefaults  synchronize];
        }else if (btn == _selectFiveBtn){
            [userDefaults setObject:@"5" forKey:_str];
            [userDefaults  synchronize];
        }else{
            [userDefaults setObject:@"0" forKey:_str];
            [userDefaults  synchronize];
        }
        //记录当前title 选中的value值
        if(_selectOneBtn.isSelected ==YES){
            _CurrentValue = model.value1;
            [userDefaults  setObject:model.value1 forKey:model.QuestDescript];
        }
        if (_selectTwoBtn.isSelected == YES) {
            _CurrentValue = model.value2;
            [userDefaults  setObject:model.value2 forKey:model.QuestDescript];
        }
        if (_selectThreeBtn.isHidden == NO && _selectThreeBtn.isSelected == YES) {
            _CurrentValue = model.value3;
            [userDefaults  setObject:model.value3 forKey:model.QuestDescript];
        }    if (_selectFourBtn.isHidden == NO && _selectFourBtn.isSelected == YES) {
                _CurrentValue = model.value4;
                [userDefaults  setObject:model.value4 forKey:model.QuestDescript];
        }    if (_selectFiveBtn.isHidden == NO && _selectFiveBtn.isSelected == YES) {
                    _CurrentValue = model.value5;
                    [userDefaults  setObject:model.value5 forKey:model.QuestDescript];
        }
        NSString  *String = [userDefaults  objectForKey:model.QuestDescript];
        _nextQuestionBtn.userInteractionEnabled = YES;
        _enable = YES;
        //进度条
            float  a = self.presenter.FoodSource.count;
            float  b = _titleIndex/a;
            if (b>=0.2) {
                [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            } if(b>=0.4){
                [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            } if(b>=0.6){
                [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            } if(b>=0.8){
                [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
            }if(b==1.0){
                [_progressOneBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineOneBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressTwoBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineTwoBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressThreeBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineThreeBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressFourBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
                [_lineFourBtn setBackgroundImage:[UIImage  imageNamed:@"SelectlineBtn"] forState:UIControlStateNormal];
                [_progressFiveBtn setBackgroundImage:[UIImage  imageNamed:@"progressSelectBtn"] forState:UIControlStateNormal];
            }
    }
 
}

-(void)QuestionBtn:(UIButton*)btn{
#pragma mark-- 上一题
    if (_type == GBHealthServiceInfoTypeFromNormal) {
        //健康测评
        
        if (btn.tag == 106) {
            //上一题
            _nextQuestionBtn.userInteractionEnabled = YES;
            if (_titleIndex == 1) {
                //            _enable = NO;
            }else{
                _enable = YES;
            }
            
            self.commitView.hidden = YES;
            _number--;
            if (_number < self.presenter.dataSource.count||_number>= 0) {
                NSInteger   index = _number ;
                HealthServiceInfo  *model = self.presenter.dataSource[index];
                _titleIndex = index+1;
                _contentLable.text = model.QuestDescript;
                //隐藏没有值的button
                if (model.Content3.length == 0){
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                    _selectFourLable.hidden = YES;
                    _selectFourBtn.hidden = YES;
                    _selectThreeBtn.hidden = YES;
                    _selectThreeLable.hidden = YES;
                }else  if (model.Content4.length == 0) {
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeBtn.hidden = NO;
                        _selectThreeLable.hidden = NO;
                    }
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    
                    _selectFourLable.hidden = YES;
                    _selectFourBtn.hidden = YES;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                }else  if (model.Content5.length == 0) {
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeLable.hidden = NO;
                        _selectThreeBtn.hidden = NO;
                    }
                    if (_selectFourBtn.isHidden == YES) {
                        _selectFourBtn.hidden = NO;
                        _selectFourLable.hidden = NO;
                    }
                    
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    _selectFourLable.text = model.Content4;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                }
                else{
                    if (_selectFiveBtn.isHidden == YES) {
                        _selectFiveBtn.hidden = NO;
                        _selectFiveLable.hidden = NO;
                    }
                    if (_selectFourBtn.isHidden == YES) {
                        _selectFourBtn.hidden = NO;
                        _selectFourLable.hidden = NO;
                    }
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeLable.hidden = NO;
                        _selectThreeBtn.hidden = NO;
                    }
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    _selectFourLable.text = model.Content4;
                    _selectFiveLable.text = model.Content5;
                }
#pragma mark ---显示上一题当前选中的button
                NSString *stt = [NSString  stringWithFormat:@"%@",model.ID];
                NSUserDefaults  *UserDefaults = [NSUserDefaults   standardUserDefaults];
                NSString   *str1 = [UserDefaults objectForKey:stt];
                _selectOneBtn.selected = NO;
                _selectTwoBtn.selected = NO;
                _selectThreeBtn.selected = NO;
                _selectFourBtn.selected = NO;
                _selectFiveBtn.selected = NO;
                if ([str1 isEqualToString:@"1"]) {
                    _selectOneBtn.selected = YES;
                } if ([str1 isEqualToString:@"2"]) {
                    _selectTwoBtn.selected = YES;
                } if ([str1 isEqualToString:@"3"]) {
                    _selectThreeBtn.selected = YES;
                } if ([str1 isEqualToString:@"4"]) {
                    _selectFourBtn.selected = YES;
                }if ([str1 isEqualToString:@"5"]) {
                    _selectFiveBtn.selected = YES;
                }
                _numberLable.text = [NSString  stringWithFormat:@"%d.",index+1];
                
                _statisticsLable.text = [NSString stringWithFormat:@"%d/%d",index+1,self.presenter.dataSource.count];
#pragma mark-- 显示 上一题和下一题  按钮的状态
                if (index == 0) {
                    [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                    [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"NolastQuestionBtn"] forState:UIControlStateNormal];
                }else{
                    [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                    [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                }
                [self.numberLable  updateLayout];
                [self.contentLable  updateLayout];
            }else{
#pragma mark-- 判断如果 QuestTitle为空，上一题为请求TID=7
                
                if (self.presenter.dataSource[0].QuestTitle.length==0) {
                    [_presenter  loadHealthServiceInfoWithTid:_healthService.TID];
                    _selectOneBtn.selected = NO;
                    _selectTwoBtn.selected = NO;
                    _selectThreeBtn.selected = NO;
                    _selectFourBtn.selected = NO;
                    _selectFiveBtn.selected = NO;
                    
                }else
                    _number = 0;
            }
#pragma mark-- 下一题
        }else if (btn.tag == 107){
            if (_enable == NO) {
                if (_titleIndex == self.presenter.dataSource.count) {
                }else{
                    [ProgressUtil showInfo:@"请选择选项后，再点击下一题"];
                }
                _nextQuestionBtn.userInteractionEnabled = NO;
            }
            else {
                
                if (self.presenter.dataSource[0].QuestTitle.length == 0) {
                    //0 --  1岁
                    if (_selectOneBtn.isSelected == YES) {
                        [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value1];
                        _selectOneBtn.selected = NO;
                        _selectTwoBtn.selected = NO;
                        _selectThreeBtn.selected = NO;
                        _selectFourBtn.selected = NO;
                        _selectFiveBtn.selected = NO;
                        
                        if (_selectOneBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value1];
                            
                        } if (_selectTwoBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value2];
                            
                        } if (_selectThreeBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value3];
                            
                        } if (_selectFourBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value4];
                            
                        } if (_selectFiveBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value5];
                        }
                        _statisticsLable.hidden = NO;
                        _lastQuestionBtn.userInteractionEnabled = YES;
                        _numberLable.hidden = NO;
                    }
                    //2 --  3岁
                    if (_selectTwoBtn.isSelected == YES) {
                        [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value2];
                        _selectOneBtn.selected = NO;
                        _selectTwoBtn.selected = NO;
                        _selectThreeBtn.selected = NO;
                        _selectFourBtn.selected = NO;
                        _selectFiveBtn.selected = NO;
                        
                        if (_selectOneBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value1];
                        } if (_selectTwoBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value2];
                        } if (_selectThreeBtn.isSelected == YES) {
                            [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value3];
                        }
                        _statisticsLable.hidden = NO;
                        _lastQuestionBtn.userInteractionEnabled = YES;
                        _numberLable.hidden = NO;
                    }
                    //4岁
                    if (_selectThreeBtn.isSelected == YES) {
                        [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value3];
                        _statisticsLable.hidden = NO;
                        _lastQuestionBtn.userInteractionEnabled = YES;
                        _numberLable.hidden = NO;
                    }
                    //5岁
                    if (_selectFourBtn.isSelected == YES) {
                        [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value4];
                        _statisticsLable.hidden = NO;
                        _lastQuestionBtn.userInteractionEnabled = YES;
                        _numberLable.hidden = NO;
                    }
                    //6岁
                    if (_selectFiveBtn.isSelected == YES) {
                        
                        [_presenter  loadMoreDataWithTid:self.presenter.dataSource[0].value5];
                        _statisticsLable.hidden = NO;
                        _lastQuestionBtn.userInteractionEnabled = YES;
                        _numberLable.hidden = NO;
                    }
                    
                }
                else{
                    //下一题
                    _number++;
                    if (_number <= self.presenter.dataSource.count-1) {
                        NSInteger   index = _number ;
                        HealthServiceInfo  *model = self.presenter.dataSource[index];
                        _titleIndex = index+1;
                        if (model.Content3.length == 0){
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                            _selectFourLable.hidden = YES;
                            _selectFourBtn.hidden = YES;
                            _selectThreeBtn.hidden = YES;
                            _selectThreeLable.hidden = YES;
                        }else  if (model.Content4.length == 0) {
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeBtn.hidden = NO;
                                _selectThreeLable.hidden = NO;
                            }
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            
                            _selectFourLable.hidden = YES;
                            _selectFourBtn.hidden = YES;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                        }else  if (model.Content5.length == 0) {
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeLable.hidden = NO;
                                _selectThreeBtn.hidden = NO;
                            }
                            if (_selectFourBtn.isHidden == YES) {
                                _selectFourBtn.hidden = NO;
                                _selectFourLable.hidden = NO;
                            }
                            
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            _selectFourLable.text = model.Content4;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                        }
                        else{
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeLable.hidden = NO;
                                _selectThreeBtn.hidden = NO;
                            }  if (_selectFourBtn.isHidden == YES) {
                                _selectFourBtn.hidden = NO;
                                _selectFourLable.hidden = NO;
                            }
                            if (_selectFiveBtn.isHidden == YES) {
                                _selectFiveBtn.hidden = NO;
                                _selectFiveLable.hidden = NO;
                            }
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            _selectFourLable.text = model.Content4;
                            _selectFiveLable.text = model.Content5;
                        }
#pragma mark - -  显示下一题选中的button
                        NSString *stt = [NSString  stringWithFormat:@"%@",model.ID];
                        NSUserDefaults  *userUserDefaults = [NSUserDefaults   standardUserDefaults];
                        NSString   *str1 = [userUserDefaults objectForKey:stt];
                        _selectOneBtn.selected = NO;
                        _selectTwoBtn.selected = NO;
                        _selectThreeBtn.selected = NO;
                        _selectFourBtn.selected = NO;
                        _selectFiveBtn.selected = NO;
                        if ([str1 isEqualToString:@"1"]) {
                            _selectOneBtn.selected = YES;
                        } if ([str1 isEqualToString:@"2"]) {
                            _selectTwoBtn.selected = YES;
                        } if ([str1 isEqualToString:@"3"]) {
                            _selectThreeBtn.selected = YES;
                        } if ([str1 isEqualToString:@"4"]) {
                            _selectFourBtn.selected = YES;
                        }if ([str1 isEqualToString:@"5"]) {
                            _selectFiveBtn.selected = YES;
                        }
                        _contentLable.text = model.QuestDescript;
                        _numberLable.text = [NSString  stringWithFormat:@"%ld.",index+1];
                        _statisticsLable.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)self.presenter.dataSource.count];
                        if (index == self.presenter.dataSource.count-1) {
                            self.commitView.hidden = NO;
                            [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"NonextQuestionBtn"] forState:UIControlStateNormal];
                            [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                        }else{
                            [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                            [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                        }
                        [self.numberLable  updateLayout];
                        [self.contentLable  updateLayout];
                    }else{
                        _number = self.presenter.dataSource.count-1;
                        _commitBtn.userInteractionEnabled = YES;
                        
                    }
                }
            }
            if (_selectOneBtn.isSelected == YES ||_selectTwoBtn.isSelected == YES ||_selectThreeBtn.isSelected == YES ||_selectFourBtn.isSelected == YES ||_selectFiveBtn.isSelected == YES ) {
                _enable =  YES;
            }
            else{
                _enable =  NO;
            }
        }

    }else if (_type == GBHealthServiceInfoTypeFromFood){
    //饮食行为测评
        
        if (btn.tag == 106) {
            //上一题
            _nextQuestionBtn.userInteractionEnabled = YES;
            if (_titleIndex == 1) {
                //            _enable = NO;
            }else{
                _enable = YES;
            }
            
            self.commitView.hidden = YES;
            _number--;
            if (_number < self.presenter.FoodSource.count||_number>= 0) {
                NSInteger   index = _number ;
                FoodDetailService  *model = self.presenter.FoodSource[index];
                _titleIndex = index+1;
                _contentLable.text = model.QuestDescript;
                //隐藏没有值的button
                if (model.Content3.length == 0){
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                    _selectFourLable.hidden = YES;
                    _selectFourBtn.hidden = YES;
                    _selectThreeBtn.hidden = YES;
                    _selectThreeLable.hidden = YES;
                }else  if (model.Content4.length == 0) {
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeBtn.hidden = NO;
                        _selectThreeLable.hidden = NO;
                    }
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    
                    _selectFourLable.hidden = YES;
                    _selectFourBtn.hidden = YES;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                }else  if (model.Content5.length == 0) {
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeLable.hidden = NO;
                        _selectThreeBtn.hidden = NO;
                    }
                    if (_selectFourBtn.isHidden == YES) {
                        _selectFourBtn.hidden = NO;
                        _selectFourLable.hidden = NO;
                    }
                    
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    _selectFourLable.text = model.Content4;
                    _selectFiveBtn.hidden = YES;
                    _selectFiveLable.hidden = YES;
                }
                else{
                    if (_selectFiveBtn.isHidden == YES) {
                        _selectFiveBtn.hidden = NO;
                        _selectFiveLable.hidden = NO;
                    }
                    if (_selectFourBtn.isHidden == YES) {
                        _selectFourBtn.hidden = NO;
                        _selectFourLable.hidden = NO;
                    }
                    if (_selectThreeBtn.isHidden == YES) {
                        _selectThreeLable.hidden = NO;
                        _selectThreeBtn.hidden = NO;
                    }
                    _selectOneLable.text = model.Content1;
                    _selectTwoLable.text = model.Content2;
                    _selectThreeLable.text = model.Content3;
                    _selectFourLable.text = model.Content4;
                    _selectFiveLable.text = model.Content5;
                }
#pragma mark ---显示上一题当前选中的button
                NSString *stt = [NSString  stringWithFormat:@"%@",model.Type_ID];
                NSUserDefaults  *UserDefaults = [NSUserDefaults   standardUserDefaults];
                NSString   *str1 = [UserDefaults objectForKey:stt];
                _selectOneBtn.selected = NO;
                _selectTwoBtn.selected = NO;
                _selectThreeBtn.selected = NO;
                _selectFourBtn.selected = NO;
                _selectFiveBtn.selected = NO;
                if ([str1 isEqualToString:@"1"]) {
                    _selectOneBtn.selected = YES;
                } if ([str1 isEqualToString:@"2"]) {
                    _selectTwoBtn.selected = YES;
                } if ([str1 isEqualToString:@"3"]) {
                    _selectThreeBtn.selected = YES;
                } if ([str1 isEqualToString:@"4"]) {
                    _selectFourBtn.selected = YES;
                }if ([str1 isEqualToString:@"5"]) {
                    _selectFiveBtn.selected = YES;
                }
                _numberLable.text = [NSString  stringWithFormat:@"%d.",index+1];
                
                _statisticsLable.text = [NSString stringWithFormat:@"%d/%d",index+1,self.presenter.FoodSource.count];
#pragma mark-- 显示 上一题和下一题  按钮的状态
                if (index == 0) {
                    [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                    [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"NolastQuestionBtn"] forState:UIControlStateNormal];
                }else{
                    [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                    [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                }
                [self.numberLable  updateLayout];
                [self.contentLable  updateLayout];
            }else{
                   _number = 0;
            }
#pragma mark-- 下一题
        }else if (btn.tag == 107){
            if (_enable == NO) {
                if (_titleIndex == self.presenter.FoodSource.count) {
                }else{
                    [ProgressUtil showInfo:@"请选择选项后，再点击下一题"];
                }
                _nextQuestionBtn.userInteractionEnabled = NO;
            }
            else {
                    //下一题
                    _number++;
                    if (_number <= self.presenter.FoodSource.count-1) {
                        NSInteger   index = _number ;
                        FoodDetailService  *model = self.presenter.FoodSource[index];
                        _titleIndex = index+1;
                        if (model.Content3.length == 0){
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                            _selectFourLable.hidden = YES;
                            _selectFourBtn.hidden = YES;
                            _selectThreeBtn.hidden = YES;
                            _selectThreeLable.hidden = YES;
                        }else  if (model.Content4.length == 0) {
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeBtn.hidden = NO;
                                _selectThreeLable.hidden = NO;
                            }
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            
                            _selectFourLable.hidden = YES;
                            _selectFourBtn.hidden = YES;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                        }else  if (model.Content5.length == 0) {
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeLable.hidden = NO;
                                _selectThreeBtn.hidden = NO;
                            }
                            if (_selectFourBtn.isHidden == YES) {
                                _selectFourBtn.hidden = NO;
                                _selectFourLable.hidden = NO;
                            }
                            
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            _selectFourLable.text = model.Content4;
                            _selectFiveBtn.hidden = YES;
                            _selectFiveLable.hidden = YES;
                        }
                        else{
                            if (_selectThreeBtn.isHidden == YES) {
                                _selectThreeLable.hidden = NO;
                                _selectThreeBtn.hidden = NO;
                            }  if (_selectFourBtn.isHidden == YES) {
                                _selectFourBtn.hidden = NO;
                                _selectFourLable.hidden = NO;
                            }
                            if (_selectFiveBtn.isHidden == YES) {
                                _selectFiveBtn.hidden = NO;
                                _selectFiveLable.hidden = NO;
                            }
                            _selectOneLable.text = model.Content1;
                            _selectTwoLable.text = model.Content2;
                            _selectThreeLable.text = model.Content3;
                            _selectFourLable.text = model.Content4;
                            _selectFiveLable.text = model.Content5;
                        }
#pragma mark - -  显示下一题选中的button
                        NSString *stt = [NSString  stringWithFormat:@"%@",model.Type_ID];
                        NSUserDefaults  *userUserDefaults = [NSUserDefaults   standardUserDefaults];
                        NSString   *str1 = [userUserDefaults objectForKey:stt];
                        _selectOneBtn.selected = NO;
                        _selectTwoBtn.selected = NO;
                        _selectThreeBtn.selected = NO;
                        _selectFourBtn.selected = NO;
                        _selectFiveBtn.selected = NO;
                        if ([str1 isEqualToString:@"1"]) {
                            _selectOneBtn.selected = YES;
                        } if ([str1 isEqualToString:@"2"]) {
                            _selectTwoBtn.selected = YES;
                        } if ([str1 isEqualToString:@"3"]) {
                            _selectThreeBtn.selected = YES;
                        } if ([str1 isEqualToString:@"4"]) {
                            _selectFourBtn.selected = YES;
                        }if ([str1 isEqualToString:@"5"]) {
                            _selectFiveBtn.selected = YES;
                        }
                        _contentLable.text = model.QuestDescript;
                        _numberLable.text = [NSString  stringWithFormat:@"%ld.",index+1];
                        _statisticsLable.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)self.presenter.FoodSource.count];
                        if (index == self.presenter.FoodSource.count-1) {
                            self.commitView.hidden = NO;
                            [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"NonextQuestionBtn"] forState:UIControlStateNormal];
                            [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                        }else{
                            [_nextQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"nextQuestionBtn"] forState:UIControlStateNormal];
                            [_lastQuestionBtn setBackgroundImage:[UIImage  imageNamed:@"lastQuestionBtn"] forState:UIControlStateNormal];
                        }
                        [self.numberLable  updateLayout];
                        [self.contentLable  updateLayout];
                    }else{
                        _number = self.presenter.FoodSource.count-1;
                        _commitBtn.userInteractionEnabled = YES;
                        
                    }
            }
            if (_selectOneBtn.isSelected == YES ||_selectTwoBtn.isSelected == YES ||_selectThreeBtn.isSelected == YES ||_selectFourBtn.isSelected == YES ||_selectFiveBtn.isSelected == YES ) {
                _enable =  YES;
            }
            else{
                _enable =  NO;
            }
        }
        

    
    }
    
    }

-(void)commit:(UIButton*)btn{
    if (_enable == NO) {
       [ProgressUtil  showInfo:@"请选择后再提交"];
    }else{
        if (_type == GBHealthServiceInfoTypeFromNormal) {
            //健康测评
            //转换json字符串
            NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.presenter.dataSource.count+1];
            NSNumber* babyID = [DefaultChildEntity defaultChild].babyID;
            [mutableDictionary  setObject:[NSString stringWithFormat:@"%@",babyID] forKey:@"userID"];
            for (int  i = 0; i<self.presenter.dataSource.count; i++) {
                HealthServiceInfo *model = self.presenter.dataSource[i];
                NSUserDefaults  *UserDefaults = [NSUserDefaults   standardUserDefaults];
                NSString   *str1 = [UserDefaults objectForKey:model.QuestTitle];
                [mutableDictionary  setObject:[NSString  stringWithFormat:@"%@",str1] forKey:model.QuestTitle];
            }
            //将字典转换成json字符串
            NSData *data = [NSJSONSerialization  dataWithJSONObject:mutableDictionary options:kNilOptions error:nil];
            NSString   *jsonString = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"健康测评%@",jsonString);
            [self.presenter  commitWithEvalName:self.EvalName andJsparam:jsonString];

        }else if (_type == GBHealthServiceInfoTypeFromFood){
        //饮食行为测评
            //转换json字符串
            NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.presenter.FoodSource.count+1];
            for (int  i = 0; i<self.presenter.FoodSource.count; i++) {
            FoodDetailService *model = self.presenter.FoodSource[i];
            NSUserDefaults  *UserDefaults = [NSUserDefaults   standardUserDefaults];
            NSString   *str1 = [UserDefaults objectForKey:[NSString  stringWithFormat:@"%@",model.QuestDescript]];
            [mutableDictionary  setObject:[NSString  stringWithFormat:@"%@",str1] forKey:[NSString  stringWithFormat:@"%@",model.Type_ID]];
            }
            //将字典转换成json字符串
            NSData *data = [NSJSONSerialization  dataWithJSONObject:mutableDictionary options:kNilOptions error:nil];
            NSString   *jsonString = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"饮食行为%@",jsonString);
            [self.presenter  commitWithJsparam:jsonString];
        }
    }
}




-(void)commitOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        
        GBHealthSucceedViewController  *vc = [GBHealthSucceedViewController  new];
        vc.title = self.title;
        vc.IsHealth = self.presenter.IsHealth;
        vc.ResultID = self.presenter.ResultID;
        vc.Result = self.presenter.Result;
        if (self.presenter.IsHealth) {
            NSLog(@"真");
        vc.type = GBHealthSucceedTypeFromhealth;
        }else{
            NSLog(@"假");
        vc.type = GBHealthSucceedTypeFromNohealth;
        }
        vc.EvalName =   self.EvalName;
        NSLog(@"GBHealthSucceedViewController：%hhd---%@---%@---%@",vc.IsHealth,vc.ResultID,vc.Result,vc.EvalName);
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        [ProgressUtil showError:message];
    }
}
-(void)commitFoodOnCompletion:(BOOL) success info:(NSString*) message{
    if(success){
        [ProgressUtil dismiss];
        GBFoodServiceCommitViewController  *vc = [GBFoodServiceCommitViewController  new];
        vc.count = self.presenter.FoodSource.count;
        vc.title = self.title;
        vc.result = self.presenter.Result;
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        [ProgressUtil showError:message];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_type == GBHealthServiceInfoTypeFromNormal) {
        for (int i = 0; i<self.presenter.dataSource.count; i++) {
            HealthServiceInfo *model = self.presenter.dataSource[i];
            _str = [NSString  stringWithFormat:@"%@",model.ID];
            NSLog(@"健康行为测评%@",_str);
            //获取UserDefaults单例
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //移除UserDefaults中存储的用户信息
            [userDefaults removeObjectForKey:_str];
            [userDefaults synchronize];
        }

    }else if (_type == GBHealthServiceInfoTypeFromFood){
        
        for (int i = 0; i<self.presenter.FoodSource.count; i++) {
            FoodDetailService *model = self.presenter.FoodSource[i];
            _str = [NSString  stringWithFormat:@"%@",model.Type_ID];
            NSLog(@"饮食行为测评%@",_str);
            //获取UserDefaults单例
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //移除UserDefaults中存储的用户信息
            [userDefaults removeObjectForKey:_str];
            [userDefaults synchronize];
        }
    }
    
}
-(void)rightItemAction:(id)sender{
    [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
