//
//  HomePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildEntity.h"
#import "AlertEntity.h"
#import "ExpertAnswerEntity.h"
#import "VaccineEvent.h"
#import "CouponEnity.h"
#import "DailyFirstArticle.h"
#import "DataTaskManager.h"
#import "BabayArchList.h"
#import "BindHospitalEntity.h"
#import "ActivityData.h"

typedef void(^isDoctor)(BOOL isDoctor, NSString *message);
typedef void (^RedDotBlock)(BOOL success);

@protocol HomePresenterDelegate <NSObject>
@optional
-(void)onGetChildInfoComplete:(BOOL)success today:(NSInteger)today;

- (void)onLoadChildStandardInfoComplete:(BOOL)success withInfoDictionary:(NSDictionary *)infoDict;

-(void)onLoadMoreDataComplete;

-(void)onCheckIsSignToday:(BOOL)isSign;

-(void)onSignToday:(BOOL)complete;

-(void)onChangeChildAvaterCompleted:(NSString*)path;

- (void)onUpdateCompletion:(BOOL)success today:(NSInteger) today;

//-(void)onGetAlertWithDay:(NSUInteger)day;
- (void)onGetAlertWithCompletion:(BOOL) success Day:(NSUInteger)day; 
- (void)onGetVaccineEventWithCompletion:(BOOL) success Day:(NSUInteger)day;

- (void)onGetExpertListCompletion;


- (void)onGetCouponListCompletion:(BOOL)success info:(NSString*)message;

- (void)onGetClaimCouponCompletion:(BOOL)success info:(NSString*)message;



- (void)onGetDailyFirstArticleCompletion:(BOOL)success info:(NSString*)message;

- (void)onGetEHRChildRecordCountCompletion:(BOOL)success info:(NSInteger )message;


- (void)setDefaultBabyCompletion:(BOOL) success info:(NSString*) info;

//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message;

-(void)onGetBindHospitalInfoSuccess:(BOOL)complete;
//获取第一个活动回调
-(void)onGetFirstActivityInfoCompletion:(BOOL)success info:(NSString*)message;

- (void)onBindWx2mlCompletion;


@end

@interface HomePresenter : BasePresenter

@property (nonatomic, weak) id<HomePresenterDelegate> delegate;

@property (nonatomic, strong) ChildEntity * childEntity;

@property (nonatomic, strong) NSMutableArray<AlertEntity*> * birthDates;
@property (nonatomic, strong) NSMutableArray<NSString*> * birthDatesForDate;
@property(nonatomic,retain) NSArray<ExpertAnswerEntity* > * dataSource;

@property(nonatomic,retain) NSArray<CouponEnity* > * CouponDataSource;
@property(nonatomic,retain) NSArray<VaccineEvent* > * VaccineSource;
@property(nonatomic,retain) NSArray<DailyFirstArticle* > * DailyFirstSource;

@property (nonatomic,retain) NSArray<BindHospitalEntity *> *hospitalEntity;

@property(nullable,nonatomic,retain) DataTaskManager* taskManager;

@property(nullable,nonatomic,retain) AlertEntity* alertEntity;
@property(nonatomic,retain) NSArray<ActivityData*> *ActivitySource;



-(void)getRedDot:(RedDotBlock)block;

-(void)getChildInfo;

- (void)loadStandardChildHeightAndWeight;

-(void)loadMoreData;

-(void)checkIsSignToady;

-(void)signToday;

-(void)changeChildAvaterWithPath:(NSString*)path;
/**
 *  每日提醒
 *
 *  @param day <#day description#>
 */
- (void)getAlertWithDay:(NSUInteger)day;

- (void)insertBindDevice;
/**
 *  更新孩子信息
 */
- (void)updateChildInfo;

- (void)loadExpertData;

typedef void(^haveOtherPWD)(BOOL haveOtherPWD, NSString *message);
typedef void(^createOtherPWD)(BOOL createOtherPWD, NSString *message);

- (void)getOtherPWDByUserID:(haveOtherPWD) block;
- (void)createOtherPWDRequest:(createOtherPWD) block;
///**
// *  获取疫苗提醒
// */
//- (void)getVaccineEventWithDay:(NSUInteger)day;
/**
 *  获取优惠券
 */
-(void)getCouponList;
/**
 *  领取优惠券接口
 *
 *
 */
-(void)getClaimCouponWithcouponID:(NSNumber*)CouponID;

- (void)getExperIDByUserID:(isDoctor) block;

/**
 * 每日必读
 */
-(void)getDailyFirstArticle;


- (void)GetEHRChildRecordCount;


- (void)setDefaultBaby:(BabayArchList*) baby;

/**
 *  文章点赞和取消
 */

//点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID;

//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID;


- (void)getNewExpertDoctorInfoWithExpertID:(NSString *)expertID;

//获取第一个活动
-(void)getFirstActivityVersion:(NSNumber*)version;

- (void)bindWx2mlWithUrl:(NSString *)url;


@end
