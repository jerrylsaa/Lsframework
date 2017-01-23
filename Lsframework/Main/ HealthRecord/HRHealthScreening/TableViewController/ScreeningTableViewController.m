//
//  ScreeningTableViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ScreeningTableViewController.h"
#import "SCellModel.h"
#import "ScreeningfCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

@interface ScreeningTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *screeningTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *alphaView;

@end

@implementation ScreeningTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupScrollView];
    [self setupTableView];
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupTableView{
    
    _alphaView = [UIView new];
    _alphaView.backgroundColor = [UIColor colorWithWhite:.6 alpha:.3];
    [_scrollView addSubview:_alphaView];
    _alphaView.clipsToBounds = YES;
    _alphaView.layer.cornerRadius = 25;
    
    _screeningTableView = [UITableView new];
    _screeningTableView.dataSource = self;
    _screeningTableView.delegate = self;
    _screeningTableView.scrollEnabled = NO;
    _screeningTableView.backgroundColor = [UIColor clearColor];
    _screeningTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_alphaView addSubview:_screeningTableView];
    
    _alphaView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_scrollView,20).heightIs([self totalHeight] + 40);
    _screeningTableView.sd_layout.leftSpaceToView(_alphaView,0).rightSpaceToView(_alphaView,0).topSpaceToView(_alphaView,20).heightIs([self totalHeight]);
    [_scrollView setupAutoContentSizeWithBottomView:_alphaView bottomMargin:100];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_screening";
    ScreeningfCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ScreeningfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SCellModel *model = [SCellModel new];
    model.title = [NSString stringWithFormat:@"%@：",_titleArray[indexPath.row]];
    model.text = _sourceDic[_titleArray[indexPath.row]];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCellModel *model = [SCellModel new];
    model.title = _titleArray[indexPath.row];
    model.text = _sourceDic[_titleArray[indexPath.row]];
    
    return [_screeningTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ScreeningfCell class] contentViewWidth:[self cellContentViewWith]];
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
- (CGFloat)totalHeight{
    CGFloat height = 0.f;
    for (int i = 0; i < _titleArray.count; i ++) {
        SCellModel *model = [SCellModel new];
        model.title = _titleArray[i];
        model.text = _sourceDic[_titleArray[i]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        height += [_screeningTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ScreeningfCell class] contentViewWidth:[self cellContentViewWith]];
    }
    return height;
}


@end
