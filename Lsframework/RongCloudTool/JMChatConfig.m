//
//  JMChatConfig.m
//  doctors
//
//  Created by 梁继明 on 16/3/26.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "JMChatConfig.h"
#import "RCDRCIMDataSource.h"
#import "FPNetwork.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"

@implementation JMChatConfig

+(JMChatConfig *)shareManager{
    

    static JMChatConfig *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        
        _sharedInstance = [[JMChatConfig alloc] init];
        
    
      
    });
    return _sharedInstance;


}

-(void)setupWithOptions:(NSDictionary *)launchOptions{
    

    [[RCIM sharedRCIM] initWithAppKey:RONG_CLOUD_APP_KEY];
    
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
  //  [self setupRongCloud];

    
  [kCurrentUser addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];


}

-(void)registerAllPush{
    //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [self registerPush];
    }
    else{
        [self registerPushForIOS8];
    }
#else
    //iOS8之前注册push方法
    //注册Push服务，注册后才能收到推送
    [self registerPush];
#endif


}


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


-(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    NSLog(@"get device Token%@",token);
    
    
   // USER_DATA.pushToken = token;
    
  //  USER_DATA.strDeviceToken = deviceToken;
    
    
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    

}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{

    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"--didReceiveRemoteNotification--该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"--didReceiveRemoteNotification--该远程推送不包含来自融云的推送服务");
    }
    
    NSLog(@"%@",userInfo);
    
    
    //  [self handleTheNotifaction:userInfo];
    
    // [self updateMassageBadge];



}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"token"]){
        [self setupRongCloud];
    }

}




-(void)setupRongCloud{
    
    if (!kCurrentUser.userId || !kCurrentUser.userName) {
        
        return;
    }
    
//    NSLog(@"userid=%ld--%@==",kCurrentUser.userId,kCurrentUser.userName);
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"u%ld",kCurrentUser.userId],@"name":kCurrentUser.userName};
    
    [FPNetwork postRongCloud:@"user/getToken.json" params:dic success:^(NSURLSessionDataTask * task, id response) {
        
        
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        
        
        
        //设置用户信息源和群组信息源
        [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
        [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
        //设置群组内用户信息源。如果不使用群名片功能，可以不设置
        [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
        
        //设置接收消息代理
        [RCIM sharedRCIM].receiveMessageDelegate=self;
       
        
        if ([[response objectForKey:@"code"] intValue] == 200) {
            
            NSString *rongToken = [response objectForKey:@"token"];
            
           // USER_DATA.rongToken = [dic objectForKey:@"token"];
            
            [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
                
                NSLog(@"rong cloud connect success");
                
                RCUserInfo *_currentUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld",kCurrentUser.userId]
                                              name:kCurrentUser.userName
                                          portrait:kCurrentUser.userImageStr];
                [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                
                
                
                //  [self updateMassageBadge];
                
                
                
                
            } error:^(RCConnectErrorCode status) {
             
            } tokenIncorrect:^{
                
            }];
            
            
        }
        

        
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
  
    
    
    
}




#pragma mark  - Rong cloud delegate

-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];

    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Token已过期，请重新登录"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
            [alertView show];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];

        });
    }
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
}



-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    

    
    if ([message.objectName isEqualToString:RCTextMessageTypeIdentifier] ) {
        
        RCTextMessage * msg = (RCTextMessage*)message.content;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getChatMsg" object:msg];
        
        
        
    }
    
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        
       

    }
    
}








@end
