//
//  BaseTableView.m
//  doctors
//
//  Created by 梁继明 on 16/3/29.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupView];
        
        
    }
    return self;
}


-(void)setupView{
    
    self.pageIndex = 1;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    

    
    MJRefreshHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
       
        
        [weakSelf requestData];

    }];
    
    
    
    MJRefreshBackNormalFooter *refreshFooter =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [weakSelf requestData];

        
    }];
    
    
    self.myTableView.mj_footer = refreshFooter;
    
    self.myTableView.mj_header = header;
    
    self.myTableView.tableFooterView = [UIView new];
    
    
    [self.myTableView.mj_header beginRefreshing];
    
    
}

-(void)requestData{

    
}






-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.hightForRow;
}
#pragma mark -- 返回UITableView的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark -- 返回每一个cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"click u");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectRowForBlock) {
        
        id model = [self.dataArray objectAtIndex:indexPath.row];
        
        self.selectRowForBlock(tableView,model,indexPath);
    }
    

}






#pragma mark - lazy load

-(NSMutableArray *)dataArray{
    
    if (!_dataArray ) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
}


-(UITableView *)myTableView{
    
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
         
        [self addSubview:_myTableView];
        
        _myTableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_myTableView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myTableView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_myTableView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myTableView)]];
        
    }
    
    return _myTableView;
    
}




@end
