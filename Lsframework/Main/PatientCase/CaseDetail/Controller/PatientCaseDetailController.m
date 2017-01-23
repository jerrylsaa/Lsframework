//
//  PatientCaseDetailController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseDetailController.h"
#import "PatientCaseDetailPresenter.h"
#import "CircleCommentCell.h"
#import "PatientCaseRecordCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "LCChatToolBarView.h"
#import "CorePhotoPickerVCManager.h"
#import "SFPhotoBrowser.h"
#import "CommentDetailViewController.h"
#import "PatientCaseDetailHeaderCell.h"


@interface PatientCaseDetailController ()<UITableViewDataSource,UITableViewDelegate,PatientCaseDetailPresenterDelegate,LCChatToolBarViewDelegate,PhotoBrowerDelegate,CircleTableViewCellDelegate>

@property(nullable,nonatomic,retain) UIScrollView* scroll;
@property(nullable,nonatomic,retain) LCChatToolBarView* toolBarView;//聊天工具条
@property (nonatomic, strong) UITableView *tableView;
@property(nullable,nonatomic,retain)PatientCaseDetailPresenter* presenter;
@property(nullable,nonatomic,retain) NSArray* photoWallDataSource;
@property(nullable,nonatomic,retain) NSArray<NSString* >* photoWallURL;


@end

@implementation PatientCaseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [PatientCaseDetailPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter loadPatientCaseDetail:self.admissionRecordID];
}


- (void)setupView{
    self.title = @"病友案例";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //scroll
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [scroll addSubview:_tableView];
    
    [_tableView registerClass:[PatientCaseDetailHeaderCell class] forCellReuseIdentifier:@"patientCell"];
    [_tableView registerClass:[CircleCommentCell class] forCellReuseIdentifier:@"commentCell"];
    [_tableView registerClass:[PatientCaseRecordCell class] forCellReuseIdentifier:@"recordCell"];
    
    WS(ws);
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        ws.table.userInteractionEnabled = NO;
        //        ws.toolBarView.userInteractionEnabled = NO;
        [ws.presenter getPostCommentListByCommentID:[ws.patientCaseEntity.admissionRecordID integerValue]];
    }];

    //上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter getMorePostCommentListCommentID:[ws.patientCaseEntity.admissionRecordID integerValue]];
    }];


    //toolbar
    [self.scroll addSubview:self.toolBarView];

    
    //添加约束
    _tableView.sd_layout.topSpaceToView(self.scroll,0).leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,50);
    self.toolBarView.sd_layout.leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,0).heightIs(50);
    [self.scroll  setupAutoHeightWithBottomView:self.toolBarView bottomMargin:0];

}

