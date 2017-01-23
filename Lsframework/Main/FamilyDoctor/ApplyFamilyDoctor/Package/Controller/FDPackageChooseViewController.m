//
//  FDPackageChooseViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDPackageChooseViewController.h"
#import "FDChoicePackagePresenter.h"

@interface FDPackageChooseViewController ()<UITableViewDelegate,UITableViewDataSource,FDChoicePackagePresenterDelegate>{
    UITableView* _table;
    UIButton* _commitBt;
}
@property(nonatomic,retain) NSMutableArray* datasourceArray;
@property(nonatomic,retain) NSMutableDictionary* openDic;
@property(nonatomic,retain) NSMutableArray* sectionTitle;
@property(nonatomic,retain) NSMutableDictionary* selectState;

@property(nonatomic,retain) FDChoicePackagePresenter* presenter;


@end

@implementation FDPackageChooseViewController

-(NSMutableArray *)datasourceArray{
    if(!_datasourceArray){
        _datasourceArray=[NSMutableArray array];
    }
    return _datasourceArray;
}
-(NSMutableDictionary *)openDic{
    if(!_openDic){
        _openDic=[NSMutableDictionary dictionary];
    }
    return _openDic;
}
-(NSMutableArray *)sectionTitle{
    if(!_sectionTitle){
        _sectionTitle=[NSMutableArray array];
    }
    return _sectionTitle;
}
-(NSMutableDictionary *)selectState{
    if(!_selectState){
        _selectState = [NSMutableDictionary dictionary];
    }
    return _selectState;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [FDChoicePackagePresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getPackage:self.doctorID];
}

