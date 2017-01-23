//
//  DietManagerPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DMHotKeyEntity.h"
#import "FoodSearchResultEntity.h"
#import "DMMyFoodListEntity.h"
#import "DMMyDietAnalysisEntity.h"
#import "BabyFoodTipsEntity.h"

@protocol DietManagerPresenterDelegate<NSObject>
@optional
- (void)uploadPhotoDataOnCompletion:(BOOL)success Info:(NSString *)info photoUrl:(NSString *)url;

- (void)getBabyTips:(NSString *)tips;

- (void)getHotKeyOnCompletion:(BOOL)success Info:(NSString *)info;

- (void)getFoodSearchResultOnCompletion:(BOOL)success Info:(NSString *)info;

- (void)addUserFoodOnCompletion:(BOOL)success Info:(NSString *)info;

- (void)getUserFoodListOnCompletion:(BOOL)success Info:(NSString *)info;

- (void)delUserFoodOnCompletion:(BOOL)success Info:(NSString *)info;

- (void)getDietAnalysisOnCompletion:(BOOL)success Info:(NSString *)info;

@end
@interface DietManagerPresenter : BasePresenter

@property(nonatomic,weak) id<DietManagerPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<BabyFoodTipsEntity *> * babyFoodTipsSource;
@property(nonatomic,retain) NSArray<DMHotKeyEntity *> * hotKeySource;
@property(nonatomic,retain) NSArray<FoodSearchResultEntity *> * foodSearchResultSource;
@property(nonatomic,retain) NSArray<DMMyFoodListEntity *> * myFoodListSource;
@property(nonatomic,retain) NSArray<DMMyDietAnalysisEntity *> * myDietAnalysisSource;
@property(nonatomic,retain) NSMutableArray *myDietIllSource;

- (void)uploadPhoto:(UIImage *)photo;

- (void)getBabyFoodTips;

- (void)getHotKeyWord;

- (void)searchFoodByKeyWords:(NSString *)keyWord OrUrl:(NSString *)url;

- (void)addUserFoodByFoodID:(NSNumber *)foodID;

- (void)getUserFoodList;

- (void)delUserFoodByFoodID:(NSNumber *)foodID;

- (void)getFoodAnalysis;

@end
