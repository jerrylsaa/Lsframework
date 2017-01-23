//
//  DailyArticleMorePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DailyFirstArticle.h"

@protocol  DailyArticleMorePresenterDelegate <NSObject>

//获取每日必读列表
-(void)GetDailyArticleListCompletion:(BOOL)success info:(NSString*)message;
-(void)GetDailyArticleMoreListCompletion:(BOOL)success info:(NSString*)message;

//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;


@end
@interface DailyArticleMorePresenter : BasePresenter

@property (nonatomic, weak) id<DailyArticleMorePresenterDelegate> delegate;
@property(nonatomic) BOOL noMoreData;

@property(nonatomic,retain) NSMutableArray<DailyFirstArticle* > * dataSource;


-(void)GetDailyArticleList;


-(void)GetDailyArticleMoreList;

/**
 *  文章点赞和取消
 */

//点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID;

//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID;



@end
