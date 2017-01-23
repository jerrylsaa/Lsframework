//
//  PublicPostDetailViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PublicPostDetailViewController.h"
#import "LCChatToolBarView.h"
#import "CorePhotoPickerVCManager.h"
#import "ApiMacro.h"
#import "PublicPostDetailPresenter.h"
#import "CircleCommentCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "JMFoundation.h"
//#import "CommentHeaderCell.h"
#import "CommentDetailViewController.h"
#import "SFPhotoBrowser.h"
#import "TabbarViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-2*kImageXspace)/3

@interface PublicPostDetailViewController ()<LCChatToolBarViewDelegate,UITableViewDelegate,UITableViewDataSource,PublicPostDetailPresenterDelegate,PhotoBrowerDelegate,CircleTableViewCellDelegate>{
    
    UIView* headView;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    
    UILabel* postTitle;
    UILabel* consultation;
    
    UIView* photoWallBgView;
    UIImageView* photo1;
    UIImageView* photo2;
    UIImageView* photo3;
    
    UIImageView* leftPhoto1;
    UIImageView* midelPhoto2;
    UIImageView* rightPhoto3;
    
    UIView* bottomBgView;
    UILabel* timeLabel;
    UIView* grayBarView;
    UILabel* commentLabel;
    
    
    UIButton *deleteBtn;
    UIButton *smallBtn;

}

@property(nullable,nonatomic,strong)UIButton  *praiseButton;
@property(nullable,nonatomic,strong)UILabel *praiseLabel;

@property(nullable,nonatomic,retain) UIScrollView* scroll;
@property(nullable,nonatomic,retain) LCChatToolBarView* toolBarView;//聊天工具条
@property(nullable,nonatomic,retain) UITableView* table;

@property(nullable,nonatomic,retain) PublicPostDetailPresenter* presenter;
@property(nullable,nonatomic,retain) NSMutableArray* photoWallDataSource;
@property(nullable,nonatomic,retain) NSMutableArray<NSString* >* photoWallURL;

@property (nullable,nonatomic, strong) NSNumber *isPraise;
@property (nullable,nonatomic, strong) NSNumber *praiseCount;
@property (nonatomic, assign) NSInteger rowID;

@end

@implementation PublicPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshConsulationList) name:@"refreshPopViewnew" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"帖子详情";
    //    [self.table.mj_header beginRefreshing];
    [self initRightBarWithTitle:@"分享"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark * 加载视图
-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self setupTableView];
    [self setupToobarView];

}
- (void)setupTableView{
    
     
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scroll addSubview:table];
    self.table = table;
    table.sd_layout.topSpaceToView(self.scroll,0).leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,50);
    
