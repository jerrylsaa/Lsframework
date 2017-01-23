//
//  DataInputViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DataInputViewController.h"
#import "DataInputPresenter.h"
#import "DataInputCell.h"
#import "DataValue.h"
#import "DefaultChildEntity.h"

@interface DataInputViewController ()<UITableViewDataSource,UITableViewDelegate,DataInputCellDelegate,DataInputDelegate>

@property (nonatomic, strong) UITableView *inputTableView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableDictionary *heightdic;
@property (nonatomic, strong) DataInputPresenter *presenter;

@end

@implementation DataInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = _titleText;
    _imageArray = @[@"1岁",@"2岁",@"3岁",@"4岁",@"5岁",@"6岁",@"7岁"];
    _heightdic = [NSMutableDictionary dictionary];
    [self setupTableView];
    _presenter = [DataInputPresenter new];
    _presenter.delegate = self;
    [self loadData];
    [self initRightBarWithTitle:@"保存"];
}

- (void)setupTableView{
    _inputTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _inputTableView.backgroundColor = [UIColor whiteColor];
    _inputTableView.dataSource = self;
    _inputTableView.delegate = self;
    [self.view addSubview:_inputTableView];
    _inputTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_input";
    DataInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DataInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_heightdic objectForKey:indexPath] && ![[_heightdic objectForKey:indexPath] isEqual:@0.f]) {
        cell.colHeight = [[_heightdic objectForKey:indexPath] floatValue];
        if ([_presenter.dataDic objectForKey:[NSNumber numberWithInteger:indexPath.section]]) {
            cell.dataArray = [_presenter.dataDic objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        }else{
            cell.dataArray = nil;
        }
    }else{
        cell.colHeight = 0.f;
    }
    cell.sd_indexPath = indexPath;
    cell.delegate = self;
    NSString *type;
    if ([self.title isEqualToString:@"身高编辑"]) {
        type = @"cm";
    }else{
        type = @"kg";
    }
    cell.type = type;
    cell.sd_indexPath = indexPath;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_heightdic objectForKey:indexPath]) {
        return [[_heightdic objectForKey:indexPath] floatValue];
    }else{
        [_heightdic setObject:@0 forKey:indexPath];
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *ageStr = [DefaultChildEntity defaultChild].nL;
    NSInteger age;
    ageStr = [ageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange range = [ageStr rangeOfString:@"岁"];
    if (range.length == 0) {
        //0岁(开放1岁)
        age = 1;
    }else{
        NSRange yearRange = {0,1};
        age = [[ageStr substringWithRange:yearRange] integerValue];
        age ++;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, kScreenWidth, 80);
    
    UIImageView *imageView = [UIImageView new];
    if (section <= age-1) {
        imageView.image = [UIImage imageNamed:_imageArray[section]];
    }else{
        NSString *name = [NSString stringWithFormat:@"%@-锁定",_imageArray[section]];
        imageView.image = [UIImage imageNamed:name];
    }
    [view addSubview:imageView];
    imageView.sd_layout.leftSpaceToView(view,25).topSpaceToView(view,17).heightIs(46).widthIs(46);
    
    UIButton *button = [UIButton new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (![_heightdic objectForKey:indexPath] || [[_heightdic objectForKey:indexPath] floatValue] == 0.f) {
        if (section <= age-1) {
            [button setImage:[UIImage imageNamed:@"闭合"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"闭合(锁定)"] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    }else{
        [button setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(44, 0, 17, 0)];
    button.tag = 100+section;
    [button addTarget:self action:@selector(unfoldAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    button.sd_layout.topSpaceToView(view,0).rightSpaceToView(view,0).widthIs(66).heightIs(80);
    
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0xefefef);
    [view addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(view,0).rightSpaceToView(view,0).bottomSpaceToView(view,0).heightIs(1);
    
    return view;
}

- (void)unfoldAction:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btn.tag - 100];
    if ([[_heightdic objectForKey:indexPath] floatValue] == 0.f) {
        [_heightdic setObject:@313.f forKey:indexPath];
        [btn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    }else{
        [_heightdic setObject:@0.f forKey:indexPath];
        [btn setImage:[UIImage imageNamed:@"闭合"] forState:UIControlStateNormal];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:btn.tag - 100];
    [_inputTableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)input:(NSString *)text indexPath:(NSIndexPath *)indexPath{
    //上传，刷新
    WS(ws);
    NSString *month = [NSString stringWithFormat:@"%ld",indexPath.section*12+indexPath.row];
    NSString *type;
    if ([self.title isEqualToString:@"身高编辑"]) {
        type = @"1";
    }else{
        type = @"2";
    }
    //当前岁数有数据存在
    if ([_presenter.dataDic objectForKey:[NSNumber numberWithInteger:indexPath.section]]) {
        NSArray *array = [_presenter.dataDic objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        BOOL isExist = NO;
        DataValue *existValue;
        for (DataValue *value in array) {
            if ([value.Month integerValue] == [month integerValue]) {
                isExist = YES;
                existValue = value;
            }
        }
        if (isExist == YES) {
            //已有数据编辑
            if ([text floatValue] == [existValue.DataValue floatValue]) {
                return;
            }
            [_presenter UpdateBabyBodyData:text id:existValue.RowID type:type block:^(BOOL success) {
                [ws loadData];
            }];
        }else{
            //新数据插入
            [_presenter InsertBabyBodyDataMonth:text type:type month:month block:^(BOOL success) {
                [ws loadData];
            }];
        }

    }else{
        //新数据插入
        [_presenter InsertBabyBodyDataMonth:text type:type month:month block:^(BOOL success) {
            [ws loadData];
        }];
    }
    
}
- (void)complete:(BOOL)success message:(NSString *)message{
    if (success == YES) {
        [_inputTableView reloadData];
    }
}
- (void)loadData{
    NSString *type;
    if ([self.title isEqualToString:@"身高编辑"]) {
        type = @"1";
    }else{
        type = @"2";
    }
    [_presenter GetBabyBodyDataByBabyID:type];
}
- (void)rightItemAction:(id)sender{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
}
@end
