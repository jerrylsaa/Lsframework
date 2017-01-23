//
//  MyAnswerPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyAnserEntity.h"

@protocol MyAnswerPresenterDelegate <NSObject>

- (void)loadDataComplete:(BOOL) success message:(NSString *)message;

@end

@interface MyAnswerPresenter : BasePresenter

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, weak) id<MyAnswerPresenterDelegate> delegate;

@property (nonatomic, copy) NSString *doctorID;

- (void)loadMyAnswerData;

- (void)loadMoreData;



@end
