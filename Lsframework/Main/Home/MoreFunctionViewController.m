//
//  MoreFunctionViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreFunctionViewController.h"
#import "MoreFunctionCollectionViewCell.h"
#import "MoreFunctionPresenter.h"
#import "MoreFunction.h"
#import "PatientCaseController.h"
#import "OutPatientAppointViewController.h"
#import "VaccinePlaneViewController.h"
#import "DefaultChildEntity.h"
#import "ConfiguresEntity.h"
#import"HRHealthAssessmentViewController.h" //健康测评
#import "ArchivesMainViewController.h"
#import "MoreFunctionDestricstionViewController.h"

#define KW_TopHearder   25+kFitHeightScale(120)+15+15+90
#define xSpace ([[UIScreen mainScreen] bounds].size.width-3*kFitWidthScale(214))/4
#define ySpace  ([[UIScreen mainScreen] bounds].size.width-3*kFitWidthScale(214))/4
#define k_Item_xspace   (kScreenWidth-kFitWidthScale(120)*4)/5
#define k_Item_top    25
#define  k_single_height  (2*ySpace+kFitHeightScale(214))




@interface MoreFunctionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MoreFunctionPresenterDelegate>{
NSInteger  count;

}

@property(nonatomic,retain) UICollectionView* Morecollection;
@property(nonatomic,retain) UIView* MorecollectionView;
@property(nonatomic,retain) UIScrollView*scrllow;
@property(nonatomic,retain) NSMutableArray* dataSourceArray;
@property(nonatomic,retain) NSArray* VCArray;
@property(nonatomic ,strong) NSArray *dataSource;
@property(nonatomic,strong)MoreFunctionPresenter   *presenter;


@property(nonatomic,strong)UIView  *contanierView;
@property(nonatomic,strong)UIImageView  *menuImageView1;
@property(nonatomic,strong)UILabel  *titleLabel1;


@property(nonatomic,strong)UIImageView  *menuImageView2;
@property(nonatomic,strong)UILabel  *titleLabel2;


@property(nonatomic,strong)UIImageView  *menuImageView3;
@property(nonatomic,strong)UILabel  *titleLabel3;

@property(nonatomic,strong)UIImageView  *menuImageView4;
@property(nonatomic,strong)UILabel  *titleLabel4;
@property(nonatomic,strong)UIView  *centerView;
@property(nonatomic,strong)UILabel  *centerLb;
@property(nonatomic,strong)UIView  *centerLine1;
@property(nonatomic,strong)UIView  *centerLine2;

@end

