//
//  SecondMenuView.m
//  LoveBB
//
//  Created by AngelLL on 15/10/22.
//  Copyright © 2015年 Daniel_Li. All rights reserved.
//

#import "JHCustomMenu.h"

#define TopToView 10.0f
#define LeftToView 10.0f
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)

@interface JHCustomMenu()
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat rowHeight;
@end
@implementation JHCustomMenu

- (instancetype)initWithDataArr:(NSArray *)dataArr origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight rowNumber:(NSInteger) number
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.rowHeight = rowHeight;
        self.arrData = [dataArr copy];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, rowHeight * (dataArr.count > number ? number : dataArr.count)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        _tableView.backgroundColor = UIColorFromRGB(0Xefefef);
        [_tableView setSeparatorColor:[UIColor lightGrayColor]];
        if (rowHeight == 30) {
            _tableView.backgroundColor = [UIColor whiteColor];
            [_tableView setSeparatorColor:UIColorFromRGB(0x71CAEE)];
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JHCustomMenu"];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self.tableView setSeparatorInset:CellLineEdgeInsets];   
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.tableView setLayoutMargins:CellLineEdgeInsets];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHCustomMenu"];
    cell.layer.borderWidth = .5;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (self.rowHeight == 30) {
        cell.layer.borderColor = UIColorFromRGB(0x71CAEE).CGColor;
    }
    cell.backgroundColor = UIColorFromRGB(0Xefefef);
    cell.textLabel.textColor = UIColorFromRGB(0x999999);
    if (self.rowHeight == 30) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.arrData[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.currentMenu){
        self.currentMenu = nil;
    }
    self.currentMenu = self.arrData[indexPath.row];
    if([self.delegate respondsToSelector:@selector(jhCustomMenu:didSelectRowAtIndexPath:)]){
        [self.delegate jhCustomMenu:tableView didSelectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithCompletion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:CellLineEdgeInsets];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:CellLineEdgeInsets];
        
    }
    
}

- (void)dismissWithCompletion:(void (^)(JHCustomMenu *object))completion
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
        weakSelf.tableView.frame = CGRectMake(weakSelf.origin.x, weakSelf.origin.y + TopToView, weakSelf.tableView.width, 0);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (completion) {
            completion(weakSelf);
        }
        if (weakSelf.dismiss) {
            weakSelf.dismiss();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self]) {
        [self dismissWithCompletion:nil];
    }
}

- (void)drawRect:(CGRect)rect
{
    
    
}

@end
