//
//  CommentDetailPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ConsulationReplyList.h"
#import "UIImage+Category.h"
#import "ConsultationCommenList.h"


@protocol CommentDetailPresenterDelegate <NSObject>

- (void)replyCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;
- (void)moreReplyCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;

//获取圈子详情回复单条数据
-(void)GetCircleQuestionInfoSingleCompletion:(BOOL) success info:(NSString*) messsage;

@end


@interface CommentDetailPresenter : BasePresenter

@property(nullable,nonatomic,weak) id<CommentDetailPresenterDelegate> delegate;

@property(nullable,nonatomic,retain) NSMutableArray<ConsulationReplyList* > * dataSource;

@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSUInteger totalCount;
@property (nonatomic, strong) NSArray *CircleInfoSingleDataSource;

@property(nonatomic)BOOL isPatinetCase;//是否是从病友案例评论跳过来的，是的话，就改变一下CommentDetailPresenter中请求评论回复的actionName



/**
 获取帖子回复
 
 @param commentID 帖子ID
 */
- (void)getPostReplyListByCommentID:(NSInteger) commentID;

/**
 加载更多
 
 @param commentID <#commentID description#>
 */
- (void)getMorePostReplyListCommentID:(NSInteger) commentID;


/**
 添加帖子回复
 
 @param uploadPath     <#uploadPath description#>
 @param commentID      <#commentID description#>
 @param CommentContent <#CommentContent description#>
 */
- (void)commitPostReplyWithConsultationID:(NSInteger) commentID  CommentContent:(NSString* _Nonnull) commentContent;

//获取圈子详情回复单条数据
-(void)GetCircleQuestionInfoSingleWithcommentID:(NSNumber*_Nullable)commentID;


-(void)deleteInvitationWithID:(NSInteger)InvitationID;

-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId;

@end
