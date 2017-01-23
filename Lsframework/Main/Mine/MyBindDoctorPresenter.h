//
//  MyBindDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyBindDoctorEntity.h"

@protocol MyBindDoctorPresenterDelegate <NSObject>
@optional

- (void)getBindExpertListSuccess;

@end
@interface MyBindDoctorPresenter : BasePresenter
@property(nonatomic,weak) id<MyBindDoctorPresenterDelegate> delegate;

@property (nonatomic,strong) NSArray <MyBindDoctorEntity *>*doctorDataSource;

- (void)getBindExpertList;

- (void)cancelBindExpertByExpertID:(NSNumber *)expertID;

@end