//    [table registerClass:[CommentHeaderCell class] forCellReuseIdentifier:@"header"];
    [table registerClass:[CircleCommentCell class] forCellReuseIdentifier:@"cell"];
    [ProgressUtil  show];
    table.hidden = YES;
    WS(ws);
    //下拉刷新
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter getPostCommentListByCommentID:[_UUID  integerValue]];
    }];
    [table.mj_header beginRefreshing];
    //上拉加载
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter getMorePostCommentListCommentID:[_UUID  integerValue]];
    }];
    
    [self setupHeadView];

}
- (void)setupHeadView{
  
    headView  = [UIView new];
    headView.backgroundColor = [UIColor  whiteColor];
    
    //宝贝头像
    babyImageView = [UIImageView new];
    [headView addSubview:babyImageView];
    //baby昵称
    babyNickName = [UILabel new];
    babyNickName.textColor = UIColorFromRGB(0x333333);
    babyNickName.font = [UIFont systemFontOfSize:midFont];
    babyNickName.backgroundColor = [UIColor clearColor];
    [headView addSubview:babyNickName];
    
    //删除button
    deleteBtn = [UIButton new];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn addTarget:self action:@selector(deleteBtnInvation) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:deleteBtn];
    
    smallBtn = [UIButton new];
    smallBtn.backgroundColor  = [UIColor clearColor];
    [smallBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [smallBtn addTarget:self action:@selector(deleteBtnInvation) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:smallBtn];
    
    //帖子标题
    postTitle = [UILabel new];
    postTitle.textColor = UIColorFromRGB(0x333333);
    postTitle.font = [UIFont systemFontOfSize:bigFont];
    postTitle.isAttributedContent = YES;
    postTitle.numberOfLines = 0;
    postTitle.backgroundColor = [UIColor clearColor];
    [headView addSubview:postTitle];
    //咨询内容
    consultation = [UILabel new];
    consultation.textColor = UIColorFromRGB(0x666666);
    consultation.font = [UIFont systemFontOfSize:sbigFont];
    consultation.isAttributedContent = YES;
    consultation.numberOfLines = 0;
    consultation.backgroundColor = [UIColor clearColor];
    [headView addSubview:consultation];

    
    //照片墙
    photoWallBgView = [UIView new];
    [headView addSubview:photoWallBgView];
    photo1 = [self imageVIiewWithTag:211];
    photo2 = [self imageVIiewWithTag:212];
    photo3 = [self imageVIiewWithTag:213];
    leftPhoto1 = [self imageVIiewWithTag:214];
    midelPhoto2 = [self imageVIiewWithTag:215];
    rightPhoto3 = [self imageVIiewWithTag:216];
    [photoWallBgView sd_addSubviews:@[photo1,photo2,photo3,leftPhoto1,midelPhoto2,rightPhoto3]];
    
    
    
    //底部
    bottomBgView = [UIView new];
    bottomBgView.backgroundColor = [UIColor  clearColor];
    [headView  addSubview:bottomBgView];
    //时间
    timeLabel = [UILabel new];
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:11];
    [bottomBgView  addSubview:timeLabel];
    //赞
    _praiseLabel = [UILabel new];
    _praiseLabel.font = timeLabel.font;
    _praiseLabel.userInteractionEnabled = YES;
    _praiseLabel.textColor = timeLabel.textColor;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.text = [NSString stringWithFormat:@"%@",_circleEntity.praiseCount];
    [bottomBgView  addSubview:_praiseLabel];
    _praiseButton = [UIButton new];
    if ([_isPraise integerValue] == 1) {
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
    }else{
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
    }

    [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *praiseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseTapAction)];
    [_praiseLabel addGestureRecognizer:praiseTap];
    [bottomBgView  addSubview:_praiseButton];
    
    //底部灰色条
    grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
     [bottomBgView  addSubview:grayBarView];
    //评论
    commentLabel = [UILabel new];
    commentLabel.textColor = timeLabel.textColor;
    commentLabel.font = [UIFont systemFontOfSize:midFont];
     [bottomBgView  addSubview:commentLabel];
    
    
    
    
    //baby头像
    [babyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.childImg]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    
    //baby昵称
    babyNickName.text = _circleEntity.nickName;
//    帖子标题
    postTitle.attributedText = [UILabel getAttributeTextWithString:_circleEntity.title];


    //咨询内容
    consultation.attributedText = [UILabel getAttributeTextWithString:_circleEntity.consultationContent];
    

    //赞
    if ([_isPraise integerValue] == 1) {
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
    }else{
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
    }
    //评论
    commentLabel.text = (_circleEntity.commentCount)? [NSString stringWithFormat:@"评论 %@",_circleEntity.commentCount]: @"0";
    _praiseLabel.text = [NSString stringWithFormat:@"%@",_praiseCount];
    

    timeLabel.text = _circleEntity.createTime;
    //添加约束
    
   


    
    
    babyImageView.sd_layout.topSpaceToView(headView,15).leftSpaceToView(headView,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(headView,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];

    deleteBtn.sd_layout.centerYEqualToView(babyImageView).rightSpaceToView(headView,13).heightIs(50).widthIs(50);
    smallBtn.sd_layout.centerYEqualToView(babyImageView).rightSpaceToView(headView,13).heightIs(30).widthIs(30);
    
    postTitle.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).widthIs(kScreenWidth-15*2).heightIs(40);

    consultation.sd_layout.topSpaceToView(postTitle,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-15*2).autoHeightRatio(0);
    
    
