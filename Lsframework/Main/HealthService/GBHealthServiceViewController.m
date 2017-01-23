//
//  GBHealthServiceViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBHealthServiceViewController.h"
#import "HealthServiceCollectionViewCell.h"
#import "HealthServicePresenter.h"
#import "HealthService.h"
#import "GBHealthServiceInfoViewController.h"
#import "GBhomeViewController.h"
#import "ScreenAppraiseController.h"
#import "FoodService.h"

#define xSpace 20
#define ySpace  20
#define  k_width  ([[UIScreen mainScreen] bounds].size.width-3*xSpace)/2
 #define  k_height  3*k_width/4

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && (SCREEN_MAX_LENGTH < 568.0))
#define IS_IPHONE_5 (IS_IPHONE && (SCREEN_MAX_LENGTH == 568.0))
#define IS_IPHONE_6 (IS_IPHONE && (SCREEN_MAX_LENGTH == 667.0))
#define IS_IPHONE_6P (IS_IPHONE && (SCREEN_MAX_LENGTH == 736.0))
@interface GBHealthServiceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign)  CGFloat xx;
@property (nonatomic, assign)  CGFloat yy;
@property(nonatomic,strong)UICollectionView  *healthServiceCollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout  *layout;
@property(nonatomic,strong)HealthServicePresenter   *presenter;
@property(nonatomic ,strong) NSArray *dataSource;

@end

@implementation GBHealthServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
}
-(void)setupView{
    
    if (_type == GBHealthServiceTypeFromNormal) {
        self.title = @"健康测评";
//        [self initRightBarWithTitle:@"查看"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        BOOL isFirstTime = [[user objectForKey:[NSString stringWithFormat:@"%dFirstTimeHealthService",kCurrentUser.userId]] boolValue];
        if (!isFirstTime) {
            [self showUserGuildView];
        }

    }else if (_type == GBHealthServiceTypeFromFood){
        self.title = @"饮食测评";
    }
    self.view.backgroundColor = [UIColor  whiteColor];
    self.presenter = [HealthServicePresenter new];

    _layout=[[UICollectionViewFlowLayout  alloc]init];
    _layout.scrollDirection=UICollectionViewScrollPositionCenteredVertically;
        
    _healthServiceCollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)  collectionViewLayout:_layout];
        
    _healthServiceCollectionView.backgroundColor = [UIColor  whiteColor];
    _healthServiceCollectionView.delegate=self;
        
    _healthServiceCollectionView.dataSource=self;

    [_healthServiceCollectionView  registerClass:[HealthServiceCollectionViewCell  class] forCellWithReuseIdentifier:@"ID"];
    [self.view  addSubview:_healthServiceCollectionView];
    
    __weak typeof(self) weakSelf = self;
    _healthServiceCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_type == GBHealthServiceTypeFromNormal ) {
            //健康测评
            [weakSelf.presenter loadHealthService:^(BOOL success, NSString *message) {
                [weakSelf.healthServiceCollectionView.mj_header endRefreshing];
                if (success == TRUE){
                    
                    weakSelf.dataSource = weakSelf.presenter.dataSource;
                    [weakSelf.healthServiceCollectionView reloadData];
                    
                }else if (success == false){
                    [ProgressUtil showError:message];
                }
            }];
        }else{
        //饮食测评
            [weakSelf.presenter loadFoodService:^(BOOL success, NSString *message) {
                [weakSelf.healthServiceCollectionView.mj_header endRefreshing];
                if (success == TRUE){
                    
                    weakSelf.dataSource = weakSelf.presenter.dataSource;
                    [weakSelf.healthServiceCollectionView reloadData];
                    
                }else if (success == false){
                    [ProgressUtil showError:message];
                }
            }];

        }
    }];
    [_healthServiceCollectionView.mj_header beginRefreshing];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"数量：%ld",_dataSource.count);
    return _dataSource.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HealthServiceCollectionViewCell  *cell=[collectionView  dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    if (_type == GBHealthServiceTypeFromNormal) {
        HealthService *model =  [self.presenter.dataSource objectAtIndex:indexPath.item];
        [cell.imageView  sd_setImageWithURL:[NSURL  URLWithString:model.ImageUrl] placeholderImage:[UIImage  imageNamed:@"hyperactivityBtn"]];
    }else if (_type == GBHealthServiceTypeFromFood){
    FoodService *model = [self.presenter.dataSource  objectAtIndex:indexPath.item];
    [cell.imageView  sd_setImageWithURL:[NSURL  URLWithString:model.ImageUrl] placeholderImage:[UIImage  imageNamed:@"hyperactivityBtn"]];
    }

    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(k_width,k_height);
}
//设置Item距离边缘的距离

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(ySpace, xSpace, k_height-ySpace, xSpace);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView setUserInteractionEnabled:NO];
    [collectionView performSelector:@selector(setUserInteractionEnabled:)
                         withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];

    GBHealthServiceInfoViewController  *vc = [GBHealthServiceInfoViewController new];
    
    if (_type == GBHealthServiceTypeFromNormal) {
        HealthService *model =  [self.presenter.dataSource objectAtIndex:indexPath.item];
        vc.healthService = model;
        vc.title = model.Name;
        vc.EvalName = model.Remark;
        vc.type = GBHealthServiceInfoTypeFromNormal;
        
    }else if (_type == GBHealthServiceTypeFromFood){
        FoodService *model = [self.presenter.dataSource  objectAtIndex:indexPath.item];
        vc.title = model.Name;
        vc.TypeID = model.FoodID;
        
        
        vc.type = GBHealthServiceInfoTypeFromFood;
    }

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)rightItemAction:(id)sender{
    [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];
}

- (void)showUserGuildView{
    BOOL isFirstTime =YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(isFirstTime) forKey:[NSString stringWithFormat:@"%dFirstTimeHealthService",kCurrentUser.userId]];
    
    NSString *imageName = nil;
    if (IS_IPHONE_4_OR_LESS) {
        imageName = @"healthServiceGuild960";
        
    } else if (IS_IPHONE_5){
        imageName = @"healthServiceGuild1136";
        
    } else if (IS_IPHONE_6){
        imageName = @"healthServiceGuild1334";

    }else if (IS_IPHONE_6P){
        imageName = @"healthServiceGuild2208";

    }
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = window.bounds;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
}

- (void)dismissGuideView:(UITapGestureRecognizer *)tap{
    
  [UIView animateWithDuration:0.2 animations:^{
      tap.view.alpha =0;
  } completion:^(BOOL finished) {
      [tap.view removeFromSuperview];
  }];
}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"健康测评"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"健康测评"];
    
}


@end
