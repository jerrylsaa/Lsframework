//
//  BookingDatePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
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


@protocol BookingDatePresenterDelegate <NSObject>

- (void)locationComplete;

@end

typedef void (^Compelte)(BOOL complete);
typedef void (^LoadListDataCompelte)(BOOL complete, BOOL hasMoreData);

@interface BookingDatePresenter : BasePresenter

@property (nonatomic ,weak) id<ZHCityPickerDelegate> delegate;
@property (nonatomic ,strong)CityEntity *city;
@property (nonatomic ,strong)HospitalEntity *hospital;
@property (nonatomic ,strong)DepartmentEntity *depart;
@property (nonatomic ,strong)NSArray *hospitalArray;
@property (nonatomic ,strong)NSArray *departmentArray;

@property (nonatomic ,strong)NSMutableArray *dataSource;

- (void)showPickerInView:(UIView *)view;
- (void)dismissPicker;
- (void)loadHospitalDataWith:(Compelte)block;
- (void)loadDepartmentDataWith:(Compelte)block;

- (void)locationWithBlock:(LocationManagerBlcok)block;

@end
