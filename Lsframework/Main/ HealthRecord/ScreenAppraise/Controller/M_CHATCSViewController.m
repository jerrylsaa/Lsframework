//
//  M_CHATCSViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "M_CHATCSViewController.h"
#import "M_CHATCSCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface M_CHATCSViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *table;

@property (nonatomic,strong) NSArray *tableNameArr;

@end

@implementation M_CHATCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor clearColor];
    
    _tableNameArr =@[@"总分",@"11、18、20、22",@"不通过项"];
    
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
    
    return (self.tableNameArr.count*self.xllbDataSource.count);
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    M_CHATCSCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[M_CHATCSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    NSInteger numb = indexPath.row%self.tableNameArr.count;
    cell.titleName =_tableNameArr[numb];
    
    NSInteger dataNumb =indexPath.row/self.tableNameArr.count;
    XLLBEntity *cellData =[self.xllbDataSource objectAtIndex:dataNumb];
    NSString *scores =cellData.ScaleStandard_Result;
    
    NSArray* subStringArray= [scores componentsSeparatedByString:@"|"];
    if (numb ==0) {
        cell.bzScore =[NSString stringWithFormat:@"总分：%@",[subStringArray objectAtIndex:numb]];

    }else if (numb ==1){
        cell.bzScore =[NSString stringWithFormat:@"未通过项：%@",[subStringArray objectAtIndex:numb]];
    }else if (numb ==2){
        cell.bzScore =[NSString stringWithFormat:@"所有不通过数：%@ , 项目2、7、9、13、14、15不通过数：%@",[subStringArray objectAtIndex:numb],[subStringArray objectAtIndex:(numb+1)]];
    }
    
    NSString *results =cellData.ScaleText_Result;
    
    NSArray* resultStringArray= [results componentsSeparatedByString:@"|"];
    cell.pj =[resultStringArray objectAtIndex:numb];
    
    
    cell.xllbEntity = cellData;
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numb = indexPath.row/self.tableNameArr.count;
    NSInteger numbb = indexPath.row%self.tableNameArr.count;
    if (numbb ==2) {
        return [_table cellHeightForIndexPath:indexPath model:self.xllbDataSource[numb] keyPath:@"xllbEntity" cellClass:[M_CHATCSCell class] contentViewWidth:[self cellContentViewWith]]+120;
    }
    return [_table cellHeightForIndexPath:indexPath model:self.xllbDataSource[numb] keyPath:@"xllbEntity" cellClass:[M_CHATCSCell class] contentViewWidth:[self cellContentViewWith]]+80;
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
