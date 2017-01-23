//
//  MHealthServiceOderViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MHealthServicePresenter.h"

@interface MHealthServiceOderViewController : BaseViewController
@property(nullable,nonatomic,retain) MHealthServicePresenter* presenter;
@property (nonatomic,assign) NSInteger noDirectPush;

@end
