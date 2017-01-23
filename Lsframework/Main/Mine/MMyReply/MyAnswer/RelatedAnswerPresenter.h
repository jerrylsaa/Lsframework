//
//  RelatedAnswerPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "RelatedAnswerEntity.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHAVRecorder.h"
#import "RelatedAnswerCell.h"

#define _player [ZHAVRecorder sharedRecorder]
typedef void(^playStart)(BOOL success);

@protocol RelatedAnswerPresenterDelegate <NSObject>
@optional
- (void)playFinished;

- (void)second:(NSString *)second;

- (void)getdocfullanwerconsultationSuccess;

@end

@interface RelatedAnswerPresenter : BasePresenter

@property(nonatomic,weak) id<RelatedAnswerPresenterDelegate> delegate;

@property (nonatomic,strong) NSArray <RelatedAnswerEntity *>*relatedAnswerDataSource;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, copy) NSString *playingType;
@property (nonatomic, strong) RelatedAnswerCell *playingCell;
@property (nonatomic, strong) NSTimer *timer;

- (void)getdocfullanwerconsultationByUUID:(NSNumber *)uuid;

- (void)play:(playStart) block;
- (void)stop;

@end
