//
//  HExpertAnswerPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ExpertAnswerEntity.h"
#import "DataTaskManager.h"
#import "ExpertHospitalEntity.h"
#import "ExpertOfficeEntity.h"


@protocol HExpertAnswerPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL) success info:(NSString*) messsage;

- (void)onBindCompletion:(BOOL) success info:(NSString*) messsage;


- (void)onGetHospitalCompletion:(BOOL) success info:(NSString*) messsage;

- (void)onGetOfficeCompletion:(BOOL) success info:(NSString*) messsage;

- (void)MoreOnCompletion:(BOOL) success info:(NSString*) message;

- (void)MoreOnBindCompletion:(BOOL) success info:(NSString*) message;


- (void)bannerOnCompletion:(BOOL) success info:(NSString*) message;

@end

typedef void(^isDoctor)(BOOL isDoctor, NSString *message);

@interface HExpertAnswerPresenter : BasePresenter

@property(nonatomic,weak) id<HExpertAnswerPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<ExpertAnswerEntity* > * dataSource;

@property(nonatomic,retain) NSArray<ExpertAnswerEntity* > * myBindDataSource;


@property(nonatomic,retain) NSArray * hospitalDataSource;

@property(nonatomic,retain) NSArray<ExpertOfficeEntity* > * officeDataSource;

@property(nonatomic,retain) NSString* bannerURL;

@property(nonatomic) BOOL noMoreData;

@property(nonatomic,assign) NSInteger hospitalName;
@property(nonatomic,strong) NSString *officeName;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *latitude;
- (void)loadExpertData;

- (void)loadMoreExpertData;

- (void)getExperIDByUserID:(isDoctor) block;

- (void)loadExpertHospital;

- (void)loadExpertOffice;

-(void)loadMyBindHospitalData;

-(void)loadMoreMyBindHospitalData;
@end
