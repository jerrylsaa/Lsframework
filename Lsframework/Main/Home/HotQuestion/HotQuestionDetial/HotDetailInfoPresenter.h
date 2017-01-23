//
//  HotDetailInfoPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ConsulationReplyList.h"
#import "UIImage+Category.h"
#import "ConsultationCommenList.h"

@protocol  HotDetailInfoPresenterDelegate<NSObject>

@optional
-(void)getConsulationReplyCompletion:(BOOL) success info:(NSString*) messsage;

-(void)GetMoreConsultationReplyCompletion:(BOOL)success info:(NSString*)message;
-(void)InsertConsulationOnCompletion:(BOOL)success info:(NSString*)message;
//首页热门咨询数据
-(void)GetHotQuestionInfoSingleCompletion:(BOOL) success info:(NSString*) messsage;

@end


@interface HotDetailInfoPresenter : BasePresenter

@property (nonatomic, weak) id<HotDetailInfoPresenterDelegate> delegate;
@property(nonatomic,retain) NSMutableArray<ConsulationReplyList* > * DataSource;

@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSInteger totalCount;

@property (nonatomic, strong) NSArray *HotInfoSingleDataSource;



-(void)GetConsulationReplyByCommentID:(NSUInteger)CommentID;

-(void)getMoreConsultationReplyList;



- (void)InsertConsultationByCommentID:(NSInteger)CommentID  CommentContent:(NSString*) CommentContent;
//获取热门详情回复单条数据
-(void)GetHotQuestionInfoSingleWithcommentID:(NSNumber*_Nullable)commentID;

-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId;

-(void)deleteInvitationWithID:(NSInteger)InvitationID;

@end
