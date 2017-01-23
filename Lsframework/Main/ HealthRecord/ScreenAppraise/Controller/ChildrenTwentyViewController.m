//
//  ChildrenTwentyViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChildrenTwentyViewController.h"
#import "ChildrenTwentyPresenter.h"
#import "ChildrenTwentyCSTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface ChildrenTwentyViewController ()<HospitalChildrenTwentyPresenterDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UITableView *table;
@property (nonatomic,strong) ChildrenTwentyPresenter *presenter;

@end

@implementation ChildrenTwentyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.presenter getChild20Data];
}

- (void)setupView{
    self.title = @"医院测评报告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.presenter =[ChildrenTwentyPresenter new];
    self.presenter.delegate = self;
    
    [self setupPage];
    
}

- (void)setupPage{
    UIImageView *backgroundIV =[UIImageView new];
    backgroundIV.image =[UIImage imageNamed:@"hptBGImage"];
    [self.view addSubview:backgroundIV];
    backgroundIV.sd_layout.centerYIs(kScreenHeight/2.0).centerXEqualToView(self.view).widthIs(255).heightIs(329);
    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.topSpaceToView(self.view,30).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.presenter.child20DataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    ChildrenTwentyCSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[ChildrenTwentyCSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    
    
    cell.child20Entity = [self.presenter.child20DataSource objectAtIndex:indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [_table cellHeightForIndexPath:indexPath model:self.presenter.child20DataSource[indexPath.row] keyPath:@"child20Entity" cellClass:[ChildrenTwentyCSTableViewCell class] contentViewWidth:[self cellContentViewWith]]+60;
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

- (void)onCompletion:(BOOL)success info:(NSString *)messsage{
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
