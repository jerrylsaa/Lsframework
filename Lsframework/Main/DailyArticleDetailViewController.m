//
//  DailyArticleDetailViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleDetailViewController.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "PraiseList.h"

#import "DailyArticleDetailTableViewCell.h"
#import "DailyArticleDetailPresenter.h"

#import "PublicPostTextView.h"
#import "JMFoundation.h"


@interface DailyArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DailyArticleDetailPresenterDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CircleTableViewCellDelegate>{


    UIView   *_backView ;
    UIView  *ReplyView;
}

@property(nonatomic,strong)UIImageView  *HeadImageView;
@property(nonatomic,strong)UILabel  *HeadName;
@property(nonatomic,strong)UILabel  *FloorLb;
@property(nonatomic,strong)UILabel  *CommentContent;
@property(nonatomic,strong)UIImageView  *TimeImageView;
@property(nonatomic,strong)UILabel  *TimeLb;


@property(nonatomic,strong)UILabel  *AnswerLb;
@property(nonatomic,strong)UILabel  *AnswerCountLb;


@property(nonatomic,strong)UITableView  *table;

@property(nonatomic,strong)DailyArticleDetailPresenter  *Presenter;

@property(nullable,nonatomic,retain)PublicPostTextView* textView ;
@property(nullable,nonatomic,retain) UIScrollView* scrollView;
@property(nullable,nonatomic,retain) UIButton* sendButton;//发送按钮

@property(nonatomic,strong)UIButton *deletedBtn;
@property(nonatomic,strong)UIButton *smallBtn;

@end


@implementation DailyArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor   whiteColor];
    
    
    self.title = @"评论详情";

}

-(void)setupView{

    self.Presenter = [DailyArticleDetailPresenter new];
    self.Presenter.delegate = self;

    [self.Presenter  getReplyListWithCommentID:_PraiseList.uuid];

    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    self.scrollView = scroll;
    [self.view addSubview:scroll];
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self  setupReplyView];
    
    [self  setupTableView];


}
-(void)setupTableView{


    
    _table = [UITableView  new];
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollEnabled = YES;
    _table.userInteractionEnabled = YES;
    
    
    [_table registerClass:[DailyArticleDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.scrollView  addSubview:_table];
    
    _table.sd_layout.topEqualToView(self.scrollView).leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).bottomSpaceToView(ReplyView,0);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.Presenter getReplyListWithCommentID:_PraiseList.uuid];
    }];
    
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.Presenter getMoreReplyList];
    }];


[self  setupHeadView];
    
}

-(void)setupReplyView{
    
    
    ReplyView = [UIView  new];
    
    ReplyView.backgroundColor = [UIColor  clearColor];
    [self.scrollView  addSubview:ReplyView];
    
    
    PublicPostTextView* textView = [PublicPostTextView new];
    textView.delegate =  self;
    textView.placeholder = @"评论";
    //    textView.textColor = UIColorFromRGB(0xfbffff);
    textView.textColor = [UIColor  blackColor];
    textView.font = [UIFont systemFontOfSize:bigFont];
    textView.placeholderColor = UIColorFromRGB(0xcccccc);
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8;
    textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    //    textView.inputAccessoryView = self.toolBar;
    textView.autoAdjustHeight = YES;
    [ReplyView addSubview:textView];
    self.textView = textView;
    
    
    UIButton* sendbt = [UIButton new];
    sendbt.userInteractionEnabled = NO;
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_NoSendImage"] forState:UIControlStateNormal];
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_SendImage"] forState:UIControlStateSelected];
    sendbt.tag = 103;
    [sendbt addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    //    sendbt.userInteractionEnabled = NO;
    [ReplyView addSubview:sendbt];
    self.sendButton = sendbt;
    
    //添加约束
    ReplyView.sd_layout.bottomSpaceToView(self.scrollView,0).leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).heightIs(50);
    
    sendbt.sd_layout.centerYEqualToView(ReplyView).rightSpaceToView(ReplyView,5).heightIs(76/2).widthIs(100/2);
    
    textView.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(ReplyView,5).rightSpaceToView(sendbt,5).heightIs(sendbt.frame.size.height);
    
    [self.scrollView  setupAutoHeightWithBottomView:ReplyView bottomMargin:0];
    
}

