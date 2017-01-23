//
//  MWarningPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MWarningEntity.h"
@protocol MWarningPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL) success info:(NSString*) messsage;

- (void)MoreOnCompletion:(BOOL) success info:(NSString*) message;


@end

@interface MWarningPresenter : BasePresenter

@property(nonatomic,weak) id<MWarningPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<MWarningEntity* > * dataSource;
@property(nonatomic) BOOL noMoreData;

- (void)loadMyWarningList;
- (void)loadMoreWarningList;
@end