-(void)setupView{
    self.title = @"家庭医生套餐";

    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorColor = UIColorFromRGB(0xdbdbdb);
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView* tableFooterView = [UIView new];
    
    _commitBt = [UIButton new];
    [_commitBt setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [_commitBt setTitle:@"确认选择套餐" forState:UIControlStateNormal];
    [_commitBt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:_commitBt];
    
    _commitBt.sd_layout.topSpaceToView(tableFooterView,50).leftSpaceToView(tableFooterView,10).rightSpaceToView(tableFooterView,10).heightIs(40);
    [tableFooterView setupAutoHeightWithBottomView:_commitBt bottomMargin:50];
    [_commitBt setHidden:YES];
    [tableFooterView layoutSubviews];
    _table.tableFooterView = tableFooterView;
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasourceArray.count;
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
    NSArray* array=self.datasourceArray[section];
    if([self.openDic[@(section)] intValue]){
        return array.count;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray* array=self.datasourceArray[indexPath.section];
    NSString* title=array[indexPath.row];
    cell.contentView.backgroundColor = UIColorFromRGB(0xEFEFEF);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = title;
    cell.textLabel.textColor = UIColorFromRGB(0x535353);
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSNumber* sectionTitle = self.sectionTitle[section];
    
    UIView* sectionView=[UIView new];
    sectionView.backgroundColor=UIColorFromRGB(0xffffff);
    sectionView.tag=100+section;
    
    //选中框
    UIButton* selectbt = [UIButton new];
    selectbt.tag = sectionView.tag;
    [sectionView addSubview:selectbt];
    if([[self.selectState objectForKey:@(section)] intValue]){
        [selectbt setBackgroundImage:[UIImage imageNamed:@"remeberpsw_sel"] forState:UIControlStateNormal];
    }else{
        [selectbt setBackgroundImage:[UIImage imageNamed:@"remeberpsw_nor"] forState:UIControlStateNormal];
    }
    [selectbt addTarget:self action:@selector(selectPackagesAction:) forControlEvents:UIControlEventTouchUpInside];

    //标题
    UILabel * titleLabel=[UILabel new];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=UIColorFromRGB(0x535353);
    titleLabel.text=[NSString stringWithFormat:@"%@元套餐",sectionTitle];
    [sectionView addSubview:titleLabel];
    //下拉箭头
    UIImageView* narrow = [UIImageView new];
    narrow.image = [UIImage imageNamed:@"ac_down"];
    narrow.userInteractionEnabled = YES;
    [sectionView addSubview:narrow];
    
    selectbt.sd_layout.topSpaceToView(sectionView,17).heightIs(16).leftSpaceToView(sectionView,20).widthEqualToHeight();
    titleLabel.sd_layout.centerYEqualToView(selectbt).autoHeightRatio(0).leftSpaceToView(selectbt,20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    narrow.sd_layout.widthIs(18).heightIs(10).rightSpaceToView(sectionView,25).centerYEqualToView(selectbt);
    
    //添加手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [sectionView addGestureRecognizer:tap];
    
    
    return sectionView;
}


-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        if(self.presenter.packageArray.count == 0){
            [ProgressUtil showInfo:@"未查询到套餐!"];
            return ;
        }
        
        [ProgressUtil dismiss];
        for(Package* package in self.presenter.packageArray){
            NSInteger index = [self.presenter.packageArray indexOfObject:package];
            [self.openDic setObject:@0 forKey:@(index)];
            [self.selectState setObject:@0 forKey:@(index)];
            //标题
            [self.sectionTitle addObject:package.fapackagePrice];
            //套餐内容
            NSMutableArray* packageArray = [NSMutableArray array];
            for(NSDictionary* dic in package.basePackageInfo){
                [packageArray addObject:dic[@"PackageInfo"]];
            }
            [self.datasourceArray addObject:packageArray];
        }
        [_commitBt setHidden:NO];
        [_table reloadData];

    }else{
        [ProgressUtil showError:message];
    }
}



#pragma mark - 点击事件
/**
 *  点击事件
 *
 *  @param tap <#tap description#>
 */
- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
    UIView* sectionView = tap.view;
    NSInteger tag = sectionView.tag-100;
    
//    NSArray* allKeys = self.openDic.allKeys;
//    for(NSNumber* key in allKeys){
//        if([[self.openDic objectForKey:key] intValue]){
//            [self.openDic setObject:@0 forKey:key];
//            [self.selectState setObject:@0 forKey:key];
//            
//            NSInteger index = [key integerValue];
//            if([[self.datasourceArray objectAtIndex:index] count] != 0){
//                [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            return ;
//        }
//    }
    
    if([[self.openDic objectForKey:@(tag)] integerValue]){
        [self.openDic setObject:@0 forKey:@(tag)];
//        [self.selectState setObject:@0 forKey:@(tag)];

    }else{
        [self.openDic setObject:@1 forKey:@(tag)];
//        [self.selectState setObject:@1 forKey:@(tag)];
    }
    
    [_table reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];

    
    
//    if([[self.datasourceArray objectAtIndex:tag] count] != 0){
//        [self.openDic setObject:@1 forKey:@(tag)];
//        [self.selectState setObject:@1 forKey:@(tag)];
//        
//        [_table reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
}

- (void)commitAction{

    NSArray* keys = self.selectState.allKeys;
    BOOL selectPackage = NO;
    NSNumber* selectKey;
    for(NSNumber* key in keys){
        if([[self.selectState objectForKey:key] intValue]){
            selectPackage = YES;
            selectKey = key;
            break;
        }
    }
    if(!selectPackage){
    //提示选择套餐
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请选择套餐" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        
        Package* p = [self.presenter.packageArray objectAtIndex:[selectKey intValue]];
        [kdefaultCenter postNotificationName:Notification_SelectPackage object:nil userInfo:@{@"package":p}];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

/**
 *  选择套餐
 */
- (void)selectPackagesAction:(UIButton*) bt{
    NSInteger index = bt.tag -100;
    
    NSArray* keys = self.selectState.allKeys;
    for(NSNumber* key in keys){
        [self.selectState setObject:@0 forKey:key];
    }
    
    [self.selectState setObject:@1 forKey:@(index)];
    
//    [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_table reloadData];

}






@end
