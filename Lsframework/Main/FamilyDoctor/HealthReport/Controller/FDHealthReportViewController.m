//
//  FDHealthReportViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDHealthReportViewController.h"

@interface FDHealthReportViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView* _table;
}

@property(nonatomic,retain) NSArray* dataSource;

@end

@implementation FDHealthReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"健康报告";

    [self setupTableView];
    
    self.dataSource = @[@"第一期健康报告",@"第二期健康报告",@"第三期健康报告",@"第四期健康报告"];
}

- (void)setupTableView{
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = UIColorFromRGB(0xdbdbdb);
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identy=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identy];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}






@end
