//
//  BaseArchivesViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/5/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseArchivesViewController.h"

@interface BaseArchivesViewController ()

@end

@implementation BaseArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initRightBarWithTitle:@"完成"];
}

-(void)rightItemAction:(id)sender{
    if (_poptoClass) {
        UIViewController * back;
        for (UIViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:_poptoClass]) {
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
