//
//  FDCollectFamilyDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ProvinceEntity.h"
#import "CityEntity.h"
#import "CollectDoctor.h"
#import "DataTaskManager.h"
#import "HospitalEntity.h"
#import "DepartmentEntity.h"


@protocol FDCollectFamilyDoctorPresenterDelegate <NSObject>
@optional
- (void)onCompletion:(BOOL) success info:(NSString*) message;
- (void)onCompletionDepart:(BOOL)success info:(NSString*) info;

@end

@interface FDCollectFamilyDoctorPresenter : BasePresenter

@property(nonatomic,weak) id<FDCollectFamilyDoctorPresenterDelegate> delegate;

@property(nonatomic,retain) DataTaskManager* request;


@property(nonatomic,retain) NSArray<CollectDoctor* >* dataSource;

@property(nonatomic,retain) NSArray<NSString* >* departSource;



/**
 *  加载收藏的医生列表
 *
 *  @param city <#city description#>
 */
- (void)loadDoctorData:(NSString*) city;

/**
 *  加载医院科室
 *
 *  @param hospatialID <#hospatialID description#>
 */
- (void)loadHospatialDepart:(NSInteger) hospatialID;




@end
