//
//  CABSCSViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CABSCSViewController.h"
#import "CABSCSCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface CABSCSViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *table;



@end

@implementation CABSCSViewController

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
    
    return self.xllbDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    CABSCSCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[CABSCSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    
    cell.xllbEntity = [self.xllbDataSource objectAtIndex:indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [_table cellHeightForIndexPath:indexPath model:self.xllbDataSource[indexPath.row] keyPath:@"xllbEntity" cellClass:[CABSCSCell class] contentViewWidth:[self cellContentViewWith]]+60;
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
