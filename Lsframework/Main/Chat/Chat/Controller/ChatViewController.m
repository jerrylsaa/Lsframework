//
//  ChatViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatPresenter.h"
#import "ChatCell.h"
#import "ChatSingalCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIImage+Category.h"
#import "MoreCardView.h"
#import "JMFoundation.h"
#import "EmotionTextAttachment.h"
//系统消息进入相应页面
#import "HotDetailConsulationViewController.h"      //问题详情
#import "HotDetailConsulationInfoViewController.h"  //问题评论回复
#import "PublicPostDetailViewController.h"   //帖子详情
#import "CommentDetailViewController.h"     //帖子评论回复
#import "AwaitAnswerViewController.h"  //医生待回答页面
#import "DailyArticleViewController.h" //每日必读详情页

#import "TodayRecommend.h"
#import "MyAnserEntity.h"

#import "AppDelegate.h"

#define kAddInputViewHeight (448 / 2.0)
#define kFaceInputViewHeight (264 - 40)
#define kScrollViewHeight (270/2.0)

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MoreCardDelegate,ChatPresenterDelegate,CellImageDelegate>{
    
    NSNumber  *uuid;
    
}


@property (nonatomic, strong) ChatPresenter *presenter;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) BOOL isEmoji;
@property (nonatomic, assign) BOOL isKeyboard;

@property (nonatomic, strong) MoreCardView *moreView;
@property (nonatomic, strong) UIView *faceInputView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isEmotion;
@property (nonatomic) NSInteger emotionColumn;//表情列数
@property (nonatomic) NSInteger emotionRow;//表情行数
@property(nullable,nonatomic,retain) NSMutableArray<NSDictionary*>* defaultEmotionArray;//表情数据源

@property (nonatomic, strong) NSMutableArray *dataCache;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, strong) NSMutableDictionary *heightDic;//记录图片cell的高度

@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshGeTuiChatList) name:Notification_RefreshPushChartList object:nil];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.chatType == ChatTypeSingal) {
        WS(ws);
        _appDelegate.saveTitle = ws.nickName;
       
    }else if(self.chatType == ChatTypeConversation){
     
        _appDelegate.saveTitle = _conversation.NickName;
      
    }else if (self.chatType == ChatTypePush){
     
        _appDelegate.saveTitle = _nickName;
    }

   
     NSLog(@"11111%@",_appDelegate.saveTitle);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RefreshGeTuiChatList{
    WS(ws);
    [ws.dataCache removeAllObjects];
    NSLog(@"重新刷新消息页面");
    if (ws.chatType == ChatTypeSingal) {
        NSLog(@"消息头像进入%ld",ws.presenter.dialodID);
        [ws.presenter refreshDetailList:ws.presenter.dialodID];
        
    }else if(ws.chatType == ChatTypeConversation){
        NSLog(@"消息上个页面进入%@",ws.conversation.RowID);
        [ws.presenter refreshDetailList:[ws.conversation.RowID integerValue]];
    }else if (self.chatType == ChatTypePush){
        NSLog(@"消息推送进入%@",_RowID);
        [self.presenter refreshDetailList:[_RowID integerValue]];
        
    }

}

