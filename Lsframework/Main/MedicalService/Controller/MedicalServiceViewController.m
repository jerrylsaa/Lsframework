//
//  MedicalServiceViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MedicalServiceViewController.h"
#import "ServiceTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "ACMainViewController.h"
#import "WholetimeAssisstController.h"
#import "BookingDateViewController.h"
#import "ParkServiceViewController.h"

@interface MedicalServiceViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView* _table;
}

@property(nonatomic,retain) NSArray* imageArray;
@property(nonatomic,retain) NSArray* titleArray;
@property(nonatomic,retain) NSArray* detailArray;



@end

@implementation MedicalServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.imageArray=@[@"normal_reservation",@"special_reservation",@"medical_assistant",@"carservice"];
//    self.titleArray=@[@"普通门诊预约",@"特需门诊预约",@"全程就医协助",@"泊车服务"];
//    self.detailArray=@[@"专业的医疗团队为您服务",@"帮您解决就医中的特殊问题",@"全程协助您看病以及陪护",@"快速帮您解决停车烦恼"];
    
//    self.imageArray=@[@"normal_reservation",@"special_reservation"];
//    self.titleArray=@[@"普通门诊预约",@"特需门诊预约"];
//    self.detailArray=@[@"专业的医疗团队为您服务",@"帮您解决就医中的特殊问题"];
    
    self.imageArray=@[@"normal_reservation"];
    self.titleArray=@[@"普通门诊预约"];
    self.detailArray=@[@"专业的医疗团队为您服务"];
}

-(void)setupView{
    self.title=@"门诊预约";
    self.view.backgroundColor=UIColorFromRGB(0xf2f2f2);
    
    [self setupTableView];
}

- (void)setupTableView{
    _table=[UITableView new];
    _table.backgroundColor=[UIColor clearColor];
    _table.dataSource=self;
    _table.delegate=self;
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

#pragma mark - 代理

/**
 *  tableView的数据源代理
 *
 *  @param tableView tableView description
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identy=@"cell";
    ServiceTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identy];
    if(!cell){
        cell=[[ServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        
    }
    
    cell.iconName=self.imageArray[indexPath.row];
    cell.title=self.titleArray[indexPath.row];
    cell.detail=self.detailArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:{
            ACMainViewController *vc = [ACMainViewController new];
            vc.mainType = MainTypeBooking;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 1:
        {
            BookingDateViewController *vc = [BookingDateViewController new];
            vc.dateType = BookDateTtypeSpecial;
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        }

        case 2:{
            WholetimeAssisstController *vc = [WholetimeAssisstController new];
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            ParkServiceViewController *vc = [ParkServiceViewController new];
            [self.navigationController pushViewController:vc animated:YES];
          
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString* detail=self.detailArray[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:detail keyPath:@"detail" cellClass:[ServiceTableViewCell class] contentViewWidth:[self cellContentViewWith]];
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





@end
