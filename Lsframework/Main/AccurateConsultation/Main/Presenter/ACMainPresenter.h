//
//  ACMainPresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ProvinceEntity.h"
#import "CityEntity.h"
#import "ZHCityPicker.h"
#import "HospitalEntity.h"
#import "DepartmentEntity.h"
#import "DoctorList.h"
#import "LocationManager.h"

@protocol ACMainPresenterDelegate <NSObject>
@optional

- (void)locationComplete;
- (void)loadChildrenH5Ctrl;

/**
 *  加载医院回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)onCompletion:(BOOL) success info:(NSString*) message;

/**
 *  加载医院科室回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)departOnCompletion:(BOOL) success info:(NSString*) message;
/**
 *  下来刷新回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)doctorOnCompletion:(BOOL) success info:(NSString*) message;
/**
 *  上拉加载更多回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)doctorMoreDataOnCompletion:(BOOL) success info:(NSString*) message;

@end

@interface ACMainPresenter : BasePresenter

@property (nonatomic ,weak) id<ACMainPresenterDelegate> aCMaindelegate;
@property(nonatomic,retain) NSArray* hospitalDataSource;
@property(nonatomic,retain) NSArray* departDataSource;
@property(nonatomic,retain) NSNumber* provinceId;
@property(nonatomic,retain) NSString* cityId;
@property(nonatomic,retain) NSNumber* hospitalId;
@property(nonatomic,retain) NSNumber* departId;
@property(nonatomic,retain) NSMutableArray* doctorDataSource;
@property(nonatomic) BOOL noMoreData;

/**
 *  加载医院
 *
 *  @param cityName <#cityName description#>
 */
- (void)loadHospitalWith:(NSString*) cityName;

/**
 *  加载医院科室
 *
 *  @param hospatialID <#hospatialID description#>
 */
- (void)loadHospatialDepart:(NSInteger) hospatialID;

/**
 *  下来刷新
 */
- (void)loadDoctorDta;

/**
 *  上拉加载更多
 */
- (void)loadMoreDoctroDtaa;

@end
