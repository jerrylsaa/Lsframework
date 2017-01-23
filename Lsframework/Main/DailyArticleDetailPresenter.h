//
//  DailyArticleDetailPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "PraiseList.h"
@protocol DailyArticleDetailPresenterDelegate <NSObject>
@optional
-(void)GetReplyListCompletion:(BOOL)success info:(NSString*)message;

-(void)GetMoreReplyListCompletion:(BOOL)success info:(NSString*)message;

-(void)insertArticleCommentCompletion:(BOOL)success info:(NSString*)message;
@end

@interface DailyArticleDetailPresenter : BasePresenter
@property(nonatomic,weak) id<DailyArticleDetailPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray<PraiseList* > * dataSource;
@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSInteger totalCount;


//获取文章回复列表
-(void)getReplyListWithCommentID:(NSNumber*)CommentID ;
-(void)getMoreReplyList;

//插入评论
-(void)insertArticleCommentWithArticleID:(NSNumber*)ArticleID CommentID:(NSNumber*)commentID UserID:(NSNumber*)userid CommentContent:(NSString*)CommentContent;

-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId;

@end
