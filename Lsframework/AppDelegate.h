//
//  AppDelegate.h
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/3/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RDVTabBarController *viewController;

@property(nonatomic,copy) NSString* proVince;

@property(nonatomic,copy) NSString* city;

@property (nonatomic, strong) NSString *saveTitle;

@property (nonatomic, strong) NSString *DotTitle;
@end

