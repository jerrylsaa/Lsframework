//
//  DailyArticleViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleViewController.h"
#import "PraiseTableViewCell.h"
#import "PraisePresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "PraiseList.h"
#import "DailyArticleDetailViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "PublicPostTextView.h"
#import "JMFoundation.h"
#import <JavaScriptCore/JavaScriptCore.h>



@interface DailyArticleViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,PraisePresenterDelegate,UITextViewDelegate,UIScrollViewDelegate>{

    UIView  *_topView;
    UIView  *_PraiseTitleView;
    NSInteger  AnswerIndex;
    NSInteger  SendIndex;
    NSInteger  Praisecount;
    BOOL   isPraise;
    UIView  *ReplyView;

    UIView  *_headerView;

    
}

@property(nonatomic,strong)UIWebView  *ArticleWebView;
@property(nonatomic,strong)UIButton  *PraiseCountBtn;


@property(nonatomic,strong)UILabel  *PraiseTitle;
@property(nonatomic,strong)UILabel  *PraiseTitleCountLb;
@property(nonatomic,strong)UITableView  *PraiseTableView;
@property(nonatomic,strong)PraisePresenter  *Presenter;
@property(nonatomic,strong)UIButton  *starButton;
@property(nullable,nonatomic,retain)PublicPostTextView* textView ;
@property(nullable,nonatomic,retain) UIScrollView* scrollView;
@property(nullable,nonatomic,retain) UIButton* sendButton;//发送按钮
@property(nonatomic,strong)UIImageView  *shareImageView;


@end

@implementation DailyArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日推荐";
    self.view.backgroundColor = [UIColor  whiteColor];
    
   [self initRightBarWithTitle:@"分享"];
//    self.DailyFirstArticle.ID = self.DailyUUID;
//    NSLog(@"每日必读页面uuid%@----%@",self.DailyFirstArticle.ID,self.DailyUUID);
    
    _shareImageView = [UIImageView  new];
    [_shareImageView  setImageWithUrl:self.TodayRecommend.Photo placeholderImage:nil];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshDailyAtricelView) name:@"refreshDailyAtricleView" object:nil];
    
     [kdefaultCenter addObserver:self selector:@selector(webViewReload) name:@"webViewReload" object:nil];
    
}