- (void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.emotionColumn = 6;
    self.emotionRow = 3;
    _dataCache = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _presenter = [ChatPresenter new];
    _presenter.delegate = self;
    if (self.chatType == ChatTypeSingal) {
        WS(ws);
        ws.title = ws.nickName;
        [_presenter GetDialogInfo:_ReceiveUserID complete:^(BOOL success, NSString *message) {
            [ws setupScrollView];
            [ws setupTextView];
            [ws setupTableView];
        }];
    }else if(self.chatType == ChatTypeConversation){
         self.title = _conversation.NickName;
            [self setupScrollView];
            [self setupTextView];
            [self setupTableView];
    }else if (self.chatType == ChatTypePush){
        self.title = _nickName;
//        [_presenter GetDialogInfo:_ReceiveUserID complete:^(BOOL success, NSString *message) {
            [self setupScrollView];
            [self setupTextView];
            [self setupTableView];
//        }];
        
    }
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupTableView{
    _chatTableView = [UITableView new];
    _chatTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    [_chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollView addSubview:_chatTableView];
    if([self.title  isEqualToString:@"系统消息"]){
        _chatTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //可用全局变量累加消息

    }else{
      _chatTableView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_editView,0);
        
    }
    
    
    WS(ws);
    _chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (ws.chatType == ChatTypeSingal) {
            [ws.presenter loadMoreDetailList:ws.presenter.dialodID];
            
        }else  if(ws.chatType == ChatTypeConversation){
            [ws.presenter loadMoreDetailList:[ws.conversation.RowID integerValue]];
           
        }else  if(self.chatType == ChatTypePush){
        [self.presenter loadMoreDetailList:[_RowID integerValue]];
        }

    }];
    [_chatTableView.mj_header beginRefreshing];
}
- (void)setupTextView{
    _editView = [UIView new];
    _editView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_editView];
    
    _editView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).bottomSpaceToView(_scrollView,0).heightIs(45);
    
    _moreButton = [UIButton new];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateNormal];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"circle_add_heigh"] forState:UIControlStateHighlighted];
    [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
//    [_editView addSubview:_moreButton];
//    _moreButton.sd_layout.leftSpaceToView(_editView,5).bottomSpaceToView(_editView,9).widthIs(27).heightIs(27);
//    _moreButton.sd_cornerRadius = @13.5;
    
    _emojiButton = [UIButton new];
    [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
    [_emojiButton addTarget:self action:@selector(emojiAction) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:_emojiButton];
    _emojiButton.sd_layout.leftSpaceToView(_editView,5).bottomSpaceToView(_editView,9).widthIs(27).heightIs(27);
    _emojiButton.sd_cornerRadius = @13.5;
    
    
    _textView = [UITextView new];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.layer.borderWidth = 1;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    _textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    [_editView addSubview:_textView];
    _textView.sd_layout.leftSpaceToView(_emojiButton,5).topSpaceToView(_editView,5).bottomSpaceToView(_editView,5).rightSpaceToView(_editView,60);
    _textView.sd_cornerRadius = @5;
    
    _sendButton = [UIButton new];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:_sendButton];
    _sendButton.sd_layout.leftSpaceToView(_textView,10).rightSpaceToView(_editView,10).topEqualToView(_emojiButton).heightRatioToView(_emojiButton,1);
    _sendButton.sd_cornerRadius = @5;
    
    [_scrollView setupAutoContentSizeWithBottomView:_editView bottomMargin:0];
    if([self.title  isEqualToString:@"系统消息"]){
        
        _editView.hidden = YES;
    }else{
        _editView.hidden = NO;
        
    }

    }

