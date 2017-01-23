//
//  GBSearchPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "CircleEntity.h"

@protocol GBSearchPresenterDelegate <NSObject>

- (void)loadSearchResultComplete:(BOOL) success info:(NSString* _Nonnull) message;

- (void)praiseOnComplete:(NSIndexPath* _Nonnull) index;

@end

@interface GBSearchPresenter : BasePresenter

@property(nonatomic) NSInteger totalCount;//总数
@property(nonatomic)BOOL noMoreData;
@property(nullable,nonatomic,retain) NSMutableArray<NSDictionary* >* dataSource;
@property(nullable,nonatomic,weak) id<GBSearchPresenterDelegate> delegate;



/**
 搜索关键词

 @param keyWords <#keyWords description#>
 */
- (void)loadSearchResultWithKeyWords:(NSString* _Nonnull) keyWords;


/**
 加载更多
 */
- (void)laodMoreSearchResult;

/**
 *  通知刷新
 */
-(void)NotificationRefreshSearchResult;


/**
 点赞

 @param indexPath <#indexPath description#>
 @param type      0,语音，2帖子
 */
- (void)clickPraiseWith:(NSIndexPath* _Nonnull) indexPath type:(NSInteger) type;


/**
 取消点赞

 @param indexPath <#indexPath description#>
 @param type      <#type description#>
 */
-(void)cancelPraiseWith:(NSIndexPath* _Nonnull) indexPath type:(NSInteger) type;

@end