//    照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photoWallBgView updateLayout];
    [leftPhoto1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [midelPhoto2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [rightPhoto3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photoWallBgView updateLayout];
    
    
    photo1.hidden = !(self.circleEntity.image1 && self.circleEntity.image1.length > 10);
    photo2.hidden = !(self.circleEntity.image2 && self.circleEntity.image2.length > 10);
    photo3.hidden = !(self.circleEntity.image3 && self.circleEntity.image3.length > 10);
    leftPhoto1.hidden = !(self.circleEntity.image4 && self.circleEntity.image4.length > 10);
    midelPhoto2.hidden = !(self.circleEntity.image5 && self.circleEntity.image5.length > 10);
    rightPhoto3.hidden = !(self.circleEntity.image6 && self.circleEntity.image6.length > 10);
    
    
    [photo1 sd_resetLayout];
    [photo2 sd_resetLayout];
    [photo3 sd_resetLayout];
    [leftPhoto1 sd_resetLayout];
    [midelPhoto2 sd_resetLayout];
    [rightPhoto3 sd_resetLayout];
    

    if(photo1.hidden && photo2.hidden && photo3.hidden && leftPhoto1.hidden && midelPhoto2.hidden && rightPhoto3.hidden){
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(0).heightIs(0);
        
    }else if (leftPhoto1.hidden == YES) {
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
    }else{
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth*2+kImageTopspace);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
        leftPhoto1.sd_layout.topSpaceToView(photo1,kImageTopspace).leftEqualToView(photo1).widthRatioToView(photo1,1).heightEqualToWidth();
        leftPhoto1.sd_cornerRadius = @5;
        midelPhoto2.sd_layout.topEqualToView(leftPhoto1).leftEqualToView(photo2).widthRatioToView(photo2,1).heightEqualToWidth();
        midelPhoto2.sd_cornerRadius = @5;
        rightPhoto3.sd_layout.topEqualToView(leftPhoto1).leftEqualToView(photo3).widthRatioToView(photo3,1).heightEqualToWidth();
        rightPhoto3.sd_cornerRadius = @5;
    }
    
    
    
    if (photoWallBgView.height == 0) {
        bottomBgView.sd_layout.topSpaceToView(consultation,15).leftSpaceToView(headView,0).rightSpaceToView(headView,0);
        
    }else if (photoWallBgView.height == kImageWidth){
        
        bottomBgView.sd_layout.topSpaceToView(consultation,15+kImageWidth).leftSpaceToView(headView,0).rightSpaceToView(headView,0);
        
    }else{
        
        bottomBgView.sd_layout.topSpaceToView(consultation,15+kImageWidth*2+kImageTopspace).leftSpaceToView(headView,0).rightSpaceToView(headView,0);
    }

    //创建时间
    timeLabel.sd_layout.topSpaceToView(bottomBgView,0).leftSpaceToView(bottomBgView,15).heightIs(10).widthIs(kJMWidth(timeLabel));
//    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //赞
    _praiseLabel.sd_layout.rightSpaceToView(bottomBgView,0).centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).widthIs(40);
    _praiseButton.sd_layout.rightSpaceToView(_praiseLabel,0).centerYEqualToView(timeLabel).heightIs(18).widthIs(18);
    
    //灰色条
    grayBarView.sd_layout.topSpaceToView(timeLabel,15).leftSpaceToView(bottomBgView,0).rightSpaceToView(bottomBgView,0).heightIs(5);
    
    //评论
    commentLabel.sd_layout.leftEqualToView(timeLabel).heightIs(20).topSpaceToView(grayBarView,10);
    [commentLabel setSingleLineAutoResizeWithMaxWidth:250];
    

    [bottomBgView setupAutoHeightWithBottomView:commentLabel bottomMargin:15];
    
    [headView setupAutoHeightWithBottomView:bottomBgView bottomMargin:0];
    
    
    
    
    [headView  updateLayout];
    [headView layoutSubviews];
    
    _table.tableHeaderView = headView;
    
    
    if ((self.usrId == kCurrentUser.userId)) {
        deleteBtn.hidden = NO;
        smallBtn.hidden = NO;
    }else
    {
        deleteBtn.hidden = YES;
        smallBtn.hidden = YES;
    }
   

}
#pragma mark Action

