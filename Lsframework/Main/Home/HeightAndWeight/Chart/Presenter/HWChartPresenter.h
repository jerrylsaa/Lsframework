//
//  HWChartPresenter.h
//  FamilyPlatForm
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

//typedef void(^LoadChart)(BOOL success, NSString *message);
@protocol HWChartDelegate <NSObject>

- (void)complete:(BOOL) success message:(NSString *) message;

@end

@interface HWChartPresenter : BasePresenter

@property (nonatomic, weak) id<HWChartDelegate> delegate;

@property (nonatomic, strong) NSArray *highArray;
@property (nonatomic, strong) NSArray *middleArray;
@property (nonatomic, strong) NSArray *lowArray;
@property (nonatomic, strong) NSArray *dataArray;

- (void)loadData:(NSString *)type;


@end
