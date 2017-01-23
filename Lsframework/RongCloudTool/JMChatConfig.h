//
//  JMChatConfig.h
//  doctors
//
//  Created by 梁继明 on 16/3/26.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>




@interface JMChatConfig : NSObject<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

+(JMChatConfig *)shareManager;

-(void)setupWithOptions:(NSDictionary *)launchOptions;

-(void)registerAllPush;

- (void)registerPushForIOS8;

-(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
