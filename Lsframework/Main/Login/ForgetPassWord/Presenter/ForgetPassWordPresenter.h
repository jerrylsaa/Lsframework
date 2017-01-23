//
//  ForgetPassWordPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol ForgetPassWordDelegate <NSObject>

@optional

- (void)sendIdentifyingCodeComplete:(BOOL )success;
- (void)commitComplete:(BOOL ) success info:(NSString*) info;

- (void)onHandlerCompletion;

@end


@interface ForgetPassWordPresenter : BasePresenter

@property (nonatomic ,weak) id<ForgetPassWordDelegate> delegate;

- (void)sendIdentifyingCodeToPhone:(NSString *)phoneNumber with:(NSInteger )idCode;

- (void)commitWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code password:(NSString *) password rePassword:(NSString *) rePassword identifyCode:(NSInteger )idCode;

@end
