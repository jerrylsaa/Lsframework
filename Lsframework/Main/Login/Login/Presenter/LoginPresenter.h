//
//  LoginPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol LoginPresenterDelegate <NSObject>

-(void)onLoginComplete:(BOOL)success info:(NSString*)info;

-(void)onBindWeChatComplete:(BOOL)success info:(NSString*)info;


- (void)onLoginWeChatComplete:(BOOL)success info:(NSString*)info Dictionary:(NSDictionary *)dict;

-(void)onbindWxToUserComplete:(BOOL)success info:(NSString*)info;
- (void)sendIdentifyingCodeComplete:(BOOL)success;
@end


@interface LoginPresenter : BasePresenter

@property (nonatomic, weak) id<LoginPresenterDelegate>delegate;

-(void)loginWithUserName:(NSString*)userName withPasswd:(NSString*)passwd;

- (void)loginWithWeChatCode:(NSString *)codeStr;

- (void)registerWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code;

- (void)sendIdentifyingCodeToPhone:(NSString *)phoneNumber;
@end
