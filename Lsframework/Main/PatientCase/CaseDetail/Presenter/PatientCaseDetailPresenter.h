//
//  PatientCaseDetailPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "PatientCaseDetailEntity.h"
#import "ConsultationCommenList.h"
#import "DataTaskManager.h"
#import "UIImage+Category.h"

@protocol PatientCaseDetailPresenterDelegate <NSObject>

- (void)loadPatientCaseDetailComplete;

- (void)postCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;
- (void)morePostCommentComplete:(BOOL) success info:(NSString* _Nonnull) message;


@end


@interface PatientCaseDetailPresenter : BasePresenter

@property(nullable,nonatomic,retain) DataTaskManager* taskManager;
@property(nullable,nonatomic,weak) id<PatientCaseDetailPresenterDelegate> delegate;
@property(nullable,nonatomic,retain) NSMutableArray<NSMutableArray* > * dataSource;
@property(nullable,nonatomic,retain) NSMutableArray<NSDictionary* > * patientCaseDetailDataSource;//入院纪录数据源
@property(nullable,nonatomic,retain) NSMutableArray<ConsultationCommenList* > * commentListDataSource;//评论数据源
@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSInteger commentTotalCount;

@property(nonatomic,assign)NSInteger currentIndex;



/**
 加载病友详情

 @param recordID <#recordID description#>
 */
- (void)loadPatientCaseDetail:(NSNumber* _Nonnull) recordID;


/**
 上传帖子照片
 
 @param imageDataSorce <#imageDataSorce description#>
 @param commentID      <#commentID description#>
 @param CommentContent <#CommentContent description#>
 */
- (void)uploadPostImage:(NSMutableArray* _Nonnull) imageDataSorce ConsultationID:(NSInteger) commentID  CommentContent:(NSString* _Nonnull) CommentContent;

/**
 添加帖子评论
 
 @param uploadPath     <#uploadPath description#>
 @param commentID      <#commentID description#>
 @param CommentContent <#CommentContent description#>
 */
- (void)commitPostComment:(NSString* _Nonnull) uploadPath ConsultationID:(NSUInteger) commentID  CommentContent:(NSString* _Nonnull) commentContent;

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

-(void)getPostCommentListByCommentID:(NSInteger)commentID NSindexRow:(NSInteger)inter;

@end
