//
//  BaseTableView.h
//  doctors
//
//  Created by 梁继明 on 16/3/29.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UITableViewCell *(^CellForRowWithIndexBlock)(UITableView *tableView,id model,NSIndexPath * indexPath);
typedef void (^DidSelectRowWithIndexBlock)(UITableView *tableView,id model,NSIndexPath * indexPath);

@interface BaseTableView : UIView<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic, strong)UITableView *myTableView;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat hightForRow;

@property (nonatomic,copy) CellForRowWithIndexBlock cellForBlock;

@property (nonatomic,copy) DidSelectRowWithIndexBlock selectRowForBlock;

-(void)setupView;

-(void)requestData;

-(void)setRowBlock:(CellForRowWithIndexBlock)block;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
