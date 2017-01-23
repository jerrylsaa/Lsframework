//
//  DietManagerViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DietManagerViewController.h"
#import "DefaultChildEntity.h"
#import "DietListViewController.h"
#import "ApiMacro.h"
#import "DietManagerPresenter.h"
#import "GBHealthServiceViewController.h"
#import "ArchivesMainViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "BabyFoodTIpsCell.h"
#import "BabyFoodTipsEntity.h"
@interface DietManagerViewController ()<DietManagerPresenterDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) DietManagerPresenter *presenter;

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) UIView *secondView;
@property(nonatomic,retain) UIView *thirdView;
@property(nonatomic,retain) UIButton *bottomBtn;

@property(nonatomic,retain) UIImageView *photoBGIV;
@property(nonatomic,retain) UIImageView *photoIV;
@property(nonatomic,retain) UILabel *photoNameLabel;

@property(nonatomic,retain) UILabel *secondTipLabel;

@property(nonatomic,retain) UILabel *babyFoodTipsLabel;
@property(nonatomic,retain) UITableView *table;
@property(nonatomic,assign) CGFloat height;

@end

@implementation DietManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"膳食管理";
    
    

}


- (void)setupView{
    _presenter =[DietManagerPresenter new];
    _presenter.delegate =self;
    
    _scrollView =[UIScrollView new];
    _scrollView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _topView =[UIView new];
    _topView.backgroundColor =[UIColor whiteColor];
    _topView.layer.cornerRadius =5.0f;
    //    _photoIV.layer.borderWidth =f;
    _topView.clipsToBounds =YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_topView addGestureRecognizer:tap1];
    [_scrollView addSubview:_topView];
    
    _photoBGIV =[UIImageView new];
    _photoBGIV.backgroundColor =UIColorFromRGB(0x61d8d3);
    _photoBGIV.layer.cornerRadius =5.0f;
