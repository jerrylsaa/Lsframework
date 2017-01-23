//
//  MyListenPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^MyListenComplete)(BOOL success, NSString *message);

@interface MyListenPresenter : BasePresenter

@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,assign) NSInteger pageIndex;

- (void)loadListenData:(MyListenComplete)block;
- (void)loadMoreData:(MyListenComplete)block;

@end