#pragma mark - 代理
#pragma mark * tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.presenter.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray* array = self.presenter.dataSource[section];
    
    if(section == 0){
        return array.count + 1;
    }
    
    return array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientCaseDetailHeaderCell* patientCaseCell = [tableView dequeueReusableCellWithIdentifier:@"patientCell"];//病友案例cell
    CircleCommentCell* commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];//评论cell
    if(!commentCell.delegate){
        commentCell.delegate = self;
    }

    
    PatientCaseRecordCell* recordCell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];//纪录cell
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //病友案例
            patientCaseCell.patientCaseEntity = self.patientCaseEntity;
            
            patientCaseCell.sd_indexPath = indexPath;
            patientCaseCell.sd_tableView = tableView;
            return patientCaseCell;
        }else{
            //纪录
            NSDictionary* recordDic = self.presenter.patientCaseDetailDataSource[indexPath.row - 1];
            
            recordCell.recordDic = recordDic;
            
            recordCell.sd_indexPath = indexPath;
            recordCell.sd_tableView = tableView;
            return recordCell;
        }
    }else{
        //评论
        ConsultationCommenList* commentEntity = self.presenter.commentListDataSource[indexPath.row];
//        WSLog(@"====%@",commentEntity.CommentContent);
        commentCell.commentEntity = commentEntity;
        
        commentCell.commentLabel.text =[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:commentEntity.ReplayCount]];
        [commentCell.commentLabel  updateLayout];

        
        commentCell.sd_indexPath = indexPath;
        commentCell.sd_tableView = tableView;
        return commentCell;

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //病友案例
            
        }else{
            //纪录
        }
    }else{
        //评论
        CommentDetailViewController* commentDetail = [CommentDetailViewController new];
//        commentDetail.commentEntity = self.presenter.commentListDataSource[indexPath.row];
        
        ConsultationCommenList* consultationComment = self.presenter.commentListDataSource[indexPath.row];
        
        commentDetail.commentID = [NSNumber  numberWithInteger:consultationComment.uuid];

        commentDetail.isPatinetCase = YES;
        commentDetail.commentEntity = consultationComment;
        commentDetail.deleteRow = ^(BOOL isDelete){
            
            
//            [self.presenter.commentListDataSource removeObjectAtIndex:indexPath.row];
//            
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            
//            [self.presenter getPostCommentListByCommentID:[self.patientCaseEntity.admissionRecordID integerValue]];
//            
//            [tableView reloadData];
            if (isDelete == YES) {

            if (indexPath.row <= 10) {
                
                [self.presenter.commentListDataSource removeObjectAtIndex:indexPath.row];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
              
                 [self.presenter getPostCommentListByCommentID:[self.patientCaseEntity.admissionRecordID integerValue]];
                
                [tableView reloadData];
                
            }
            
            }
            
        };
        
        commentDetail.RefreshRow = ^(BOOL isfresh){
            
            if (isfresh == YES) {
            
            if (indexPath.row <= 10) {
                
                [self.presenter getPostCommentListByCommentID:[self.patientCaseEntity.admissionRecordID integerValue]];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [tableView reloadData];
                
            }else
            {
               [self.presenter getPostCommentListByCommentID:[self.patientCaseEntity.admissionRecordID integerValue]];
            }
            
            
        }
        };
        
        
        [self.navigationController pushViewController:commentDetail animated:YES];

    }

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //病友案例
            return [tableView cellHeightForIndexPath:indexPath model:self.patientCaseEntity keyPath:@"patientCaseEntity" cellClass:[PatientCaseDetailHeaderCell class] contentViewWidth:[self cellContentViewWith]];
        }else{
            //纪录
            NSDictionary* recordDic = self.presenter.patientCaseDetailDataSource[indexPath.row - 1];
            
            return [tableView cellHeightForIndexPath:indexPath model:recordDic keyPath:@"recordDic" cellClass:[PatientCaseRecordCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }else{
        //评论
        ConsultationCommenList* commentEntity = [self.presenter.commentListDataSource objectAtIndex:indexPath.row];
        
        return [tableView cellHeightForIndexPath:indexPath model:commentEntity keyPath:@"commentEntity" cellClass:[CircleCommentCell class] contentViewWidth:[self cellContentViewWith]];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        return 35;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont  systemFontOfSize:midFont];
    header.textLabel.textColor = RGB(153, 153, 153);
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return [NSString stringWithFormat:@"评论  %ld",self.presenter.commentTotalCount];
    }
    return @"";
}
#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:self.tableView]){
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
    else {
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
        [self.presenter uploadPostImage:imageDataSource ConsultationID:[self.patientCaseEntity.admissionRecordID integerValue] CommentContent:consultation];
    }else{
        //直接走发送评论接口
        [ProgressUtil show];
        [self.presenter commitPostComment:@"" ConsultationID:[self.patientCaseEntity.admissionRecordID integerValue] CommentContent:consultation];
    }
}

#pragma mark * 评论列表代理
-(void)postCommentComplete:(BOOL)success info:(NSString *)message{
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header endRefreshing];
    //    _table.userInteractionEnabled = YES;
    //    self.toolBarView.userInteractionEnabled = YES;
    if(success){
        [ProgressUtil dismiss];
        self.patientCaseEntity.commentCount = [NSNumber numberWithInteger:self.presenter.commentTotalCount];
        
        if(self.presenter.noMoreData){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if(self.toolBarView.textView.text.length != 0){
            self.toolBarView.textView.text = nil;
        }
        
        self.toolBarView.sendButton.selected = NO;
        
        [self.toolBarView.imageDataSource removeAllObjects];
        self.toolBarView.imageDataSource = nil;
        
        [self.tableView reloadData];
    }else{
        [ProgressUtil showError:message];
    }
    
}
-(void)morePostCommentComplete:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [self.tableView.mj_footer endRefreshingWithNoMoreData]: [self.tableView.mj_footer endRefreshing];
    //    self.table.userInteractionEnabled = YES;
    //    self.toolBarView.userInteractionEnabled = YES;
    if(success){
        [self.tableView reloadData];
    }else{
        [ProgressUtil showError:message];
    }
    
}

#pragma mark * 监听点击了照片墙
-(void)clickPhotoWallWithCircleEntity:(CircleEntity *)circleEntity currentPhoto:(UIImageView *)imageView photoDataSource:(NSArray<UIImageView *> *)photoDataSource photoURLDataSource:(NSArray<NSString *> * _Nonnull)photoURL{
    
    NSInteger photoIndex = imageView.tag - 201;
    
    
    self.photoWallDataSource = photoDataSource;
    self.photoWallURL = photoURL;
    
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

#pragma mark * PatientCaseDetailPresenter代理
-(void)loadPatientCaseDetailComplete{
    [ProgressUtil dismiss];
    
    WSLog(@"----%d",self.presenter.noMoreData);
    
    self.presenter.noMoreData? [self.tableView.mj_footer endRefreshingWithNoMoreData]: [self.tableView.mj_footer endRefreshing];

    
    [_tableView reloadData];
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


@end