//    _photoIV.layer.borderWidth =f;
    _photoBGIV.clipsToBounds =YES;

    [_topView addSubview:_photoBGIV];
    
    _photoIV =[UIImageView new];
    _photoIV.layer.cornerRadius =30.0f;
    _photoIV.layer.borderWidth =3.5f;
    _photoIV.layer.borderColor =UIColorFromRGB(0x91e4e0).CGColor;
    _photoIV.clipsToBounds =YES;
    [_topView addSubview:_photoIV];
    
    _photoNameLabel =[UILabel new];
    _photoNameLabel.textAlignment =NSTextAlignmentCenter;
    _photoNameLabel.textColor =[UIColor whiteColor];
    _photoNameLabel.font =[UIFont systemFontOfSize:12.0f];
    [_topView addSubview:_photoNameLabel];
    
    UILabel *firstTipLabel =[UILabel new];
    firstTipLabel.text =@"食材查询";
    firstTipLabel.textAlignment =NSTextAlignmentCenter;
    firstTipLabel.font =[UIFont systemFontOfSize:18.0f];
    firstTipLabel.textColor =UIColorFromRGB(0x999999);
    [_topView addSubview:firstTipLabel];
    
    UIImageView *cameraIV =[UIImageView new];
    cameraIV.image =[UIImage imageNamed:@"cameraIcon"];
    [_topView addSubview:cameraIV];
    
    _secondTipLabel =[UILabel new];
    _secondTipLabel.font =[UIFont systemFontOfSize:15.0f];
    _secondTipLabel.textColor =UIColorFromRGB(0x333333);
    _secondTipLabel.text =@"今天宝宝饮食tips：";
    [_scrollView addSubview:_secondTipLabel];
    
    _secondView =[UIView new];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondTapAction)];
    [_secondView addGestureRecognizer:tap2];
    _secondView.backgroundColor =[UIColor whiteColor];
    _secondView.layer.cornerRadius =5.0f;
    //    _photoIV.layer.borderWidth =f;
    _secondView.clipsToBounds =YES;
    [_scrollView addSubview:_secondView];
    
    UIImageView *addBabyIV =[UIImageView new];
    addBabyIV.image =[UIImage imageNamed:@"addbaby"];
    [_secondView addSubview:addBabyIV];
    
    UILabel *addBabyLabel =[UILabel new];
    addBabyLabel.font =[UIFont systemFontOfSize:13.0f];
    addBabyLabel.textColor =UIColorFromRGB(0x333333);
    addBabyLabel.text =@"添加宝宝档案";
    addBabyLabel.textAlignment =NSTextAlignmentCenter;
    [_secondView addSubview:addBabyLabel];
    
    _thirdView =[UIView new];
    _thirdView.backgroundColor =[UIColor whiteColor];
    [_scrollView addSubview:_thirdView];
    
    _babyFoodTipsLabel =[UILabel new];
    _babyFoodTipsLabel.numberOfLines =0;
    _babyFoodTipsLabel.font =[UIFont systemFontOfSize:14.0f];
    _babyFoodTipsLabel.textColor =UIColorFromRGB(0x666666);
    [_thirdView addSubview:_babyFoodTipsLabel];
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.layer.cornerRadius =5.0f;
    _table.clipsToBounds =YES;
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.dataSource = self;
    _table.delegate = self;
    _table.scrollEnabled =NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_table];
    
    [_table registerClass:[BabyFoodTIpsCell class] forCellReuseIdentifier:@"cell"];
    
    
    _bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.hidden =YES;
    [_bottomBtn setImage:[UIImage imageNamed:@"btn_bbysxwcp"] forState:UIControlStateNormal];
    [_bottomBtn  addTarget:self action:@selector(babyFoodAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_bottomBtn];
    
    
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _topView.sd_layout.topSpaceToView(_scrollView,15).leftSpaceToView(_scrollView,18).rightSpaceToView(_scrollView,18).heightIs(80);
    _photoBGIV.sd_layout.topSpaceToView(_topView,0).leftSpaceToView(_topView,0).heightIs(80).widthIs(80);
    _photoIV.sd_layout.centerXEqualToView(_photoBGIV).centerYEqualToView(_photoBGIV).heightIs(60).widthIs(60);
    _photoNameLabel.sd_layout.centerXEqualToView(_photoIV).widthIs(80).heightIs(17.5f);
    firstTipLabel.sd_layout.centerXEqualToView(_topView).centerYEqualToView(_topView).widthIs(100).heightIs(27);
    cameraIV.sd_layout.rightSpaceToView(_topView,8).centerYEqualToView(_topView).widthIs(55).heightIs(48);
    
    
    _secondTipLabel.sd_layout.topSpaceToView(_topView,30).leftEqualToView(_topView).widthIs(200).heightIs(25);
    
    
    _secondView.sd_layout.topSpaceToView(_secondTipLabel,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(200);
    addBabyIV.sd_layout.topSpaceToView(_secondView,62).centerXEqualToView(_secondView).heightIs(38).widthIs(38);
    addBabyLabel.sd_layout.topSpaceToView(addBabyIV,15).centerXEqualToView(_secondView).heightIs(27).widthIs(200);
    
    _babyFoodTipsLabel.sd_layout.topSpaceToView(_thirdView,15).leftSpaceToView(_thirdView,15).rightSpaceToView(_thirdView,15).autoHeightRatio(0);
    [_thirdView setupAutoHeightWithBottomView:_babyFoodTipsLabel bottomMargin:15];

    _table.tableHeaderView =_thirdView;

    _table.sd_layout.topSpaceToView(_secondView,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).bottomSpaceToView(_scrollView,0);

    
    
//    _bottomBtn.sd_layout.topSpaceToView(_table,50).centerXEqualToView(_scrollView).widthIs(180).heightIs(40);
    
    [_scrollView setupAutoHeightWithBottomView:_table bottomMargin:30];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count > 0) {
        DefaultChildEntity *entity = entityArray.lastObject;
        
        if (entity.childImg!=nil) {
            [_photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,entity.childImg]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        }else{
            _photoIV.image =[UIImage imageNamed:@"touxiang_normal"];
        }
        if ([entity.babyID intValue] != 0) {
            
            [_secondView sd_clearAutoLayoutSettings];
            _secondView.sd_layout.topSpaceToView(_secondTipLabel,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
            
            [ProgressUtil show];
            [_presenter getBabyFoodTips];


        }else{
            
            
            [_table sd_clearAutoLayoutSettings];
            
            _table.sd_layout.topSpaceToView(_secondView,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
            

        }
    }else{
        
        

        [_table sd_clearAutoLayoutSettings];
        _table.sd_layout.topSpaceToView(_secondView,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
        

    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _presenter.babyFoodTipsSource.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    BabyFoodTIpsCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.myTips =_presenter.babyFoodTipsSource[indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;

    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"点击单元格");
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BabyFoodTipsEntity *myTips= self.presenter.babyFoodTipsSource[indexPath.row];
    
    _height +=[tableView cellHeightForIndexPath:indexPath model:myTips keyPath:@"myTips" cellClass:[BabyFoodTIpsCell class] contentViewWidth:[self cellContentViewWith]];
    
    
    return [tableView cellHeightForIndexPath:indexPath model:myTips keyPath:@"myTips" cellClass:[BabyFoodTIpsCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith{
    CGFloat width = kScreenWidth-25;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tapAction{
    [self.navigationController pushViewController:[DietListViewController new] animated:YES];
    
#pragma 打点统计*食材查询按钮
    [BasePresenter  EventStatisticalDotTitle:DotDietManagerFood Action:DotEventEnter  Remark:nil];

}

- (void)secondTapAction{
    
    [self.navigationController pushViewController:[ArchivesMainViewController new] animated:YES];
    
}

- (void)getBabyTips:(NSString *)tips{
    
    _height =0;
    NSString *resultText = [NSString stringWithFormat:@"%@", [tips  stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
    _babyFoodTipsLabel.text =resultText;
    
    [_thirdView layoutSubviews];
    [_table setTableHeaderView:_thirdView];

    [_table reloadData];

    [_table sd_clearAutoLayoutSettings];
    _table.sd_layout.topSpaceToView(_secondView,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(_height+_table.tableHeaderView.height);
    

    [_scrollView updateLayout];
    [ProgressUtil dismiss];

}
#pragma mark----宝宝饮食行为测评事件
-(void)babyFoodAction{

    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count > 0) {
        DefaultChildEntity *entity = entityArray.lastObject;
        if ([entity.babyID intValue] != 0) {
            //        [self.navigationController pushViewController:[HealthServiceViewController new] animated:YES];
            //健康测评改版入口
            GBHealthServiceViewController  *vc  =[GBHealthServiceViewController  new];
            vc.type = GBHealthServiceTypeFromFood;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
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
