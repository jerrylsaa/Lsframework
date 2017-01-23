//
//  MyQuestionDetailPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ApiMacro.h"
#import <AVFoundation/AVFoundation.h>
#import "MyReply.h"
#import "ZHAVRecorder.h"
#import "HEAParentQuestionEntity.h"
#import "ExpertCommentListEntity.h"

#define _player [ZHAVRecorder sharedRecorder]
typedef void(^LoadHandler)(BOOL success, NSString *message);

typedef void(^playStart)(BOOL success);

@protocol  MyQuestionDetailDelegate <NSObject>

- (void)playFinished;

- (void)second:(NSString *)second;

- (void)payCallBack:(BOOL) success;

- (void)addExpertCommentSuccess;

- (void)getExpertCommentListSuccess;


@end

@interface MyQuestionDetailPresenter : BasePresenter

//@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, weak) id<MyQuestionDetailDelegate> delegate;
@property (nonatomic, strong) MyReply *myReply;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ExpertCommentListEntity *myComment;

- (void)play:(playStart)block;
- (void)stop;

- (void)payWithPayType:(NSString *) payType;
//加载问题详情
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block;
//加载追问问题
- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block;

- (void)addExpertComment:(NSString *)comment Stars:(NSInteger )stars ConsultationID:(NSNumber *)consultationID ExpertID:(NSNumber *)expertID;

- (void)GetExpertCommentListByConsultationID:(NSNumber *)uuid;

@end
