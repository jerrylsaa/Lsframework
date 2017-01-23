//
//  ScreenAppraiseController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ScreenAppraiseController.h"
//#import "DoneCell.h"
#import "FeedBackTableController.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "GaugeListModel.h"
#import "GaugeDetailModel.h"
#import "DefaultChildEntity.h"
#import "GBDoneCell.h"
#import "HospitalScrAprCell.h"
#import "HospitalCPDetailViewController.h"
#import "HospitalDDSTViewController.h"
#import "EXLBViewController.h"
#import "ChildrenTwentyViewController.h"
#import "XLLBViewController.h"

@interface ScreenAppraiseController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *doneView;
@property (weak, nonatomic) IBOutlet UICollectionView *hptScrAprView;



@property (nonatomic,strong) NSMutableArray *gaugeArr;
@property (nonatomic,strong) NSMutableArray *gaugeDetailArr;
@property (nonatomic,strong) GaugeListModel *myModel;
@property (nonatomic,strong) GaugeDetailModel *myDetailModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneViewH;


@property (nonatomic,strong) NSArray *hptImageArr;
@end

@implementation ScreenAppraiseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"筛查测评";
    
    
    _hptImageArr =@[@"yesjydjcImage",@"exlbImage",@"ddstImage",@"gesellImage",@"xllbImage"];
//    [_doneView registerNib:[UINib nibWithNibName:@"DoneCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];

    [_doneView registerClass:[GBDoneCell class] forCellWithReuseIdentifier:@"menuCell"];
    [self requestData];
    
    [_hptScrAprView registerClass:[HospitalScrAprCell class] forCellWithReuseIdentifier:@"hptCell"];
    
   
    
    
}


- (void)requestData {
    WS(weakSelf);
    NSDictionary * params =[NSDictionary dictionary];
    if ([DefaultChildEntity defaultChild]){
        params = @{@"BabyID":[DefaultChildEntity defaultChild].babyID};
    }else {
        return;
    }
    
    [[FPNetwork POST:@"QueryParentUpGauge" withParams:params]  addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
//            [ProgressUtil showInfo:response.message];

            
            
            for (NSDictionary *dict in response.data) {
                [GaugeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"ID" : @"id"                         };
                }];
                GaugeListModel *model = [GaugeListModel mj_objectWithKeyValues:dict];
                [weakSelf.gaugeArr addObject:model];
                
            }
            

            [weakSelf.doneView reloadData];
            [weakSelf haveNoSCRData];
            
        }else{
            [ProgressUtil showError:response.message];
            [weakSelf haveNoSCRData];

        }
    }];
    
    
}

- (void)haveNoSCRData{
    if (_gaugeArr.count ==0) {
        _doneViewH.constant =2.5;
        [self.view updateConstraints];
    }
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag ==1001) {
        return _gaugeArr.count;

    }else {
        return _hptImageArr.count;
    }
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//横向最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
//    return 25.0f;
    return 15.0f;
    
}
//纵向最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
//    return 20.0f;
    if (collectionView.tag ==1001) {
        return 20.0f;

    }
    return 10.0f;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (collectionView.tag ==1001) {
        static NSString * CellIdentifier = @"menuCell";
        //    DoneCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        GBDoneCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.imageView setImage:[UIImage  imageNamed:@"CommitRecord"]];
        cell.cellName.text =((GaugeListModel *)(_gaugeArr[indexPath.item])).name;
        
        
        return cell;
        
    }else {
        static NSString * hptCellIdentifier = @"hptCell";
        //    DoneCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        HospitalScrAprCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hptCellIdentifier forIndexPath:indexPath];
        [cell.imageView setImage:[UIImage  imageNamed:_hptImageArr[indexPath.row]]];
//        cell.cellName.text =_hptTableArr[indexPath.row];
        
        
        return cell;

    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag ==1001) {
        CGFloat  width =([UIScreen mainScreen].bounds.size.width-55)/2;
        CGFloat  height =  0.375*width;
        return CGSizeMake(width, height);
    }else {
        CGFloat width =(kScreenWidth-45)/2.0;
        CGFloat height =(79.0*width)/164.0;
        return CGSizeMake(width, height);
    }
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
    /**
     *  <#CGFloat top#>    cell距离最上面的边界的距离
     *<#CGFloat bottom#>  每两个cell之间的纵向间距
     *  @param 15 <#CGFloat left#>   cell距离左侧边缘的距离
     *  @param 15 <#CGFloat right#>    cell距离右侧边缘的距离
     
     */
    
    return UIEdgeInsetsMake(15, 15, 20, 15);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    if (collectionView.tag ==1001) {
        FeedBackTableController *tableCtrl = [FeedBackTableController new];
        tableCtrl.title =((GaugeListModel *)(_gaugeArr[indexPath.item])).name;
        
        NSString *typeID =((GaugeListModel *)(_gaugeArr[indexPath.item])).ID;
        tableCtrl.gaugeType =typeID;
        NSDictionary * params = @{@"BabyID":[DefaultChildEntity defaultChild].babyID,@"TypeID":typeID};
        
        [[FPNetwork POST:@"QueryGaugeList" withParams:params]  addCompleteHandler:^(FPResponse* response) {
            if(response.isSuccess){
                
                //            [ProgressUtil showInfo:response.message];
                
                weakSelf.gaugeDetailArr =[NSMutableArray array];
                
                for (NSDictionary *dict in response.data) {
                    [GaugeDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"insertAge" : @"InsertAge",
                                 @"insertTime":@"InsertTime",
                                 @"gaugeID":@"GaugeID"
                                 };
                    }];
                    GaugeDetailModel *model = [GaugeDetailModel mj_objectWithKeyValues:dict];
                    [weakSelf.gaugeDetailArr addObject:model];
                    
                    
                }
                tableCtrl.detailArr = [NSArray arrayWithArray:self.gaugeDetailArr];
                [weakSelf.navigationController pushViewController:tableCtrl animated:YES];
                
            }else{
                [ProgressUtil showError:response.message];
                
            }
        }];
        
        
    }else{
        NSLog(@"BBB");
        if (indexPath.row ==0) {
            [self.navigationController pushViewController:[                                    ChildrenTwentyViewController new] animated:YES];
        }
        if (indexPath.row ==1) {
            [self.navigationController pushViewController:[                        EXLBViewController new] animated:YES];
        }
        if (indexPath.row ==2) {
            [self.navigationController pushViewController:[            HospitalDDSTViewController new] animated:YES];
        }
        if(indexPath.row ==3) {
            [self.navigationController pushViewController:[HospitalCPDetailViewController new] animated:YES];
        }
        if (indexPath.row ==4) {
            
            [self.navigationController pushViewController:[XLLBViewController new] animated:YES];
        }
        
    }
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSMutableArray *)gaugeArr {
    if (!_gaugeArr) {
        _gaugeArr =[NSMutableArray array];
    }
    return _gaugeArr;
}

- (NSMutableArray *)gaugeDetailArr {
    if (!_gaugeDetailArr) {
        _gaugeDetailArr =[NSMutableArray array];
    }
    return _gaugeDetailArr;
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
