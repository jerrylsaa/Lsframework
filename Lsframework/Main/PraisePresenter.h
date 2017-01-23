//
//  PraisePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "PraiseList.h"

@protocol PraisePresenterDelegate <NSObject>
@optional
-(void)GetPraiseListCompletion:(BOOL)success info:(NSString*)message;
-(void)GetMorePraiseListCompletion:(BOOL)success info:(NSString*)message;
-(void)insertArticleCommentCompletion:(BOOL)success info:(NSString*)message;
//获取文章是否点赞
-(void)GetArticlePraiseCompletion:(BOOL)success info:(NSString*)message;
//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

@end

@interface PraisePresenter : BasePresenter

@property(nonatomic,weak) id<PraisePresenterDelegate> delegate;

//@property(nonatomic,retain) NSArray<PraiseList* > * dataSource;
@property(nonatomic,retain) NSMutableArray<PraiseList* > * dataSource;
@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSInteger totalCount;

@property(nonatomic)BOOL  *ispraise;

//获取文章评论列表
-(void)getPraiseListWithArticleID:(NSNumber*)ArticleID ;
-(void)getMorePraiseList;
//插入评论
-(void)insertArticleCommentWithArticleID:(NSNumber*)ArticleID CommentID:(NSNumber*)commentID UserID:(NSNumber*)userid CommentContent:(NSString*)CommentContent;
//获取当前用户是否点赞

-(void)getArticlePraiseByArticleID:(NSNumber*)articleID;

//点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID;

//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID;


@end
