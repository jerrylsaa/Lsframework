//
//  SidesSliderView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SidesSliderView.h"
#import "MBSidesSliderCell.h"
#import <UIImageView+WebCache.h>
#import "ApiMacro.h"

@interface SidesSliderView ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    CompletionBlock _completionBlock;
    
    UIView* _tablebgView;
    
    CGFloat _bgViewWidth;
    
    UITableView* _table;
    
    NSInteger _currentBaby;
    
}

@end

@implementation SidesSliderView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [self setupSubviews];

    }
    return self ;
}


- (void)setupSubviews{
    _tablebgView = [[UIView alloc] initWithFrame:CGRectMake(self.width,64,0,self.height-64)];
    _tablebgView.backgroundColor = UIColorFromRGB(0xffffff);
    [self addSubview:_tablebgView];
    
    _table = [[UITableView alloc] initWithFrame:_tablebgView.bounds style:UITableViewStylePlain];
    _table.showsVerticalScrollIndicator = NO;
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tablebgView addSubview:_table];
    
    [_table registerClass:[MBSidesSliderCell class] forCellReuseIdentifier:@"cell"];
    
    UIView* headerView = [UIView new];
    
    UILabel* title = [UILabel new];
    title.text = @"选择宝宝";
    title.textColor = UIColorFromRGB(0x535353);
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
    title.sd_layout.topSpaceToView(headerView,10).autoHeightRatio(0).leftEqualToView(headerView).rightEqualToView(headerView);

    [headerView setupAutoHeightWithBottomView:title bottomMargin:10];
    [headerView layoutSubviews];
    _table.tableHeaderView = headerView;
    
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
    BabayArchList* baby = self.dataSource[indexPath.row];

    MBSidesSliderCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    //赋值
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,baby.childImg]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
    cell.name.text = baby.childName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentBaby = indexPath.row;
    BabayArchList* baby = self.dataSource[indexPath.row];
    NSString* title = [NSString stringWithFormat:@"您确认切换%@为当前宝贝?",baby.childName];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView* headerView = [[UIView alloc] init];
//    
//    UILabel* title = [UILabel new];
//    title.text = @"选择宝宝";
//    title.textColor = UIColorFromRGB(0x535353);
//    title.font = [UIFont systemFontOfSize:16];
//    title.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:title];
//    title.sd_layout.topSpaceToView(headerView,10).autoHeightRatio(0).leftEqualToView(headerView).rightEqualToView(headerView);
//    return headerView;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        _completionBlock(self,_currentBaby);
        [self dismissView];
    }
}



#pragma mark - setter方法

-(void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    
    CGFloat width = 10*2 + itemSize.width;
    _bgViewWidth = width;
    CGRect rect = _tablebgView.frame;
    rect.size.width = width;
    _tablebgView.frame = rect;
    
    CGRect _tableRect = _table.frame;
    _tableRect.size.width = width;
    _table.frame = _tableRect;
    
    _table.rowHeight = itemSize.height + 10*2;
}


#pragma mark - 公共方法

- (void)showSidesSliderView:(CompletionBlock)completionBlock{
    _completionBlock = [completionBlock copy];
    
    CGRect rect = _tablebgView.frame;
    rect.origin.x -= rect.size.width;
    
    [UIView animateWithDuration:.2f animations:^{
        _tablebgView.frame = rect;

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];

    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 私有方法

- (void)dismissView{
//    WS(ws);
    CGRect rect = _tablebgView.frame;
    rect.origin.x += rect.size.width;
    [UIView animateWithDuration:.2f animations:^{
        _tablebgView.frame = rect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
//        _completionBlock(ws);
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    UIView* view = touch.view;
    
    if([view isEqual:_tablebgView]) return ;
    
    
    [self dismissView];
}



@end
