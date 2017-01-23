//
//  BaseNavigationController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseNavigationController.h"
#import "TabbarViewController.h"
#import "SplashViewController.h"
#import "BaseViewController.h"
#import "JMChatViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIViewController * currentVc = self.childViewControllers[self.childViewControllers.count - 1];
    
    if ([currentVc isKindOfClass:[TabbarViewController class]]
        || [currentVc isKindOfClass:[SplashViewController class]]
        || [currentVc isKindOfClass:NSClassFromString(@"RegSuccessViewController")]) {
        return NO;
    }
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    
    if ([currentVc isKindOfClass:[JMChatViewController class]]) {
       return YES;
    }
    
    if ([currentVc isKindOfClass:[BaseViewController class]]) {
        return [((BaseViewController*)currentVc) isCanDragBack];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
