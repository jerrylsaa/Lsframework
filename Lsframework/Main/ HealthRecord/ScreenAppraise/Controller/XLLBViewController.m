//
//  XLLBViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "XLLBViewController.h"
#import "DoneCell.h"
#import "GJTJViewController.h"
#import "CARSViewController.h"
#import "ABCViewController.h"
#import "SASViewController.h"
#import "CABSViewController.h"
#import "SRSViewController.h"
#import "SDSViewController.h"
#import "GNSHPGViewController.h"
#import "ZDXJZPGViewController.h"
#import "CONNERS_FMViewController.h"
#import "M_CHATViewController.h"
#import "SNAP_IVViewController.h"

@interface XLLBViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *doneView;
@property (nonatomic,strong) NSArray *xllbNameArr;

@end

@implementation XLLBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"心理量表";
    self.view.backgroundColor =[UIColor whiteColor];
    
    _xllbNameArr =@[@"儿童感觉统合量表",@"儿童期孤独症量表",@"孤独症家长评定量表",@"焦虑自评量表",@"克氏行为量表",@"社交反应量表",@"抑郁自评量表",@"ADHD功能损害评估量表",@"ADHD诊断性家长评估表",@"Conners父母症状问卷",@"M_CHAT量表",@"SNAP_IV量表"];
}

- (void)setupView{
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    CGFloat  width =([UIScreen mainScreen].bounds.size.width-55)/2;
    CGFloat  height =  0.4295*width;
    
    flowLayout.itemSize = CGSizeMake(width,height);
    
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 15);
    
    
    _doneView =[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _doneView.backgroundColor =[UIColor whiteColor];
    _doneView.delegate =self;
    _doneView.dataSource =self;

    UINib *nib = [UINib nibWithNibName:@"DoneCell" bundle: [NSBundle mainBundle]];
    [_doneView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:_doneView];
    _doneView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _xllbNameArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"Cell";
    
    DoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.cellName.text =_xllbNameArr[indexPath.item];
    
    
    return cell;

}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item ==0) {
        [self.navigationController pushViewController:[GJTJViewController new] animated:YES];
    }else if (indexPath.item ==1){
        [self.navigationController pushViewController:[        CARSViewController new] animated:YES];
    }else if (indexPath.item ==2){
        [self.navigationController pushViewController:[        ABCViewController new] animated:YES];
    }else if (indexPath.item ==3){
        [self.navigationController pushViewController:[                SASViewController new] animated:YES];
    }else if (indexPath.item ==4){
        [self.navigationController pushViewController:[CABSViewController new] animated:YES];
    }else if (indexPath.item ==5){
        [self.navigationController pushViewController:[SRSViewController new] animated:YES];
    }else if (indexPath.item ==6){
        [self.navigationController pushViewController:[SDSViewController new] animated:YES];
    }else if (indexPath.item ==7){
        [self.navigationController pushViewController:[        GNSHPGViewController new] animated:YES];
    }else if (indexPath.item ==8){
        [self.navigationController pushViewController:[                ZDXJZPGViewController new] animated:YES];
    }else if (indexPath.item ==9){
        [self.navigationController pushViewController:[                        CONNERS_FMViewController new] animated:YES];
    }else if (indexPath.item ==10){
        [self.navigationController pushViewController:[                                M_CHATViewController new] animated:YES];

    }else if (indexPath.item ==11){
        [self.navigationController pushViewController:[                                    SNAP_IVViewController new] animated:YES];

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
