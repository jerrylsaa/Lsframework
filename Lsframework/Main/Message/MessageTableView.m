//
//  MessageTableView.m
//  doctors
//
//  Created by 梁继明 on 16/3/29.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "MessageTableView.h"
#import "MessageTableViewCell.h"
#import "FPNetwork.h"

@implementation MessageTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupView{
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.hightForRow = 78.0f;
    
    [super setupView];
    
    _presenter = [MessagePresenter new];
    _presenter.delegate = self;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    WS(ws);
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter refreshMessageData];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreMessageData];
    }];
    [self.myTableView.mj_header beginRefreshing];
    
    
    
  //  [USER_DATA addObserver:self forKeyPath:@"userid" options:NSKeyValueObservingOptionNew context:nil];
  

}

#pragma mark MessagePresnterDelegate

-(void)onChangeMessageStatusComplete:(BOOL)success withPosition:(NSUInteger)position{
    
}

-(void)onRefreshComplete:(BOOL)success{
    [self.myTableView reloadData];
    [self.myTableView.mj_footer resetNoMoreData];
    [self.myTableView.mj_header endRefreshing];
}

-(void)onLoadMessageComplete:(BOOL)success hasMoreData:(BOOL)hasMoreData{
    [self.myTableView reloadData];
    if (hasMoreData) {
        [self.myTableView.mj_footer endRefreshing];
    }else{
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }
}



-(void)dealloc{

  //  [USER_DATA removeObserver:self forKeyPath:@"userid"];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"userid"]) {
        
        self.pageIndex = 1;
        
        [self.myTableView.mj_header beginRefreshing];
        
        
    }
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

     return _presenter.messages.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell configCell:_presenter.messages[indexPath.row]];
    if (indexPath.row == 0) {
        
    }
    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectRowForBlock) {
        
        id model = [_presenter.messages objectAtIndex:indexPath.row];
        
        self.selectRowForBlock(tableView,model,indexPath);
    }



}




@end
