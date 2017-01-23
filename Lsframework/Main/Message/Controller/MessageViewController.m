//
//  MessageViewController.m
//  PublicHealth
//
//  Created by xuwenqi on 16/3/14.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "MessageViewController.h"
#import "MessagePresenter.h"
#import "MessageTableViewCell.h"
#import "MessageTableView.h"
#import "HMSegmentedControl.h"
#import "JMChatViewController.h"
#import "MessageEntity.h"

@interface MessageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HMSegmentedControl *segmentedConstrol;

@property (nonatomic,strong) UIView *contentView;





@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Test Git
}

- (void)setupView{
    self.title = @"消息";
    [self initBackBarWithImage:nil];
    
    [self setupTableView];

}



-(void)setupTableView{
    

    
    MessageTableView *tmpView2  = [self makeupTableViewWithType:MSG_UN_READ];
    
    tmpView2.type = MSG_UN_READ;
    
    MessageTableView *tmpView3  = [self makeupTableViewWithType:MSG_ALL];
    
    tmpView3.type = MSG_ALL;
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[tmpView2(width)]-(0)-[tmpView3(width)]-(0)-|" options:0 metrics:@{@"width":@(kScreenWidth)} views:NSDictionaryOfVariableBindings(self.contentView,tmpView2,tmpView3)]];
    
    
    
}

-(MessageTableView *)makeupTableViewWithType:(MSG_TYPE)type{
    
    MessageTableView *tableView = [[MessageTableView alloc] initWithFrame:CGRectZero];
    
    tableView.type = type;
    
    [self.contentView addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    
    
    
    tableView.selectRowForBlock = ^(UITableView *tableView,id model,NSIndexPath * indexPath){
       
        MessageEntity * tmpModel = (MessageEntity *)model;
        
        JMChatViewController *conv = [[JMChatViewController alloc] init];
        
        /*
        conv.model = tmpModel;
        
        conv.strName = tmpModel.Name;
        
        conv.sexStr = tmpModel.sex;
        
        conv.age = tmpModel.age;
        
        conv.contentStr = tmpModel.content;
        
        conv.targetId = [NSString stringWithFormat:@"%zi",tmpModel.LoginId];
        
        conv.conversationType = ConversationType_PRIVATE;
        
        conv.type = CHAT_MSG;*/
        
        
        [weakSelf.navigationController pushViewController:conv animated:YES];
        
    };
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[tableView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.contentView,tableView)]];
    
    return tableView;
    
    
    
    
    
}



#pragma mark---scrollView的两个代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    // [self.itemControlView moveToIndex:offset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    
    // [self.itemControlView endMoveToIndex:offset];
    
    
    [self.segmentedConstrol setSelectedSegmentIndex:offset animated:YES];
    
}

#pragma mark---umeng页面统计

-(void)viewWillAppear:(BOOL)animated{
   [MobClick beginLogPageView:@"消息"];
    [self.rdv_tabBarController setTabBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

-(HMSegmentedControl *)segmentedConstrol{
    
    if (!_segmentedConstrol) {
        
        _segmentedConstrol = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"未读",@"全部"]];
        
        _segmentedConstrol.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        
        [self.view addSubview:_segmentedConstrol];
        
       // _segmentedConstrol.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:COLOR_666666};
        
     //   _segmentedConstrol.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:COLOR_52CCD6};
        
        _segmentedConstrol.selectionIndicatorHeight = 3.0;
        
        
        //_segmentedConstrol.selectionIndicatorColor = COLOR_52CCD6;
        
        _segmentedConstrol.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentedConstrol.borderWidth = 3;
       // _segmentedConstrol.borderColor = COLOR_CCCCCC;
        
        __weak typeof(self) weakSelf = self;
        
        [_segmentedConstrol setIndexChangeBlock:^(NSInteger index) {
            
            
            [weakSelf.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
            
            
            
            
        }];
        
        _segmentedConstrol.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        _segmentedConstrol.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_segmentedConstrol]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_segmentedConstrol)]];
        
        
        
    }
    
    return _segmentedConstrol;
    
    
}



-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView= [[UIScrollView alloc]initWithFrame:CGRectZero];
        
        [self.view addSubview:_scrollView];
        
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_scrollView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_scrollView)]];
        
        UIView *tmpView =self.segmentedConstrol;
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[tmpView(45)]-(0)-[_scrollView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,tmpView,_scrollView)]];
        
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
    
}

-(UIView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.scrollView addSubview:_contentView];
        
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_contentView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.scrollView,_contentView)]];
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_contentView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.scrollView,_contentView)]];
        
        
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_contentView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.scrollView,_contentView)]];
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_contentView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.scrollView,_contentView)]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute  multiplier:1.0 constant:kScreenWidth * 2]];
        
    }
    
    return _contentView;
    
    
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
