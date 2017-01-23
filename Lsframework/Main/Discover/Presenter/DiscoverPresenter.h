//
//  DiscoverPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DIscoverQuestEntity.h"
#import "DiscoverHealthLogEntity.h"

@protocol DiscoverPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

- (void)MoreOnCompletion:(BOOL)success info:(NSString *)message;

- (void)onGetQuestNumberCompletion:(BOOL)success info:(NSString *)message questNumber:(NSInteger )number;

- (void)onUploadPhotoCompletion:(BOOL)success info:(NSString *)message;

- (void)uploadPhotoDataOnCompletion:(BOOL)success info:(NSString*)message urlPhotoPath:(NSString *)photoPath;

- (void)onGetPhotoUrlCompletion:(BOOL)success info:(NSString *)message dataDictionary:(NSDictionary *)dict;

- (void)onGetQuestCompletion:(BOOL)success info:(NSString *)messsage;

- (void)onGetLogListCompletion:(BOOL)success info:(NSString *)messsage;

- (void)uploadLogPhotoDataOnCompletion:(BOOL)success info:(NSString*)message urlPhotoPath:(NSString *)photoPath;

- (void)onUpdateLogCompletion:(BOOL)success info:(NSString *)message;

@end

@interface DiscoverPresenter : BasePresenter

@property(nonatomic,weak) id<DiscoverPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<DIscoverQuestEntity* > * questDataSource;

@property(nonatomic,retain) NSArray<DiscoverHealthLogEntity* > * logDataSource;

@property(nonatomic) BOOL noMoreData;

- (void)getQuestNumber;

- (void)loadQuestList;

- (void)getPhotoGraphUrls;

- (void)uploadPhoto:(UIImage *)image;

- (void)uploadPhotoUrl:(NSString *)url photoNum:(NSInteger)number;

- (void)getHealthcareLogList;

- (void)updateHealthLog:(NSString *)photoUrl LogId:(float)logid LogContent:(NSString *)content;
@end
