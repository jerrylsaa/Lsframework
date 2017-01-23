//
//  ReplyAnswerPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHAVRecorder.h"
#import "MyAnserEntity.h"

#define _player [ZHAVRecorder sharedRecorder]

typedef void(^playStart)(BOOL success);
//typedef void(^LoadHandler)(BOOL success, NSString *message);
typedef void(^GetDataSource) (NSArray *array);

@protocol  ReplyAnswerDelegate <NSObject>

- (void)playFinished;

- (void)second:(NSString *)second;

@end

@interface ReplyAnswerPresenter : BasePresenter

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, weak) id<ReplyAnswerDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MyAnserEntity *myAnswer;
@property(nonatomic,strong)NSNumber *uuid;

- (void)play:(playStart) block;
- (void)stop;

-(void)getData:(GetDataSource)data;
/*
//加载问题详情
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block;
//加载追问问题
- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block;
*/
@end
