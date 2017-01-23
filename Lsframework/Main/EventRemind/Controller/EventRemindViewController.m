//
//  EventRemindViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/6/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "EventRemindViewController.h"
#import "AddEventRemindViewController.h"

@interface EventRemindViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchBg;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"事件提醒";
    [self initRightBarWithTitle:@"添加事件提醒"];
    [_searchBg setBorderColor:MainColor];
    [_searchBg setBorderWidth:1.f];
    [_searchBg setCornerRadius:19.0];
    [_tableView registerNib:[UINib nibWithNibName:@"EventRemindTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}
#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190.f;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark Action

- (IBAction)btnSearchAction:(id)sender {
}

-(void)rightItemAction:(id)sender{
    AddEventRemindViewController * vc = [AddEventRemindViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
