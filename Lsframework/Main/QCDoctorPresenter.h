//
//  QCDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DoctorList.h"

@protocol QCDoctorListPresenterDelegate <NSObject>

- (void)clickQCDoctorListOnCompletion:(BOOL) success info:(NSString*) info;

- (void)refreshDataOnCompletion:(BOOL) success info:(NSString*) info;

- (void)loadMoreDataOnCompletion:(BOOL) success hasMoreData:(BOOL) moreData info:(NSString*) info;

@end

@interface QCDoctorPresenter : BasePresenter

@property(nonatomic,weak) id<QCDoctorListPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray* dataSource;

/**
 *  请求数据
 */
- (void)requestData;

/**
 *  下来刷新
 */
- (void)refreshData;

/**
 *  加载更多
 */
- (void)loadMoreData;

@end