@implementation MoreFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
}
-(void)setupHeardView{

    UIScrollView  *scrollview = [UIScrollView  new];
    scrollview.userInteractionEnabled = YES;
    scrollview.scrollEnabled = YES;
    scrollview.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view  addSubview:scrollview];
    self.scrllow = scrollview;

    _contanierView = [UIView new];
    _contanierView.userInteractionEnabled = YES;
    [scrollview  addSubview:_contanierView];
    
    _menuImageView1 = [UIImageView new];
    _menuImageView1.userInteractionEnabled = YES;
    [_contanierView addSubview:_menuImageView1];
    
    _titleLabel1 = [UILabel new];
    _titleLabel1.userInteractionEnabled= YES;
    _titleLabel1.textAlignment = NSTextAlignmentCenter;
    _titleLabel1.textColor = UIColorFromRGB(0x666666);
    _titleLabel1.font = [UIFont  systemFontOfSize:15];
    [_contanierView  addSubview: _titleLabel1];
    
    
    _menuImageView2 = [UIImageView new];
    _menuImageView2.userInteractionEnabled = YES;
    [_contanierView addSubview:_menuImageView2];
    
    _titleLabel2 = [UILabel new];
    _titleLabel2.userInteractionEnabled= YES;
    _titleLabel2.textAlignment = NSTextAlignmentCenter;
    _titleLabel2.textColor = UIColorFromRGB(0x666666);
    _titleLabel2.font = _titleLabel1.font;
    [_contanierView  addSubview: _titleLabel2];
    
    _menuImageView3 = [UIImageView new];
    _menuImageView3.userInteractionEnabled = YES;
    [_contanierView addSubview:_menuImageView3];
    
    _titleLabel3 = [UILabel new];
    _titleLabel3.userInteractionEnabled= YES;
    _titleLabel3.textAlignment = NSTextAlignmentCenter;
    _titleLabel3.textColor = UIColorFromRGB(0x666666);
    _titleLabel3.font = _titleLabel1.font;
    [_contanierView  addSubview: _titleLabel3];
    
    _menuImageView4 = [UIImageView new];
    _menuImageView4.userInteractionEnabled = YES;
    [_contanierView addSubview:_menuImageView4];
    
    _titleLabel4 = [UILabel new];
    _titleLabel4.userInteractionEnabled= YES;
    _titleLabel4.textAlignment = NSTextAlignmentCenter;
    _titleLabel4.textColor = UIColorFromRGB(0x666666);
    _titleLabel4.font = _titleLabel1.font;
    [_contanierView  addSubview: _titleLabel4];
    
    _centerView = [UIView  new];
    _centerView.backgroundColor  = [UIColor  clearColor];
    [_contanierView  addSubview:_centerView];
    
    
    _centerLb = [UILabel new];
    _centerLb.textAlignment = NSTextAlignmentCenter;
    _centerLb.textColor = UIColorFromRGB(0x666666);
    _centerLb.font = _titleLabel1.font;
    _centerLb.text = @"快乐成长";
    [_centerView  addSubview: _centerLb];
    
    _centerLine1 = [UIView  new];
    _centerLine1.backgroundColor = UIColorFromRGB(0x6ed8d3);
    [_centerView  addSubview:_centerLine1];
    
    _centerLine2 = [UIView  new];
    _centerLine2.backgroundColor = UIColorFromRGB(0x6ed8d3);
    [_centerView  addSubview:_centerLine2];
    
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem1)];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem1)];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem2)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem2)];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem3)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem3)];
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem4)];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeardMenuItem4)];
    
    
    
    
    
    [_menuImageView1 addGestureRecognizer:tap1];
    [_titleLabel1 addGestureRecognizer:tap2];
    
    [_menuImageView2 addGestureRecognizer:tap3];
    [_titleLabel2 addGestureRecognizer:tap4];
    
    [_menuImageView3 addGestureRecognizer:tap5];
    [_titleLabel3 addGestureRecognizer:tap6];
    
    [_menuImageView4 addGestureRecognizer:tap7];
    [_titleLabel4 addGestureRecognizer:tap8];


     scrollview.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    _contanierView.sd_layout.topSpaceToView(scrollview ,0).leftEqualToView(scrollview).rightEqualToView(scrollview);
    
    _menuImageView1.sd_layout.topSpaceToView(_contanierView,k_Item_top).leftSpaceToView(_contanierView,k_Item_xspace).widthIs(kFitWidthScale(120)).heightIs(kFitWidthScale(120));
    
    _titleLabel1.sd_layout.topSpaceToView(_menuImageView1,15).centerXEqualToView(_menuImageView1).widthIs(15*4).heightIs(15);
    
    _menuImageView1.sd_layout.topSpaceToView(_contanierView,k_Item_top).leftSpaceToView(_contanierView,k_Item_xspace).widthIs(kFitWidthScale(120)).heightIs(kFitWidthScale(120));

    _titleLabel1.sd_layout.topSpaceToView(_menuImageView1,15).centerXEqualToView(_menuImageView1).widthIs(15*4).heightIs(15);
    
    _menuImageView2.sd_layout.topSpaceToView(_contanierView,k_Item_top).leftSpaceToView(_menuImageView1,k_Item_xspace).widthIs(kFitWidthScale(120)).heightIs(kFitWidthScale(120));
    
    _titleLabel2.sd_layout.topSpaceToView(_menuImageView2,15).centerXEqualToView(_menuImageView2).widthIs(15*4).heightIs(15);
    
    _menuImageView3.sd_layout.topSpaceToView(_contanierView,k_Item_top).leftSpaceToView(_menuImageView2,k_Item_xspace).widthIs(kFitWidthScale(120)).heightIs(kFitWidthScale(120));
    
    _titleLabel3.sd_layout.topSpaceToView(_menuImageView3,15).centerXEqualToView(_menuImageView3).widthIs(15*4).heightIs(15);
    
    _menuImageView4.sd_layout.topSpaceToView(_contanierView,k_Item_top).leftSpaceToView(_menuImageView3,k_Item_xspace).widthIs(kFitWidthScale(120)).heightIs(kFitWidthScale(120));
    
    _titleLabel4.sd_layout.topSpaceToView(_menuImageView4,15).centerXEqualToView(_menuImageView4).widthIs(15*4).heightIs(15);
    
    
    _centerView.sd_layout.topSpaceToView(_titleLabel4,0).leftSpaceToView(_contanierView,0).rightSpaceToView(_contanierView,0).heightIs(90);
    
    _centerLb.sd_layout.topSpaceToView(_centerView,100/2).centerXEqualToView(_centerView).widthIs([JMFoundation  calLabelWidth:_centerLb]).heightIs(15);
    
    _centerLine1.sd_layout.topSpaceToView(_centerView,100/2+15/2-1).leftSpaceToView(_centerView,30/2).rightSpaceToView(_centerLb,10/2).heightIs(1);
    
    _centerLine2.sd_layout.topEqualToView(_centerLine1).leftSpaceToView(_centerLb,10/2).rightSpaceToView(_centerView,30/2).heightIs(1);
    
    
    [_contanierView setupAutoHeightWithBottomView:_centerView bottomMargin:0];
    
      _dataSourceArray = [NSMutableArray  array];
        
        NSDictionary* dic1 = @{@"title":@"病友案例",@"image":@"MoreFoundation_disease"};
        NSDictionary* dic2 = @{@"title":@"门诊预约",@"image":@"MoreFoundation_appointment"};
        
        
        NSDictionary* dic3 = @{@"title":@"疫苗接种",@"image":@"MoreFoundation_vaccine"};
        NSDictionary* dic4 = @{@"title":@"查看报告",@"image":@"MoreFoundation_report"};
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:@[dic1,dic2,dic3,dic4]];
        
    [_dataSourceArray  addObjectsFromArray:array];

    
    [self  initCellWith:_dataSourceArray];
    
    _titleLabel1.width = [JMFoundation  calLabelWidth:_titleLabel1];
    _titleLabel2.width = [JMFoundation  calLabelWidth:_titleLabel2];
    _titleLabel3.width = [JMFoundation  calLabelWidth:_titleLabel3];
    _titleLabel4.width = [JMFoundation  calLabelWidth:_titleLabel4];
    
    [_titleLabel1  updateLayout];
    [_titleLabel2  updateLayout];
    [_titleLabel3  updateLayout];
    [_titleLabel4  updateLayout];
    
    
}