-(void)setupHeadView{

    UIView  *headView  = [UIView new];
    headView.backgroundColor = [UIColor  whiteColor];
    headView.userInteractionEnabled = YES;
    
    UIView  *topView = [UIView  new];
    topView.backgroundColor = [UIColor whiteColor];
    [headView  addSubview:topView];
    
    _HeadImageView = [UIImageView  new];
 
    _HeadImageView.backgroundColor = [UIColor  clearColor];
    [topView  addSubview:_HeadImageView];
    
    
    _HeadName = [UILabel  new];
    _HeadName.backgroundColor = [UIColor  clearColor];
    _HeadName.textColor = UIColorFromRGB(0X333333);
    _HeadName.font = [UIFont  systemFontOfSize:14];
    _HeadName.textAlignment = NSTextAlignmentLeft;
    [topView   addSubview:_HeadName];
    
    
    _FloorLb = [UILabel  new];
    _FloorLb.backgroundColor = [UIColor  clearColor];
    _FloorLb.textColor = UIColorFromRGB(0X999999);
    _FloorLb.font = [UIFont  systemFontOfSize:11];
    _FloorLb.textAlignment = NSTextAlignmentRight;
    [topView   addSubview:_FloorLb];
    
    
    _CommentContent = [UILabel  new];
    _CommentContent.backgroundColor = [UIColor  clearColor];
    _CommentContent.textColor = UIColorFromRGB(0X666666);
    _CommentContent.font = [UIFont  systemFontOfSize:16];
    _CommentContent.textAlignment = NSTextAlignmentLeft;
    _CommentContent.numberOfLines = 0;
    [topView   addSubview:_CommentContent];
    
    
    _deletedBtn = [UIButton new];
    [_deletedBtn addTarget:self action:@selector(deleteContentDailyArticle) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_deletedBtn];
    
    _smallBtn = [UIButton new];
    [_smallBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [_smallBtn addTarget:self action:@selector(deleteContentDailyArticle) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_smallBtn];
    
    
    _TimeImageView = [UIImageView  new];
    _TimeImageView.backgroundColor = [UIColor  clearColor];
    [topView  addSubview:_TimeImageView];
    
    _TimeLb = [UILabel  new];
    _TimeLb.backgroundColor = [UIColor  clearColor];
    _TimeLb.textColor = _FloorLb.textColor;
    _TimeLb.font = [UIFont  systemFontOfSize:11];
    _TimeLb.textAlignment = NSTextAlignmentLeft;
    _TimeLb.numberOfLines = 1;
    [topView   addSubview:_TimeLb];
    
    UILabel  *lineLb = [UILabel  new];
    lineLb.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [headView   addSubview:lineLb];

    
    UIView  *answerView = [UIView  new];
    answerView.backgroundColor = [UIColor  whiteColor];
    [headView  addSubview:answerView];
    _AnswerLb = [UILabel  new];
    _AnswerLb.backgroundColor = [UIColor  clearColor];
    _AnswerLb.textColor = _FloorLb.textColor;
    _AnswerLb.font = [UIFont  systemFontOfSize:15];
    _AnswerLb.textAlignment = NSTextAlignmentLeft;
    _AnswerLb.numberOfLines = 1;
    [answerView   addSubview:_AnswerLb];
    
    _AnswerCountLb = [UILabel  new];
    _AnswerCountLb.backgroundColor = [UIColor  clearColor];
    _AnswerCountLb.textColor = _FloorLb.textColor;
    _AnswerCountLb.font = [UIFont  systemFontOfSize:15];
    _AnswerCountLb.textAlignment = NSTextAlignmentLeft;
    _AnswerCountLb.numberOfLines = 1;
    [answerView   addSubview:_AnswerCountLb];
//    UILabel  *lineLb2 = [UILabel  new];
//    lineLb2.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [answerView   addSubview:lineLb2];


    
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_PraiseList.CHILD_IMG] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    


    _HeadName.text = _PraiseList.NickName;
    
    _CommentContent.text = _PraiseList.CommentContent;
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];
    
    
    NSTimeInterval timeInterval = [_PraiseList.CreateTime doubleValue];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate  dateWithTimeIntervalSince1970:timeInterval];
    NSString*confromTimespStr = [formatter  stringFromDate:confromTimesp];
    
    NSString* myAnswerTime = [NSDate getDateCompare:confromTimespStr];
    _TimeLb.text = myAnswerTime;
    
    _FloorLb.text = [NSString  stringWithFormat:@"%@楼",_PraiseList.RowID];
    
    _AnswerLb.text = @"相关回复";
    

    topView.sd_layout.topSpaceToView(headView,0).leftEqualToView(headView).rightEqualToView(headView);
    
    _HeadImageView.sd_layout.topSpaceToView(topView,30/2).leftSpaceToView(topView,30/2).widthIs(60/2).heightIs(60/2);
      _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
