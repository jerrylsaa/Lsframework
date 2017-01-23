//
//  BehaviourDetailsViewController.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BehaviourDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface BehaviourDetailsViewController ()

@end

@implementation BehaviourDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)setupView
{
    self.title = @"指导内容";
    
    [self loadData];
   
}
-(void)loadData
{
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:_model.createTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd/hh:mm"];
    NSString *dateString = [dateFormat stringFromDate:myDate];
    NSLog(@"date: %@", dateString);
    self.timeLabel.text = dateString;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg]];
     _diseaseLabel.text = [NSString stringWithFormat:@"所患疾病：%@", _model.descriptionDisease];
    
    _departmentsLabel.text = [NSString stringWithFormat:@"科室：%@",_model.departName];
    
    _nameLabel.text = [NSString stringWithFormat:@"医生：%@",_model.doctorName];
    _doctorLevelLabel.text = _model.dictionaryName;
    
    
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