-(void)setupView{

    self.Presenter = [PraisePresenter new];
    self.Presenter.delegate = self;
    [self.Presenter getPraiseListWithArticleID:_TodayRecommend.ID];
    [self.Presenter  getArticlePraiseByArticleID:_TodayRecommend.ID];
    

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

    
    _PraiseTableView = [UITableView  new];
    _PraiseTableView.delegate = self;
    _PraiseTableView.dataSource = self;
    _PraiseTableView.scrollEnabled = YES;
    _PraiseTableView.userInteractionEnabled = YES;
    [_PraiseTableView registerClass:[PraiseTableViewCell class] forCellReuseIdentifier:@"cell"];
    _PraiseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView  addSubview:_PraiseTableView];
    
    _PraiseTableView.sd_layout.topEqualToView(_scrollView).leftEqualToView(_scrollView).rightEqualToView(_scrollView).bottomSpaceToView(ReplyView,0);
    
    
    
    
    
    
    
    
    WS(ws);
    _PraiseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.PraiseTableView.userInteractionEnabled = NO;
        [ws.Presenter getPraiseListWithArticleID:_TodayRecommend.ID];
    }];
    
    _PraiseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.PraiseTableView.userInteractionEnabled = NO;
        [ws.Presenter getMorePraiseList];
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
    [sendbt addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
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
     _headerView =[UIView new];
    _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _topView = [UIView  new];
    _topView.backgroundColor = [UIColor  whiteColor];
    [_headerView  addSubview:_topView];
    

    
    _ArticleWebView = [UIWebView  new];
    _ArticleWebView.scalesPageToFit =YES;
    _ArticleWebView.scrollView.scrollEnabled = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_TodayRecommend.Url]];
    _ArticleWebView.delegate = self;
    [_ArticleWebView loadRequest:request];
    [_topView addSubview:_ArticleWebView];
    
    
    _PraiseCountBtn = [UIButton  new];
    _PraiseCountBtn.backgroundColor = [UIColor  clearColor];
    
    [_PraiseCountBtn  setTitle:[NSString  stringWithFormat:@"%@",_TodayRecommend.PraiseCount] forState:UIControlStateNormal];
    [_PraiseCountBtn  addTarget:self action:@selector(PraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_PraiseCountBtn  setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _PraiseCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_PraiseCountBtn  setTitleEdgeInsets:UIEdgeInsetsMake(30, -65, 0, 0)];

    [_topView  addSubview:_PraiseCountBtn];
    
    
    
    
    _PraiseTitleView = [UIView   new];
    _PraiseTitleView.backgroundColor =  [UIColor  whiteColor];
    [_headerView  addSubview:_PraiseTitleView];
    
    _PraiseTitle = [UILabel  new];
    _PraiseTitle.text = @"评论";
    _PraiseTitle.font = [UIFont  systemFontOfSize:14];
    _PraiseTitle.textColor = UIColorFromRGB(0x999999);
    _PraiseTitle.textAlignment = NSTextAlignmentLeft;
    [_PraiseTitleView  addSubview:_PraiseTitle];
    
    _PraiseTitleCountLb = [UILabel  new];

    _PraiseTitleCountLb.font = [UIFont  systemFontOfSize:14];
    _PraiseTitleCountLb.textColor = UIColorFromRGB(0x999999);
    _PraiseTitleCountLb.textAlignment = NSTextAlignmentLeft;
    [_PraiseTitleView  addSubview:_PraiseTitleCountLb];
    
    
    
    
    
    
    
    
    //头部
    _topView.sd_layout.topSpaceToView(_headerView,0).leftEqualToView(_headerView).rightEqualToView(_headerView);
    
    _ArticleWebView.sd_layout.topSpaceToView(_topView,0).leftEqualToView(_topView).rightEqualToView(_topView).heightIs(480);
    
    
    _PraiseCountBtn.sd_layout.topSpaceToView(_ArticleWebView,80/2).centerXEqualToView(_topView).widthIs(kFitWidthScale(150)).heightIs(kFitHeightScale(150));
    
    
    [_topView  setupAutoHeightWithBottomView:_PraiseCountBtn bottomMargin:80/2];
    
    
    //标题
    _PraiseTitleView.sd_layout.topSpaceToView(_topView,10/2).leftEqualToView(_headerView).rightEqualToView(_headerView).heightIs(24);
    
    _PraiseTitle.sd_layout.topSpaceToView(_PraiseTitleView,10).leftSpaceToView(_PraiseTitleView,30/2).widthIs(30).heightIs(14);
    
    _PraiseTitleCountLb.sd_layout.topEqualToView(_PraiseTitle).leftSpaceToView(_PraiseTitle,15).widthIs(100).heightIs(14);
    
    
    
    [_headerView setupAutoHeightWithBottomView:_PraiseTitleView bottomMargin:0];
    
    
    [_headerView  updateLayout];
    [_PraiseTableView  updateLayout];
    [_headerView layoutSubviews];

    
    _PraiseTableView.tableHeaderView = _headerView;

    

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
    
    PraiseTableViewCell* cell = [_PraiseTableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.praiseList = [self.Presenter.dataSource objectAtIndex:indexPath.row];
    cell.AnswerBtn.tag = indexPath.row+1 ;
    [cell.AnswerBtn   addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside ];
    
    //回复内容
    if (  [[self.Presenter.dataSource objectAtIndex:indexPath.row].CommentID  isEqualToNumber:@(0)]  ) {
    }else{
        
        NSInteger  AnserPath=0;
        for (int  i = 0; i<self.Presenter.dataSource.count; i++) {
            if ([self.Presenter.dataSource[i].uuid isEqualToNumber: [self.Presenter.dataSource objectAtIndex:indexPath.row].CommentID]) {
                AnserPath=i;
                break;
            }else{
            
            }
        }
    PraiseList *model =  [self.Presenter.dataSource objectAtIndex:AnserPath];
    cell.AnswerName.text = model.NickName;
        
    cell.AnswerfloorLb.text = [NSString  stringWithFormat:@"%@楼",model.RowID];
        [cell.AnswerName  updateLayout];
        [cell.AnswerfloorLb  updateLayout];
    cell.AnswerComment.text = model.CommentContent;
    }
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _PraiseTableView;
    
    
    return cell;
}

#pragma mark----点击事件

-(void)PraiseBtn:(UIButton*)btn{
   
    if (isPraise) {
            Praisecount = Praisecount -1 ;
            if ([[NSString  stringWithFormat:@"%ld",Praisecount]  isEqualToString:@"0"]) {
                
                [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_NoOne"] forState:UIControlStateNormal];
                
            }else{
                
                [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_NOSELECT"] forState:UIControlStateNormal];
            }
            [_PraiseCountBtn  setTitle:[NSString  stringWithFormat:@"%ld",Praisecount] forState:
             UIControlStateNormal];


    [_Presenter  CancelArticlePraiseByArticleID:_TodayRecommend.ID];
        isPraise = NO;
    }else{
    //点赞

        Praisecount = Praisecount + 1;
        
        [_Presenter  InsertArticlePraiseByArticleID:_TodayRecommend.ID];
    
    [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_SELECT"] forState:UIControlStateNormal];
    [_PraiseCountBtn  setTitle:[NSString  stringWithFormat:@"%d",Praisecount] forState:
         UIControlStateNormal];

    isPraise = YES;
    
        
    }
}

-(void)answer:(UIButton*)btn{
    if(btn!=self.starButton){
        self.starButton.selected=NO;
        self.starButton=btn;
    }
    self.starButton.selected=YES;
    if (btn.selected == YES) {
        AnswerIndex = btn.tag;
    }
_textView.placeholder = [NSString  stringWithFormat:@"回复%ld楼",(long)AnswerIndex];
    if (!_textView.isFirstResponder) {
        [_textView  becomeFirstResponder];
    }
    
    
}

-(void)send:(UIButton*)btn{
    NSLog(@"字数：%@",_textView.text);
      NSLog(@"index1:%ld",(long)AnswerIndex);
    SendIndex = AnswerIndex;
      NSLog(@"index2:%ld",(long)SendIndex);
    if (SendIndex == 0) {
        [_Presenter  insertArticleCommentWithArticleID:_TodayRecommend.ID CommentID:@(0) UserID:@(kCurrentUser.userId) CommentContent:_textView.text];


    }else{
        
PraiseList  *model = [self.Presenter.dataSource objectAtIndex:SendIndex-1];
       
        
        NSNumber *commentid;
        commentid = model.uuid;
        if ([model.CommentID integerValue] == 0) {
            commentid = model.uuid;
        }else{
            commentid = model.CommentID;
        }
        
        
 [_Presenter  insertArticleCommentWithArticleID:_TodayRecommend.ID CommentID:commentid UserID:@(kCurrentUser.userId) CommentContent:_textView.text];
  
    }
    [self.textView  endEditing:YES];
    self.textView.text = nil;
    self.sendButton.selected = NO;
    self.sendButton.userInteractionEnabled = NO;
    self.textView.placeholder = @"评论";
    [self.textView   resignFirstResponder];
    [self textViewDidChange:_textView];
    AnswerIndex = 0 ;
    
    
}
#pragma mark----tableView的代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (_textView.isFirstResponder) {
        
        [self.view endEditing:YES];
        self.textView.text = nil;
        _textView.placeholder = @"评论";
        
        [ _textView resignFirstResponder];//直接取消输入框的第一响应  ]
        

    }else{
    DailyArticleDetailViewController  *vc = [DailyArticleDetailViewController  new];
        if ([[self.Presenter.dataSource objectAtIndex:indexPath.row].CommentID isEqualToNumber:@(0)]) {
            
            PraiseList  *model = [self.Presenter.dataSource objectAtIndex:indexPath.row];
            vc.PraiseList =model;
            [self.navigationController  pushViewController:vc animated:YES];
            
        }else{
            
            NSInteger currentIndex;
            for (int i= 0; i<self.Presenter.dataSource.count; i++) {
                if ([self.Presenter.dataSource[i].uuid isEqualToNumber:[self.Presenter.dataSource objectAtIndex:indexPath.row].CommentID]) {
                    currentIndex = i;
                    break;
                }
            }
           
            PraiseList  *model = [self.Presenter.dataSource objectAtIndex:currentIndex];
            vc.PraiseList =model;
            [self.navigationController  pushViewController:vc animated:YES];
        }
        
   
        vc.ArticleId = _TodayRecommend.ID;
        vc.deleteRow = ^(BOOL isCurrentRow){
            if (isCurrentRow == YES) {
                
                if (indexPath.row <= 10) {
                    
                [self.Presenter.dataSource removeObjectAtIndex:indexPath.row];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.Presenter getPraiseListWithArticleID:_TodayRecommend.ID];
                
                [tableView reloadData];
                  
                }
            }
            
        };
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    return    [_PraiseTableView cellHeightForIndexPath:indexPath model:self.Presenter.dataSource[indexPath.row] keyPath:@"PraiseList" cellClass:[PraiseTableViewCell  class] contentViewWidth:[self cellContentViewWith]]; ;
}

#pragma mark----网络请求回调
-(void)GetPraiseListCompletion:(BOOL)success info:(NSString *)messsage{
    _PraiseTableView.userInteractionEnabled = YES;
    [_PraiseTableView.mj_footer resetNoMoreData];
    [_PraiseTableView.mj_header endRefreshing];

    
    if(success){
        [_PraiseTableView reloadData];
        
    _PraiseTitleCountLb.text = [NSString  stringWithFormat:@"%d",_Presenter.totalCount];
        [_PraiseTitleCountLb  updateLayout];
    }else{
        
    }
}

-(void)GetMorePraiseListCompletion:(BOOL)success info:(NSString *)message{
    
    _PraiseTableView.userInteractionEnabled = YES;
    
 self.Presenter.noMoreData? [_PraiseTableView.mj_footer endRefreshingWithNoMoreData]: [_PraiseTableView.mj_footer endRefreshing];
    
    if(success){
        
        [_PraiseTableView reloadData];
        
    }else{
        [ProgressUtil showError:message];
    }
    

}
-(void)insertArticleCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        NSLog(@"inde3:%d",SendIndex);
    if (SendIndex == 0) {
        
      [ProgressUtil showInfo:@"评论成功"];
    }else{
    
    [ProgressUtil showInfo:@"回复成功"];
    
        
    }
    [_Presenter  getPraiseListWithArticleID:_TodayRecommend.ID];
//    [_PraiseTableView  reloadData];
    }else{
    
      [ProgressUtil showError:message];
    
    }
}

