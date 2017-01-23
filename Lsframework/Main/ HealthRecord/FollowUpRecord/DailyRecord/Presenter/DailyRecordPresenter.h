//
//  DailyRecordPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FollowUp.h"

typedef void(^Complete)(BOOL success ,NSArray *followUp);
typedef void(^CompleteWithAge)(BOOL success ,NSArray *followUp ,NSString *age);

@protocol FollowUpDelegate <NSObject>

- (void)saveSuccess;

@end

@interface DailyRecordPresenter : NSObject

@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,weak) id<FollowUpDelegate> delegate;

//拉取随访记录显示
- (void)loadHistoryFollowUpDataWith:(CompleteWithAge)block byDate:(NSString *)date;

//获取填写的随访记录，上传
- (void)upLoadFollowUpData:(FollowUp *)followUp forBaby:(NSString *)BABYID date:(NSString *)date age:(NSString *)age complete:(Complete)block;


@end
