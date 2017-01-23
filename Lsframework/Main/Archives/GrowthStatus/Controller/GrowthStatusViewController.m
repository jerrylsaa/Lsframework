//
//  GrowthStatusViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//  发育情况

#import "GrowthStatusViewController.h"
#import "FPTextField.h"
#import "TabbarViewController.h"

@interface GrowthStatusViewController ()<GrowthStatusPresenterDelegate>{
    UIScrollView* _scrollView;
}

@property(nonatomic,retain) NSMutableArray* textfieldArray;

@property(nonatomic,retain) GrowthStatusPresenter* presenter;

@property(nonatomic,retain) NSArray* leftTitleArray;

@property (nonatomic ,strong) UIButton* backbt;
@property (nonatomic ,strong) UIButton* nextbt;

@end

@implementation GrowthStatusViewController
-(NSMutableArray *)textfieldArray{
    if(!_textfieldArray){
        _textfieldArray=[NSMutableArray array];
    }
    return _textfieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:nil];

}

-(void)setupView{
    self.title=@"发育情况";
    
    self.presenter=[GrowthStatusPresenter new];
    self.presenter.delegate=self;
    
    _scrollView=[UIScrollView new];
    _scrollView.showsVerticalScrollIndicator=NO;
//    _scrollView.bounces=NO;
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupTextField];
    [self setupBackAndNextButton];
}

- (void)setupTextField{
    self.leftTitleArray=@[@"抬头：",@"翻身：",@"坐稳：",@"俯爬：",@"手膝爬：",@"独站：",@"独行：",@"上楼梯/台阶：",@"跑步：",@"双脚跳：",@"单脚站立：",@"单脚跳：",@"伸手够物：",@"拇食指对捏：",@"叫爸爸/妈妈：",@"说3个物品的名称：",@"说2-3个字的短语：",@"说自己的名字："];
    for(int i=0;i<self.leftTitleArray.count;++i){
        FPTextField* tf=[FPTextField new];
        tf.title=self.leftTitleArray[i];
        tf.unit=@"月";
        tf.keyboardType = UIKeyboardTypeNumberPad ;
        tf.stopAnimation = YES;
        tf.textCenter = YES;
        if(i == self.leftTitleArray.count-2 || i == self.leftTitleArray.count - 3){
            tf.textCenter = NO;
        }
        [_scrollView addSubview:tf];
        tf.sd_layout.topSpaceToView(_scrollView,15+i*(40+15)).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
        [self.textfieldArray addObject:tf];
    }
}

#pragma mark - button
- (void)setupBackAndNextButton{
    FPTextField* tf=[self.textfieldArray lastObject];
    
    _backbt=[UIButton new];
    [_backbt setBackgroundImage:[UIImage imageNamed:@"upstep_nor"] forState:UIControlStateNormal];
    [_backbt setBackgroundImage:[UIImage imageNamed:@"upstep_sel"] forState:UIControlStateHighlighted];
    [_backbt setTitle:@"上一步" forState:UIControlStateNormal];
    _backbt.tag=300;
    [_backbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_backbt];
    
    _nextbt=[UIButton new];
    [_nextbt setBackgroundImage:[UIImage imageNamed:@"downstep_nor"] forState:UIControlStateNormal];
    [_nextbt setBackgroundImage:[UIImage imageNamed:@"downstep_sel"] forState:UIControlStateHighlighted];
    [_nextbt setTitle:@"保存" forState:UIControlStateNormal];
    _nextbt.tag=301;
    [_nextbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nextbt];
    
    
//    _backbt.sd_layout.topSpaceToView(tf,15).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,kScreenWidth/2.0+10);
//
//    
//    _nextbt.sd_layout.topSpaceToView(tf,15).heightIs(40).rightSpaceToView(_scrollView,25).widthRatioToView(_backbt,1);
    
    _scrollView.sd_equalWidthSubviews = @[_nextbt,_backbt];
    
    _backbt.sd_layout.topSpaceToView(tf,15).heightIs(40).leftSpaceToView(_scrollView,25);
    _nextbt.sd_layout.topEqualToView(_backbt).heightRatioToView(_backbt,1).leftSpaceToView(_backbt,20).rightSpaceToView(_scrollView,25);
    
    
    [_scrollView setupAutoContentSizeWithBottomView:_nextbt bottomMargin:15];
}