//获取文章是否点赞
-(void)GetArticlePraiseCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
      
       Praisecount = [_TodayRecommend.PraiseCount integerValue];
if ([[NSString  stringWithFormat:@"%@",_TodayRecommend.PraiseCount]  isEqualToString:@"0"]) {
            
            [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_NoOne"] forState:UIControlStateNormal];
  }
else{
    if (_Presenter.ispraise) {
    [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_SELECT"] forState:UIControlStateNormal];
        isPraise = YES;
            
    }
     else{
      
    [_PraiseCountBtn  setImage:[UIImage  imageNamed:@"DailyPrise_NOSELECT"] forState:UIControlStateNormal];
       isPraise = NO;
    }
}
  
        }

}
//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
       [ProgressUtil showSuccess:@"点赞成功"];
        
        //发送通知，刷新每日必读更多列表
        [kdefaultCenter postNotificationName:Notification_RefreshDailyArticleMore object:nil userInfo:nil];
        //发送通知，刷新首页每日必读点赞数量
        [kdefaultCenter postNotificationName:Notification_Refresh_DailyArticlePraiseCount object:nil userInfo:nil];
    }else{
    
        [ProgressUtil  showError:message];
    }



}

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
         [ProgressUtil showSuccess:@"取消点赞成功"];
        //发送通知，刷新每日必读更多列表
        [kdefaultCenter postNotificationName:Notification_RefreshDailyArticleMore object:nil userInfo:nil];
        //发送通知，刷新首页每日必读点赞数量
        [kdefaultCenter postNotificationName:Notification_Refresh_DailyArticlePraiseCount object:nil userInfo:nil];
    }else{
        
        [ProgressUtil  showError:message];
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
#pragma mark----webView相关
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressUtil show];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
//    CGRect frame = webView.frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    webView.frame = frame;
//   
//    NSLog(@"web高度:%f",webView.frame.size.height);
//    _ArticleWebView.sd_layout.topSpaceToView(_topView,0).leftEqualToView(_topView).rightEqualToView(_topView).heightIs(webView.frame.size.height);
//    [_topView updateLayout];
//    [_headerView updateLayout];
//    [_PraiseCountBtn  updateLayout];
////    [_headerView  layoutSubviews];
//    [_PraiseTableView setTableHeaderView:_headerView];
//    
//    [_PraiseTableView  updateLayout];
    
    
  [ProgressUtil  dismiss];
    
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    _ArticleWebView.sd_layout.heightIs(webViewHeight);
    
    [_ArticleWebView updateLayout];
    [_topView updateLayout];
    
    [_PraiseTitle updateLayout];
    [_PraiseTitleView updateLayout];
    
    [_headerView updateLayout];
    

     _ArticleWebView.hidden = NO;
    [_PraiseTableView setTableHeaderView:_headerView];



}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [ProgressUtil dismiss];
    [ProgressUtil showError:error.localizedDescription];
}

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

