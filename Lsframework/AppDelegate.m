//
//  AppDelegate.m
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/3/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "BasePresenter.h"
#import "HotPatchViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "ZHAVRecorder.h"
#import "AVRecorderPlayerManager.h"
#import "UIImage+Category.h"
#import "BaseNavigationController.h"
#import <SVProgressHUD.h>
#import "JMChatConfig.h"
#import "LocationManager.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "ProgressUtil.h"
#import "MJExtension.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "JMMessageViewController.h"
#import "AliPayUtil.h"
#import "WXPayUtil.h"
#import "DefaultChildEntity.h"
//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import <AlipaySDK/AlipaySDK.h>

#import "GeTuiSdk.h"     // GetuiSdk头文件，需要使用的地方需要添加此代码

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
//正式环境
#define kGtAppId           @"izlaQFCgwq8whJR09fZch7"
#define kGtAppKey          @"L3WSDQ7K1k6fzKVgsv8kI1"
#define kGtAppSecret       @"0lZJ8wQu9x7Vs4JySVDGP1"
////开发环境
//#define kGtAppId           @"4LHg0YgILW9d4vOpDVq1Y5"
//#define kGtAppKey          @"yz9CneSHKq7FO2VBnIl1x4"
//#define kGtAppSecret       @"ySs1ry7qlC7M1Z84FKlDHA"


#define NotifyActionKey "NotifyAction"
NSString *const NotificationCategoryIdent = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"ACTION_ONE";
NSString *const NotificationActionTwoIdent = @"ACTION_TWO";

static const char associatedkey;

// 开放平台登录https://open.weixin.qq.com的开发者中心获取APPID
#define WX_APPID @"wx0261cd4176bce070"
//// 开放平台登录https://open.weixin.qq.com的开发者中心获取AppSecret。
//#define WX_APPSecret @"fc32dfae99bc67e****5f77dddd4ea5"
//// 微信支付商户号
//#define MCH_ID  @"1353***702"
//// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com
//// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
//#define WX_PartnerKey @"B6246A6D8***C730EEA0F78D3B461"


@interface AppDelegate ()<RDVTabBarControllerDelegate,GeTuiSdkDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSString createVoicePath];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor clearColor];
    
    [self setupCoreData];
    
    [self customizeInterface];
    
    [self configKeyBoard];
    
    [self  umengTrack];
    

    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[HotPatchViewController new]];
    
    [self rongCloudPush:application WithOptions:launchOptions];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    // 该方法需要在主线程中调用
    [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
    // [2]注册APNS
    [self registerRemoteNotification];
    
    [self setupShareSDK];
    
    [self.window makeKeyAndVisible];
    
//    WS(ws);
//    [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString *province, NSString *city, BOOL success) {
//        if(success){
//            ws.proVince = province;
//            ws.city = city;
//        }
//    }];
    [WXApi registerApp:WX_APPID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutAction) name:Notification_LoginOutAction object:nil];
    
#pragma mark---程序杀死状态下推送
    if (launchOptions) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        
         NSString  *type = [userInfo  objectForKey:@"TYPE"];
        
        if (type.length== 0 || type == nil) {
            //平台推送
        }else{
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (userInfo) {
            NSLog(@"未启动程序推送");
            NSLog(@"推送消息==== %@",userInfo);
#pragma *推送杀死状态收到推送角标设置
    NSNumber  *BadgeCount = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    [GeTuiSdk  setBadge:[BadgeCount  integerValue]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[BadgeCount integerValue]];  //可用全局变量累加消息
            
            NSString   *userString = [userInfo  objectForKey:@"DATA"];
            NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
            NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            

            
            [self  PushDotWithType:type  EventType:@"0"  uuid:[dic  objectForKey:@"ID"]];  //推送打点
            
            if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
                NSString  *message =  [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                NSLog(@"message：%@",message);
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"掌上儿保"                                                        message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:@"查看",nil];
                [alert show];

   objc_setAssociatedObject(alert, &associatedkey, userInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       
}
           
        }
                }
    }
    return YES;
}


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    //该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[ action1, action2 ]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
    
    
}

#pragma mark - umeng数据统计
- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"5763607d67e58e85b8001a12";
    UMConfigInstance.secret = @"secretstringaldfkals";
    [MobClick setCrashReportEnabled:YES];
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick  setLogEnabled:NO];
}

#pragma mark - Methods

-(void)setupShareSDK{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1473aebbc5047"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2424918189"
                                           appSecret:@"84d5e583a1e3bbe1f1de8dc74bedf16b"
                                         redirectUri:@"http://etjk365.dzjk.com:8084/MobileHtml/gzh/FenXiangIndex.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxde62bdad971161c1"
                                       appSecret:@"900823fe4f2fb796e4cfb6c8c7383b20"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105518222"
                                      appKey:@"HU1yXfIbK9n1RM9M"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
         
         
         
     }];
}