- (void)praiseAction:(UIButton *)button{
    WS(ws);
    _praiseButton.userInteractionEnabled = NO;
    _presenter.praiseType = 2;
    if ([_isPraise integerValue] == 1) {
        //取消点赞
        [_presenter cancelPraise:[NSString stringWithFormat:@"%ld",(long)_rowID] success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"取消点赞成功"];
                ws.isPraise = [NSNumber numberWithInteger:0];
                ws.praiseCount = [NSNumber numberWithInteger:[_praiseCount integerValue]-1];
                ws.praiseLabel.text = [NSString stringWithFormat:@"%@",_praiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
                //圈子首页刷新
                [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
            }else{
                [ProgressUtil showError:@"取消点赞失败"];
            }
        }];
    }else{
        //点赞
        [_presenter praise:[NSString stringWithFormat:@"%ld",(long)_rowID] success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"点赞成功"];
                ws.isPraise = [NSNumber numberWithInteger:1];
                ws.praiseCount = [NSNumber numberWithInteger:[_praiseCount integerValue]+1];
                ws.praiseLabel.text = [NSString stringWithFormat:@"%@",_praiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
                //圈子首页刷新
                [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];

            }else{
                [ProgressUtil showSuccess:@"点赞失败"];
            }
        }];
    }
}
- (void)praiseTapAction{
    [self praiseAction:_praiseButton];
}

- (void)setupToobarView{
    [self.scroll addSubview:self.toolBarView];
    self.toolBarView.sd_layout.leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,0).heightIs(50);
    [self.scroll  setupAutoHeightWithBottomView:self.toolBarView bottomMargin:0];
    
}



#pragma mark - 代理
#pragma mark * tableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return self.presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleCommentCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell.delegate){
        cell.delegate = self;
    }

        if(indexPath.row >= self.presenter.dataSource.count){
            cell.commentEntity = [self.presenter.dataSource lastObject];
            
        cell.commentLabel.text =[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[self.presenter.dataSource lastObject].ReplyCount]];
            [cell.commentLabel  updateLayout];
            
        }else{
        cell.commentEntity = self.presenter.dataSource[indexPath.row];
        cell.commentLabel.text =[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.presenter.dataSource[indexPath.row].ReplyCount]];
            [cell.commentLabel  updateLayout];
            
        }
    
    
    
        cell.sd_indexPath = indexPath;
        cell.sd_tableView = tableView;
        
        return cell;

//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    if(indexPath.section){
        CommentDetailViewController* commentDetail = [CommentDetailViewController new];
//        commentDetail.commentEntity = self.presenter.dataSource[indexPath.row];
        commentDetail.commentID = [NSNumber  numberWithInteger:[self.presenter.dataSource  objectAtIndex:indexPath.row].uuid];
      NSLog(@"uuid2 is- is%@",commentDetail.commentID);
    
