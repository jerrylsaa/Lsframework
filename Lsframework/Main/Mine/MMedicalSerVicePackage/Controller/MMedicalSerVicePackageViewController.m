//
//  MMedicalSerVicePackageViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MMedicalSerVicePackageViewController.h"

@interface MMedicalSerVicePackageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView* _table;
}

@property(nonatomic,retain) NSMutableArray* sectionTitle;
@property(nonatomic,retain) NSMutableArray* serviceDate;

@property(nonatomic,retain) NSMutableDictionary* openDic;
@property(nonatomic,retain) NSMutableArray* datasourceArray;

@end

@implementation MMedicalSerVicePackageViewController
-(NSMutableArray *)sectionTitle{
    if(!_sectionTitle){
        _sectionTitle=[NSMutableArray array];
    }
    return _sectionTitle;
}
-(NSMutableArray *)serviceDate{
    if(!_serviceDate){
        _serviceDate=[NSMutableArray array];
    }
    return _serviceDate;
}



-(NSMutableDictionary *)openDic{
    if(!_openDic){
        _openDic=[NSMutableDictionary dictionary];
    }
    return _openDic;
}
-(NSMutableArray *)datasourceArray{
    if(!_datasourceArray){
        _datasourceArray=[NSMutableArray array];
    }
    return _datasourceArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    for(Package* package in self.dataSorce){
        NSInteger index = [self.dataSorce indexOfObject:package];
        [self.openDic setObject:@0 forKey:@(index)];
        //标题
        [self.sectionTitle addObject:package.packageName];
        //时间戳
        NSString* endTime = [package.packageEndTime format2String:@"yyyy/MM/dd"];
        if(endTime.length == 0){
            endTime = @" ";
        }
        [self.serviceDate addObject:endTime];
        //套餐内容
        NSMutableArray* packageArray = [NSMutableArray array];
        for(NSDictionary* dic in package.basePackageInfo){
            [packageArray addObject:dic[@"PackageInfo"]];
        }
        [self.datasourceArray addObject:packageArray];
    }

}


#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"我的医疗服务套餐";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorColor = UIColorFromRGB(0xdbdbdb);
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
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
    NSString* sectionTitle = self.sectionTitle[section];
    NSString* sectionDetailTitle = self.serviceDate[section];
    
    UIView* sectionView=[UIView new];
    sectionView.backgroundColor=UIColorFromRGB(0xffffff);
    sectionView.tag=100+section;
    
    UILabel * titleLabel=[UILabel new];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=UIColorFromRGB(0x535353);
    titleLabel.text=sectionTitle;
    [sectionView addSubview:titleLabel];
    
    UILabel * dateLabel=[UILabel new];
    dateLabel.font=[UIFont systemFontOfSize:14];
    dateLabel.textColor=UIColorFromRGB(0x878787);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text=[NSString stringWithFormat:@"到期日期：%@",sectionDetailTitle];
    [sectionView addSubview:dateLabel];
    
    UIView* line=[UIView new];
    line.backgroundColor=UIColorFromRGB(0xdbdbdb);
    [sectionView addSubview:line];

    titleLabel.sd_layout.topSpaceToView(sectionView,15).autoHeightRatio(0).leftSpaceToView(sectionView,20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    dateLabel.sd_layout.centerYEqualToView(titleLabel).autoHeightRatio(0).rightSpaceToView(sectionView,15);
    [dateLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    line.sd_layout.bottomSpaceToView(sectionView,50).heightIs(1).leftSpaceToView(sectionView,0).rightSpaceToView(sectionView,0);

    //添加手势
//    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    [sectionView addGestureRecognizer:tap];
    
    
    return sectionView;
}

/**
 *  点击事件
 *
 *  @param tap <#tap description#>
 */
//- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
//    NSInteger tag = tap.view.tag-100;
//    
//    NSArray* allKeys = self.openDic.allKeys;
//    for(NSNumber* key in allKeys){
//        if([[self.openDic objectForKey:key] intValue]){
//            [self.openDic setObject:@0 forKey:key];
//            NSInteger index = [key integerValue];
//            if([[self.datasourceArray objectAtIndex:index] count] != 0){
//                [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            return ;
//        }
//    }
//
//    if([[self.datasourceArray objectAtIndex:tag] count] != 0){
//        [self.openDic setObject:@1 forKey:@(tag)];
//        [_table reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}



@end
