//
//  SplashPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DataTaskManager.h"
#import "ConfiguresEntity.h"

@protocol SplashPresenterDelegate <NSObject>

-(void)onInitCommonDataComplete;

@end

@interface SplashPresenter : BasePresenter
@property (nonatomic, strong) DataTaskManager* request;

@property (nonatomic, weak) id<SplashPresenterDelegate> delegate;

-(void)initCommonData;

@end