//    commentDetail.deletePubPostDetailRow = ^(BOOL isDeleteRow){
//        
//        if (isDeleteRow == YES) {
//            
//            if (indexPath.row <= 10) {
//                
//                [self.presenter.dataSource removeObjectAtIndex:indexPath.row];
//                
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                
//                [self.presenter getPostCommentListByCommentID:[_UUID  integerValue]];
//                
//                [tableView reloadData];
//                
//            }
//            
//        }
//        
//    };
    
        [self.navigationController pushViewController:commentDetail animated:YES];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    ConsultationCommenList* commentEntity = [self.presenter.dataSource objectAtIndex:indexPath.row];
    return [_table cellHeightForIndexPath:indexPath model:commentEntity keyPath:@"commentEntity" cellClass:[CircleCommentCell class] contentViewWidth:[self cellContentViewWith]];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:self.table]){
        if([self.toolBarView.textView isFirstResponder]){
            [self.toolBarView.textView resignFirstResponder];
        }
        
        if([self.toolBarView.unUsedTextView isFirstResponder]){
            [self.toolBarView.unUsedTextView resignFirstResponder];
        }

    }


}
#pragma mark * 点击工具条获取图片代理
-(void)clickAddPhotoCompleteHandler:(Complete)complete{
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    
    NSInteger maxPhotoNumber = 0;
    if(self.toolBarView.imageDataSource.count == 1){
        maxPhotoNumber = 5;
    }else if(self.toolBarView.imageDataSource.count == 2){
        maxPhotoNumber = 4;
    }else if(self.toolBarView.imageDataSource.count == 3){
        maxPhotoNumber = 3;
    }else if(self.toolBarView.imageDataSource.count == 4){
        maxPhotoNumber = 2;
    }else if(self.toolBarView.imageDataSource.count == 5){
        maxPhotoNumber = 1;
    }else if(self.toolBarView.imageDataSource.count == 6){
        maxPhotoNumber = 0;
    }
   else{
        maxPhotoNumber = 6;
    }
    manager.maxSelectedPhotoNumber = maxPhotoNumber;

    
//    manager.maxSelectedPhotoNumber = 3;

    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
//    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        NSMutableArray* imageDataSource = [NSMutableArray array];
        for (CorePhoto *photo in medias) {
            [imageDataSource addObject:photo.editedImage];
        }
    
        if(complete){
            complete(imageDataSource);
        }
    };
    [self presentViewController:pickerVC animated:YES completion:nil];

}
#pragma mark * 发送评论代理
-(void)sendCommitPostWith:(BOOL)isNeedUploadPImage content:(NSString *)consultation imageDataSource:(NSMutableArray * _Nonnull)imageDataSource{
    if(isNeedUploadPImage){
        //先上传图片
        [ProgressUtil showWithStatus:@"正在上传照片..."];
        [self.presenter uploadPostImage:imageDataSource ConsultationID:[_UUID  integerValue] CommentContent:consultation];
    }else{
        //直接走发送评论接口
        [ProgressUtil show];
        [self.presenter commitPostComment:@"" ConsultationID:[_UUID integerValue] CommentContent:consultation];
    }
}

#pragma mark * 评论列表代理
-(void)postCommentComplete:(BOOL)success info:(NSString *)message{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
//    _table.userInteractionEnabled = YES;
//    self.toolBarView.userInteractionEnabled = YES;
    if(success){
        [ProgressUtil dismiss];
        _table.hidden = NO;
        self.circleEntity.commentCount = [NSNumber numberWithInteger:self.presenter.totalCount];
        
        if(self.presenter.dataSource.count == 0){
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        if(self.toolBarView.textView.text.length != 0){
            self.toolBarView.textView.text = nil;
        }
        
        self.toolBarView.sendButton.selected = NO;
        
        [self.toolBarView.imageDataSource removeAllObjects];
        self.toolBarView.imageDataSource = nil;
        
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }

}
-(void)morePostCommentComplete:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [self.table.mj_footer endRefreshingWithNoMoreData]: [self.table.mj_footer endRefreshing];
//    self.table.userInteractionEnabled = YES;
//    self.toolBarView.userInteractionEnabled = YES;
    if(success){
        [self.table reloadData];
    }else{
        [ProgressUtil showError:message];
    }

}