-(void)setupView{
    self.title = @"更多功能";
 self.presenter = [MoreFunctionPresenter new];
    _presenter.delegate = self;
    
   [self  setupHeardView];
    
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
        CGFloat width = kFitWidthScale(214);
        CGFloat height = kFitHeightScale(214);
        layout.itemSize = CGSizeMake(width,height);

  UICollectionView  *collection = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:layout];
    
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor  clearColor];
    collection.showsVerticalScrollIndicator = NO;
    collection.scrollEnabled = NO;
    collection.userInteractionEnabled = YES;

    [collection registerClass:[MoreFunctionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.scrllow addSubview:collection];
    self.Morecollection = collection;
    
    
    WS(ws);
    //下拉刷新
    _scrllow.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.scrllow.userInteractionEnabled = NO;
        [ws.presenter loadMoreFunction];
    }];
    [_scrllow.mj_header beginRefreshing];

    _Morecollection.sd_layout.topSpaceToView(_contanierView,0).leftSpaceToView(_scrllow ,0).rightSpaceToView(_scrllow,0).heightIs(kScreenHeight - KW_TopHearder);
    
   
    NSLog(@"数据源数量2:%d",count);
    [_scrllow  setupAutoContentSizeWithBottomView:_Morecollection bottomMargin:0];
    
    
}

#pragma mark * 下拉刷新和上拉加载
- (void)LoadMoreFunctionComplete:(BOOL) success info:(NSString*) info{
   
    [_scrllow.mj_header endRefreshing];
    _scrllow.userInteractionEnabled = YES;
    
    if(success){
        [ProgressUtil dismiss];
        [_Morecollection reloadData];
        if (self.presenter.MoreFunctionSource.count%3>0) {
            count =self.presenter.MoreFunctionSource.count/3+1;
        }else{
            count = self.presenter.MoreFunctionSource.count/3;

        }
        NSLog(@"count数量：%ld",count);


        
        _Morecollection.sd_layout.topSpaceToView(_contanierView,0).leftSpaceToView(_scrllow ,0).rightSpaceToView(_scrllow,0).heightIs(count*(k_single_height+ySpace));
        [_scrllow  setupAutoContentSizeWithBottomView:_Morecollection bottomMargin:ySpace];
        
    }else{
        [ProgressUtil showError:info];
    }
}


