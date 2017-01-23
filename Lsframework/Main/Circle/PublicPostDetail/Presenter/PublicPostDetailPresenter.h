//
//  PublicPostDetailPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ConsultationCommenList.h"
#import "UIImage+Category.h"
#import "DataTaskManager.h"
#import "ConsulationReplyList.h"
#import "CircleEntity.h"

typedef void(^LoadHandler)(BOOL success, NSString *message);

@protocol PublicPostDetailPresenterDelegate <NSObject>

- (void)postCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;
- (void)morePostCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;

//获取帖子详情单条数据
- (void)GetCircleDetailSingleComplete:(BOOL) success info:(NSString* _Nonnull) message;



@end

@interface PublicPostDetailPresenter : BasePresenter

@property(nullable,nonatomic,retain) DataTaskManager* taskManager;

@property(nullable,nonatomic,weak) id<PublicPostDetailPresenterDelegate> delegate;

@property(nullable,nonatomic,retain) NSMutableArray<ConsultationCommenList* > * dataSource;
@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSUInteger totalCount;

@property (nonatomic, strong) NSArray *CircleDetailSingleSource;
@property (nonatomic, assign) NSInteger praiseType;
@property(nonatomic,strong) NSMutableArray* commentDataSource;

/**
 获取帖子评论

 @param commentID 帖子ID
 */
- (void)getPostCommentListByCommentID:(NSInteger) commentID;

/**
 加载更多

 @param commentID <#commentID description#>
 */
- (void)getMorePostCommentListCommentID:(NSUInteger) commentID;


/**
 添加帖子评论

 @param uploadPath     <#uploadPath description#>
 @param commentID      <#commentID description#>
 @param CommentContent <#CommentContent description#>
 */
- (void)commitPostComment:(NSString* _Nonnull) uploadPath ConsultationID:(NSUInteger) commentID  CommentContent:(NSString* _Nonnull) commentContent;


/**
 上传帖子照片

 @param imageDataSorce <#imageDataSorce description#>
 @param commentID      <#commentID description#>
 @param CommentContent <#CommentContent description#>
 */
- (void)uploadPostImage:(NSMutableArray* _Nonnull) imageDataSorce ConsultationID:(NSInteger) commentID  CommentContent:(NSString* _Nonnull) CommentContent;



//获取帖子详情单条数据
-(void)GetCircleDetailSingleWithuuid:(NSNumber*_Nullable)uuid;


- (void)praise:(nullable NSString *)consultationID success:(nullable LoadHandler)block;
- (void)cancelPraise:(nullable NSString *)consultationID success:(nullable LoadHandler)block;

-(void)deleteFirstWorldId:(NSNumber *)worldId;

-(void)loadReply:(NSNumber *)uuid;

@end