- (void)GetCircleDetailSingleComplete:(BOOL) success info:(NSString* _Nonnull) message{
    
    if (success) {
        if (_presenter.CircleDetailSingleSource.count==0) {
            
        }else{
            CircleEntity  *circleEntity= _presenter.CircleDetailSingleSource[0];
            _circleEntity = circleEntity;
            _isPraise = circleEntity.isPraise;
            _praiseCount = circleEntity.praiseCount;
            _rowID = [circleEntity.uuid  integerValue];
            //创建时间
            timeLabel.text = _circleEntity.createTime;
            timeLabel.width = kJMWidth(timeLabel);
            [timeLabel  updateLayout];
            [self  setupHeadView];
//
            
        }
    }else{
        
        [ProgressUtil  showError:message];
    }
}


#pragma mark * 监听点击了照片墙
-(void)clickPhotoWallWithCircleEntity:(CircleEntity *)circleEntity currentPhoto:(UIImageView *)imageView photoDataSource:(NSArray<UIImageView *> *)photoDataSource photoURLDataSource:(NSArray<NSString *> * _Nonnull)photoURL{
    
    NSInteger photoIndex = imageView.tag - 201;
    
    [self.photoWallDataSource removeAllObjects];
    [self.photoWallURL removeAllObjects];
    self.photoWallDataSource = [NSMutableArray arrayWithArray:( photoDataSource)];
    self.photoWallURL = [NSMutableArray arrayWithArray:photoURL];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [SFPhotoBrowser showImageInView:window selectImageIndex:photoIndex delegate:self];
    
}
#pragma mark * 照片墙浏览代理
-(NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.photoWallDataSource.count;
}
-(SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    SFPhoto* sfPhoto = [SFPhoto new];
    
    //原图
    sfPhoto.srcImageView = self.photoWallDataSource[index];
    
    //缩略图片的url
    NSString *imgUrl = self.photoWallURL[index];
    if(imgUrl && imgUrl.length != 0){
        sfPhoto.url = [NSURL URLWithString:imgUrl];
    }
    
    
    return sfPhoto;
}
#pragma mark--删除--
-(void)deleteBtnInvation
{
    [_presenter deleteFirstWorldId:self.UUID];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.PublicPostDetailViewControllerBlock(YES);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}
