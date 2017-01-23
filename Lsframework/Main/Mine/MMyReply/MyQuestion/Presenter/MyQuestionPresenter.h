//
//  MyQuestionPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol MyQuestionPresenterDelegate <NSObject>

- (void)loadDataComplete:(BOOL) success message:(NSString *)message;

@end

@interface MyQuestionPresenter : BasePresenter

@property (nonatomic, weak) id<MyQuestionPresenterDelegate> delegate;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong)NSMutableArray *dataSource;

- (void)loadQuestionData;
- (void)loadMoreData;

@end
