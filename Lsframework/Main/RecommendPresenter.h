//
//  RecommendPresenter.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "TodayRecommend.h"

@protocol RecommendPresenterDelegate <NSObject>

-(void)GetRecommendListCompletion:(BOOL)success info:(NSString *)message;
-(void)GetRecommendMoreListCompletion:(BOOL)success info:(NSString*)message;
//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;
@end

@interface RecommendPresenter : BasePresenter

@property(nonatomic,retain) NSMutableArray<TodayRecommend* > * reommendSource;
@property(nonatomic) BOOL noMoreData;
@property(nonatomic,weak) id<RecommendPresenterDelegate> delegate;

-(void)getRecommendList;

-(void)getMoreRecommendList;

//点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID;

//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID;

@end
