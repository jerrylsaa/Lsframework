//
//  RegisterPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DataTaskManager.h"

@protocol RegisterDelegate <NSObject>

@optional
- (void)sendIdentifyingCodeComplete:(BOOL )success;
- (void)registerComplete:(BOOL ) success info:(NSString*) info;
- (void)loginComplete:(BOOL) success info:(NSString*) info;

- (void)onHandlerCompletion;

- (void)registerWCNewComplete:(BOOL)success info:(NSString *)info;
@end

@interface RegisterPresenter : BasePresenter

@property (nonatomic ,weak)id<RegisterDelegate> delegate;



- (void)sendIdentifyingCodeToPhone:(NSString *)phoneNumber;

- (void)registerWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code password:(NSString *) password rePassword:(NSString *) rePassword;

- (void)registerWCWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code password:(NSString *) password rePassword:(NSString *) rePassword;


-(void)autoLogin;

@end
