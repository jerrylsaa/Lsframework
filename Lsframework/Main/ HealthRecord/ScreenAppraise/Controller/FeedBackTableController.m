//
//  FeedBackTableController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/5/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FeedBackTableController.h"
#import "FeedBackTableCell.h"
#import "FFeedBackTableCell.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "SucceedSubmitViewController.h"
#import "DefaultChildEntity.h"
#import "HealthSucceedViewController.h"

@interface FeedBackTableController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *commit;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation FeedBackTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"FeedBackTableCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view  addSubview:_topView];

    self.topView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).widthIs(kScreenWidth).heightIs(46);
    self.commit.text = @"已完成的测评问卷";
    self.commit.font = [UIFont systemFontOfSize:16];
    [_topView  addSubview:_commit];
    self.commit.sd_layout.centerYEqualToView(self.topView).leftSpaceToView(self.topView,15).widthIs(32).heightIs(16);
    
    _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
        [_tableView registerNib:[UINib nibWithNibName:@"FFeedBackTableCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _detailArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 25.0f;
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5.0f;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"Cell";
//    FeedBackTableCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    FFeedBackTableCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.insertAgeLabel.text =((GaugeDetailModel *)_detailArr[indexPath.item]).insertAge;
    cell.insertTimeLabel.text =[NSDate showMyDate:(NSTimeInterval )(((GaugeDetailModel *)_detailArr[indexPath.item]).insertTime) withDateFormatter:@"yyyy-MM-dd"];
    cell.doctorLabel.text =((GaugeDetailModel *)_detailArr[indexPath.item]).doctor;
    
    if (((GaugeDetailModel *)_detailArr[indexPath.item]).resultTime>2) {
        cell.resultTimeLabel.text =@" 已完成 ";
        cell.resultTimeLabel.font = [UIFont  systemFontOfSize:14];
        cell.resultTimeLabel.backgroundColor =[UIColor colorWithRed:0.4431 green:0.8314 blue:0.8078 alpha:1.0];
//        cell.topLineView.backgroundColor =[UIColor colorWithRed:0.4431 green:0.8314 blue:0.8078 alpha:1.0];
//        cell.bottomLineView.backgroundColor =[UIColor colorWithRed:0.4431 green:0.8314 blue:0.8078 alpha:1.0];
    }else {
        cell.resultTimeLabel.font = [UIFont  systemFontOfSize:14];
        cell.resultTimeLabel.text =@" 等待结果 ";
        cell.resultTimeLabel.backgroundColor =[UIColor colorWithRed:0.3457 green:0.7012 blue:0.839 alpha:1.0];
//        cell.topLineView.backgroundColor =[UIColor colorWithRed:0.3457 green:0.7012 blue:0.839 alpha:1.0];
//        cell.bottomLineView.backgroundColor =[UIColor colorWithRed:0.3457 green:0.7012 blue:0.839 alpha:1.0];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 115);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
//    SucceedSubmitViewController *susCtril =[SucceedSubmitViewController new];
    HealthSucceedViewController  *susCtril =[HealthSucceedViewController new];
    NSString *gaugeId =[NSString stringWithFormat:@"%ld",((GaugeDetailModel *)_detailArr[indexPath.item]).gaugeID];
    NSDictionary * params = @{@"BabyID":[DefaultChildEntity defaultChild].babyID,@"ID":gaugeId,@"GaugeType":weakSelf.gaugeType};
    
    [[FPNetwork POST:@"QueryGauge" withParams:params]  addCompleteHandler:^(FPResponse* response) {
        if(response.status ==200|response.status ==201){
            
//            [ProgressUtil showInfo:response.message];
            
            /*
            if (weakSelf.title.length>=30&&weakSelf.title.length<42) {
                susCtril.titleArray = @[[weakSelf.title substringToIndex:15],[weakSelf.title substringWithRange:NSMakeRange(15, 15)],[NSString stringWithFormat:@"%@",[weakSelf.title substringFromIndex:30]]];
            }
            else if (weakSelf.title.length>=42&&weakSelf.title.length<50) {
                susCtril.titleArray = @[[weakSelf.title substringToIndex:15],[weakSelf.title substringWithRange:NSMakeRange(15, 15)],[weakSelf.title substringFromIndex:30],@""];
            }
            else if (weakSelf.title.length>=12&&weakSelf.title.length<20) {
                susCtril.titleArray = @[[weakSelf.title substringToIndex:8],[NSString stringWithFormat:@"%@",[weakSelf.title substringFromIndex:8]]];
            }
            else if (weakSelf.title.length>=20&&weakSelf.title.length<27) {
                susCtril.titleArray = @[[weakSelf.title substringToIndex:15],[NSString stringWithFormat:@"%@",[weakSelf.title substringFromIndex:15]]];
            }
            else{
            susCtril.titleArray = @[[NSString stringWithFormat:@"%@",weakSelf.title]];
            }
            */
     susCtril.FootText = weakSelf.title;
     NSString *result =response.data;
            
             if (result.length>=15&&result.length<30)
            {
                susCtril.subtitleArray = @[[result substringToIndex:15],[result substringFromIndex:15]];
            }
             else if (result.length>=30&&result.length<45)
            {
                susCtril.subtitleArray = @[[result substringToIndex:15],[result substringWithRange:NSMakeRange(15, 15)],[result substringFromIndex:30]];
            }
             else if (result.length>=45&&result.length<60)
            {
                susCtril.subtitleArray = @[[result substringToIndex:15],[result substringWithRange:NSMakeRange(15, 15)],[result substringWithRange:NSMakeRange(30, 15)],[result substringFromIndex:45]];         }
             else if (result.length>=60&&result.length<75)
             {
                 susCtril.subtitleArray = @[[result substringToIndex:15],[result substringWithRange:NSMakeRange(15, 15)],[result substringWithRange:NSMakeRange(30, 15)],[result substringWithRange:NSMakeRange(45, 15)],[result substringFromIndex:60]];
                  
                 
             }
             else if (result.length>=75&&result.length<100)
             {
                 susCtril.subtitleArray = @[[result substringToIndex:15],[result substringWithRange:NSMakeRange(15, 15)],[result substringWithRange:NSMakeRange(30, 15)],[result substringWithRange:NSMakeRange(45, 15)],[result substringWithRange:NSMakeRange(60, 15)],[result substringFromIndex:75]];         }
            else{
                susCtril.subtitleArray = @[[NSString stringWithFormat:@"%@",result]];
            }
             
            /*
            if (result.length>=12&&result.length<24)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringFromIndex:24]];
            }
            else if (result.length>=24&&result.length<36)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringFromIndex:24]];
            }
            else if (result.length>=36&&result.length<48)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringWithRange:NSMakeRange(24, 12)],[result substringFromIndex:36]];         }
            else if (result.length>=48&&result.length<60)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringWithRange:NSMakeRange(24, 12)],[result substringWithRange:NSMakeRange(36, 12)],[result substringFromIndex:48]];
                
                
            }
            else if (result.length>=60&&result.length<72)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringWithRange:NSMakeRange(24, 12)],[result substringWithRange:NSMakeRange(36, 12)],[result substringWithRange:NSMakeRange(48, 12)],[result substringFromIndex:60]];
            }else if (result.length>=72&&result.length<84)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringWithRange:NSMakeRange(24, 12)],[result substringWithRange:NSMakeRange(36, 12)],[result substringWithRange:NSMakeRange(48, 12)],[result substringWithRange:NSMakeRange(60, 12)],[result substringFromIndex:72]];
            }
            else if (result.length>=84&&result.length<96)
            {
                susCtril.subtitleArray = @[[result substringToIndex:12],[result substringWithRange:NSMakeRange(12, 12)],[result substringWithRange:NSMakeRange(24, 12)],[result substringWithRange:NSMakeRange(36, 12)],[result substringWithRange:NSMakeRange(48, 12)],[result substringWithRange:NSMakeRange(60, 12)],[result substringWithRange:NSMakeRange(72, 12)],[result substringFromIndex:84]];
            }
            else{
                susCtril.subtitleArray = @[[NSString stringWithFormat:@"%@",result]];
            }
             */

            
//            susCtril.tips = nil;
            [weakSelf.navigationController pushViewController:susCtril animated:YES];
            
        }else{
            [ProgressUtil showError:response.message];
            
        }
    }];

}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