#pragma mark - 点击事件
- (void)clickAction:(UIButton*) bt{
    if (bt.tag == 300) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(bt.tag==301){
    //保存
        NSMutableArray* dataSource = [NSMutableArray arrayWithCapacity:self.textfieldArray.count];
        for(int i=0;i<self.textfieldArray.count;++i){
            FPTextField* tf = [self.textfieldArray objectAtIndex:i];
            [dataSource addObject:tf.text];
        }
        [ProgressUtil show];
        self.presenter.dataSource=dataSource;
        self.presenter.titleArray=self.leftTitleArray;
        [self.presenter commitGrowthStatus:self.childForm];
    }
}

#pragma mark - 代理

-(void)onCommitComplete:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];

        if (self.poptoClass) {
            UIViewController * back;
            for (UIViewController * vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:self.poptoClass]) {
                    back = vc;
                    break;
                }
            }
            if (back) {
                [self.navigationController popToViewController:back animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        }

    }else{
        [ProgressUtil showError:info];
    }
}

#pragma mark - 公有方法

-(void)loadData:(ChildForm *)child{
    self.childForm = child;
    
        for(int i=0;i<self.textfieldArray.count;++i){
        FPTextField* tf = [self.textfieldArray objectAtIndex:i];
        
        switch (i) {
            case 0:{//抬头
                tf.text = child.rise;
            }
                break;
            case 1:{//翻身
                tf.text = child.turnOver;
            }
                break;
            case 2:{//坐稳
                tf.text = child.sit;
            }
                break;
            case 3:{//俯爬
                tf.text = child.overLookClimb;
            }
                break;
            case 4:{//手膝爬
                tf.text = child.handClimb;
            }
                break;
            case 5:{//独站
                tf.text = child.stand;
            }
                break;
            case 6:{//独行
                tf.text = child.walk;
            }
                break;
            case 7:{//上楼梯
                tf.text = child.upStairs;
            }
                break;
            case 8:{//跑步
                tf.text = child.run;
            }
                break;
            case 9:{//双脚跳
                tf.text = child.twoFootJump;
            }
                break;
            case 10:{//单脚站立
                tf.text = child.standOneFoot;
            }
                break;
            case 11:{//单脚跳
                tf.text = child.oneFootJump;
            }
                break;
            case 12:{//伸手购物
                tf.text = child.reach;
            }
                break;
            case 13:{//拇食指对捏
                tf.text = child.pinch;
            }
                break;
            case 14:{//叫爸爸
                tf.text = child.callFather;
            }
                break;
            case 15:{//说物品名字
                tf.text = child.sayGoods;
            }
                break;
            case 16:{//说短语
                tf.text = child.sayPhrase;
            }
                break;
            case 17:{//说自己的名字
                tf.text = child.sayOwnName;
            }
                break;
        }

    
    }

    
}

#pragma mark -

- (void)hiddenButton{
    _backbt.hidden = YES;
    _nextbt.hidden = YES;
}

- (void)vc_5_save:(Complete)block{
    NSMutableArray* dataSource = [NSMutableArray arrayWithCapacity:self.textfieldArray.count];
    for(int i=0;i<self.textfieldArray.count;++i){
        FPTextField* tf = [self.textfieldArray objectAtIndex:i];
        [dataSource addObject:tf.text];
    }
    [ProgressUtil show];
    self.presenter.dataSource=dataSource;
    self.presenter.titleArray=self.leftTitleArray;
    [self.presenter commitGrowthStatus:self.childForm block:^(BOOL success, NSString *message) {
        block(success,message);
    }];
}

@end
