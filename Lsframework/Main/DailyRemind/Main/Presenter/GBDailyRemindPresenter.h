//
//  GBDailyRemindPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DailyRemindEntity.h"

@protocol GBDailyRemindPresenterDelegate <NSObject>

- (void)loadDailyRemindComplete:(BOOL) success message:(NSString* _Nullable) info;

@end

@interface GBDailyRemindPresenter : BasePresenter

@property(nullable,nonatomic,retain) NSMutableArray<DailyRemindEntity* >* dataSource;
@property(nonatomic)BOOL noMoreData;
@property(nullable,nonatomic,weak) id<GBDailyRemindPresenterDelegate> delegate;

/**
 加载每日提醒

 @param day 生日(单位：天)
 */
- (void)loadDailyRemindWithDay:(NSInteger) day;


/**
 加载更多
 */
- (void)loadMoreDailyRemind;

@end