#pragma mark----collectionviewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

            return self.presenter.MoreFunctionSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

        MoreFunctionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
    MoreFunction *model =  [self.presenter.MoreFunctionSource objectAtIndex:indexPath.item];
    [cell.imageView  sd_setImageWithURL:[NSURL  URLWithString:model.Menu_url] placeholderImage:nil];


        return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //每个item的距边缘的距离
       return UIEdgeInsetsMake(ySpace, xSpace,ySpace , xSpace);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //这个是两行cell之间的间距（上下行cell的间距）
    
    return ySpace;
}
//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return xSpace;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
#pragma 打点统计*More-->成长快乐
    [BasePresenter  EventStatisticalDotTitle:DotMoreFountionGood Action:DotEventEnter  Remark:nil];

    
    NSLog(@"标题：%@",[self.presenter.MoreFunctionSource objectAtIndex:indexPath.item].title);
    
    MoreFunctionDestricstionViewController  *vc = [MoreFunctionDestricstionViewController  new];
    vc.Mfucation =  [self.presenter.MoreFunctionSource objectAtIndex:indexPath.item];
    
    [self.navigationController  pushViewController:vc animated:YES];
    
}
-(void)tapHeardMenuItem1{
    
    NSLog(@"病友案例");
#pragma 打点统计*More-->病友案例
    [BasePresenter  EventStatisticalDotTitle:DotMoreFountionPatientCase Action:DotEventEnter  Remark:nil];

    
[self.navigationController pushViewController:[PatientCaseController new] animated:YES];
   
    
}
-(void)tapHeardMenuItem2{
    NSLog(@"门诊预约");
#pragma 打点统计*More-->门诊预约
    [BasePresenter  EventStatisticalDotTitle:DotMoreFountionOutPatientAppoint Action:DotEventEnter  Remark:nil];
    
            //门诊预约
            OutPatientAppointViewController* outPatientVc = [OutPatientAppointViewController new];
    
            NSString* url = [NSString URLDecodedString:[ConfiguresEntity findConfigureValueWithKey:@"openmzyyurl1"]];
    
            outPatientVc.outPatientURL = [NSString stringWithFormat:@"%@?token=%@&username=%@",url,kCurrentUser.token,kCurrentUser.phone];
            //        NSString *midUrl =outPatientVc.outPatientURL;
            NSLog(@"2222url = %@",outPatientVc.outPatientURL);
            WS(ws);
            [self.presenter getOtherPWDByUserID:^(BOOL haveOtherPWD, NSString *message) {
                if (haveOtherPWD == YES) {
                    // &pass=%@
                    outPatientVc.outPatientURL =[outPatientVc.outPatientURL stringByAppendingString:[NSString stringWithFormat:@"&pass=%@",message]];
                    [self.navigationController pushViewController:outPatientVc animated:YES];
    
                    NSLog(@"==1111==%@",outPatientVc.outPatientURL);
                }else{
                    //没有外网密码 需创建
                    if ([message isEqualToString:@"error"]) {
    
                    }else {
                        [ws.presenter createOtherPWDRequest:^(BOOL createOtherPWD, NSString *message) {
                            if (createOtherPWD ==YES) {
                                //创建外网密码成功
                                outPatientVc.outPatientURL =[outPatientVc.outPatientURL stringByAppendingString:[NSString stringWithFormat:@"&pass=%@",kCurrentUser.userPasswd]];
    
                                NSLog(@"==0000==%@",outPatientVc.outPatientURL);
                                [ws.navigationController pushViewController:outPatientVc animated:YES];
                            }else{
                                //创建外网密码失败
                            }
                        }];
                    }
                }
            }];
            
            
            

    
}
-(void)tapHeardMenuItem3{
    NSLog(@"疫苗接种");
#pragma 打点统计*More-->疫苗接种
    [BasePresenter  EventStatisticalDotTitle:DotMoreFountionVaccinePlane Action:DotEventEnter  Remark:nil];
    
    VaccinePlaneViewController* vaccine = [VaccinePlaneViewController new];
    
            if([DefaultChildEntity defaultChild].birthDate){
                NSDate* birthDay = [DefaultChildEntity defaultChild].birthDate;
                vaccine.childBirtDay = [birthDay format2String:@"yyyy-MM-dd"];
            }else{
                vaccine.childBirtDay = @"";
            }
    
            [self.navigationController  pushViewController:vaccine animated:YES];

    
}
-(void)tapHeardMenuItem4{
    NSLog(@"查看报告");
#pragma 打点统计*More-->查看报告
    [BasePresenter  EventStatisticalDotTitle:DotMoreFountionHRHealthAssess Action:DotEventEnter  Remark:nil];
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count > 0) {
        DefaultChildEntity *entity = entityArray.lastObject;
        if ([entity.babyID intValue] != 0) {
            [self.navigationController pushViewController:[HRHealthAssessmentViewController new] animated:YES];
        }else{
            [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
        }
    }else{
        [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
    }

    
}
-(void)initCellWith:(NSArray *)array{
    
    _menuImageView1.image = [UIImage imageNamed:[array[0] objectForKey:@"image"]];
    _titleLabel1.text = [array[0] objectForKey:@"title"];
    
    _menuImageView2.image = [UIImage imageNamed:[array[1] objectForKey:@"image"]];
    _titleLabel2.text = [array[1] objectForKey:@"title"];
    
    _menuImageView3.image = [UIImage imageNamed:[array[2] objectForKey:@"image"]];
    _titleLabel3.text = [array[2] objectForKey:@"title"];
    
    _menuImageView4.image = [UIImage imageNamed:[array[3] objectForKey:@"image"]];
    _titleLabel4.text = [array[3] objectForKey:@"title"];
    
    
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
