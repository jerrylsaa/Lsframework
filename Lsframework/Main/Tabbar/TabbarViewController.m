//
//  TabbarViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TabbarViewController.h"
#import "BaseViewController.h"
#import "HomeViewController.h"
#import "DoctorViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "UIImage+Category.h"
#import "BaseNavigationController.h"
#import "FDMainViewController.h"
#import "JMMessageViewController.h"
#import "ChatListViewController.h"

#import "GBhomeViewController.h"
#import "GBMineViewController.h"
#import "DiscoverViewController.h"
#import "CircleViewController.h"
#import "TopLineMainViewController.h"

@interface TabbarViewController ()<RDVTabBarControllerDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)setupViewControllers {
    //首页改版
  GBhomeViewController   *GBVC = [[GBhomeViewController alloc] init];
    BaseNavigationController *homeNavi = [[BaseNavigationController alloc]
                                          initWithRootViewController:GBVC];
//    去掉医生tab

//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    BaseNavigationController *homeNavi = [[BaseNavigationController alloc]
//                                        initWithRootViewController:homeVC];
//    //去掉医生tab
//    FDMainViewController *friVC = [[FDMainViewController alloc] init];
//    BaseNavigationController *friNavigationController = [[BaseNavigationController alloc]
//                                                       initWithRootViewController:friVC];
    
    //隐藏系统消息tab
    TopLineMainViewController *TopLineVC = [[TopLineMainViewController alloc] init];
    BaseNavigationController *TopLineNav = [[BaseNavigationController alloc]
                                                      initWithRootViewController:TopLineVC];



    CircleViewController* circleVC = [CircleViewController new];
    BaseNavigationController *discoverVCNav =[[BaseNavigationController alloc]initWithRootViewController:circleVC];
    
//    MineViewController *fouthViewController = [[MineViewController alloc] init];
    GBMineViewController  *fouthViewController = [[GBMineViewController  alloc]init];
    
    BaseNavigationController *fouthNavigationController = [[BaseNavigationController alloc]
                                                         initWithRootViewController:fouthViewController];
    
    
    
    
    
    self.delegate = self;
    
    self.hidesBottomBarWhenPushed = YES;
    
    //    [self setViewControllers:@[homeNavi, friNavigationController,disNavigtionController,
    //                               fouthNavigationController]];
    
    [self setViewControllers:@[homeNavi,TopLineNav,discoverVCNav,fouthNavigationController]];
//    [self setViewControllers:@[homeNavi,disNavigtionController,fouthNavigationController]];
    
    [self customizeTabBarForController:self];
    
    
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageWithColor:UIColorFromRGB(0xffffff)];
//    UIImage *unfinishedImage = [UIImage imageWithColor:UIColorFromRGB(0xffffff)];
    UIImage *finishedImage = [UIImage imageNamed:@"tabr_bg.jpg"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabr_bg.jpg"];

    
    //    NSArray *tabBarItemImages = @[@"tab_1_",@"tab_2_",@"tab_3_", @"tab_4_"];
    //    NSArray *nameArray = @[@"首页", @"医生",@"消息", @"我的"];
    
//    NSArray *tabBarItemImages = @[@"tab_1_",@"tab_3_",@"tab_5_",@"tab_4_"];
    NSArray *tabBarItemImages = @[@"tab_1_",@"TopLine_",@"tab_5_",@"tab_4_"];
//    NSArray *tabBarItemImages = @[@"tab_1_",@"tab_3_",@"tab_4_"];
//    NSArray *nameArray = @[@"首页",@"消息",@"圈子",@"我的"];
//    NSArray *nameArray = @[@"首页",@"头条",@"圈子",@"我的"];
    NSArray *nameArray = @[@"首页",@"头条",@"圈子",@"我的"];
    NSInteger index = 0;
    
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@press",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];

            [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//            item.itemHeight = 55;
        
        
        [item setTitle:[nameArray objectAtIndex:index]];
        
        
        
        item.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9.0f],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
        
        item.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9.0f],NSForegroundColorAttributeName:UIColorFromRGB(0x61d8d3)};
        
        item.titlePositionAdjustment = UIOffsetMake(0, 6);
        
        item.imagePositionAdjustment = UIOffsetMake(0, 2);
        
        

        item.badgePositionAdjustment = UIOffsetMake(0, 15);
        
        NSLog(@"------%f",item.itemHeight);
        
        item.titlePositionAdjustment = UIOffsetMake(0, 2);
        item.imagePositionAdjustment = UIOffsetMake(0, -2);
        
        
        index++;
    }
    
}

#pragma mark Delegate


-(void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

-(BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    return YES;
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
