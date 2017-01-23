//
//  FDSelectFamilyDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ProvinceEntity.h"
#import "CityEntity.h"
#import "DoctorList.h"
#import "DataTaskManager.h"
#import "HospitalEntity.h"
#import "DepartmentEntity.h"


typedef void (^ CityListComplete)();


@protocol FDSelectFamilyDoctorPresenterDelegate <NSObject>

- (void)fetchFamilyDoctorData:(BOOL) success info:(NSString*) info;


- (void)onCompletionDepart:(BOOL)success info:(NSString*) info;

@end

@interface FDSelectFamilyDoctorPresenter : BasePresenter

@property(nonatomic,weak) id<FDSelectFamilyDoctorPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray* dataSource;

@property(nonatomic,retain) NSMutableArray* hospitalSource;

@property(nonatomic,retain) NSArray* departSource;

@property(nonatomic,retain) DataTaskManager* request;


- (void)loadDoctorData:(NSString*) proVince City:(NSString*) city;

/**
 *  加载医院科室
 *
 *  @param hospatialID <#hospatialID description#>
 */
- (void)loadHospatialDepart:(NSInteger) hospatialID;



@end
