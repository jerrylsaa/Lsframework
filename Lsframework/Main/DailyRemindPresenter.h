//
//  DailyRemindPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DailyRemind.h"
@protocol DailyRemindPresenterDelegate <NSObject>
@optional
- (void)onGetDailyEventWithCompletion:(BOOL) success Day:(NSUInteger)day;

@end
@interface DailyRemindPresenter : BasePresenter
@property(nonatomic,weak) id<DailyRemindPresenterDelegate>delegate;
@property(nonatomic,retain) NSArray<DailyRemind* > * DailySource;


/**
 *  获取每日提醒
 */
- (void)getDailyEventWithDay:(NSUInteger)day;

@end
