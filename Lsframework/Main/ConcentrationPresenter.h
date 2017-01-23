//
//  ConcentrationPresenter.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "TodayRecommend.h"

@protocol  ConcentrationPresenterDelegate <NSObject>

//获取每日必读列表
-(void)GetDailyArticleListCompletion:(BOOL)success info:(NSString*)message;
-(void)GetDailyArticleMoreListCompletion:(BOOL)success info:(NSString*)message;

//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;


@end
@interface ConcentrationPresenter : BasePresenter
@property (nonatomic, weak) id<ConcentrationPresenterDelegate> delegate;
@property(nonatomic) BOOL noMoreData;

@property(nonatomic,retain) NSMutableArray<TodayRecommend* > * dataSource;
@property(nonatomic,strong) NSMutableArray *MoreArray;




-(void)GetDailyArticleList;


-(void)GetDailyArticleMoreList;


-(void)GetMoreList:(NSNumber *)CategoryID;

-(void)GetMoreNewList:(NSNumber *)CategoryID;

/**
 *  文章点赞和取消
 */

//点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID;

//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID;

@end