-(void)dealloc{
    

    

}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.textView resignFirstResponder];
        NSLog(@"tableview滑动");
    
    }
    
}
//拖动结束触发此方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
NSLog(@"高度5\n%f",scrollView.contentOffset.y);

    
        //得到当前页面的JSContext，如果不在这里获得当前网页的context可能有问题
        JSContext *js = [_ArticleWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //设置 js 代码中的method对象为控制器
        js[@"method"] = self;
    
        //在OC中执行js并取得js返回的数据
        //方式1 使用JSContext的对象方法执行JS脚本
        NSString *jsScript = @"document.title";     //获取网页标题
        //evaluateScript方法返回的是JSValue类型的对象，需要将类型转换为OC对象
//        NSString *title = [js evaluateScript:jsScript].toString;
//        self.navigationItem.title = title;
//        NSLog(@"evaluateScript --->  %@",title);
    
        //方式2 使用webView的对象方法执行js，该方法返回的数据类型始终是NSString，不管JS实际传递过来的是什么类型，
        //如JS传递过来的是10 那么该方法的返回值任然是字符串
         CGFloat  y = scrollView.contentOffset.y;
      NSString *myString2 = [NSString stringWithFormat:@"setScrollTop(%f)",y];
    
    
    [_ArticleWebView stringByEvaluatingJavaScriptFromString:myString2];

}
//滑动结束出发此方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    NSLog(@"高度6\n%f",scrollView.contentOffset.y);
    
    
    //得到当前页面的JSContext，如果不在这里获得当前网页的context可能有问题
    JSContext *js = [_ArticleWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //设置 js 代码中的method对象为控制器
    js[@"method"] = self;
    
    //在OC中执行js并取得js返回的数据
    //方式1 使用JSContext的对象方法执行JS脚本
//    NSString *jsScript = @"document.title";     //获取网页标题
//    //evaluateScript方法返回的是JSValue类型的对象，需要将类型转换为OC对象
//    NSString *title = [js evaluateScript:jsScript].toString;
//    self.navigationItem.title = title;
//    NSLog(@"evaluateScript --->  %@",title);
    
    //方式2 使用webView的对象方法执行js，该方法返回的数据类型始终是NSString，不管JS实际传递过来的是什么类型，
    //如JS传递过来的是10 那么该方法的返回值任然是字符串
    CGFloat  y = scrollView.contentOffset.y;
    NSString *myString2 = [NSString stringWithFormat:@"setScrollTop(%f)",y];
    
    
    [_ArticleWebView stringByEvaluatingJavaScriptFromString:myString2];

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark  *分享
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    if ([_textView  isFirstResponder]) {
        
        [_textView  resignFirstResponder];
    }
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr = _TodayRecommend.Url;
    if (imageArray) {
//        NSString *text = [NSString stringWithFormat:@"掌上儿保——免费测评、查看报告、权威专家、语音解答%@",urlStr];
        NSString  *title =_TodayRecommend.Title;
        NSString *text = [NSString stringWithFormat:@"%@ %@",_TodayRecommend.Title,urlStr];
//         NSString *text = [NSString stringWithFormat:@"%@",_TodayRecommend.Title];
        if (title.length>=124) {
            title = [title  substringToIndex:124];
        }
//        _shareImageView = [UIImageView  new];
//     [_shareImageView  setImageWithUrl:self.TodayRecommend.Photo placeholderImage:nil];
        
        
        NSData * imageData = UIImageJPEGRepresentation(_shareImageView.image,1);
        NSLog(@"压缩前%@",_shareImageView.image);
        NSLog(@"压缩前data:%lu",[imageData length]/1000);
        
        UIImage  *shareimage =  [JMFoundation  imageCompressForSize:_shareImageView.image targetSize:CGSizeMake(120, 180)];
        NSLog(@"压缩后%@",shareimage);
        NSData * imageData1 = UIImageJPEGRepresentation(shareimage,1);
        NSLog(@"压缩后data:%lu",[imageData1 length]/1000);

        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:text               images:shareimage
                                            url:[NSURL URLWithString:urlStr]
                                          title:title                                           type:SSDKContentTypeAuto];
        
        NSLog(@"text--is-- %@\n image--is %@\n title--is-- %@\n url--is-- %@",text,_shareImageView.image,title,urlStr);
        NSLog(@"Photo1 --is--%@",self.TodayRecommend.Photo);
        NSLog(@"tupian:%@",_shareImageView);
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _ArticleWebView.hidden = YES;

   

}
#pragma mark-- 通知回调刷新当前页--
-(void)refreshDailyAtricelView
{
    [self.Presenter getPraiseListWithArticleID:_TodayRecommend.ID];
    
    [_PraiseTableView reloadData];
}
-(void)webViewReload
{
    _ArticleWebView.hidden = NO;
    
}
@end
