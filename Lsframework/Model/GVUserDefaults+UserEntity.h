//
//  GVUserDefaults+UserEntity.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (UserEntity)

@property (nonatomic) NSInteger userId;

@property (nonatomic, strong) NSString * userName;

@property (nonatomic, strong) NSString * userPasswd;

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong) NSString * phone;

@property (nonatomic, strong) NSString * registerTime;

@property (nonatomic) NSInteger registerWay;

@property (nonatomic, strong) NSString * token;

@property (nonatomic,strong) NSData * strDeviceToken;

@property (nonatomic,strong) NSString *geTuiDeviceToken;

@property (nonatomic, assign) BOOL needToUpdateChildInfo;

@property (nonatomic, copy) NSString* userImageStr;

@property(nonatomic) BOOL isLogin;

@property(nullable,nonatomic,retain) NSNumber* expertID;

@property (nonatomic,assign) BOOL hotIsNeedReload;

@end
