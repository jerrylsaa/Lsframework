//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateDelegate <NSObject>

- (void)selectDate:(NSDate *)date;
- (void)selectMonth:(NSInteger)month;

@end

@interface FDCalendar : UIView

@property (nonatomic ,weak)id<DateDelegate> delegate;

@property (nonatomic ,strong) UICollectionView *monthCollectionView;

@property (nonatomic ,assign)NSInteger year;
@property (nonatomic ,assign)NSInteger month;
@property (nonatomic ,assign)NSInteger day;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)NSMutableDictionary *stateDic;

- (instancetype)initWithCurrentDate:(NSDate *)date;

- (void)reloadCalendar;

@end
