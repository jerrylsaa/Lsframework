//
//  MDoctoreWalletPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DataTaskManager.h"
#import "MWallet.h"


@protocol MDoctoreWalletPresenterDelegate <NSObject>

@optional


-(void)onCompletion:(BOOL)success info:(NSString *)messsage;

- (void)onBalanceCompletion:(BOOL)success info:(NSString*) messsage;

- (void)MoreOnCompletion:(BOOL) success info:(NSString*) message;



- (void)pushSetUpPass;

- (void)popVC;

- (void)popRootVC;
@end


@interface MDoctoreWalletPresenter : BasePresenter

@property(nonatomic,weak) id<MDoctoreWalletPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray <MWallet *> * dataSource;

@property(nonatomic) BOOL noMoreData;

- (void)loadWalletBalance;

- (void)loadWalletConsumption;

- (void)loadMoreWalletConsumption;

- (void)checkWalletAccount;

- (void)submitWalletPwd:(NSString *)password;

@end