_HeadName.sd_layout.topSpaceToView(topView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
    
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(topView,30/2).heightIs(11).minWidthIs(10);
    [_FloorLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);
    
    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    
    _smallBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).heightIs(15).widthIs(15);
    
    _deletedBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).heightIs(50).widthIs(50);
    
    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(100).heightIs(11);
    
    [topView  setupAutoHeightWithBottomView:_TimeImageView bottomMargin:30/2];
    
    lineLb.sd_layout.topSpaceToView(topView,0).leftEqualToView(headView).rightEqualToView(headView).heightIs(1);
    
    answerView.sd_layout.topSpaceToView(lineLb,0).leftEqualToView(headView).rightEqualToView(headView).heightIs(35);
    
    _AnswerLb.sd_layout.topSpaceToView(answerView,10).leftEqualToView(_HeadImageView).widthIs(70).heightIs(15);
    _AnswerCountLb.sd_layout.topEqualToView(_AnswerLb).leftSpaceToView(_AnswerLb,10).minWidthIs(20).heightIs(15);
      [_AnswerCountLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    

    
    
    [headView  setupAutoHeightWithBottomView:answerView bottomMargin:0];
  
    
        [headView  updateLayout];
        [headView layoutSubviews];
    
    _table.tableHeaderView = headView;
    
    NSInteger userid = [self.PraiseList.UserID integerValue];
    
    NSLog(@"userid is -%ld --2--is %@ commentid is-%@",(long)userid,self.PraiseList.UserID
          ,self.PraiseList.CommentID);
    
    if (userid  == kCurrentUser.userId) {
        
        _deletedBtn.hidden = NO;
        _smallBtn.hidden = NO;
        
    }else
    {
        _deletedBtn.hidden = YES;
        _smallBtn.hidden = YES;
    }

}
#pragma mark----点击发送事件-----
-(void)send{
    
    [_Presenter  insertArticleCommentWithArticleID: _ArticleId CommentID:_PraiseList.uuid UserID:@(kCurrentUser.userId) CommentContent:_textView.text];
    
    
    [self.textView  endEditing:YES];
    self.textView.text = nil;
    self.sendButton.selected = NO;
    self.sendButton.userInteractionEnabled = NO;
    self.textView.placeholder = @"评论";
    [self.textView   resignFirstResponder];
    [self textViewDidChange:_textView];
    

    
}
#pragma mark - 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.Presenter.dataSource) {
        
        return self.Presenter.dataSource.count;
    }else {
        return 0;
    }

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DailyArticleDetailTableViewCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    cell.praiseList = [self.Presenter.dataSource objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return    [_table cellHeightForIndexPath:indexPath model:self.Presenter.dataSource[indexPath.row] keyPath:@"PraiseList" cellClass:[DailyArticleDetailTableViewCell  class] contentViewWidth:[self cellContentViewWith]]; ;
}

#pragma mark----网络请求回调
-(void)GetReplyListCompletion:(BOOL)success info:(NSString*)message{
        _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if(success){
        [_table reloadData];
        _AnswerCountLb.text =[NSString  stringWithFormat:@"%ld条",_Presenter.totalCount];
        [_AnswerCountLb  updateLayout];
    }else{
        
    }
}

-(void)GetMoreReplyListCompletion:(BOOL)success info:(NSString*)message{
    _table.userInteractionEnabled = YES;
    self.Presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    if(success){
        [_table reloadData];
    }else{
        
    }
}


-(void)insertArticleCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showInfo:@"评论成功"];
        [self.Presenter getReplyListWithCommentID:_PraiseList.uuid];;
        [self.view  updateLayout];
        
    }else{
        
        [ProgressUtil showError:message];
        
    }
}
#pragma mark---键盘监听通知---


- (void)textViewDidChange:(UITextView *)textView
{
    
    
    
    NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString=[textView.text stringByTrimmingCharactersInSet:set];
    if (trimedString.length==0) {
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
        
    }else{
        
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
    }
    
    CGFloat height = [JMFoundation calLabelHeight:textView.font andStr:textView.text withWidth:textView.width];
    if (ReplyView.height == 100) {
        if (textView.text.length > 0) {
            return;
        }
    }
    if (height > textView.height) {
        textView.sd_layout.heightIs(textView.height+25);
        ReplyView.sd_layout.heightIs(ReplyView.height+25);
        if (textView.height > 80) {
            textView.height = 80;
            ReplyView.sd_layout.heightIs(100);
        }
    }
    if ([textView.text isEqualToString:@""] || textView.text == nil || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"\n"]) {
        self.textView.placeholder = @"评论";
        textView.sd_layout.heightIs(38);
        ReplyView.sd_layout.heightIs(50);
        
    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.textView resignFirstResponder];
        NSLog(@"tableview滑动");
    }
    
}




#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{



}
#pragma mark-- 删除--
-(void)deleteContentDailyArticle
{
    [_Presenter deleteAallInvitationWithCommentId:_PraiseList.uuid];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.deleteRow(YES);
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
}
-(void)deleButtonWithIndexPath:(UITableViewCell *)indexPath
{
    
    NSIndexPath *index = [_table indexPathForCell:indexPath];
    
    [self tableView:_table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:index];
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PraiseList * praiseList = [self.Presenter.dataSource objectAtIndex:indexPath.row];
    
    NSLog(@"now uuid is- %@",praiseList.uuid);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.Presenter deleteAallInvitationWithCommentId:praiseList.uuid];
        
        [self.Presenter.dataSource removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        self.RefreshRow(YES);
        
        [_table.mj_header beginRefreshing];
        
       [kdefaultCenter postNotificationName:@"refreshDailyAtricleView" object:nil userInfo:nil]; 
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [kdefaultCenter postNotificationName:@"webViewReload" object:nil userInfo:nil];
}
@end
