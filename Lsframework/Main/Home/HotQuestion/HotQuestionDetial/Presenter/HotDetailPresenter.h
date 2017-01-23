//
//  HotDetailPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHAVRecorder.h"
#import "ExpertAnswerEntity.h"
#import "TherapeuticVisit.h"
#import "ConsultationCommenList.h"
#import "FormData.h"
#import "UIImage+Category.h"
#import "ConsulationReplyList.h"
#import "DataTaskManager.h"
#import "WXPayUtil.h"
#import "DetailQuestion.h"
#import "ExpertCommentListEntity.h"


#define _player [ZHAVRecorder sharedRecorder]

typedef void(^playStart)(BOOL success);
typedef void(^LoadHandler)(BOOL success, NSString *message);

@protocol  HotDetailPresenterDelegate <NSObject>



- (void)playFinished;

- (void)second:(NSString *)second;

//获取专家数据

- (void)loadDoctorInfoCompletion:(BOOL) success info:(NSString*) messsage;

//获取限时免费次数完成
- (void)onFreeListeningCountCompletion:(BOOL) success info:(NSString*) messsage;

//疗效回访回调
-(void)GetTherapeuticVisitCompletion:(BOOL) success info:(NSString*) messsage;

//获取咨询评论列表
-(void)GetConsultationCommentListCompletion:(BOOL)success info:(NSString*)message;
-(void)GetMoreConsultationCommentListCompletion:(BOOL)success info:(NSString*)message;
//插入咨询

-(void)InsertConsulationOnCompletion:(BOOL)success info:(NSString*)message;

//获取微信订单状态回调
- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url;

//获取偷听咨询微信预支付信息回调
- (void)onGetListenWXPrePayCompletion:(BOOL) success info:(NSString*) message PayDict:(NSDictionary *)dict;

-(void)GetExpertHalfPriceOnCompletion:(BOOL)success info:(NSString*)message;

- (void)getExpertCommentListSuccess;

- (void)addExpertCommentSuccess;


@end

@interface HotDetailPresenter : BasePresenter

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, weak) id<HotDetailPresenterDelegate> delegate;

@property (nonatomic, strong) ExpertAnswerEntity *expert;
@property (nonatomic, strong) NSArray<ExpertAnswerEntity* > * expertAnswer;
//@property(nonatomic,strong)NSArray<TherapeuticVisit* > * TherapeuticVisitSource;
@property (nonatomic, strong) ExpertCommentListEntity *myComment;
@property(nonatomic,retain) NSMutableArray<ConsultationCommenList* > * ConsultationDataSource;

@property(nullable,nonatomic,retain) DataTaskManager* taskManager;

@property(nonatomic) BOOL noMoreData;
@property(nonatomic) NSInteger totalCount;
@property (nonatomic, assign) NSInteger praiseType;
@property (nullable,nonatomic, strong) NSArray *dataSource;
@property (nullable,nonatomic,strong) DetailQuestion *question;
@property (nullable,nonatomic,strong) TherapeuticVisit *TherapeuticVisitSource;


@property(nonatomic,strong) NSNumber *halfPrice;
@property(nonatomic,retain) NSNumber *ifVacation;
@property (nonatomic, retain) NSNumber *NoAnswer;

- (void)play:(playStart)block;
- (void)stop;

- (void)loadDoctorInfoBy:(NSNumber *)experID complete:(LoadHandler)block;

//限时免费计数
-(void)FreeListeningCountWithConsultationID:(NSInteger)ConsultationID;

//疗效回访
-(void)GetTherapeuticVisitByConsultationID:(NSUInteger)ConsultationID;
-(void)GetTherapeuticVisitByConsultationID:(NSUInteger)ConsultationID complete:(LoadHandler)block;

-(void)GetConsultationCommentListByConsultationID:(NSUInteger)ConsultationID ;


-(void)getMoreConsultationCommentList;

-(void)loadDoctorInfoBy:(NSNumber *)experID;


- (void)ConsultationPost:(NSMutableArray*) imageDataSorce ConsultationID:(NSInteger)ConsultationID  CommentContent:(NSString*) CommentContent;


- (void)commitConsultation:(NSString*) uploadPath ConsultationID:(NSInteger)ConsultationID  CommentContent:(NSString*) CommentContent;

- (void)praise:(nullable NSString *)consultationID success:(nullable LoadHandler)block;
- (void)cancelPraise:(nullable NSString *)consultationID success:(nullable LoadHandler)block;
- (void)checkWXPayResultWithOder:(NSString *)oder;

- (void)weixinPayWithListenId:(NSInteger )questionId;
//加载追问问题数据
- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block;
//问题数据
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block;

- (void)GetExpertHalfPriceByExpertID:(NSInteger )expertID;

- (void)GetExpertCommentListByConsultationID:(NSNumber *)uuid;

- (void)addExpertComment:(NSString *)comment Stars:(NSInteger )stars ConsultationID:(NSNumber *)consultationID ExpertID:(NSNumber *)expertID;

@end
