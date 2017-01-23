//
//  AwaitAnswerPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyAnserEntity.h"
#import "UploadV1Entity.h"
#import "UploadV1BlockInfos.h"

#import <AVFoundation/AVFoundation.h>
#import "ZHAVRecorder.h"
#define _player [ZHAVRecorder sharedRecorder]
typedef void(^playStart)(BOOL success);
typedef void(^LoadHandler)(BOOL success, NSString *message);

typedef void(^LoadVoiceFile)(NSString *file,NSString *downPath);

@protocol AwaitAnswerPresenterDelegate <NSObject>

- (void)commitAwaitAnswerOnComplete:(BOOL) success info:(NSString*) info;

- (void)uploadOnComplete:(BOOL)success info:(NSString *)info;

@end
@interface AwaitAnswerPresenter : BasePresenter

@property(nonatomic,weak) id<AwaitAnswerPresenterDelegate> delegate;

@property(nonatomic,copy) NSString * DoctorAudioPath;
@property(nonatomic,retain) NSMutableArray* audioArray;

@property(nonatomic) CGRect rect;

@property (nonatomic, strong) MyAnserEntity *myAnswer;
@property (nonatomic, assign) NSInteger answerType;
@property (nonatomic, strong) NSNumber *doctorID;
@property (nonatomic, strong) NSNumber *TraceID;

@property (nonatomic, strong) UploadV1Entity *myUploadV1;
@property (nonatomic, strong) NSArray <UploadV1BlockInfos *> *myUploadBlockInfos;
@property (nonatomic,assign) NSInteger uploadTag;

@property (nonatomic, copy) NSString *urls;
@property (nonatomic, assign) BOOL isPlaying;
@property(nonatomic,strong)NSString *fileName;

- (void)stop;


- (void)commitAwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent;
- (void)commitOldAwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent;
- (void)commit44AwaitAnswerVoiceWithPath:(NSString*)uploadPath ConsultationID:(NSString*)consultationID Time:(long)myTime WordContent:(NSString*)WordContent;
- (void)uploadBlockInfos;

//加载问题详情
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block;
- (void)play:(playStart) block;

-(void)loadVoiceUrl:(LoadVoiceFile)file;

@end
