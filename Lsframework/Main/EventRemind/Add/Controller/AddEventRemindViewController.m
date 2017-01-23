//
//  AddEventRemindViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/6/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AddEventRemindViewController.h"

@interface AddEventRemindViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrow;
@property (weak, nonatomic) IBOutlet UITextView *tvDetail;

@end

@implementation AddEventRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"添加事件";
}

- (IBAction)btnAddAction:(id)sender {
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