- (void)setupCoreData{
    [MagicalRecord setupAutoMigratingCoreDataStack];
}

//防止点击一个文本框，触发到其他文本框的键盘弹出的事件
-(void)configKeyBoard
{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldAdoptDefaultKeyboardAnimation:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}


- (void)customizeInterface {
    
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    [SVProgressHUD setForegroundColor:RGBA(255, 255, 255, 1)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)loginOutAction{
    [[ZHAVRecorder sharedRecorder] playerStop];//所有语音播放停止
    [[ZHAVRecorder sharedRecorder] stop];
    [[AVRecorderPlayerManager sharedManager] stop];
    [DefaultChildEntity MR_truncateAll];
    kCurrentUser.token =@"";
    kCurrentUser.userId =0;
    
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController sharedLoginViewController]];
    [MobClick  profileSignOff];  //umeng账号登出

}



-(void)rongCloudPush:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions{
    
     [XGPush startApp:XG_ACCESS_ID appKey:XG_ACCESS_KEY];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            
            [[JMChatConfig shareManager] registerAllPush];
            
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    
    
    [[JMChatConfig shareManager] setupWithOptions:launchOptions];
    
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
}


/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
    NSLog(@"-----didRegisterUserNotificationSettings");
    
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    
    [[JMChatConfig shareManager] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    NSLog(@"get device Token%@",token);
    kCurrentUser.strDeviceToken = deviceToken;
    
    [self registerToken];
    
    NSString *gtToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    gtToken = [gtToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    kCurrentUser.geTuiDeviceToken =gtToken;
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", gtToken);

    NSLog(@"\n>>>[clientId Success]:%@\n\n", [GeTuiSdk clientId]);

    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:gtToken];
    
}

