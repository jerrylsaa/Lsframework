//
//  MBabyManager.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BabayArchList.h"

@protocol MBabyManagerPresenterDelegate <NSObject>
@optional
- (void)onCompletion:(BOOL) success info:(NSString*) info;

- (void)setDefaultBabyCompletion:(BOOL) success info:(NSString*) info;

- (void)updateListCompletion:(BOOL)success info:(NSString*) info;

@end


@interface MBabyManagerPresenter : BasePresenter


@property(nonatomic,weak) id<MBabyManagerPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray* dataSource;


@property(nonatomic,retain) BabayArchList* currentBaby;

/**
 *  获取所有的宝贝
 */
- (void)getAllBaby;

/**
 *  设置默认宝贝
 *
 *  @param baby <#baby description#>
 */
- (void)setDefaultBaby:(BabayArchList*) baby;

/**
 *  更新所有宝宝列表
 */
- (void)updateAllBabyList;



@end
