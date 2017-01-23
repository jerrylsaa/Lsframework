//
//  PersonFileViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

//typedef void(^Complete)(BOOL success);

@interface PersonFileViewController : BaseViewController

@property(nonatomic) NSInteger babyID;

@property(nonatomic) BOOL updateBabyInfo;//更新宝贝信息


@end






@interface State : NSObject

@property (nonatomic ,assign) BOOL success;
@property (nonatomic ,copy) NSString *message;

@end