- (void)setupMoreCardView{
    _moreView = [[MoreCardView alloc] init];
    _moreView.frame = CGRectMake(0, 0, kScreenWidth, 224);
    _moreView.delegate = self;
    _moreView.backgroundColor = UIColorFromRGB(0xffffff);
    _textView.inputView = nil;
    _textView.inputView = _moreView;
    [_textView becomeFirstResponder];
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatEntity *chat = self.dataSource[indexPath.row];
    //单行cell，不包含图片
    if ([self checkForImage:chat] == NO && [self getWidthByText:chat.Content] < kScreenWidth - 120) {
        ChatSingalCell *cell;
        //发送者
        if ([chat.SendUserID isEqual:@(kCurrentUser.userId)]) {
            static NSString *identifier1 = @"cell_chatSend_default_singal";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell) {
                cell = [[ChatSingalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            cell.talkType = TalkTypeSend;
            cell.displayType = DisplayTypeDefault;
        }else{//接收者
            static NSString *identifier2 = @"cell_chatRecive_default_singal";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell) {
                cell = [[ChatSingalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            }
            cell.talkType = TalkTypeRecive;
            cell.displayType = DisplayTypeDefault;
        }
        cell.isTime = YES;//[self checkTimeForCellByIndexPath:indexPath];
        cell.chat = chat;
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        //正常多行cell和图片类型
    }else{
        ChatCell *cell;
        //发送者
        if ([chat.SendUserID isEqual:@(kCurrentUser.userId)]) {
            //默认类型
            if ([self checkForImage:chat] == NO) {
                static NSString *identifier1 = @"cell_chatSend_default";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if (!cell) {
                    cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
                }
                cell.talkType = TalkTypeSend;
                cell.displayType = DisplayTypeDefault;
            }else{//图片类型
                static NSString *identifier1 = @"cell_chatSend_image";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if (!cell) {
                    cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
                }
                cell.talkType = TalkTypeSend;
                cell.displayType = DisplayTypeImage;
                cell.image = [UIImage imageNamed:@"chat_default"];
                if ([_heightDic objectForKey:indexPath]) {
                    cell.image = [_heightDic objectForKey:indexPath];
                }
            }
        }else{
            //接收者
            //默认类型
            if ([self checkForImage:chat] == NO) {
                static NSString *identifier2 = @"cell_chatRecive_default";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if (!cell) {
                    cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
                }
                cell.talkType = TalkTypeRecive;
                cell.displayType = DisplayTypeDefault;
            }else{ //图片类型
                static NSString *identifier2 = @"cell_chatRecive_image";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if (!cell) {
                    cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
                }
                cell.talkType = TalkTypeRecive;
                cell.displayType = DisplayTypeImage;
                cell.image = [UIImage imageNamed:@"chat_default"];
                if ([_heightDic objectForKey:indexPath]) {
                    cell.image = [_heightDic objectForKey:indexPath];
                }
            }
        }
        cell.chat = chat;
        cell.isTime = YES;//[self checkTimeForCellByIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self checkForImage:_dataSource[indexPath.row]] == YES) {
        if ([_heightDic objectForKey:indexPath]) {
            UIImage *image = [_heightDic objectForKey:indexPath];
            CGFloat width = image.size.width;
            CGFloat scole = image.size.width/image.size.height;
            if (width > kScreenWidth - 120) {
                width = kScreenWidth-120;
            }
            return width/scole+40;
        }
        return 60+20;
    }
    return [_chatTableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.row] keyPath:@"chat" cellClass:[ChatCell class]  contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.chatTableView]) {
            [_textView resignFirstResponder];
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.isMore = NO;
    self.isEmoji = NO;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{   
    CGFloat height = [JMFoundation calLabelHeight:textView.font andStr:textView.text withWidth:textView.width];
    if (_editView.height == 90) {
        if (textView.text.length > 0) {
            return;
        }
    }
        if (height > textView.height) {
            textView.sd_layout.heightIs(textView.height+25);
            _editView.sd_layout.heightIs(_editView.height+25);
            if (textView.height > 80) {
                textView.height = 80;
                _editView.sd_layout.heightIs(90);
            }
        }
    if ([textView.text isEqualToString:@""] || textView.text == nil || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"\n"]) {
        textView.text = @"";
//        if (textView.text.length == 0){
            textView.sd_layout.heightIs(35);
            _editView.sd_layout.heightIs(45);
//        }
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //移除相机相册选项卡和表情选项卡
    if (_isMore == NO && _isEmoji == NO) {
        if (_moreView) {
            [_moreView removeFromSuperview];
        }
        if (_faceInputView) {
            [_faceInputView removeFromSuperview];
        }
    }
    return YES;
}
#pragma mark ChatPresenterDelegate
- (void)loadComplete:(BOOL)success message:(NSString *)message{
    
    //正序插入后倒序排列
    if (success == YES) {
        [self.dataCache addObjectsFromArray:self.presenter.dataSource];
        if (self.presenter.dataSource.count > 0) {
            [_heightDic removeAllObjects];
            self.dataSource = [self sortArray:self.dataCache];
            //计算总高度
            self.totalHeight = 0;
            [self totalHeightOfCells];
            [self.chatTableView reloadData];
            if (self.dataSource.count <= 10) {
                //滚动到最底下
                if (_totalHeight > kScreenHeight - 45 - 64) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
                    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
            }
            [self heightForImageCell:self.dataSource];
        }
        [self.chatTableView.mj_header endRefreshing];
    }else{
        [ProgressUtil showError:message];
    }
}


#pragma mark MoreCardDelegate
- (void)selectImage:(UIViewController *)vc{
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (void)didSelectImage:(NSArray *)imageArray{
    NSLog(@"返回图片相关数据数组");
    [self dismissViewControllerAnimated:YES completion:nil];
    [ProgressUtil show];
    WS(ws);
    [_presenter upload:imageArray.firstObject complete:^(BOOL success, NSString *message) {
        [ProgressUtil dismiss];
        if (success == YES) {
            [ws send:[NSString stringWithFormat:@"%@%@",ICON_URL,message]];
        }else{
            [ProgressUtil showError:@"发送图片失败"];
        }
    }];
}

#pragma mark action
- (void)sendAction{
    [self send:_textView.text];
}
- (void)moreAction{
    _isMore = YES;
    _isEmoji = NO;
    //创建相机相册选项卡
    [self setupMoreCardView];
}
- (void)emojiAction{
    if (_isEmoji == NO) {
        _isEmoji = YES;
        [self setIsKeyboard:NO];
        _textView.inputView = nil;
        _textView.inputView = self.faceInputView;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }else{
        _isEmoji = NO;
        [self setIsKeyboard:YES];
//        self.faceInputView = nil;
        _textView.inputView = nil;
        [_textView reloadInputViews];
    }
    
}
#pragma mark 监听键盘动作
- (void)keyboardWillChangeFrameNotification:(NSNotification *)note{
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY;
    if (keyboardFrame.origin.y == kScreenHeight) {
        transformY = 0;
        _isMore = NO;
//        _isEmoji = NO;
//        [self setIsKeyboard:YES];
    }else{
        transformY = keyboardFrame.size.height;
    }
    //执行动画
    WS(ws);
    [UIView animateWithDuration:duration animations:^{
        ws.chatTableView.sd_layout.topSpaceToView(_scrollView,transformY);
    } completion:^(BOOL finished) {
        //滚动到最底下
        if (ws.totalHeight > kScreenHeight - keyboardFrame.size.height - ws.editView.height) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ws.dataSource.count-1 inSection:0];
            [ws.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        //收起键盘
        if (transformY == 0) {
            ws.textView.inputView = nil;
            ws.faceInputView = nil;
            ws.isEmoji = NO;
            [ws setIsKeyboard:YES];
        }
    }];
}

- (void)cancelCellForIndexPath:(NSIndexPath *)indexPath{
    //删除单条内容
    ChatEntity *chat = self.dataSource[indexPath.row];
    WS(ws);
    [ProgressUtil show];
    [_presenter cancelContent:[chat.uuid integerValue] complete:^(BOOL success, NSString *message) {
        if (success == YES) {
            [ProgressUtil dismiss];
            [ws.dataCache removeAllObjects];
            [ws.presenter refreshDetailList:[chat.DialogID integerValue]];
        }else{
            [ProgressUtil showError:@"删除失败"];
        }
    }];
}
- (void)enterCellForIndexPath:(NSIndexPath *)indexPath{
    if ([self.title  isEqualToString:@"系统消息"]) {
    ChatEntity *chat = self.dataSource[indexPath.row];
        NSString   *userString = chat.Params;
        NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([chat.Type  isEqualToString:@"10"]||[chat.Type  isEqualToString:@"8"]||[chat.Type  isEqualToString:@"9"]) {
            
            
        }else{
            
            uuid = [dic  objectForKey:@"UUID"];
            
        }

        NSLog(@"uuid:%@-----类型%@",uuid,chat.Type);

        if ([chat.Type  isEqualToString:@"0"]||[chat.Type  isEqualToString:@"2"]||[chat.Type  isEqualToString:@"3"]) {
            //问题咨询被评论、旁听问题、点赞
            HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController new];
            vc.UUID = uuid;
            [self.navigationController  pushViewController:vc animated:YES];

        }else if ([chat.Type  isEqualToString:@"1"]){
            //问题评论被回复
        HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
            vc.commentID = uuid;
            [self.navigationController  pushViewController:vc animated:YES];

        
        }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
            //帖子被评论、点赞
            PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
            vc.UUID = uuid;
            [self.navigationController  pushViewController:vc animated:YES];

            
        }else if ([chat.Type  isEqualToString:@"7"]){
            //帖子评论被回复
            CommentDetailViewController  *vc = [CommentDetailViewController new];
            vc.commentID = uuid;
            [self.navigationController  pushViewController:vc animated:YES];

            
        }else if ([chat.Type  isEqualToString:@"-1"]){
            //-1正式服务器Bug
            
        }else if ([chat.Type  isEqualToString:@"8"]||[chat.Type  isEqualToString:@"9"]){
            //医生待回答页面
            AwaitAnswerViewController  *vc = [AwaitAnswerViewController new];
            /**
             *
             uuid
             answerType
             Expert_ID
             consultationContent
             Image1
             Image2、
             Image3
             createTime
             hearCount
             imageUrl
             TraceID
             doctorName
             {"UUID":"1","answerType":"1","Expert_ID":"1","consultationContent":"888","Image1":"1","Image2":"1","Image3":"1","createTime":"2016/10/19 16:10:56","hearCount":"0","imageUrl":"http://121.42.15.43:9020/MobileHtml/images/zhaodongmei.jpg","doctorName":"赵冬梅","TraceID":"1"}
             
             */
            
            vc.MyAnswerEntity = [MyAnserEntity mj_objectWithKeyValues:dic];
            NSLog(@"系统消息进入医生待回答：uuid%@-----专家id%d----追问id%d-----回答类型%d-----咨询内容%@-----图片1%@-----图片2%@-----图片3%@-----时间：%@-----听过次数%d-----头像url%@-----医生名字%@",vc.MyAnswerEntity.uuid,vc.MyAnswerEntity.Expert_ID,vc.MyAnswerEntity.TraceID,vc.MyAnswerEntity.answerType,vc.MyAnswerEntity.consultationContent,vc.MyAnswerEntity.Image1,vc.MyAnswerEntity.Image2,vc.MyAnswerEntity.Image3,vc.MyAnswerEntity.createTime,vc.MyAnswerEntity.hearCount,vc.MyAnswerEntity.imageUrl,vc.MyAnswerEntity.doctorName);
            

            [self.navigationController pushViewController:vc animated:YES];
            
        }else  if ([chat.Type  isEqualToString:@"10"]){
            //每日必读详情页
            DailyArticleViewController  *vc = [DailyArticleViewController new];
            /**    DATA = "{\"ID\":\"39\",\"Title\":\"世界早产日活动\",\"Url\":\"http://www.zhongkang365.com/MobileHtml/everyday/childgm161110.html\",\"Photo\":\"http://tigerhuang007.xicp.io/MobileHtml/everyday/images/pic16926.png\",\"PraiseCount\":4,\"badgeID\":1624.0}";
             TYPE = 10;
             
             */
            vc.TodayRecommend = [TodayRecommend mj_objectWithKeyValues:dic];
            NSLog(@"每日必读带导航栏推送：---%@-----%@-----%@-----%@-----%@",vc.TodayRecommend.ID,vc.TodayRecommend.Title,vc.TodayRecommend.Url,vc.TodayRecommend.Photo,vc.TodayRecommend.PraiseCount);
            [self.navigationController pushViewController:vc animated:YES];
    

        }
        


    }
}
- (void)setIsKeyboard:(BOOL)isKeyboard{
    if (isKeyboard == YES) {
        [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
        [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
//        if (_faceInputView) {
//            [_faceInputView removeFromSuperview];
//        }
//        if (_moreView) {
//            [_moreView removeFromSuperview];
//        }
    }else{
        [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
        [_emojiButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
//        if (_moreView) {
//            [_moreView removeFromSuperview];
//        }
    }
}

#pragma mark private
- (void)send:(NSString *)text{
    if (text == nil || [text isEqualToString:@""] || [[text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"\n"]) {
        [ProgressUtil showInfo:@"请输入有效内容"];
        return;
    }
    WS(ws);
    NSInteger reciverID;
    if (self.chatType == ChatTypeSingal) {
        reciverID = self.ReceiveUserID;
    }else if(self.chatType == ChatTypeConversation){
        if ([self.conversation.ReceiveUserID integerValue] == kCurrentUser.userId) {
            reciverID = [self.conversation.SendUserID integerValue];
        }else{
            reciverID = [self.conversation.ReceiveUserID integerValue];
        }
    }else if(self.chatType == ChatTypePush){
        if (_ReceiveUserID  == kCurrentUser.userId) {
            reciverID = _SendUserID;
        }else{
            reciverID = _ReceiveUserID;
        }
    }
    
    //转换
    NSMutableString* mutableStr  = [NSMutableString string];
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        EmotionTextAttachment* attach = attrs[@"NSAttachment"];
        if(attach){
            //表情
            [mutableStr appendString:attach.emotionTag];
        }else{
            //拼接文本
            NSAttributedString* temp = [self.textView.attributedText attributedSubstringFromRange:range];
            [mutableStr appendString:temp.string];
        }
    }];
    
    [_presenter insertChatWithContent:mutableStr reciverID:reciverID complete:^(BOOL success, NSString *message) {
        if (success == YES) {
            ws.textView.text = @"";
            [ws textViewDidChange:ws.textView];
            //刷新
            [ws.dataCache removeAllObjects];
            if (ws.chatType == ChatTypeSingal) {
                [ws.presenter refreshDetailList:ws.presenter.dialodID];
                
            }else if(ws.chatType == ChatTypeConversation){
                [ws.presenter refreshDetailList:[ws.conversation.RowID integerValue]];
            }else if (self.chatType == ChatTypePush){
            
            [self.presenter refreshDetailList:[_RowID integerValue]];
            
            }
        
        }else{
            [ProgressUtil showError:message];
        }
    }];
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
//拿到键盘
- (UIView *)findKeyboard{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator]){
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView){
            return keyboardView;
        }
    }
    return nil;
}
- (UIView *)findKeyboardInView:(UIView *)view{
    for (UIView *subView in [view subviews]){
        if (strstr(object_getClassName(subView), "UIKeyboard")){
            return subView;
        }else{
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView){
                return tempView;
            }
        }
    }
    return nil;
}
//排列数组
- (NSArray *)sortArray:(NSArray *)array{
    NSMutableArray *sortArray = [NSMutableArray array];
    for (ChatEntity *entity in array) {
        [sortArray insertObject:entity atIndex:0];
    }
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    [mArray sortUsingComparator:^NSComparisonResult(ChatEntity *entity1, ChatEntity *entity2)
    {
        if ([entity1.CreateDate integerValue] > [entity2.CreateDate integerValue])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    //增加根据数组计算单个cell高度，计算完成后刷新tableview，保存对应cell高度，return时取出高度使用，数组数量增加时，高度dic需要相应调整indexPath，避免重新计算已有高度
    
    return mArray;
}
//计算总高度
- (void)totalHeightOfCells{
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ChatEntity *chat = self.dataSource[i];
        _totalHeight += [_chatTableView cellHeightForIndexPath:indexPath model:chat keyPath:@"chat" cellClass:[ChatCell class]  contentViewWidth:[self cellContentViewWith]];
    }
}
//检验cell是否是图片类型
- (BOOL)checkForImage:(ChatEntity *)entity{
    NSString *text = entity.Content;
    
    if ([text rangeOfString:ICON_URL].location != NSNotFound ) {
        //尾部验证
        NSString *footer = [text substringFromIndex:text.length - 4];
        if ([footer isEqualToString:@".png"] || [footer isEqualToString:@".jpg"]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark 计算每个cell高度，图片加载完成后刷新
- (void)heightForImageCell:(NSArray *)array{
    //首次加载直接写入，后续加载根据数据数量判断更新indexPath
    //refresh的时候清空
    if (_heightDic.count > 0) {
        if (_presenter.dataSource.count > 0) {
            for (NSIndexPath *indexPath in _heightDic.allKeys) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+_presenter.dataSource.count) inSection:0];
                [_heightDic setObject:[_heightDic objectForKey:indexPath] forKey:newIndexPath];
                [_heightDic removeObjectForKey:indexPath];
            }
        }
    }
    //是否已存在，已存在的只需在加载时读取即可，不存在的继续写入
    WS(ws);
    for (int i = 0; i < array.count; i ++) {
        ChatEntity *chat = array[i];
        if ([self checkForImage:chat] == YES) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            if (![_heightDic.allKeys containsObject:indexPath]) {
                //获取图片，异步刷新
                UIImageView *imageView = [UIImageView new];
                NSString *path = chat.Content;
                [imageView sd_setImageWithURL:[NSURL URLWithString:path]placeholderImage:[UIImage imageNamed:@"chat_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [_heightDic setObject:imageView.image forKey:indexPath];
                    CGFloat width = image.size.width;
                    CGFloat scole = image.size.width/image.size.height;
                    if (width > kScreenWidth - 120) {
                        width = kScreenWidth-120;
                    }

                    ws.totalHeight += (width/scole - 80);
                    
                    [ws.chatTableView reloadData];
                    //滚动到最底下
                    if (ws.presenter.pageIndex == 1) {
                        if (ws.totalHeight > kScreenHeight - _editView.height) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
                            [ws.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                        }
                    }
                }];
            }
        }
    }
}
//计算当前cell需不需要展示时间
- (BOOL)checkTimeForCellByIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return YES;
    }else{
        ChatEntity *chatPre = _dataSource[indexPath.row - 1];
        ChatEntity *chatNow = _dataSource[indexPath.row];
        long preTime = [chatPre.CreateDate longLongValue];
        long nowTime = [chatNow.CreateDate longLongValue];
        if (nowTime - preTime > 3000) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)dealloc{
    [kdefaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [kdefaultCenter removeObserver:self name:Notification_RefreshPushChartList object:nil];
    [_moreView removeFromSuperview];
    [_faceInputView removeFromSuperview];
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
}

#pragma mark 表情相关

-(UIView *)faceInputView{
    if(!_faceInputView){
        _faceInputView = [UIView new];
        _faceInputView.height = 224;
        _faceInputView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIScrollView* faceScrollView = [UIScrollView new];
        faceScrollView.showsHorizontalScrollIndicator = NO;
        faceScrollView.pagingEnabled = YES;
        faceScrollView.delegate = self;
        faceScrollView.backgroundColor = UIColorFromRGB(0xfafafa);
//                self.faceScrollView = faceScrollView;
        [_faceInputView addSubview:faceScrollView];
        
        UIPageControl* pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = RGB(232, 208, 217);
        pageControl.currentPageIndicatorTintColor = RGB(248, 187, 208);
        self.pageControl = pageControl;
        [_faceInputView addSubview:pageControl];
        
        UIButton* deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_face_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteFaceAction) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:deleteButton];
        
        //
        UIButton* emojybt = [UIButton new];
        [emojybt setImage:[UIImage imageNamed:@"Hotemoij_default"] forState:UIControlStateNormal];
        emojybt.tag = 301;
        [emojybt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emojybt];
        
        UIButton* emotionbt = [UIButton new];
        [emotionbt setImage:[UIImage imageNamed:@"Hotemoij_selec"] forState:UIControlStateNormal];
        emotionbt.tag = 302;
        [emotionbt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emotionbt];
        
        if(_isEmotion){
            emotionbt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emojybt.backgroundColor = UIColorFromRGB(0xffffff);
        }else{
            emojybt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emotionbt.backgroundColor = UIColorFromRGB(0xffffff);
        }
        
        
        CGFloat width = 33;
        CGFloat height = 33;
        CGFloat horizontalMargin = (kScreenWidth - self.emotionColumn * width) / (self.emotionColumn + 1);
        CGFloat verticalMargin = (kScrollViewHeight - self.emotionRow * height) / (self.emotionRow + 1);
        
        NSInteger pageTotal = (self.emotionColumn * self.emotionRow);//当前页表情总个数
        
        NSInteger page = self.defaultEmotionArray.count / pageTotal;
        if(self.defaultEmotionArray.count % pageTotal ){
            page ++ ;
        }
                NSLog(@"====%ld",self.defaultEmotionArray.count);
        faceScrollView.contentSize = CGSizeMake(kScreenWidth * page, kScrollViewHeight);
        pageControl.numberOfPages = page;
        
        NSInteger currentPage = 0;
        for(int i = 0; i < self.defaultEmotionArray.count; i++){
            if(i % pageTotal == 0 ){
                //整数
                currentPage = i / pageTotal;
            }
            NSInteger j = (i - currentPage * pageTotal);
            CGFloat x = currentPage * kScreenWidth + horizontalMargin + (width + horizontalMargin) * (j % self.emotionColumn);
            
            //            NSLog(@"---%g",x);
            
            CGFloat y = verticalMargin + (height + verticalMargin) * (j / self.emotionColumn);
            //            NSLog(@"---%ld",self.defaultEmotionArray.count);
            UIButton* emotion = [UIButton new];
            emotion.frame = CGRectMake(x, y, width, height);
            //            emotion.backgroundColor = [UIColor redColor];
            NSDictionary* emotionDic = [self.defaultEmotionArray objectAtIndex:i];
            [emotion setBackgroundImage:[UIImage imageNamed:[emotionDic valueForKey:@"png"]] forState:UIControlStateNormal];
            
            emotion.tag = 200 + i;
            [emotion addTarget:self action:@selector(clickEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [faceScrollView addSubview:emotion];
        }
        
        
        
        faceScrollView.sd_layout.topSpaceToView(_faceInputView,0).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(kScrollViewHeight);
        pageControl.sd_layout.topSpaceToView(faceScrollView,20).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(8);
        deleteButton.sd_layout.rightSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        emojybt.sd_layout.leftSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);
        emotionbt.sd_layout.leftSpaceToView(emojybt,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);
        
    }
    return _faceInputView;
}

#pragma mark * 删除emojy表情
- (void)deleteFaceAction{
    [self.textView deleteBackward];
}
#pragma mark * 切换表情
- (void)convertEmotionAction:(UIButton*) bt{
    UIButton* emojyButton = (UIButton*)[self.faceInputView viewWithTag:301];
    UIButton* emotionButton = (UIButton*)[self.faceInputView viewWithTag:302];
    
    if(self.textView.inputView){
        self.textView.inputView = nil;
        self.faceInputView = nil;
    }
    [self.defaultEmotionArray removeAllObjects];
    self.defaultEmotionArray = nil;
    
    if([bt isEqual:emojyButton]){
        //emojy表情
        _isEmotion = NO;
        
    }else if([bt isEqual:emotionButton]){
        //自定义表情
        _isEmotion = YES;
        
    }
    self.textView.inputView = self.faceInputView;
    [self.textView reloadInputViews];
}

#pragma mark * 点击emojy表情
- (void)clickEmotionAction:(UIButton*) emotionbt{
    NSInteger index = emotionbt.tag - 200;
    NSDictionary* emotionDic = self.defaultEmotionArray[index];
    
    //获取之前写的文本
    NSAttributedString* str = self.textView.attributedText;
    //将之前的文本包含进去
    NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    //记录当前光标的位置
    NSInteger currentPosition;
    EmotionTextAttachment* attach = [EmotionTextAttachment new];
    attach.bounds = CGRectMake(0, -2.5, self.textView.font.lineHeight - 5, self.textView.font.lineHeight - 5);
    attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
    attach.emotionTag = [emotionDic valueForKey:@"tag"];
    NSAttributedString* attr = [NSAttributedString attributedStringWithAttachment:attach];
    //保存一下当前光标位置
    currentPosition = self.textView.selectedRange.location;
    [mutableStr insertAttributedString:attr atIndex:currentPosition];
    
    //重写给文本框赋值
    [mutableStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, mutableStr.length)];
    self.textView.attributedText = mutableStr;
    self.textView.selectedRange = NSMakeRange(currentPosition + 1, 0);
    
}
-(NSMutableArray *)defaultEmotionArray{
    if(!_defaultEmotionArray){
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        NSMutableArray* tempArray = [NSMutableArray array];
        if(_isEmotion){
            //移除emojy表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if(![dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }
            
        }else{
            //移除自定义表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if([dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }
            
        }
        
        [_defaultEmotionArray removeObjectsInArray:tempArray];
    }
    return _defaultEmotionArray;
}
- (CGFloat)getWidthByText:(NSString *)text{
    NSArray *leftArray = [text componentsSeparatedByString:@"["];
    NSArray *rightArray = [text componentsSeparatedByString:@"]"];
    NSInteger count = leftArray.count > rightArray.count ? rightArray.count : leftArray.count;
    CGFloat width;
    //表情数目
    if (count != 0) {
        
        width = [JMFoundation calLabelWidth:[UIFont systemFontOfSize:14] andStr:text withHeight:20];
        width = width + count*-15;
        return width;
    }
    
    return width = [JMFoundation calLabelWidth:[UIFont systemFontOfSize:14] andStr:text withHeight:20];
}

#pragma mark - 代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x / kScreenWidth == (int)(scrollView.contentOffset.x / kScreenWidth)){
        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
[kdefaultCenter removeObserver:self name:Notification_RefreshPushChartList object:nil];
    
    _appDelegate.saveTitle= nil;
    
[kdefaultCenter postNotificationName:@"SegmentChatListTypeRefresh" object:nil userInfo:nil];

}

@end
