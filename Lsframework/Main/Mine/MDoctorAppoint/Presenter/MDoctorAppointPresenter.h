//
//  MDoctorAppointPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "AppointDoctor.h"

@protocol MDoctorAppointPresenterDelegate <NSObject>
@optional
- (void)onCompletion:(BOOL) success info:(NSString*) message;
- (void)refreshOnCompletion:(BOOL) success info:(NSString*)message;
- (void)loadMoreOnCompletion:(BOOL) succes info:(NSString*)message;
@end

@interface MDoctorAppointPresenter : BasePresenter

@property(nonatomic,weak) id<MDoctorAppointPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<AppointDoctor* >* dataSource;
@property(nonatomic) BOOL noMoreData;


- (void)getAppointDoctorData;

/**
 *  下拉刷新
 */
- (void)refreshAppointDoctorData;

/**
 *  上拉加载更多
 */
- (void)loadMoreAppointDoctorData;


@end
