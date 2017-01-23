//
//  GBHealthServiceInfooPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "HealthServiceInfo.h"
#import "FoodDetailService.h"
@protocol GBHealthServiceInfoPresenterDelegate <NSObject>

@optional
- (void)onComplete:(BOOL) success info:(NSString*) info;

- (void)FoodSericeComplete:(BOOL) success info:(NSString*) info;

- (void)commitOnCompletion:(BOOL) success info:(NSString*) message;
-(void)commitFoodOnCompletion:(BOOL) success info:(NSString*) message;
@end


@interface GBHealthServiceInfooPresenter : BasePresenter
@property(nonatomic,weak) id<GBHealthServiceInfoPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<HealthServiceInfo* >* dataSource;

@property(nonatomic,retain) NSArray<FoodDetailService* >* FoodSource;

@property(nonatomic,retain)NSMutableArray *InfoDataSource;
@property(nonatomic,retain)NSString *Result;
@property(nonatomic)BOOL  IsHealth;
@property(nonatomic,strong)NSNumber *ResultID;

- (void)loadHealthServiceInfoWithTid:(NSNumber*)tid;

- (void)loadFoodServiceInfoWithTid:(NSNumber*)TypeID;

//-(void)commitWithEvalName:(NSString*)evalName andDictionary:(NSDictionary*)dictionary;
-(void)commitWithEvalName:(NSString*)evalName andJsparam:(NSString*)Jsparam;

-(void)loadMoreDataWithTid:(NSNumber*)tid;

-(void)commitWithJsparam:(NSString*)Jsparam;


@end