-(void)registerToken{
    
    
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    [XGPush setAccount:kCurrentUser.phone];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    //注册设备
    XGSetting *setting = (XGSetting *)[XGSetting getInstance];
    
    
     NSString * deviceTokenStr = [XGPush registerDevice:kCurrentUser.strDeviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
      NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
    
    
}



/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    [[JMChatConfig shareManager] didReceiveRemoteNotification:userInfo];
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    NSString   *userString = [userInfo  objectForKey:@"DATA"];
    NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString  *NickName = [dic objectForKey:@"NickName"];
    NSString  *type = [userInfo  objectForKey:@"TYPE"];
    if (type.length== 0 || type == nil) {
        //平台推送
    }else{
    
    [self  PushDotWithType:type  EventType:@"0" uuid:[dic  objectForKey:@"ID"]];  //推送打点
    }
    

    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //前台
        
#pragma *推送前台收到推送角标设置
        NSNumber  *BadgeCount = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
        [GeTuiSdk  setBadge:[BadgeCount  integerValue]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[BadgeCount integerValue]];  //可用全局变量累加消息

        
        NSLog(@"-------_saveTitle:%@",_saveTitle);
         NSLog(@"测试在当前消息页面 vc.title  %@-----%@", _saveTitle,NickName);
        if (NickName == nil) {
            NSLog(@"不是消息推送");
            if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
                NSString  *message =  [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                NSLog(@"message：%@",message);
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"掌上儿保"                                                        message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:@"查看",nil];
                [alert show];
                
                objc_setAssociatedObject(alert, &associatedkey, userInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                       }
            }else{
            NSLog(@"是消息推送");
            if ([_saveTitle isEqualToString:NickName]) {
                    NSLog(@"不显示弹窗 vc.title  %@-----%@",_saveTitle ,NickName);
                    [kdefaultCenter postNotificationName:Notification_RefreshPushChartList object:nil userInfo:userInfo];
                
                NSString  *type = [userInfo  objectForKey:@"TYPE"];
                if (type.length== 0 || type == nil) {
                    //平台推送
                }else{
                    
                   [self  PushDotWithType:type  EventType:@"1" uuid:[dic  objectForKey:@"ID"]];  //推送打点
                }

                }else{
                   NSLog(@"显示弹窗 vc.title  %@-----%@",_saveTitle ,NickName);
                    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
                        NSString  *message =  [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                        NSLog(@"message：%@",message);
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"掌上儿保"                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:@"查看",nil];
                        [alert show];
                        
                        objc_setAssociatedObject(alert, &associatedkey, userInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                    }
 
                }

            
            }
    
    }else if([UIApplication sharedApplication].applicationState != UIApplicationStateBackground && [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        //后台
#pragma *推送后台收到推送角标设置
        NSNumber  *BadgeCount = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
        [GeTuiSdk  setBadge:[BadgeCount  integerValue]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[BadgeCount integerValue]];  //可用全局变量累加消息
        
        [kdefaultCenter postNotificationName:Notification_PushGeTui object:nil userInfo:userInfo];
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        if (NickName== nil) {
            NSLog(@"不是消息推送");
        }else{
            NSLog(@"是消息推送");
            if ([_saveTitle  isEqualToString:NickName]) {
                NSLog(@"发通知刷新消息页面");
                [kdefaultCenter postNotificationName:Notification_RefreshPushChartList object:nil userInfo:userInfo];
                
                NSString  *type = [userInfo  objectForKey:@"TYPE"];
                if (type.length== 0 || type == nil) {
                    //平台推送
                }else{
                    [self  PushDotWithType:type  EventType:@"1" uuid:[dic  objectForKey:@"ID"]];  //推送打点
                }

            }
            
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//取消
        NSLog(@"取消进入推送页面");
        
    }else{
        
        NSLog(@"确定进入推送页面");
  NSDictionary  *userInfo =objc_getAssociatedObject(alertView, &associatedkey);
        NSString  *type = [userInfo  objectForKey:@"TYPE"];
        NSString   *userString = [userInfo  objectForKey:@"DATA"];
        NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        [self  PushDotWithType:type  EventType:@"1"  uuid:[dic  objectForKey:@"ID"]];  //推送打点

        NSLog(@"弹窗信息传递：%@",userInfo);
 [kdefaultCenter postNotificationName:Notification_PushGeTui object:nil userInfo:userInfo];
//[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

 
        
    }
}

#pragma mark---推送打点
-(void)PushDotWithType:(NSString*)type EventType:(NSString*)EventType  uuid:(NSNumber*)uuid{
    if ([type  isEqualToString:@"0"]) {
        //问题详情
        _DotTitle = @"评论咨询推送";
        
    }else if ([type  isEqualToString:@"1"]){
        //问题评论回复
        _DotTitle = @"回复咨询评论推送";
    }else if ([type  isEqualToString:@"3"]){
        //问题评论回复
        _DotTitle = @"旁听问题推送";
    }else if ([type  isEqualToString:@"4"]){
        //帖子详情
        _DotTitle = @"评论贴子推送";
    }else if ([type  isEqualToString:@"5"]){
        //消息
        _DotTitle = @"聊天对话推送";
        
    }else if ([type  isEqualToString:@"7"]){
        //帖子评论回复
        _DotTitle = @"回复帖子推送";
    }else if ([type  isEqualToString:@"8"]){
        //
        _DotTitle = @"咨询问题推送";
    }else  if ([type  isEqualToString:@"9"]){
        //每日必读详情页
        _DotTitle = @"追问咨询推送";
    }
else  if ([type  isEqualToString:@"10"]){
        //每日必读详情页
        _DotTitle = @"文章推送";
    }

    if ([EventType isEqualToString:@"0"]) {
        
        if ([_DotTitle  isEqualToString:@"文章推送"]) {
            
        [BasePresenter  EventStatisticalDotTitle:_DotTitle Action:DotEventReceive  Remark:nil  SrcID:uuid];
            
        }else{
            
[BasePresenter  EventStatisticalDotTitle:_DotTitle Action:DotEventReceive  Remark:nil];
            
        }

        
    }else  if([EventType isEqualToString:@"1"]){
        
        if ([_DotTitle  isEqualToString:@"文章推送"]) {
            
            [BasePresenter  EventStatisticalDotTitle:_DotTitle Action:DotEventEnter  Remark:nil  SrcID:uuid];
            
        }else{
            
    [BasePresenter  EventStatisticalDotTitle:_DotTitle Action:DotEventEnter  Remark:nil];
            
        }

    }
    
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    NSLog(@"\n>>>[GexinSdk]:%@\n\n",payloadData );
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    
    
 
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
}




#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //可用全局变量累加消息
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"======pay result = %@",resultDic);
            if ([AliPayUtil sharedManager].callback) {
                [AliPayUtil sharedManager].callback(resultDic);
            }

        }];
    
    }else {
        return [WXApi handleOpenURL:url delegate:self];

    }
    return YES;

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([AliPayUtil sharedManager].callback) {
                [AliPayUtil sharedManager].callback(resultDic);
            }

        }];
    }else {
        return [WXApi handleOpenURL:url delegate:self];

    }
    return YES;
}

//微信回调授权信息
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSLog(@"%d",authResp.errCode);
        NSLog(@"%@",authResp.code);
        if (authResp.code!=nil) {
            
            NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:authResp.code forKey:@"authRespCode"];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:Notification_WeXinLogin object:nil userInfo:myDictionary];
        }

        
    }
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                
                if([WXPayUtil sharedManager].callback){
                    
                    [WXPayUtil sharedManager].callback();
                    
                }

                break;
            default:
                [ProgressUtil dismiss];

                NSLog(@"支付失败，retcode=%d",resp.errCode);
                
                break;
        }
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_LoginOutAction object:nil];
}

//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
//{
//    return NO;
//}

@end