#pragma mark--通知回调--
-(void)refreshConsulationList
{
    [_table.mj_header beginRefreshing];
    
}
-(void)dealloc{
    
    [kdefaultCenter removeObserver:self name:@"refreshPopViewnew" object:nil];
}
#pragma mark - 懒加载
-(LCChatToolBarView *)toolBarView{
    if(!_toolBarView){
        _toolBarView = [LCChatToolBarView new];
        _toolBarView.backgroundColor = UIColorFromRGB(0xffffff);
        _toolBarView.emotionRow = 3;//3行
        _toolBarView.emotionColumn = 6;//6列
        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

-(PublicPostDetailPresenter *)presenter{
    if(!_presenter){
        _presenter = [PublicPostDetailPresenter new];
        _presenter.delegate = self;
        
        //入口参数请求
        /**
         *  推送、系统消息、上个页面都这样进入
         */
  [_presenter  GetCircleDetailSingleWithuuid:_UUID];
    }
    return _presenter;
}
#pragma mark--分享--
-(void)rightItemAction:(id)sender{
    NSLog(@"分享");
    UIImageView *shareImage = [UIImageView new];
    [shareImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_circleEntity.childImg]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    if (shareImage.image !=nil) {
        
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        NSString *urlStr =[NSString stringWithFormat:@"%@=%@",QuanZi_URL,self.UUID];
        
        
        if (imageArray) {
            NSString *text = [NSString stringWithFormat:@"%@",_circleEntity.title];
            
            NSString  *title = [NSString  stringWithFormat:@"%@",_circleEntity.consultationContent];
            
            if (title.length>=124) {
                title = [title  substringToIndex:124];
            }
            
            NSData * imageData = UIImageJPEGRepresentation(shareImage.image,1);
            NSLog(@"压缩前%@",shareImage.image);
            NSLog(@"压缩前data:%lu",[imageData length]/1000);
            
            UIImage  *shareimage =  [JMFoundation  imageCompressForSize:shareImage.image targetSize:CGSizeMake(120, 180)];
            NSLog(@"压缩后%@",shareimage);
            NSData * imageData1 = UIImageJPEGRepresentation(shareimage,1);
            NSLog(@"压缩后data:%lu",[imageData1 length]/1000);
            
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            [shareParams SSDKSetupShareParamsByText:text               images:shareimage
                                                url:[NSURL URLWithString:urlStr]
                                              title:title                                           type:SSDKContentTypeAuto];
            
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
    }else {
        [ProgressUtil showInfo:@"正在加载,请稍后"];
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
#pragma action
-(UIImageView *)imageVIiewWithTag:(NSInteger)tag
{
    UIImageView *newImage =[[UIImageView alloc]init];
    
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    newImage.tag =tag;
    newImage.layer.cornerRadius= 8;
    [newImage.layer setBorderWidth:2];
    [newImage.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImage.clipsToBounds =YES;
    newImage.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [newImage addGestureRecognizer:Tap];
    return newImage;
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImageView* photo = (UIImageView*)tap.view;
    //    NSLog(@"点击了照片---%ld",(long)photo.tag);
    
    NSMutableArray* tempPhoto = [NSMutableArray array];
    NSMutableArray* tempPhotoURL = [NSMutableArray array];
    if(self.circleEntity.image1 && self.circleEntity.image1.length > 4){
        [tempPhoto addObject:photo1];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image1]];
    }
    if(self.circleEntity.image2 && self.circleEntity.image2.length > 4){
        [tempPhoto addObject:photo2];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image2]];
    }
    if(self.circleEntity.image3 && self.circleEntity.image3.length > 4){
        [tempPhoto addObject:photo3];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image3]];
    }
    if(self.circleEntity.image4 && self.circleEntity.image4.length > 4){
        [tempPhoto addObject:leftPhoto1];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image4]];
    }
    if(self.circleEntity.image5 && self.circleEntity.image5.length > 4){
        [tempPhoto addObject:midelPhoto2];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image5]];
    }
    if(self.circleEntity.image6 && self.circleEntity.image6.length > 4){
        [tempPhoto addObject:rightPhoto3];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image6]];
    }
    
    NSArray* photoDataSource = tempPhoto;
    NSArray* photoURLDataSource = tempPhotoURL;
    
    [self NewclickPhotoWallWithCircleEntity:self.circleEntity currentPhoto:photo photoDataSource:photoDataSource photoURLDataSource:photoURLDataSource];
}
- (void)NewclickPhotoWallWithCircleEntity:(CircleEntity* _Nonnull) circleEntity currentPhoto:(UIImageView* _Nonnull) imageView photoDataSource:(NSArray<UIImageView*>* _Nonnull) photoDataSource photoURLDataSource:(NSArray<NSString*> * _Nonnull) photoURL
{
    NSInteger photoIndex = imageView.tag - 211;
    
    [self.photoWallDataSource removeAllObjects];
    [self.photoWallURL removeAllObjects];
    self.photoWallDataSource = [NSMutableArray arrayWithArray:( photoDataSource)];
    self.photoWallURL = [NSMutableArray arrayWithArray:photoURL];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [SFPhotoBrowser showImageInView:window selectImageIndex:photoIndex delegate:self];
    
}
@end
