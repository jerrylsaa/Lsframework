//
//  ZHCalendarView.h
//  Date
//
//  Created by 中弘科技 on 16/4/2.
//  Copyright © 2016年 中弘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCalendarCell.h"

@protocol ZHCalendarDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath andDateStr:(NSString *)dateStr;

@end

@interface ZHCalendarView : UIView

@property (nonatomic ,weak)id<ZHCalendarDelegate> delegate;

@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *indexPathArray;

- (instancetype)initWithFrame:(CGRect)frame withDate:(NSDate *) date andDays:(NSArray *)days;

- (void)updateWithDate:(NSDate *)date andDays:(NSArray *)days;
@end
