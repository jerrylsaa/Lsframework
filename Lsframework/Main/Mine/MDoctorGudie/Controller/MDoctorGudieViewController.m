//
//  MDoctorGudieViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorGudieViewController.h"
#import "BehaviourViewController.h"
#import "MedicationViewController.h"

@interface MDoctorGudieViewController ()
{
    UIButton *behaviourBtn;
    UIButton *medicationBtn;
}

@end

@implementation MDoctorGudieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"医生指导";
    self.view.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    
    [self setupTwoBtn];

    
}
-(void)setupTwoBtn
{
    behaviourBtn = [UIButton new];
    [self.view addSubview:behaviourBtn];
    [behaviourBtn setImage:[UIImage imageNamed:@"DietGuide_nor"] forState:UIControlStateNormal];
    [behaviourBtn setImage:[UIImage imageNamed:@"DietGuide_sel"] forState:UIControlStateSelected];
    [behaviourBtn addTarget:self action:@selector(behaviour) forControlEvents:UIControlEventTouchUpInside];
    behaviourBtn.sd_layout.topSpaceToView(self.view, 100).rightSpaceToView(self.view, 60).leftSpaceToView(self.view, 60).heightIs(100);
    
    
    medicationBtn = [UIButton new];
    [self.view addSubview:medicationBtn];
    [medicationBtn setImage:[UIImage imageNamed:@"Medication guide_nor"] forState:UIControlStateNormal];
    [medicationBtn setImage:[UIImage imageNamed:@"Medication guide_sel"] forState:UIControlStateSelected];
    [medicationBtn addTarget:self action:@selector(medication) forControlEvents:UIControlEventTouchUpInside];
    medicationBtn.sd_layout.topSpaceToView(behaviourBtn,35).rightEqualToView(behaviourBtn).leftEqualToView(behaviourBtn).heightIs(100);
    
}
#pragma mark 行为指导
-(void)behaviour
{
    BehaviourViewController *vc = [[BehaviourViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 用药指导
-(void)medication
{
    
    
}


@end
