//
//  QuestDetailViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "QuestDetailViewController.h"
#import "DiscoverQuestTableViewCell.h"
#import "DiscoverPresenter.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface QuestDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DiscoverPresenterDelegate>
@property(nonatomic,retain) UITableView *table;
@property (nonatomic,strong) DiscoverPresenter *presenter;
@end

@implementation QuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"任务列表";
    
    self.presenter = [DiscoverPresenter new];
    self.presenter.delegate = self;
    [self.presenter loadQuestList];
    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)backItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.presenter.questDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    DiscoverQuestTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[DiscoverQuestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.questEntity = [self.presenter.questDataSource objectAtIndex:indexPath.row];
    
    if (indexPath.row%2==0) {
        cell.contentView.backgroundColor =[UIColor whiteColor];
    }else{
        cell.contentView.backgroundColor =UIColorFromRGB(0xb6eceb);
    }
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_table cellHeightForIndexPath:indexPath model:self.presenter.questDataSource[indexPath.row] keyPath:@"questEntity" cellClass:[DiscoverQuestTableViewCell class] contentViewWidth:[self cellContentViewWith]]<77) {
        return 77;
    }
    return [_table cellHeightForIndexPath:indexPath model:self.presenter.questDataSource[indexPath.row] keyPath:@"questEntity" cellClass:[DiscoverQuestTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
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

- (void)onGetQuestCompletion:(BOOL)success info:(NSString *)messsage{
    if(success){
        [_table reloadData];
    }else{
        [ProgressUtil showError:messsage];
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
