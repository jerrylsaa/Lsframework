//
//  HptzhidaoViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HptzhidaoViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "HospitalZDaoCell.h"
@interface HptzhidaoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *table;


@end

@implementation HptzhidaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor clearColor];

}

-(void)setupView{
    
    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.topSpaceToView(self.view,30).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.gesellDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    HospitalZDaoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[HospitalZDaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    
    
    cell.gesellEntity = [self.gesellDataSource objectAtIndex:indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if ([_table cellHeightForIndexPath:indexPath model:self.presenter.gesellDataSource[indexPath.row] keyPath:@"gesellEntity" cellClass:[HospitalCSCell class] contentViewWidth:[self cellContentViewWith]]<80) {
    //        return 80;
    //    }
    return [_table cellHeightForIndexPath:indexPath model:self.gesellDataSource[indexPath.row] keyPath:@"gesellEntity" cellClass:[HospitalZDaoCell class] contentViewWidth:[self cellContentViewWith]]+60;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
