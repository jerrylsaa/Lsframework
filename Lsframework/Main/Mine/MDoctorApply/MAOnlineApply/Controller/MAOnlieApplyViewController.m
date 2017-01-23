//
//  MAOnlieApplyViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MAOnlieApplyViewController.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MAOnlineApplyPresenter.h"
#import "OnlineApplyCell.h"


@interface MAOnlieApplyViewController ()<UITableViewDelegate,UITableViewDataSource,MAOnlineDelegate,MAOnlineApplyPresenterDelegate>{
}

@property(nonatomic,retain) NSArray<MineApplyFamilyDoctorEntity*>* dataSource;

@property(nonatomic,retain) MAOnlineApplyPresenter* presenter;
@property(nonatomic,retain) UIView* noApplyView;
@property(nonatomic,retain) UITableView* table;


@end

@implementation MAOnlieApplyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [MAOnlineApplyPresenter new];
    self.presenter.delegate = self;

}


#pragma mark - 代理

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
    
    MineApplyFamilyDoctorEntity* doctor = self.dataSource[indexPath.row];
    
    OnlineApplyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.doctor = doctor;
    if(!cell.delegate){
        cell.delegate = self;
    }
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 130;
    
    MineApplyFamilyDoctorEntity* doctor = self.dataSource[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:doctor keyPath:@"doctor" cellClass:[OnlineApplyCell class] contentViewWidth:[self cellContentViewWith]];
}

/**
 *  确认支付
 */
-(void)commitPay{
    NSLog(@"立即支付");
}

-(void)onCompletion:(BOOL)success info:(NSString *)info{
    [self.table.mj_header endRefreshing];
    
    if(success){
        self.dataSource = nil;
        self.dataSource = self.presenter.dataSource;
        [self.table reloadData];
    }else{
    }
}


#pragma mark - 懒加载
-(UIView *)noApplyView{
    if(!_noApplyView){
        _noApplyView = [UIView new];
        _noApplyView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        UILabel* title = [UILabel new];
        title.text = @"您还没有家庭医生申请记录";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = RGB(83, 83, 83);
        
        [_noApplyView addSubview:title];
        title.sd_layout.centerYEqualToView(_noApplyView).autoHeightRatio(0).leftSpaceToView(_noApplyView,0).rightSpaceToView(_noApplyView,0);
    }
    return _noApplyView;
}
-(UITableView *)table{
    if(!_table){
        _table = [UITableView new];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorColor = UIColorFromRGB(0xbbbbbb);
        
        [_table registerClass:[OnlineApplyCell class] forCellReuseIdentifier:@"cell"];
        
        WS(ws);
        _table.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [ws.presenter refreshHeader];
        }];

    }
    return _table;
}


#pragma mark - 公有方法
- (void)reloadData:(FPResponse *)response{
    if(response.success){
        if([response.data isKindOfClass:[NSArray class]]){
            NSArray* data = response.data;
            if(data.count != 0){
                self.dataSource = [MineApplyFamilyDoctorEntity mj_objectArrayWithKeyValuesArray:response.data];
                [self.view addSubview:self.table];
                self.table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
                
                [self.table reloadData];
            }else{
                [self.view addSubview:self.noApplyView];
                self.noApplyView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
            }
        }else if([response.data isKindOfClass:[NSString class]]){
            //兼容查询成功，后台返回字符串
            [self.view addSubview:self.noApplyView];
            self.noApplyView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        }
    }else{
        [ProgressUtil showError:response.message];
    }

}



#pragma mark -

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}




@end
